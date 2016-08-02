cmake_minimum_required(VERSION 3.4 FATAL_ERROR)

find_package(Torch REQUIRED)
find_package(ITK REQUIRED)

if (ITK_USE_FILE)
  include(${ITK_USE_FILE})
endif(ITK_USE_FILE)

if(LUAROCKS_PREFIX)
  message(STATUS "Installing Torch through Luarocks")
  string(REGEX REPLACE "(.*)lib/luarocks/rocks.*" "\\1" CMAKE_INSTALL_PREFIX  "${LUAROCKS_PREFIX}")
  message(STATUS "Prefix inferred from Luarocks: ${CMAKE_INSTALL_PREFIX}")
endif()

set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../src")

include(${SOURCE_DIR}/CMakeMacros.cmake)

set(srcs
  GaussianFilters
  )

generate_image_type(Float2D  float  2 ${SOURCE_DIR} ${srcs})
generate_image_type(Float3D  float  3 ${SOURCE_DIR} ${srcs})
generate_image_type(Double2D double 2 ${SOURCE_DIR} ${srcs})
generate_image_type(Double3D double 3 ${SOURCE_DIR} ${srcs})
generate_image_type(Short2D  short  2 ${SOURCE_DIR} ${srcs})
generate_image_type(Short3D  short  3 ${SOURCE_DIR} ${srcs})

add_library(citkffi SHARED ${generated_srcs})
target_link_libraries(citkffi ${ITK_LIBRARIES})

file(GLOB luasrc "${CMAKE_SOURCE_DIR}/*.lua")
add_torch_package(itkffi "" "${luasrc}" "ITKFFI")

configure_file(${CMAKE_SOURCE_DIR}/init.lua.in ${CMAKE_CURRENT_BINARY_DIR}/init.lua)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/init.lua DESTINATION ${Torch_INSTALL_LUA_PATH_SUBDIR}/itkffi)

install(TARGETS citkffi LIBRARY DESTINATION ${Torch_INSTALL_LUA_PATH_SUBDIR}/itkffi/lib)


