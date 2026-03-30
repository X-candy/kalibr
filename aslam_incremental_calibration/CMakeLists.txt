cmake_minimum_required(VERSION 3.10)
project(aslam_incremental_calibration VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 增量校准模块 - 按依赖顺序添加
add_subdirectory(incremental_calibration)
add_subdirectory(incremental_calibration_python)
