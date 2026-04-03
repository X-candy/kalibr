cmake_minimum_required(VERSION 3.10)
project(aslam_cv_backend_python VERSION 0.0.1)

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
  find_package(Boost REQUIRED COMPONENTS thread system serialization)
  find_package(OpenCV REQUIRED)
  find_package(Python3 REQUIRED COMPONENTS Development NumPy)
  find_package(sm_common REQUIRED)
  find_package(sm_python REQUIRED)
  find_package(sm_opencv REQUIRED)
  find_package(numpy_eigen REQUIRED)
  find_package(python_module REQUIRED)
  find_package(sparse_block_matrix REQUIRED)
  find_package(aslam_backend REQUIRED)
  find_package(aslam_backend_expressions REQUIRED)
  find_package(aslam_backend_python REQUIRED)
  find_package(aslam_cameras REQUIRED)
  find_package(aslam_cv_error_terms REQUIRED)
  find_package(aslam_splines REQUIRED)
  find_package(aslam_cv_python REQUIRED)
  find_package(aslam_cv_backend REQUIRED)
  find_package(aslam_time REQUIRED)
endif()

# 内部依赖查找
kalibr_find_module(sm_common REQUIRED)
kalibr_find_module(sm_python REQUIRED)
kalibr_find_module(sm_opencv REQUIRED)
kalibr_find_module(numpy_eigen REQUIRED)
kalibr_find_module(python_module REQUIRED)
kalibr_find_module(sparse_block_matrix REQUIRED)
kalibr_find_module(aslam_backend REQUIRED)
kalibr_find_module(aslam_backend_expressions REQUIRED)
kalibr_find_module(aslam_backend_python REQUIRED)
kalibr_find_module(aslam_cameras REQUIRED)
kalibr_find_module(aslam_cv_error_terms REQUIRED)
kalibr_find_module(aslam_splines REQUIRED)
kalibr_find_module(aslam_cv_python REQUIRED)
kalibr_find_module(aslam_cv_backend REQUIRED)
kalibr_find_module(aslam_time REQUIRED)

# 第三方依赖查找
find_package(Boost REQUIRED COMPONENTS thread system serialization)
find_package(OpenCV REQUIRED)
find_package(Python3 REQUIRED COMPONENTS Development NumPy)
find_package(Eigen3 REQUIRED)

include_directories(
  include
  ${Boost_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
  ${Python3_INCLUDE_DIRS}
  ${Python3_NumPy_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIRS}
  ${sm_common_INCLUDE_DIRS}
  ${sm_python_INCLUDE_DIRS}
  ${sm_opencv_INCLUDE_DIRS}
  ${numpy_eigen_INCLUDE_DIRS}
  ${python_module_INCLUDE_DIRS}
  ${sparse_block_matrix_INCLUDE_DIRS}
  ${aslam_backend_INCLUDE_DIRS}
  ${aslam_backend_expressions_INCLUDE_DIRS}
  ${aslam_backend_python_INCLUDE_DIRS}
  ${aslam_cameras_INCLUDE_DIRS}
  ${aslam_cv_error_terms_INCLUDE_DIRS}
  ${aslam_splines_INCLUDE_DIRS}
  ${aslam_cv_python_INCLUDE_DIRS}
  ${aslam_cv_backend_INCLUDE_DIRS}
  ${aslam_time_INCLUDE_DIRS}
)

include(GNUInstallDirs)

##############
## Building ##
##############

add_python_export_library(${PROJECT_NAME} python/aslam_cv_backend
  src/module.cpp  
  src/GridCalibration.cpp
  # src/CameraGeometryDesignVariableContainer.cpp
#  src/NCameraSystemDesignVariableContainer.cpp
)
target_link_libraries(${PROJECT_NAME}
  ${Boost_LIBRARIES}
  ${OpenCV_LIBRARIES}
  ${Python3_LIBRARIES}
  ${sm_common_LIBRARIES}
  ${sm_python_LIBRARIES}
  ${sm_opencv_LIBRARIES}
  ${numpy_eigen_LIBRARIES}
  ${python_module_LIBRARIES}
  ${sparse_block_matrix_LIBRARIES}
  ${aslam_backend_LIBRARIES}
  ${aslam_backend_expressions_LIBRARIES}
  ${aslam_backend_python_LIBRARIES}
  ${aslam_cameras_LIBRARIES}
  ${aslam_cv_error_terms_LIBRARIES}
  ${aslam_splines_LIBRARIES}
  ${aslam_cv_python_LIBRARIES}
  ${aslam_cv_backend_LIBRARIES}
  ${aslam_time_LIBRARIES}
)

# Python包配置
kalibr_python_setup(
  PACKAGE_DIR "python"
  PACKAGES "aslam_cv_backend"
)

##################
## Installation ##
##################

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
