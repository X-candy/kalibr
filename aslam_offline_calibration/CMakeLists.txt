cmake_minimum_required(VERSION 3.10)
project(aslam_offline_calibration VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 离线校准模块 - 按依赖顺序添加
add_subdirectory(ethz_apriltag2)
add_subdirectory(kalibr)
