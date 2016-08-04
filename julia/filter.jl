
gaussiansmoothing{T}(image::Image{T}, sigma::Float64) = begin
  outptr = @itkcall("", T, Ptr{Void}, ())
  @itkcall("GaussianSmoothing", T, Ptr{Void}, (Ptr{Void}, Ptr{Void}, Float64), image.ptr, outptr, sigma)
  Image{T}(outptr)
end

laplacianofgaussian{T}(image::Image{T}, sigma::Float64) = begin
  outptr = @itkcall("", T, Ptr{Void}, ())
  @itkcall("LaplacianOfGaussian", T, Ptr{Void}, (Ptr{Void}, Ptr{Void}, Float64), image.ptr, outptr, sigma)
  Image{T}(outptr)
end


export gaussiansmoothing
export laplacianofgaussian

