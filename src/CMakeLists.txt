cmake_minimum_required(VERSION 3.4)

find_package(ITK REQUIRED)
if (ITK_USE_FILE)
  include(${ITK_USE_FILE})
endif(ITK_USE_FILE)

set(generated_srcs)

macro(generate_image_type suffix pixel_type dimension)
  set(PixelType ${pixel_type})
  set(Dim ${dimension})
  set(Suffix ${suffix})
  configure_file(Image.cxx ${CMAKE_CURRENT_BINARY_DIR}/Image${Suffix}.cxx)
  configure_file(GaussianFilters.cxx ${CMAKE_CURRENT_BINARY_DIR}/GaussianFilters${Suffix}.cxx)
  set(generated_srcs ${generated_srcs} Image${Suffix}.cxx GaussianFilters${Suffix}.cxx)
endmacro(generate_image_type)

generate_image_type(Float2D  float  2)
generate_image_type(Float3D  float  3)
generate_image_type(Double2D double 2)
generate_image_type(Double3D double 3)
generate_image_type(Short2D  short  2)
generate_image_type(Short3D  short  3)

add_library(itkffi SHARED ${generated_srcs})
target_link_libraries(itkffi ${ITK_LIBRARIES})
