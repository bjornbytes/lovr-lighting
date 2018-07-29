return function()
  return lovr.graphics.newShader([[
    out vec3 vPosition;
    out vec3 vNormal;
    out vec3 vTangent;

    out vec3 vLight;
    uniform vec3 lightDirection = vec3(0., 1., 1.);

    vec4 position(mat4 projection, mat4 transform, vec4 vertex) {
      vec4 position = lovrTransform * vertex;
      vNormal = lovrNormalMatrix * lovrNormal;
      vTangent = (lovrView * vec4(lovrTangent, 0.)).xyz;
      vPosition = position.xyz / position.w;
      vLight = (lovrView * vec4(lightDirection, 0.)).xyz;
      return projection * transform * vertex;
    }
  ]], [[
    in vec3 vPosition;
    in vec3 vNormal;
    in vec3 vTangent;
    in vec3 vLight;

    #define M_PI 3.141592653589

    vec3 computeN(vec3 vertexNormal, vec3 vertexTangent, sampler2D normalTexture, vec2 uv) {
      vec3 sample = normalize(texture(normalTexture, uv).rgb * 2. - 1.);
      vec3 N = normalize(vertexNormal);
      vec3 T = normalize(vertexTangent);
      vec3 B = cross(N, T);
      mat3 TBN = mat3(T, B, N);
      return normalize(TBN * sample);
    }

    float computeD(vec3 H, vec3 N, float roughness) {
      float alpha = roughness * roughness;
      float alpha2 = alpha * alpha;
      float NdotH = clamp(dot(N, H), 0., 1.);
      float x = (NdotH * NdotH) * (alpha2 - 1.) + 1.;
      return alpha2 / (M_PI * x * x);
    }

    vec3 computeF(vec4 baseColor, float metalness, vec3 H, vec3 V) {
      vec3 x = baseColor.rgb * metalness;
      return x + (1. - x) * pow(clamp(1. - dot(V, H), 0., 1.), 5.);
    }

    float computeG(float roughness, float NdotL, float NdotV) {
      float r = roughness * roughness;
      float GL = 2. * NdotL / (NdotL + sqrt(r * r + (1. - r * r) * (NdotL * NdotL)));
      float GV = 2. * NdotV / (NdotV + sqrt(r * r + (1. - r * r) * (NdotV * NdotV)));
      return GL * GV;
    }

    vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) {
      vec4 baseColor = texture(lovrDiffuseTexture, uv) * lovrDiffuseColor;
      float ao = texture(lovrOcclusionTexture, uv).r;
      float metalness = texture(lovrMetalnessTexture, uv).b * lovrMetalness;
      float roughness = texture(lovrRoughnessTexture, uv).g * lovrRoughness;
      vec4 emissive = texture(lovrEmissiveTexture, uv) * lovrEmissiveColor;

      vec3 N = computeN(vNormal, vTangent, lovrNormalTexture, uv);
      vec3 V = normalize(-vPosition);
      vec3 L = normalize(vLight);
      vec3 H = normalize(L + V);

      float NdotL = clamp(dot(N, L), .001, 1.);
      float NdotV = abs(dot(N, V)) + .001;

      vec3 diffuse = baseColor.rgb * (1. - metalness) * dot(N, L);

      vec3 specularColor = baseColor.rgb * metalness;
      float D = computeD(H, N, roughness);
      vec3 F = computeF(baseColor, metalness, H, V);
      float G = computeG(roughness, NdotL, NdotV);
      vec3 brdf = (D * F * G) / (4. * NdotL * NdotV);
      vec3 specular = specularColor * brdf;

      vec3 main = clamp((diffuse + specular) * ao, 0., 1.);
      return graphicsColor * vertexColor * vec4(clamp(main + emissive.rgb, 0., 1.), 1.);
    }
  ]])
end
