cmake_minimum_required(VERSION 3.10)
project(python_module)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 包含全局依赖配置
include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)

# 包含Python模块辅助工具
include(${CMAKE_SOURCE_DIR}/cmake/modules/PythonBindingHelpers.cmake)

# 这个模块只提供CMake宏，没有编译内容
# 所以我们不需要创建任何库或二进制文件

# 虽然没有编译内容，但我们需要确保安装了所需的CMake文件
install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/python_module-extras.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/python_module
)

# 安装头文件（如果有的话）
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include)
  install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
endif()

# 导出Python模块配置
include(CMakePackageConfigHelpers)

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/python_moduleConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/python_moduleConfig.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/python_module
)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/python_moduleConfigVersion.cmake"
  VERSION 0.0.1
  COMPATIBILITY SameMajorVersion
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/python_moduleConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/python_moduleConfigVersion.cmake"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/python_module
)
