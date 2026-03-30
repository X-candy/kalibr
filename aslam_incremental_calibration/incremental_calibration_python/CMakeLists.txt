cmake_minimum_required(VERSION 3.10)
project(incremental_calibration_python VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_definitions(-fPIC)

# 包含全局依赖配置
include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/modules/ModuleDependencies.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/modules/PythonBindingHelpers.cmake)

# 内部依赖查找
kalibr_find_module(aslam_backend REQUIRED)
kalibr_find_module(incremental_calibration REQUIRED)
kalibr_find_module(sm_property_tree REQUIRED)
kalibr_find_module(python_module REQUIRED)
kalibr_find_module(numpy_eigen REQUIRED)

# 第三方依赖查找
find_package(Python3 REQUIRED COMPONENTS Development NumPy)

include_directories(
  include
  ${KALIBR_THIRD_PARTY_INCLUDE_DIRS}
  ${Python3_INCLUDE_DIRS}
  ${Python3_NumPy_INCLUDE_DIRS}
  ${aslam_backend_INCLUDE_DIRS}
  ${incremental_calibration_INCLUDE_DIRS}
  ${sm_property_tree_INCLUDE_DIRS}
)

add_python_export_library(${PROJECT_NAME} python/incremental_calibration
  src/module.cpp
  src/OptimizationProblem.cpp
  src/IncrementalEstimator.cpp
  src/LinearSolver.cpp
)
target_link_libraries(${PROJECT_NAME}
  ${KALIBR_THIRD_PARTY_LIBRARIES}
  ${Python3_LIBRARIES}
  ${aslam_backend_LIBRARIES}
  ${incremental_calibration_LIBRARIES}
)

# Python包配置
kalibr_python_setup(
  PACKAGE_DIR "python"
  PACKAGES "incremental_calibration"
)

##################
## Installation ##
##################
include(GNUInstallDirs)

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
