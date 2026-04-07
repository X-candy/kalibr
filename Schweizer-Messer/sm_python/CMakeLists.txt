cmake_minimum_required(VERSION 3.10)
project(sm_python VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

option(BUILD_TESTING "Build tests" ON)

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
  message(STATUS "Building sm_python independently - assuming dependencies are installed")
  find_package(Boost REQUIRED COMPONENTS system serialization)
  find_package(Eigen3 REQUIRED)
  find_package(sm_common REQUIRED)
  find_package(numpy_eigen REQUIRED)
  find_package(sm_kinematics REQUIRED)
  find_package(sm_timing REQUIRED)
  find_package(sm_logging REQUIRED)
  find_package(sm_matrix_archive REQUIRED)
  find_package(sm_property_tree REQUIRED)
  find_package(python_module REQUIRED)
  find_package(Python3 REQUIRED COMPONENTS Development NumPy)
endif()

add_definitions(-D__STRICT_ANSI__)

include_directories(include ${EIGEN3_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

# 设置Python导出
SET(PY_PROJECT_NAME sm_python)
SET(PY_PACKAGE_DIR python/sm)

add_python_export_library(${PY_PROJECT_NAME} ${PY_PACKAGE_DIR}
  src/module.cpp
  src/export_rotational_kinematics.cpp
  src/export_rotations.cpp
  src/export_transformations.cpp
  src/export_quaternion_algebra.cpp
  src/export_homogeneous.cpp
  src/exportTransformation.cpp
  src/exportHomogeneousPoint.cpp
  src/exportTimestampCorrector.cpp
  src/exportPropertyTree.cpp
  src/exportEigen.cpp
  src/exportUncertainVector.cpp
  src/exportMatrixArchive.cpp
  src/export_kinematics_property_tree.cpp
  src/export_eigen_property_tree.cpp
  src/Logging.cpp
  src/exportNsecTime.cpp
  src/random.cpp
)

target_link_libraries(${PY_PROJECT_NAME}
  ${Boost_LIBRARIES}
  sm_common
  numpy_eigen
  sm_kinematics
  sm_timing
  sm_logging
  sm_matrix_archive
  sm_property_tree
)

catkin_python_setup()

##################
## Installation ##
##################

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
