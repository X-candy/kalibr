cmake_minimum_required(VERSION 3.10)
project(kalibr LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CXX_EXTENSIONS OFF)

# CMake模块路径
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)

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
  message(STATUS "Building kalibr independently - assuming dependencies are installed")
  find_package(Boost REQUIRED COMPONENTS serialization system)
  find_package(OpenCV REQUIRED)
  find_package(Eigen3 REQUIRED)
  find_package(GTest)
  if(GTest_FOUND)
    enable_testing()
  endif()
endif()

# 内部依赖查找 - Schweizer-Messer基础模块
kalibr_find_module(sm_common REQUIRED)
kalibr_find_module(sm_logging REQUIRED)
kalibr_find_module(sm_eigen REQUIRED)
kalibr_find_module(sm_opencv REQUIRED)
kalibr_find_module(sm_kinematics REQUIRED)
kalibr_find_module(sm_property_tree REQUIRED)
kalibr_find_module(sm_timing REQUIRED)
kalibr_find_module(aslam_backend REQUIRED)
kalibr_find_module(aslam_backend_expressions REQUIRED)
kalibr_find_module(aslam_cv_backend REQUIRED)
kalibr_find_module(aslam_cv_error_terms REQUIRED)
kalibr_find_module(aslam_cameras REQUIRED)
kalibr_find_module(aslam_imgproc REQUIRED)
kalibr_find_module(aslam_time REQUIRED)
kalibr_find_module(sparse_block_matrix REQUIRED)
kalibr_find_module(sm_python REQUIRED)
kalibr_find_module(numpy_eigen REQUIRED)
kalibr_find_module(python_module REQUIRED)

# 第三方依赖查找
find_package(Boost REQUIRED COMPONENTS serialization system)
find_package(OpenCV REQUIRED)
find_package(Eigen3 REQUIRED)

include_directories(
  include
  ${Boost_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIRS}
)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -D__STRICT_ANSI__")

include(GNUInstallDirs)

##############
## error terms (cpp library)
##############

add_library(${PROJECT_NAME}_errorterms
  src/EuclideanError.cpp
  src/GyroscopeError.cpp
  src/AccelerometerError.cpp
)
target_link_libraries(${PROJECT_NAME}_errorterms
  ${Boost_LIBRARIES}
  ${KALIBR_LIBRARIES}
)

target_include_directories(${PROJECT_NAME}_errorterms PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

##################
## Installation ##
##################

install(TARGETS ${PROJECT_NAME}_errorterms
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

##################
## Testing
##################
if(BUILD_TESTING)
  find_package(GTest REQUIRED)

  # 测试1: IMU误差项测试
  add_executable(kalibr_test
    test/test_main.cpp
    test/TestErrorTerms.cpp
  )
  target_link_libraries(kalibr_test
    GTest::GTest
    GTest::Main
    pthread
    kalibr_errorterms
    aslam_backend
    aslam_backend_expressions
    sm_kinematics
    sm_eigen
    sm_common
    sm_logging
    ${Boost_LIBRARIES}
  )
  add_test(NAME kalibr_test COMMAND kalibr_test)

  # 测试2: 相机标定测试
  add_executable(kalibr_camera_calibration_test
    test/test_main.cpp
    test/TestCameraCalibration.cpp
  )
  target_link_libraries(kalibr_camera_calibration_test
    GTest::GTest
    GTest::Main
    pthread
    kalibr_errorterms
    aslam_backend
    aslam_backend_expressions
    aslam_cameras
    aslam_time
    aslam_imgproc
    aslam_cv_backend
    sm_kinematics
    sm_eigen
    sm_common
    sm_logging
    sm_property_tree
    sm_opencv
    sm_timing
    sparse_block_matrix
    fmt::fmt
    ${Boost_LIBRARIES}
    ${OpenCV_LIBRARIES}
  )
  add_test(NAME kalibr_camera_calibration_test COMMAND kalibr_camera_calibration_test)
endif()
