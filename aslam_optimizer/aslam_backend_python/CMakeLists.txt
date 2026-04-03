cmake_minimum_required(VERSION 3.10)
project(aslam_backend_python VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_definitions(-fPIC -Wextra -Winit-self -Woverloaded-virtual -Wnon-virtual-dtor -Wsign-promo -Wno-long-long)

# 包含CMake模块
if(EXISTS ${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/CatkinReplacements.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/ModuleDependencies.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/modules/PythonBindingHelpers.cmake)
else()
  # 独立编译时依赖处理
  find_package(Boost REQUIRED COMPONENTS thread)
  find_package(Python3 REQUIRED COMPONENTS Development NumPy)
  find_package(aslam_backend REQUIRED)
  find_package(aslam_backend_expressions REQUIRED)
  find_package(sparse_block_matrix REQUIRED)
  find_package(python_module REQUIRED)
  find_package(sm_python REQUIRED)
endif()

# 内部依赖查找
kalibr_find_module(aslam_backend REQUIRED)
kalibr_find_module(aslam_backend_expressions REQUIRED)
kalibr_find_module(sparse_block_matrix REQUIRED)
kalibr_find_module(python_module REQUIRED)
kalibr_find_module(sm_python REQUIRED)

# 第三方依赖查找
find_package(Boost REQUIRED COMPONENTS thread)
find_package(Python3 REQUIRED COMPONENTS Development NumPy)
find_package(Eigen3 REQUIRED)

include_directories(
  include
  ${KALIBR_THIRD_PARTY_INCLUDE_DIRS}
  ${Boost_INCLUDE_DIRS}
  ${Python3_INCLUDE_DIRS}
  ${Python3_NumPy_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIRS}
  ${aslam_backend_INCLUDE_DIRS}
  ${aslam_backend_expressions_INCLUDE_DIRS}
  ${sparse_block_matrix_INCLUDE_DIRS}
  ${python_module_INCLUDE_DIRS}
  ${sm_python_INCLUDE_DIRS}
)

include(GNUInstallDirs)

##############
## Building ##
##############

# This function take TARGET_NAME PYTHON_MODULE_DIRECTORY sourceFile1 [sourceFile2 ...]
# 使用CatkinReplacements.cmake中的add_python_export_library
add_python_export_library(${PROJECT_NAME} python/aslam_backend
  src/module.cpp
  src/Backend.cpp
  src/Optimizer.cpp
  src/OptimizerOptions.cpp
  src/OptimizationProblem.cpp
  src/DesignVariable.cpp
  src/ErrorTerm.cpp
  src/MEstimators.cpp
  src/JacobianContainer.cpp
  src/BackendExpressions.cpp
  src/CompressedColumnMatrix.cpp
  src/LinearSystemSolver.cpp
  src/ErrorTermTransformation.cpp
  src/TrustRegionPolicies.cpp
  src/SparseBlockMatrix.cpp
)
target_link_libraries(${PROJECT_NAME}
  ${Boost_LIBRARIES}
  ${Python3_LIBRARIES}
  ${aslam_backend_LIBRARIES}
  ${aslam_backend_expressions_LIBRARIES}
  ${sparse_block_matrix_LIBRARIES}
  ${python_module_LIBRARIES}
  ${sm_python_LIBRARIES}
)

##################
## Installation ##
##################

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
