cmake_minimum_required(VERSION 3.10)
project(Schweizer-Messer VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# CMake模块路径
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../cmake/modules")

# 包含父项目的CMake模块
include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/modules/CatkinReplacements.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/modules/FindDependencies.cmake)

# 按依赖顺序添加子模块 - 增量添加
add_subdirectory(sm_common)
add_subdirectory(sm_logging)
add_subdirectory(sm_boost)
add_subdirectory(sm_random)
add_subdirectory(sm_eigen)
add_subdirectory(sm_matrix_archive)
add_subdirectory(sm_timing)
add_subdirectory(sm_property_tree)
