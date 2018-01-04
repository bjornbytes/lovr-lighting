local g = lovr.graphics

local shaders = {
  require('phong')(),
  require('normal')()
}

function lovr.draw()
  local t = lovr.timer.getTime()
  local shaderIndex = 1 + (math.floor(t * .5) % #shaders)
  g.setShader(shaders[shaderIndex])
  g.cube('fill', 0, 1.7, -1, .5, t * 2, t / 2, t / 3, t / 4)
end
