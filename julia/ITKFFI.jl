module ITKFFI

include("image.jl")
include("filter.jl")

@wraptype Float2D
@wraptype Float3D
@wraptype Double2D
@wraptype Double3D
@wraptype Short2D
@wraptype Short3D

end

