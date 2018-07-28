return function()
  return lovr.graphics.newShader([[
    out float depth;

    vec4 position(mat4 projection, mat4 transform, vec4 vertex) {
      vec4 result = projection * transform * vertex;
      depth = result.z / result.w;
      return result;
    }
  ]], [[
    in float depth;

    vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) {
      return vec4(vec3(depth), 1.);
    }
  ]])
end
