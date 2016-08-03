local ffi = require 'ffi'

local cdef = [[
  typedef ${PixelType} PixelType;
  typedef struct itkImage${Suffix} ImageType${Suffix};

  ImageType${Suffix}* ${Suffix}();
  void DeleteImage${Suffix}(ImageType${Suffix}* image);
  unsigned int GetImageDimension${Suffix}(ImageType${Suffix}* image);
  void GetSpacing${Suffix}(ImageType${Suffix}* image, double* spacing);
  void SetSpacing${Suffix}(ImageType${Suffix}* image, double* spacing);
  void GetOrigin${Suffix}(ImageType${Suffix}* image, double* origin);
  void SetOrigin${Suffix}(ImageType${Suffix}* image, double* origin);
  void GetDirection${Suffix}(ImageType${Suffix}* image, double* direction);
  void SetDirection${Suffix}(ImageType${Suffix}* image, double* direction);
  void GetBufferedRegionSize${Suffix}(ImageType${Suffix}* image, int* bufferedRegionSize);
  void SetBufferedRegionSize${Suffix}(ImageType${Suffix}* image, int* bufferedRegionSize);
  void GetSize${Suffix}(ImageType${Suffix}* image, int* regionSize);
  void SetSize${Suffix}(ImageType${Suffix}* image, int* size);
  int GetBufferSize${Suffix}(ImageType${Suffix}* image);
  PixelType* GetData${Suffix}(ImageType${Suffix}* image);
  void SetData${Suffix}(ImageType${Suffix}* image, int* shape, PixelType* data);
  void ReadImage${Suffix}(ImageType${Suffix}* image, const char* filename);
  void WriteImage${Suffix}(ImageType${Suffix}* image, const char* filename);
  void Allocate${Suffix}(ImageType${Suffix}* image);
  ]]

local function q(input, suffix)
  return string.gsub(input..'${Suffix}','${Suffix}',suffix)
end

local tensortypes = {
  float  = torch.FloatTensor,
  double = torch.DoubleTensor,
  char   = torch.CharTensor,
  short  = torch.ShortTensor,
  long   = torch.LongTensor
}

local typesizes = {
  float  = 4,
  double = 8,
  char   = 1,
  short  = 2,
  long   = 4
}

local function wrap(itk, pixel_type, suffix)
  local cdef = string.gsub(cdef,'${Suffix}',suffix)
  local cdef = string.gsub(cdef,'${PixelType}',pixel_type)
  ffi.cdef(cdef)

  local getarr = function(im, fn, typ, size)
    local arr = ffi.new(typ .. "[?]", size)
    fn(im, arr)
    local out = {}
    for i=1,size do
      out[i] = arr[i-1]
    end
    return out
  end

  local setarr = function(im, fn, t, typ, size)
    local arr = ffi.new(typ .. "[?]", size)
    for i=1,size do
      arr[i-1] = t[i]
    end
    fn(im, arr)
  end

  return {

    createanother = function(im)
      return itk[q('',suffix)]()
    end,

    pixeltype = function(im)
      return pixel_type
    end,

    delete = function(im)
      itk[q('DeleteImage',suffix)](im)
    end,

    dim = function(im)
      return itk[q('GetImageDimension',suffix)](im)
    end,

    spacing = function(im, spacing)
      if not spacing then
        return getarr(im, itk[q('GetSpacing',suffix)], 'double', im:dim())
      end
      setarr(im, itk[q('SetSpacing',suffix)], spacing, 'double', im:dim())
    end,

    origin = function(im, origin)
      if not origin then
        return getarr(im, itk[q('GetOrigin',suffix)], 'double', im:dim())
      end
      setarr(im, itk[q('SetOrigin',suffix)], origin, 'double', im:dim())
    end,

    direction = function(im, direction)
      if not direction then
        return getarr(im, itk[q('GetDirection',suffix)], 'double', im:dim()^2)
      end
      setarr(im, itk[q('SetDirection',suffix)], direction, 'double', im:dim()^2)
    end,

    bufferedsize = function(im, size)
      if not size then
        return getarr(im, itk[q('GetBufferedRegionSize',suffix)], 'int', im:dim())
      end
      setarr(im, itk[q('SetBufferedRegionSize',suffix)], size, 'int', im:dim())
    end,

    size = function(im, size)
      if not size then
        return getarr(im, itk[q('GetSize',suffix)], 'int', im:dim())
      end
      setarr(im, itk[q('SetSize',suffix)], size, 'int', im:dim())
    end,

    allocate = function(im)
      itk[q('Allocate',suffix)](im)
    end,

    read = function(im, filename)
      itk[q('ReadImage',suffix)](im, filename)
    end,

    write = function(im, filename)
      itk[q('WriteImage',suffix)](im, filename)
    end,

    tensor = function(im, t)
      local pt = im:pixeltype()
      local len = itk[q('GetBufferSize',suffix)](im) * typesizes[pt]
      local sz = im:size()
      if not t then
        local t = tensortypes[pt](torch.LongStorage(sz))
        ffi.copy(t:data(), itk[q('GetData',suffix)](im), len)
        return t
      end
      t:resize(torch.LongStorage(sz))
      ffi.copy(t:data(), itk[q('GetData',suffix)](im), len)
    end,

    fromtensor = function(im, t)
      local pt = im:pixeltype()
      local sz = t:size()
      setarr(im, itk[q('SetSize',suffix)], sz, 'int', im:dim())
      setarr(im, itk[q('SetBufferedRegionSize',suffix)], sz, 'int', im:dim())
      itk[q('Allocate',suffix)](im)
      local len = itk[q('GetBufferSize',suffix)](im) * typesizes[pt]
      -- TODO: fail graciously if types don't match
      ffi.copy(itk[q('GetData',suffix)](im), t:contiguous():data(), len)
    end

  }

end

return {q = q,
        wrap = wrap}

