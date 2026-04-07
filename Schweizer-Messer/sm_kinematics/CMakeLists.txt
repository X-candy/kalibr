cmake_minimum_required(VERSION 3.10)
project(sm_kinematics VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

option(BUILD_TESTING "Build tests" ON)

# 包含全局依赖配置
include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)

find_package(Boost REQUIRED COMPONENTS system serialization filesystem)
find_package(Eigen3 REQUIRED)

include_directories(
  include
  ${EIGEN3_INCLUDE_DIRS}
  ${Boost_INCLUDE_DIRS}
)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

add_library(${PROJECT_NAME}
  src/quaternion_algebra.cpp
  src/rotations.cpp
  src/transformations.cpp
  src/RotationalKinematics.cpp
  src/RotationVector.cpp
  src/EulerAnglesZYX.cpp
  src/EulerAnglesYawPitchRoll.cpp
  src/EulerRodriguez.cpp
  src/Transformation.cpp
  src/homogeneous_coordinates.cpp
  src/HomogeneousPoint.cpp
  src/UncertainTransformation.cpp
  src/UncertainHomogeneousPoint.cpp
  src/three_point_methods.cpp
  src/EulerAnglesZXY.cpp
)

# 确保库使用位置无关代码（PIC）编译，以便可以被共享库链接
set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)

target_link_libraries(${PROJECT_NAME}
  ${Boost_LIBRARIES}
  sm_common
  sm_eigen
  sm_boost
  sm_random
)

target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

install(TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}Targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

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

if(BUILD_TESTING)
  enable_testing()
  find_package(GTest REQUIRED)

  add_definitions(-DGTEST_USE_OWN_TR1_TUPLE=0)

  add_executable(${PROJECT_NAME}-test
    test/RotationalKinematicsTests.cpp
    test/QuaternionTests.cpp
    test/TransformationTests.cpp
    test/transformations.cpp
    test/HomogeneousPoint.cpp
    test/UncertainHomogeneousPoint.cpp
    test/test_main.cpp
    test/UncertainTransformationTests.cpp
    test/homogeneous_coordinates.cpp
    test/three_point_methods.cpp
  )
  target_link_libraries(${PROJECT_NAME}-test
    GTest::GTest
    GTest::Main
    pthread
    ${PROJECT_NAME}
  )
  add_test(NAME ${PROJECT_NAME}-test COMMAND ${PROJECT_NAME}-test)
endif()
