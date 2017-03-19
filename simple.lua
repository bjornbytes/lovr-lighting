local vertex = [[
// Declare two variables that we are going to calculate in the vertex shader and send to the
// fragment shader.
out vec3 lightDirection;
out vec3 normalDirection;

// This variable defines the position of the light source.  It could be a uniform if you want
// to change it over time (see commented line).
vec3 lightPosition = vec3(0, 0, 5);
// uniform vec3 lightPosition; // use shader:send('lightPosition', { x, y, z }) to update

vec4 position(mat4 projection, mat4 transform, vec4 vertex) {

  // Use matrices to transform position vectors and normal vectors.  They are given to us in
  // "local" space but we want them to be in world space.  We do this by multiplying the vertex
  // by the "lovrTransform" matrix given to us by LÖVR.
  vec3 transformedPosition = vec3(lovrTransform * vec4(lovrPosition, 1));
  vec3 transformedNormal = vec3(lovrTransform * vec4(lovrNormal, 0));

  // Now that we have everything in world space, we can compute the direction between the vertex
  // and the light.  We also normalize everything (make the lengths of the vectors 1) to avoid
  // errors in calculations.
  lightDirection = normalize(lightPosition - transformedPosition);
  normalDirection = normalize(transformedNormal);

  // This is the behavior for the default vertex shader, we leave it here so everything works!
  return projection * transform * vertex;
}
]]

local fragment = [[
// Declare the two variables that are sent to us by the vertex shader
in vec3 lightDirection;
in vec3 normalDirection;

vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) {

  // Use the dot product to calculate the intensity of the light.  It will be between 0 and 1 if
  // the surface is facing the light, or less than zero if the surface is facing away from the
  // light.
  float lightIntensity = max(dot(lightDirection, normalDirection), 0);

  // Calculate the final color for this little pixel!
  vec4 lightColor = vec4(vec3(lightIntensity), 1.);
  return lightColor * graphicsColor * texture(image, uv);
}
]]

return function()
  return lovr.graphics.newShader(vertex, fragment)
end
