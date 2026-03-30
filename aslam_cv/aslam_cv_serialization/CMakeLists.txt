cmake_minimum_required(VERSION 3.10)
project(aslam_cv_serialization VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 包含CMake模块
if(EXISTS ${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/ModuleDependencies.cmake)
else()
  # 独立编译时依赖处理
  find_package(Boost REQUIRED COMPONENTS serialization system)
  find_package(OpenCV REQUIRED)
  find_package(Eigen3 REQUIRED)
  find_package(aslam_cameras REQUIRED)
  find_package(aslam_time REQUIRED)
  find_package(sm_common REQUIRED)
  find_package(sm_boost REQUIRED)
  find_package(sm_property_tree REQUIRED)
  find_package(sm_eigen REQUIRED)
  find_package(sm_kinematics REQUIRED)
  find_package(sm_opencv REQUIRED)
  find_package(sm_logging REQUIRED)
  find_package(sm_random REQUIRED)
endif()

# 内部依赖查找
kalibr_find_module(aslam_cameras REQUIRED)
kalibr_find_module(aslam_time REQUIRED)
kalibr_find_module(sm_common REQUIRED)
kalibr_find_module(sm_boost REQUIRED)
kalibr_find_module(sm_property_tree REQUIRED)
kalibr_find_module(sm_eigen REQUIRED)
kalibr_find_module(sm_kinematics REQUIRED)
kalibr_find_module(sm_opencv REQUIRED)
kalibr_find_module(sm_logging REQUIRED)
kalibr_find_module(sm_random REQUIRED)

# 第三方依赖查找
find_package(Boost REQUIRED COMPONENTS serialization system)
find_package(OpenCV REQUIRED)
find_package(Eigen3 REQUIRED)

#common commands for building c++ executables and libraries
INCLUDE(autogen_cameras.cmake)
#INCLUDE(autogen_frames.cmake)

include_directories(
  include
  ${Boost_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIRS}
  ${aslam_cameras_INCLUDE_DIRS}
  ${aslam_time_INCLUDE_DIRS}
  ${sm_common_INCLUDE_DIRS}
  ${sm_boost_INCLUDE_DIRS}
  ${sm_property_tree_INCLUDE_DIRS}
  ${sm_eigen_INCLUDE_DIRS}
  ${sm_kinematics_INCLUDE_DIRS}
  ${sm_opencv_INCLUDE_DIRS}
  ${sm_logging_INCLUDE_DIRS}
  ${sm_random_INCLUDE_DIRS}
)

include(GNUInstallDirs)

add_library(${PROJECT_NAME}
  ${AUTOGEN_CAMERA_CPP_FILES}
  src/FrameBaseSerialization.cpp
)
target_link_libraries(${PROJECT_NAME}
  ${Boost_LIBRARIES}
  ${OpenCV_LIBRARIES}
  ${aslam_cameras_LIBRARIES}
  ${aslam_time_LIBRARIES}
  ${sm_common_LIBRARIES}
  ${sm_boost_LIBRARIES}
  ${sm_property_tree_LIBRARIES}
  ${sm_eigen_LIBRARIES}
  ${sm_kinematics_LIBRARIES}
  ${sm_opencv_LIBRARIES}
  ${sm_logging_LIBRARIES}
  ${sm_random_LIBRARIES}
)

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

## Mark cpp header files for installation
install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# 生成CMake配置文件
include(CMakePackageConfigHelpers)

# 创建Config.cmake.in模板文件
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake.in "@PACKAGE_INIT@
include(\"\${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@Targets.cmake\")
check_required_components(@PROJECT_NAME@)
")

configure_package_config_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake.in"
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
  # Avoid clash with tr1::tuple: https://code.google.com/p/googletest/source/browse/trunk/README?r=589#257
  add_definitions(-DGTEST_USE_OWN_TR1_TUPLE=0)

  # 测试已被注释，保持原状态
  message(STATUS "Tests for aslam_cv_serialization are currently disabled")
endif()
