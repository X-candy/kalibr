cmake_minimum_required(VERSION 3.10)
project(sparse_block_matrix VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 包含CMake模块
if(EXISTS ${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/ModuleDependencies.cmake)
else()
  # 独立编译时依赖处理
  find_package(Eigen3 REQUIRED)
endif()

# SuiteSparse依赖配置 - 使用本地cmake模块（可选）
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
find_package(SuiteSparse QUIET)

# 条件化定义 - 如果没有SuiteSparse，禁用相关功能
if(NOT SUITESPARSE_FOUND)
  add_definitions(-DNO_SUITESPARSE)
  include_directories(
    include
    ${EIGEN3_INCLUDE_DIRS}
  )
else()
  include_directories(
    include
    ${EIGEN3_INCLUDE_DIRS}
    ${CHOLMOD_INCLUDE_DIR}
  )
endif()

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -D__STRICT_ANSI__")

include(GNUInstallDirs)

##############
## Building ##
##############

add_library(${PROJECT_NAME}
  src/matrix_structure.cpp
  src/sparse_helper.cpp
  # src/marginal_covariance_cholesky.cpp - 依赖 SuiteSparse，暂时禁用
)
if(SUITESPARSE_FOUND)
  target_link_libraries(${PROJECT_NAME}
    ${SUITESPARSE_LIBRARIES}
  )
endif()

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

install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
)

install(FILES cmake/FindSuiteSparse.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}/
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

#############
## Testing ##
#############

if(BUILD_TESTING)
  # Avoid clash with tr1::tuple: https://code.google.com/p/googletest/source/browse/trunk/README?r=589#257
  add_definitions(-DGTEST_USE_OWN_TR1_TUPLE=0)

  add_executable(${PROJECT_NAME}_tests
    test/test_main.cpp
    test/solver_tests.cpp
    test/sparse_block_matrix_tests.cpp
  )
  if(SUITESPARSE_FOUND)
    target_link_libraries(${PROJECT_NAME}_tests
      GTest::GTest
      GTest::Main
      pthread
      ${PROJECT_NAME}
      ${SUITESPARSE_LIBRARIES}
    )
  else()
    target_link_libraries(${PROJECT_NAME}_tests
      GTest::GTest
      GTest::Main
      pthread
      ${PROJECT_NAME}
    )
  endif()
  add_test(NAME ${PROJECT_NAME}_tests COMMAND ${PROJECT_NAME}_tests)
endif()
