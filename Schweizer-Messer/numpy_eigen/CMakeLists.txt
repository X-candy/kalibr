cmake_minimum_required(VERSION 3.10)
project(numpy_eigen VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

option(BUILD_TESTING "Build tests" ON)

# 包含父项目的CMake模块
include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/modules/PythonBindingHelpers.cmake)

find_package(Eigen3 REQUIRED)
find_package(Boost REQUIRED COMPONENTS python)

include_directories(include)

add_definitions(${EIGEN_DEFINITIONS})
include_directories("${PROJECT_SOURCE_DIR}/include/numpy_eigen")

add_definitions(-D__STRICT_ANSI__)

# ignore "error: return-statement with a value, in function returning 'void'" in "__multiarray_api.h"
add_compile_options(-fpermissive)

IF(APPLE)
  link_directories( /usr/local/lib )
ENDIF(APPLE)

##############
## Building ##
##############

INCLUDE(src/autogen_files.cmake)
add_python_export_library(${PROJECT_NAME}
  ${PROJECT_SOURCE_DIR}/python/${PROJECT_NAME} ${AUTOGEN_FILES}
)

target_link_libraries(${PROJECT_NAME}
  ${Boost_LIBRARIES}
  Python3::Python
  Python3::NumPy
  Eigen3::Eigen
)

# 公开Eigen3的包含目录给依赖此库的模块
target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${EIGEN3_INCLUDE_DIRS}>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

INCLUDE(src/autogen_test_files.cmake)
add_python_export_library(${PROJECT_NAME}_test
      ${PROJECT_SOURCE_DIR}/python/${PROJECT_NAME} ${AUTOGEN_TEST_FILES}
  )
target_link_libraries(${PROJECT_NAME}_test
  ${Boost_LIBRARIES}
  Python3::Python
  Python3::NumPy
  Eigen3::Eigen
)
target_include_directories(${PROJECT_NAME}_test PUBLIC
  $<BUILD_INTERFACE:${EIGEN3_INCLUDE_DIRS}>
)

#############
## Testing ##
#############
if(BUILD_TESTING)
  enable_testing()
  find_package(GTest REQUIRED)
  ##
  # Add nosetest based cpp test target.
  # catkin_add_nosetests(test/numpy_eigen_tests.py)
  # TODO: 迁移nosetest到标准CTest
endif()

##################
## Installation ##
##################

install(TARGETS ${PROJECT_NAME} ${PROJECT_NAME}_test
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

## Mark cpp header files for installation
install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
)
