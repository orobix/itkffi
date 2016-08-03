# itkffi

Interoperate with ITK (www.itk.org) through FFI in Torch (LuaJIT) or NumPy (Python).

## Install

First install ITK (works on Debian/Ubuntu and MacOS):

```
bash install_dependencies.sh
```

### Torch (LuaJIT)

Build `itkffi` using LuaRocks:

```
luarocks make itkffi-scm-1.rockspec
```

Then in Torch

```
local itk = require 'itkffi'

local img = itk.Float2D()
img:read("input.nrrd")

local simg = img:gaussiansmoothing(2.0)

t = simg:tensor()
```

### Python

Coming next.

## License

BSD license https://opensource.org/licenses/BSD-3-Clause

Copyright 2016, Luca Antiga, Orobix Srl (www.orobix.com).

