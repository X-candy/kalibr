cmake_minimum_required(VERSION 3.10)
project(incremental_calibration VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 包含全局依赖配置
include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/modules/ModuleDependencies.cmake)

# 内部依赖查找
kalibr_find_module(sm_eigen REQUIRED)
kalibr_find_module(aslam_backend REQUIRED)

# 第三方依赖查找
find_package(Boost REQUIRED COMPONENTS system thread)
find_package(Eigen3 REQUIRED)
find_package(TBB REQUIRED)

include_directories(
  include
  ${KALIBR_THIRD_PARTY_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIR}
  ${sm_eigen_INCLUDE_DIRS}
  ${aslam_backend_INCLUDE_DIRS}
  ${TBB_INCLUDE_DIRS}
)

add_library(${PROJECT_NAME}
  src/base/Serializable.cpp
  src/base/Timestamp.cpp
  src/base/Condition.cpp
  src/base/Mutex.cpp
  src/base/Thread.cpp
  src/base/Threads.cpp
  src/base/Timer.cpp
  src/exceptions/Exception.cpp
  src/exceptions/InvalidOperationException.cpp
  src/exceptions/NullPointerException.cpp
  src/exceptions/SystemException.cpp
  src/statistics/NormalDistribution1v.cpp
  src/statistics/ChiSquareDistribution.cpp
  src/statistics/EstimatorMLNormal1v.cpp
  src/functions/IncompleteGammaPFunction.cpp
  src/functions/IncompleteGammaQFunction.cpp
  src/functions/LogFactorialFunction.cpp
  src/functions/LogGammaFunction.cpp
  src/core/IncrementalEstimator.cpp
  src/core/OptimizationProblem.cpp
  src/core/IncrementalOptimizationProblem.cpp
  src/core/LinearSolver.cpp
  src/core/LinearSolverOptions.cpp
  src/algorithms/marginalize.cpp
  src/algorithms/linalg.cpp
)
target_link_libraries(${PROJECT_NAME}
  ${KALIBR_THIRD_PARTY_LIBRARIES}
  ${Boost_LIBRARIES}
  ${TBB_LIBRARIES}
  ${sm_eigen_LIBRARIES}
  ${aslam_backend_LIBRARIES}
)

# 设置目标属性
target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

if(BUILD_TESTING)
  # Avoid clash with tr1::tuple:
  # https://code.google.com/p/googletest/source/browse/trunk/README?r=589#257
  add_definitions(-DGTEST_USE_OWN_TR1_TUPLE=0)

  add_executable(${PROJECT_NAME}_test
    test/test_main.cpp
    test/VectorDesignVariableTest.cpp
    test/AlgorithmsTest.cpp
    test/OptimizationProblemTest.cpp
    test/IncrementalOptimizationProblemTest.cpp
    test/LinearSolverTest.cpp
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
## Installation ##
##################
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

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
