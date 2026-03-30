cmake_minimum_required(VERSION 3.10)
project(aslam_cv VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 视觉模块 - 按依赖顺序添加
add_subdirectory(aslam_time)
add_subdirectory(aslam_cameras)
add_subdirectory(aslam_cameras_april)
add_subdirectory(aslam_imgproc)
add_subdirectory(aslam_cv_error_terms)
add_subdirectory(aslam_cv_backend)
add_subdirectory(aslam_cv_serialization)
add_subdirectory(aslam_cv_python)
add_subdirectory(aslam_cv_backend_python)
