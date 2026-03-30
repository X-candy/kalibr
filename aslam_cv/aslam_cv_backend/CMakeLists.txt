cmake_minimum_required(VERSION 3.10)
project(aslam_cv_backend VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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
  message(STATUS "Building aslam_cv_backend independently - assuming dependencies are installed")
  find_package(Boost REQUIRED COMPONENTS system)
  find_package(OpenCV REQUIRED)
  find_package(Eigen3 REQUIRED)
  find_package(sm_common REQUIRED)
  find_package(sm_boost REQUIRED)
  find_package(sm_kinematics REQUIRED)
  find_package(sm_eigen REQUIRED)
  find_package(sm_opencv REQUIRED)
  find_package(sm_property_tree REQUIRED)
  find_package(sm_logging REQUIRED)
  find_package(sm_timing REQUIRED)
  find_package(GTest)
  if(GTest_FOUND)
    enable_testing()
  find_package(Python3 REQUIRED COMPONENTS Development NumPy)
  endif()
endif()

kalibr_package(
  LIBRARIES ${PROJECT_NAME}
  INCLUDE_DIRS include
  DEPENDS Boost OpenCV GTest
)

include_directories(
  include
  ${Boost_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIRS}
  ${sm_common_INCLUDE_DIRS}
  ${sm_boost_INCLUDE_DIRS}
  ${sm_kinematics_INCLUDE_DIRS}
  ${sm_eigen_INCLUDE_DIRS}
  ${sm_opencv_INCLUDE_DIRS}
  ${sm_property_tree_INCLUDE_DIRS}
  ${sm_logging_INCLUDE_DIRS}
  ${sm_timing_INCLUDE_DIRS}
)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -D__STRICT_ANSI__")

include(GNUInstallDirs)

##############
## Building ##
##############

add_library(${PROJECT_NAME}
  src/CameraGeometryDesignVariableContainer.cpp
  src/GridCalibrationTargetDesignVariableContainer.cpp
  src/NCameraSystemDesignVariableContainer.cpp
  src/NCameraSystemEstimation.cpp
)
target_link_libraries(${PROJECT_NAME}
  ${Boost_LIBRARIES}
)

target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

##################
## error terms (+python export) - 暂时禁用，缺少源文件
##################

kalibr_find_module(aslam_backend REQUIRED)
kalibr_find_module(aslam_backend_expressions REQUIRED)
kalibr_find_module(aslam_cv_error_terms REQUIRED)

# Python 绑定暂时禁用
# add_python_export_library(${PROJECT_NAME}_errorterms_python python/${PROJECT_NAME}_errorterms/..
#   src/module.cpp
# )
# target_link_libraries(${PROJECT_NAME}_errorterms_python
#   ${PROJECT_NAME}
#   ${sm_python_LIBRARIES}
#   ${python_module_LIBRARIES}
# )

##################
## tests
##################

if(BUILD_TESTING)
  # Avoid clash with tr1::tuple
  add_definitions(-DGTEST_USE_OWN_TR1_TUPLE=0)

  add_executable(${PROJECT_NAME}_test
    test/test_main.cpp
    test/TestErrorTerms.cpp
  )
  target_link_libraries(${PROJECT_NAME}_test
    GTest::GTest
    GTest::Main
    pthread
    ${PROJECT_NAME}
  )
  add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME}_test)
endif()

##################
## EXPORT
##################

catkin_python_setup()

install(TARGETS ${PROJECT_NAME}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

## Mark cpp header files for installation
install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
