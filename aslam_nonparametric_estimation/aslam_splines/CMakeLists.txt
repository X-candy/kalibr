cmake_minimum_required(VERSION 3.10)
project(aslam_splines VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 包含父项目的CMake模块（使用相对路径）
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/modules/FindDependencies.cmake)
elseif(EXISTS ${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
else()
  message(STATUS "Building aslam_splines independently - assuming dependencies are installed")
  find_package(Eigen3 REQUIRED)
  find_package(Boost REQUIRED COMPONENTS system)
  find_package(OpenCV REQUIRED)
endif()

kalibr_package(
  LIBRARIES ${PROJECT_NAME}
  INCLUDE_DIRS include
  DEPENDS Boost bsplines aslam_backend aslam_backend_expressions sm_kinematics sparse_block_matrix
)

include_directories(include)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -D__STRICT_ANSI__")

include(GNUInstallDirs)

##############
## Building ##
##############

add_library(${PROJECT_NAME}
  src/BSplinePoseDesignVariable.cpp
  src/BSplineExpressions.cpp
  src/EuclideanBSplineDesignVariable.cpp
)
target_link_libraries(${PROJECT_NAME} ${Boost_LIBRARIES} ${KALIBR_LIB_LIBRARIES} ${OpenCV_LIBRARIES} bsplines aslam_backend aslam_backend_expressions sm_kinematics sparse_block_matrix)

if(BUILD_TESTING)
  enable_testing()
  find_package(GTest REQUIRED)

  add_definitions(-DGTEST_USE_OWN_TR1_TUPLE=0)

  add_executable(${PROJECT_NAME}_test
    test/test_main.cpp
    test/TestBSplineExpressions.cpp
    test/TestErrors.cpp
    #  test/TestOPTBSpline.cpp
  )
  target_link_libraries(${PROJECT_NAME}_test
    GTest::GTest
    GTest::Main
    pthread
    ${PROJECT_NAME}
    bsplines
    aslam_backend
    aslam_backend_expressions
    sm_kinematics
    sparse_block_matrix
  )
  add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME}_test)
endif()

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
