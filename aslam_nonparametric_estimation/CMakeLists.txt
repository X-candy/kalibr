cmake_minimum_required(VERSION 3.10)
project(aslam_nonparametric_estimation VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 非参数估计模块 - 按依赖顺序添加
add_subdirectory(bsplines)
add_subdirectory(bsplines_python)
add_subdirectory(aslam_splines)
add_subdirectory(aslam_splines_python)
