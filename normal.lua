return function()
  return lovr.graphics.newShader([[
    out vec3 normalDirection;

    vec4 position(mat4 projection, mat4 transform, vec4 vertex) {
      normalDirection = lovrNormal;

      return projection * transform * vertex;
    }
  ]], [[
    in vec3 normalDirection;

    vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) {
      return vec4(normalDirection * .5 + .5, 1.);
    }
  ]])
end
