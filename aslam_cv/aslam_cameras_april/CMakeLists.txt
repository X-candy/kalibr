cmake_minimum_required(VERSION 3.10)
project(aslam_cameras_april VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

ADD_DEFINITIONS(-DASLAM_USE_ROS)

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
  message(STATUS "Building aslam_cameras_april independently - assuming dependencies are installed")
  find_package(Boost REQUIRED COMPONENTS serialization system)
  find_package(OpenCV REQUIRED)
  find_package(Eigen3 REQUIRED)
  find_package(Python3 REQUIRED COMPONENTS Development NumPy)
endif()

kalibr_package(
  LIBRARIES ${PROJECT_NAME}
  INCLUDE_DIRS include
  DEPENDS OpenCV Boost
)

# 内部依赖查找
kalibr_find_module(aslam_cameras REQUIRED)
kalibr_find_module(sm_common REQUIRED)
kalibr_find_module(sm_logging REQUIRED)
kalibr_find_module(sm_property_tree REQUIRED)
kalibr_find_module(sm_opencv REQUIRED)
kalibr_find_module(sm_eigen REQUIRED)

include_directories(include
  ${aslam_cameras_INCLUDE_DIRS}
  ${sm_common_INCLUDE_DIRS}
  ${sm_logging_INCLUDE_DIRS}
  ${sm_property_tree_INCLUDE_DIRS}
  ${sm_opencv_INCLUDE_DIRS}
  ${sm_eigen_INCLUDE_DIRS}
)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -D__STRICT_ANSI__")

include(GNUInstallDirs)

##############
## Building ##
##############

add_library(${PROJECT_NAME}
  src/GridCalibrationTargetAprilgrid.cpp
)
target_link_libraries(${PROJECT_NAME} ${Boost_LIBRARIES} ${OpenCV_LIBRARIES})

# 确保库使用位置无关代码（PIC）编译，以便可以被共享库链接
set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Python绑定
add_python_export_library(${PROJECT_NAME}_python python/aslam_cameras_april
  src/module.cpp
)
target_link_libraries(${PROJECT_NAME}_python ${PROJECT_NAME} ${sm_python_LIBRARIES} ${python_module_LIBRARIES})

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

# 生成CMake配置文件（让其他模块可以find_package）
include(CMakePackageConfigHelpers)

configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)

install(EXPORT ${PROJECT_NAME}Targets
  FILE ${PROJECT_NAME}Targets.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)
