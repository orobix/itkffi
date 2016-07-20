local ffi = require 'ffi'

local itk = ffi.load('itkffi')

local itkimage = require 'itkimage'
local itkfilter = require 'itkfilter'

local q = itkimage.q

local function merge(t1, t2)
  local out = {}
  for k,v in pairs(t1) do out[k] = v end
  for k,v in pairs(t2) do out[k] = v end
  return out
end

local function wrap(itklib, pixel_type, suffix)
  local mt1 = itkimage.wrap(itklib, pixel_type, suffix)
  local mt2 = itkfilter.wrap(itklib, pixel_type, suffix)

  local mt = {__index = merge(mt1, mt2)}

  ffi.metatype(q('ImageType',suffix), mt)
end

wrap(itk,'float','Float2D')
wrap(itk,'float','Float3D')
wrap(itk,'double','Double2D')
wrap(itk,'double','Double3D')
wrap(itk,'short','Short2D')
wrap(itk,'short','Short3D')

return itk
