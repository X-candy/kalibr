cmake_minimum_required(VERSION 3.10)
project(aslam_cv_python VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_definitions(-fPIC -Wextra -Winit-self -Woverloaded-virtual -Wnon-virtual-dtor -Wsign-promo -Wno-long-long)

if(APPLE)
  add_definitions( -ftemplate-depth-1024)
endif()

# 包含CMake模块
if(EXISTS ${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/ModuleDependencies.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/PythonBindingHelpers.cmake)
else()
  # 独立编译时依赖处理
  find_package(Boost REQUIRED COMPONENTS serialization)
  find_package(OpenCV REQUIRED)
  find_package(Python3 REQUIRED COMPONENTS Development NumPy)
  find_package(sm_common REQUIRED)
  find_package(sm_eigen REQUIRED)
  find_package(sm_kinematics REQUIRED)
  find_package(sm_python REQUIRED)
  find_package(sm_opencv REQUIRED)
  find_package(python_module REQUIRED)
  find_package(aslam_cv_serialization REQUIRED)
  find_package(aslam_imgproc REQUIRED)
  find_package(aslam_cameras REQUIRED)
  find_package(aslam_time REQUIRED)
endif()

# 内部依赖查找
kalibr_find_module(sm_common REQUIRED)
kalibr_find_module(sm_eigen REQUIRED)
kalibr_find_module(sm_kinematics REQUIRED)
kalibr_find_module(sm_python REQUIRED)
kalibr_find_module(sm_opencv REQUIRED)
kalibr_find_module(python_module REQUIRED)
kalibr_find_module(aslam_cv_serialization REQUIRED)
kalibr_find_module(aslam_imgproc REQUIRED)
kalibr_find_module(aslam_cameras REQUIRED)
kalibr_find_module(aslam_time REQUIRED)

# 第三方依赖查找
find_package(Boost REQUIRED COMPONENTS serialization)
find_package(OpenCV REQUIRED)
find_package(Python3 REQUIRED COMPONENTS Development NumPy)

include_directories(
  include
  ${Boost_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
  ${Python3_INCLUDE_DIRS}
  ${Python3_NumPy_INCLUDE_DIRS}
  ${sm_common_INCLUDE_DIRS}
  ${sm_eigen_INCLUDE_DIRS}
  ${sm_kinematics_INCLUDE_DIRS}
  ${sm_python_INCLUDE_DIRS}
  ${sm_opencv_INCLUDE_DIRS}
  ${python_module_INCLUDE_DIRS}
  ${aslam_cv_serialization_INCLUDE_DIRS}
  ${aslam_imgproc_INCLUDE_DIRS}
  ${aslam_cameras_INCLUDE_DIRS}
  ${aslam_time_INCLUDE_DIRS}
)

include(GNUInstallDirs)

##############
## Building ##
##############

add_python_export_library(${PROJECT_NAME} python/aslam_cv
  src/module.cpp
  src/CameraGeometries.cpp
  src/CameraGeometry.cpp
  src/Time.cpp
#  src/CameraSystem.cpp
#  src/CameraSystemClasses.cpp
#  src/MatchingAlgorithms.cpp
#  src/MultiFrame.cpp
  src/Frontend.cpp
  src/Frame.cpp
#  src/Descriptors.cpp
  src/CameraProjections.cpp
  src/CameraShutters.cpp
#  src/ImageSynchronizer.cpp
#  src/FrameBuilder.cpp
#  src/ImageContainer.cpp
  src/GridCalibration.cpp
#  src/Landmark.cpp
  src/Undistorters.cpp
#  src/NCameras.cpp
#  src/MultiFrameFactory.cpp
  src/OmniUndistorter.cpp
  src/PinholeUndistorter.cpp
)
target_compile_options(${PROJECT_NAME} PUBLIC "-Wno-deprecated-copy") # TODO: Fix...
target_link_libraries(${PROJECT_NAME}
  ${Boost_LIBRARIES}
  ${OpenCV_LIBRARIES}
  ${Python3_LIBRARIES}
  ${sm_common_LIBRARIES}
  ${sm_eigen_LIBRARIES}
  ${sm_kinematics_LIBRARIES}
  ${sm_python_LIBRARIES}
  ${sm_opencv_LIBRARIES}
  ${python_module_LIBRARIES}
  ${aslam_cv_serialization_LIBRARIES}
  ${aslam_imgproc_LIBRARIES}
  ${aslam_cameras_LIBRARIES}
  ${aslam_time_LIBRARIES}
)

# Python包配置
kalibr_python_setup(
  PACKAGE_DIR "python"
  PACKAGES "aslam_cv"
)

##################
## Installation ##
##################

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
