
abstract PixelType

macro wraptype(T)
  quote
    type $T <: PixelType end
    export $T
  end
end

suffix(T) = symbol(split(string(T),".")[2])

macro dlsym(func, lib)
  z, zlocal = gensym(string(func)), gensym()
  eval(current_module(),:(global $z = C_NULL))
  z = esc(z)
  quote
    let $zlocal::Ptr{Void} = $z::Ptr{Void}
      if $zlocal == C_NULL
        $zlocal = Libdl.dlsym($(esc(lib))::Ptr{Void}, $(esc(func)))
        global $z = $zlocal
      end
      $zlocal
    end
  end
end

macro itkcall(fname, T, rettype, argtypes, args...)
  quote
    ccall(@dlsym(symbol($fname,suffix($T)),
            Libdl.dlopen("libcitkffi")),
          $rettype, $argtypes, $(args...))
  end
end

type Image{T <: PixelType}
  ptr::Ptr{Void}
  function Image(p::Ptr{Void})
    self = new(p)
    finalizer(self, function(x)
      @itkcall("DeleteImage", T, Void, (Ptr{Void},), x.ptr)
    end)
    self
  end
end

newimg{T}(::Type{T}) = begin
  ptr = @itkcall("", T, Ptr{Void}, ())
  Image{T}(ptr)
end

newimg{T}(image::Image{T}) = begin
  ptr = @itkcall("", T, Ptr{Void}, ())
  Image{T}(ptr)
end

pixeltype{T}(image::Image{T}) = begin
  T
end

readimg{T}(image::Image{T}, filename::AbstractString) = begin
  @itkcall("ReadImage", T, Void, (Ptr{Void},Ptr{UInt8}), image.ptr, filename)
end

readimg{T}(::Type{T}, filename::AbstractString) = begin
  ptr = @itkcall("", T, Ptr{Void}, ())
  @itkcall("ReadImage", T, Void, (Ptr{Void},Ptr{UInt8}), ptr, filename)
  Image{T}(ptr)
end

writeimg{T}(image::Image{T}, filename::AbstractString) = begin
  @itkcall("WriteImage", T, Void, (Ptr{Void},Ptr{UInt8}), image.ptr, filename)
end

export newimg
export pixeltype
export readimg
export writeimg

# image
# createanother
# pixeltype
# delete
# allocate
# dim
# setdim
# spacing
# setspacing
# origin
# setorigin
# direction
# setdirectoin
# bufferedsize
# setbufferedsize
# size
# setsize
# read
# write
# toarr
# fromarr

