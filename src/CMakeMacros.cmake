cmake_minimum_required(VERSION 3.4)

macro(generate_image_type suffix pixel_type dimension prefix srcs)
  set(Prefix ${prefix})
  set(PixelType ${pixel_type})
  set(Dim ${dimension})
  set(Suffix ${suffix})
  list(APPEND ITKFFI_WRAP "wrap(itk,'${PixelType}','${Suffix}')")
  configure_file(${Prefix}/Image.cxx ${CMAKE_CURRENT_BINARY_DIR}/Image${Suffix}.cxx)
  list(APPEND generated_srcs ${CMAKE_CURRENT_BINARY_DIR}/Image${Suffix}.cxx)
  foreach (src ${srcs})
      configure_file(${Prefix}/${src}.cxx ${CMAKE_CURRENT_BINARY_DIR}/${src}${Suffix}.cxx)
      list(APPEND generated_srcs ${CMAKE_CURRENT_BINARY_DIR}/${src}${Suffix}.cxx)
  endforeach(src)
endmacro(generate_image_type)
