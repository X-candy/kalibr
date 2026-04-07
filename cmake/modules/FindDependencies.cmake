# 统一的第三方依赖查找策略

# Eigen3 查找 - 保持与原项目兼容
find_package(Eigen3 REQUIRED)

# Boost 查找 - 统一配置
find_package(Boost REQUIRED COMPONENTS
  system
  thread
  regex
  program_options
  filesystem
  date_time
)

# OpenCV 查找
find_package(OpenCV REQUIRED COMPONENTS
  core
  imgproc
  highgui
  calib3d
  features2d
)

# Python 查找
find_package(Python3 REQUIRED COMPONENTS
  Development
  NumPy
)

# 线程库
find_package(Threads REQUIRED)
find_package(fmt REQUIRED)

# GTest 查找（可选）
option(BUILD_TESTING "Build tests" OFF)
if(BUILD_TESTING)
  find_package(GTest)
  if(GTest_FOUND)
    enable_testing()
  else()
    message(WARNING "GTest not found, tests will not be built")
    set(BUILD_TESTING OFF)
  endif()
endif()

# 全局模块 include 路径 - 让所有模块都能找到彼此的头文件
set(KALIBR_MODULE_INCLUDE_DIRS
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

# 导出依赖变量
set(KALIBR_THIRD_PARTY_INCLUDE_DIRS
  ${EIGEN3_INCLUDE_DIRS}
  ${Boost_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
  ${Python3_INCLUDE_DIRS}
  ${Python3_NumPy_INCLUDE_DIRS}
  ${KALIBR_MODULE_INCLUDE_DIRS}
)

set(KALIBR_THIRD_PARTY_LIBRARIES
  ${Boost_LIBRARIES}
  ${OpenCV_LIBRARIES}
  ${Python3_LIBRARIES}
  ${CMAKE_THREAD_LIBS_INIT}
  fmt::fmt
)

if(GTest_FOUND)
  list(APPEND KALIBR_THIRD_PARTY_INCLUDE_DIRS ${GTEST_INCLUDE_DIRS})
  list(APPEND KALIBR_THIRD_PARTY_LIBRARIES ${GTEST_LIBRARIES} ${GTEST_MAIN_LIBRARIES})
endif()
