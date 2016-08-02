local ffi = require 'ffi'

local function q(input, suffix)
  return string.gsub(input..'${Suffix}','${Suffix}',suffix)
end

local cdef = [[
  typedef struct itkImage${Suffix} ImageType${Suffix};

  void GaussianSmoothing${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage, double sigma);
  void LaplacianOfGaussian${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage, double sigma);
  ]]

local function wrap(itk, pixel_type, suffix)
  local cdef = string.gsub(cdef,'${Suffix}',suffix)
  cdef = string.gsub(cdef,'${PixelType}',pixel_type)
  ffi.cdef(cdef)

  return {

    gaussiansmoothing = function(im, sigma)
      local out = im:createanother()
      itk[q('GaussianSmoothing',suffix)](im,out,sigma)
      return out
    end,

    laplacianofgaussian = function(im, sigma)
      local out = im:createanother()
      itk[q('LaplacianOfGaussian',suffix)](im,out,sigma)
      return out
    end

  }
end

return {wrap = wrap}

