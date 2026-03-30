cmake_minimum_required(VERSION 3.10)
project(aslam_splines_python VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 包含父项目的CMake模块（使用相对路径）
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/modules/FindDependencies.cmake)
  include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/modules/PythonBindingHelpers.cmake)
elseif(EXISTS ${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/PythonBindingHelpers.cmake)
else()
  message(STATUS "Building aslam_splines_python independently - assuming dependencies are installed")
  find_package(Python3 REQUIRED COMPONENTS Development NumPy)
  find_package(Boost REQUIRED)
endif()

kalibr_package(
  INCLUDE_DIRS include
)

include(GNUInstallDirs)

##############
## Building ##
##############

add_python_export_library(${PROJECT_NAME} python/aslam_splines
  src/spline_module.cpp
  src/BSplineMotionError.cpp
  src/SimpleSplineError.cpp
)
target_link_libraries(${PROJECT_NAME} ${Boost_LIBRARIES} ${KALIBR_LIBRARIES})
