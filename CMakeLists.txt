cmake_minimum_required(VERSION 3.10)
project(Kalibr LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CXX_EXTENSIONS OFF)

# CMake模块路径
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules")

# 输出目录配置
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 全局模块 include 路径 - 让所有模块都能找到彼此的头文件
include_directories(
  ${EIGEN3_INCLUDE_DIRS}
  ${Boost_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
  ${Python3_INCLUDE_DIRS}
  ${Python3_NumPy_INCLUDE_DIRS}
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_common/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_logging/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_random/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_boost/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_eigen/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_property_tree/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_timing/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_kinematics/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_matrix_archive/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_opencv/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/python_module/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/numpy_eigen/include
  ${CMAKE_SOURCE_DIR}/Schweizer-Messer/sm_python/include
  ${CMAKE_SOURCE_DIR}/aslam_optimizer/sparse_block_matrix/include
  ${CMAKE_SOURCE_DIR}/aslam_optimizer/aslam_backend/include
  ${CMAKE_SOURCE_DIR}/aslam_optimizer/aslam_backend_expressions/include
  ${CMAKE_SOURCE_DIR}/aslam_optimizer/aslam_backend_python/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_time/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_cameras/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_imgproc/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_cv_error_terms/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_cv_backend/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_cv_serialization/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_cameras_april/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_cv_python/include
  ${CMAKE_SOURCE_DIR}/aslam_cv/aslam_cv_backend_python/include
  ${CMAKE_SOURCE_DIR}/aslam_nonparametric_estimation/bsplines/include
  ${CMAKE_SOURCE_DIR}/aslam_nonparametric_estimation/aslam_splines/include
  ${CMAKE_SOURCE_DIR}/aslam_nonparametric_estimation/bsplines_python/include
  ${CMAKE_SOURCE_DIR}/aslam_nonparametric_estimation/aslam_splines_python/include
  ${CMAKE_SOURCE_DIR}/aslam_incremental_calibration/incremental_calibration/include
  ${CMAKE_SOURCE_DIR}/aslam_incremental_calibration/incremental_calibration_python/include
  ${CMAKE_SOURCE_DIR}/aslam_offline_calibration/ethz_apriltag2/include
  ${CMAKE_SOURCE_DIR}/aslam_offline_calibration/kalibr/include
)

# SuiteSparse 头文件路径（如果找到）
if(SUITESPARSE_FOUND)
  include_directories(${CHOLMOD_INCLUDE_DIR} ${CCOLAMD_INCLUDE_DIR} ${SUITESPARSE_CONFIG_INCLUDE_DIR})
endif()

# 包含CMake实用函数
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)
include(CMakeDependentOption)

# 第三方依赖查找
find_package(Eigen3 REQUIRED)
find_package(Boost REQUIRED COMPONENTS system thread regex program_options filesystem date_time serialization)
find_package(OpenCV REQUIRED)
find_package(Python3 REQUIRED COMPONENTS Development NumPy)
find_package(Threads REQUIRED)
find_package(spdlog REQUIRED)

# SuiteSparse 查找（用于稀疏矩阵求解）
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/aslam_optimizer/sparse_block_matrix/cmake")
find_package(SuiteSparse QUIET)
if(NOT SUITESPARSE_FOUND)
  message(WARNING "SuiteSparse not found, some features will be disabled")
  add_definitions(-DNO_SUITESPARSE)
endif()

# Schweizer-Messer基础模块 - 按依赖顺序添加
add_subdirectory(Schweizer-Messer/sm_common)
add_subdirectory(Schweizer-Messer/sm_logging)
add_subdirectory(Schweizer-Messer/sm_random)
add_subdirectory(Schweizer-Messer/sm_boost)
add_subdirectory(Schweizer-Messer/sm_eigen)
add_subdirectory(Schweizer-Messer/sm_property_tree)
add_subdirectory(Schweizer-Messer/sm_timing)
add_subdirectory(Schweizer-Messer/sm_kinematics)
add_subdirectory(Schweizer-Messer/sm_matrix_archive)
add_subdirectory(Schweizer-Messer/sm_opencv)
add_subdirectory(Schweizer-Messer/python_module)
add_subdirectory(Schweizer-Messer/numpy_eigen)
add_subdirectory(Schweizer-Messer/sm_python)

# aslam_optimizer模块 - 按依赖顺序添加
add_subdirectory(aslam_optimizer/sparse_block_matrix)
add_subdirectory(aslam_optimizer/aslam_backend)
add_subdirectory(aslam_optimizer/aslam_backend_expressions)
add_subdirectory(aslam_optimizer/aslam_backend_python)

# aslam_cv基础模块 - 按依赖顺序添加
add_subdirectory(aslam_cv/aslam_time)
add_subdirectory(aslam_cv/aslam_cameras)
add_subdirectory(aslam_cv/aslam_imgproc)
add_subdirectory(aslam_cv/aslam_cv_error_terms)
add_subdirectory(aslam_cv/aslam_cv_backend)
add_subdirectory(aslam_cv/aslam_cv_serialization)
add_subdirectory(aslam_cv/aslam_cameras_april)

# aslam_nonparametric_estimation模块 - 按依赖顺序添加
add_subdirectory(aslam_nonparametric_estimation/bsplines)
add_subdirectory(aslam_nonparametric_estimation/aslam_splines)
add_subdirectory(aslam_nonparametric_estimation/bsplines_python)
add_subdirectory(aslam_nonparametric_estimation/aslam_splines_python)

# aslam_incremental_calibration模块
add_subdirectory(aslam_incremental_calibration/incremental_calibration)

# aslam_offline_calibration模块
add_subdirectory(aslam_offline_calibration/ethz_apriltag2)
add_subdirectory(aslam_offline_calibration/kalibr)

# aslam_cv Python绑定模块 - 最后添加
add_subdirectory(aslam_cv/aslam_cv_python)
add_subdirectory(aslam_cv/aslam_cv_backend_python)

# aslam_incremental_calibration Python绑定
if(EXISTS ${CMAKE_SOURCE_DIR}/aslam_incremental_calibration/incremental_calibration_python/CMakeLists.txt)
  add_subdirectory(aslam_incremental_calibration/incremental_calibration_python)
endif()
