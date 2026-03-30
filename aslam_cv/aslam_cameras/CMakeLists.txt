cmake_minimum_required(VERSION 3.10)
project(aslam_cameras VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

ADD_DEFINITIONS(-DASLAM_USE_ROS)

# 包含CMake模块
if(EXISTS ${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/ModuleDependencies.cmake)
else()
  # 独立编译时依赖处理
  find_package(Boost REQUIRED COMPONENTS system serialization filesystem)
  find_package(Eigen3 REQUIRED)
  find_package(OpenCV REQUIRED)
  find_package(aslam_time REQUIRED)
  find_package(sm_common REQUIRED)
  find_package(sm_eigen REQUIRED)
  find_package(sm_boost REQUIRED)
  find_package(sm_kinematics REQUIRED)
  find_package(sm_logging REQUIRED)
  find_package(sm_opencv REQUIRED)
  find_package(sm_property_tree REQUIRED)
  find_package(sm_random REQUIRED)
endif()

# 内部依赖查找
kalibr_find_module(aslam_time REQUIRED)
kalibr_find_module(sm_common REQUIRED)
kalibr_find_module(sm_eigen REQUIRED)
kalibr_find_module(sm_boost REQUIRED)
kalibr_find_module(sm_kinematics REQUIRED)
kalibr_find_module(sm_logging REQUIRED)
kalibr_find_module(sm_opencv REQUIRED)
kalibr_find_module(sm_property_tree REQUIRED)
kalibr_find_module(sm_random REQUIRED)

# 第三方依赖查找
find_package(Boost REQUIRED COMPONENTS system serialization filesystem)
find_package(Eigen3 REQUIRED)
find_package(OpenCV REQUIRED)

include_directories(include
  ${Boost_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIR}
  ${OpenCV_INCLUDE_DIRS}
  ${aslam_time_INCLUDE_DIRS}
  ${sm_common_INCLUDE_DIRS}
  ${sm_eigen_INCLUDE_DIRS}
  ${sm_boost_INCLUDE_DIRS}
  ${sm_kinematics_INCLUDE_DIRS}
  ${sm_logging_INCLUDE_DIRS}
  ${sm_opencv_INCLUDE_DIRS}
  ${sm_property_tree_INCLUDE_DIRS}
  ${sm_random_INCLUDE_DIRS}
)

##############
## Building ##
##############

add_library(${PROJECT_NAME}
  src/CameraGeometryBase.cpp
  src/GlobalShutter.cpp
  src/RollingShutter.cpp
  src/NoMask.cpp
  src/NoDistortion.cpp
  src/RadialTangentialDistortion.cpp
  src/EquidistantDistortion.cpp
  src/FovDistortion.cpp
  src/ImageMask.cpp
  src/GridCalibrationTargetObservation.cpp
  src/GridCalibrationTargetBase.cpp
  src/GridCalibrationTargetCheckerboard.cpp
  src/GridCalibrationTargetCirclegrid.cpp
  src/GridDetector.cpp
  src/Triangulation.cpp
  src/FrameBase.cpp
  src/KeypointBase.cpp
  src/DescriptorBase.cpp
  src/BackProjection.cpp
  src/Landmark.cpp
  src/Image.cpp
  src/DepthCameraGeometry.cpp
  src/MaskedCameraGeometry.cpp
  src/PinholeCameraGeometry.cpp
  src/SphericalCameraGeometry.cpp
  src/PinholeRSCameraGeometry.cpp
  src/OmniCameraGeometry.cpp
)

target_link_libraries(${PROJECT_NAME}
  ${Boost_LIBRARIES}
  ${OpenCV_LIBRARIES}
  ${aslam_time_LIBRARIES}
  ${sm_common_LIBRARIES}
  ${sm_eigen_LIBRARIES}
  ${sm_boost_LIBRARIES}
  ${sm_kinematics_LIBRARIES}
  ${sm_logging_LIBRARIES}
  ${sm_opencv_LIBRARIES}
  ${sm_property_tree_LIBRARIES}
  ${sm_random_LIBRARIES}
)

target_compile_options(${PROJECT_NAME} PUBLIC "-Wno-deprecated-copy")

# 目标包含目录
target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

##################
## Installation ##
##################

install(TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}Targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# CMake配置文件
include(CMakePackageConfigHelpers)
configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)

install(EXPORT ${PROJECT_NAME}Targets
  FILE ${PROJECT_NAME}Targets.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

#############
## Testing ##
#############
if(BUILD_TESTING)
  enable_testing()
  find_package(GTest REQUIRED)
  add_definitions(-DGTEST_USE_OWN_TR1_T_TUPLE=0)

  add_executable(${PROJECT_NAME}-test
    test/test_main.cpp
    test/PinholeCameraGeometry.cpp
    test/OmniCameraGeometry.cpp
    test/ExtendedUnifiedCameraGeometry.cpp
    test/DoubleSphereCameraGeometry.cpp
    test/RadialTangentialDistortion.cpp
    test/EquidistantDistortion.cpp
    test/FovDistortion.cpp
    test/Triangulation.cpp
    test/testFrame.cpp
    test/GridCalibration.cpp
  )

  target_link_libraries(${PROJECT_NAME}-test
    ${PROJECT_NAME}
    GTest::GTest
    GTest::Main
    pthread
  )

  add_test(NAME ${PROJECT_NAME}-test COMMAND ${PROJECT_NAME}-test)
endif()
