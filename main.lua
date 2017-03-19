local g = lovr.graphics
local simple = require 'simple'

function lovr.load()
  g.setShader(simple())
end

function lovr.draw()
  local angle = lovr.timer.getTime() * 2
  g.cube('fill', 0, 0, -1, .5, angle, -.5, .2, .3)
end
