local ffi = require 'ffi'

local function q(input, suffix)
  return string.gsub(input..'${Suffix}','${Suffix}',suffix)
end

local cdef = [[
  typedef struct itkImage${Suffix} ImageType${Suffix};

  void GaussianConvolution${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage, double sigma, int normalize);
  void GaussianSmoothing${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage, double sigma, int normalize);
  void LaplacianOfGaussian${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage, double sigma);

  void ConnectedComponents${Suffix}(ImageType${Suffix}* inputImage, ImageType${Suffix}* outputImage);
  ]]

local function wrap(itk, pixel_type, suffix)
  local cdef = string.gsub(cdef,'${Suffix}',suffix)
  cdef = string.gsub(cdef,'${PixelType}',pixel_type)
  ffi.cdef(cdef)

  return {

    gaussianconvolution = function(im, sigma, normalize)
      if normalize == nil then normalize = 0 end
      local out = im:createanother()
      itk[q('GaussianConvolution',suffix)](im,out,sigma,normalize)
      return out
    end,

    gaussiansmoothing = function(im, sigma, normalize)
      if normalize == nil then normalize = 0 end
      local out = im:createanother()
      itk[q('GaussianSmoothing',suffix)](im,out,sigma,normalize)
      return out
    end,

    laplacianofgaussian = function(im, sigma)
      local out = im:createanother()
      itk[q('LaplacianOfGaussian',suffix)](im,out,sigma)
      return out
    end,

    connectedcomponents = function(im)
      local out = im:createanother()
      itk[q('ConnectedComponents',suffix)](im,out)
      return out
    end

  }
end

return {wrap = wrap}

