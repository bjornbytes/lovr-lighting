lovr-lighting
===

A collection of lighting shaders for [LÖVR](https://github.com/bjornbytes/lovr).

Usage
---

Drop the shader you want to use in a LÖVR project, then require it.  It will return a function that
returns the Shader when called.

```lua
local phong = require('phong')
local shader = phong()

function lovr.draw()
  lovr.graphics.setShader(shader)

  -- draw stuff
end
```

Shaders
---

- Phong - Simple phong lighting.  Per fragment lighting with a single directional light that has
  ambient/diffuse/specular colors.  Includes specular reflections.
- Normal - Colors pixels based on their vertex normal.  Can be used to debug problems with vertex
  normals and also looks really cool.
- Depth - Visualizes the depth buffer.  Pixels closer to the camera will be darker.
- PBR - A basic PBR shader (WIP).  Make sure you set `t.gammacorrect = true` in `conf.lua` when you use
  this.
