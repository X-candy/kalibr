cmake_minimum_required(VERSION 3.10)
project(aslam_optimizer VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 优化模块 - 按依赖顺序添加
add_subdirectory(sparse_block_matrix)
add_subdirectory(aslam_backend)
add_subdirectory(aslam_backend_expressions)
add_subdirectory(aslam_backend_python)
