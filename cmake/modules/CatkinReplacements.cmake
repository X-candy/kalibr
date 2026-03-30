# Catkin宏到标准CMake的替换实现

# catkin_package() 替换函数
function(kalibr_package)
  cmake_parse_arguments(PARSE_ARGV 0 KPKG
    ""
    ""
    "INCLUDE_DIRS;LIBRARIES;CATKIN_DEPENDS;DEPENDS;CFG_EXTRAS"
  )

  # 处理包含目录
  foreach(inc_dir ${KPKG_INCLUDE_DIRS})
    if(NOT IS_ABSOLUTE ${inc_dir})
      set(inc_dir ${CMAKE_CURRENT_SOURCE_DIR}/${inc_dir})
    endif()
    list(APPEND KALIBR_INCLUDE_DIRS ${inc_dir})
  endforeach()
  set(KALIBR_INCLUDE_DIRS ${KALIBR_INCLUDE_DIRS} CACHE INTERNAL "Kalibr include directories")

  # 处理库
  foreach(lib ${KPKG_LIBRARIES})
    list(APPEND KALIBR_LIBRARIES ${lib})
  endforeach()
  set(KALIBR_LIBRARIES ${KALIBR_LIBRARIES} CACHE INTERNAL "Kalibr libraries")

  # 处理CFG_EXTRAS - 保持原有的配置文件
  foreach(cfg ${KPKG_CFG_EXTRAS})
    include(${CMAKE_CURRENT_SOURCE_DIR}/${cfg})
  endforeach()
endfunction()

# add_python_export_library() 替换
function(add_python_export_library target_name subdir)
  set(options)
  set(oneValueArgs)
  set(multiValueArgs)
  cmake_parse_arguments(PARSE_ARGV 2 ARG "${options}" "${oneValueArgs}" "${multiValueArgs}")

  set(SOURCE_FILES ${ARG_UNPARSED_ARGUMENTS})

  if(TARGET ${target_name})
    message(WARNING "Target ${target_name} already exists")
    return()
  endif()

  # 使用PythonModule的标准方式添加
  add_library(${target_name} SHARED ${SOURCE_FILES})
  target_link_libraries(${target_name} Python3::Module Python3::NumPy)

  # 设置输出属性
  set_target_properties(${target_name} PROPERTIES
    PREFIX ""
    SUFFIX "${Python3_SOABI}.so"
  )

  # 安装配置
  install(TARGETS ${target_name}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/python${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}/site-packages
  )
endfunction()

# catkin_install_python() 替换
function(catkin_install_python)
  set(options)
  set(oneValueArgs DESTINATION)
  set(multiValueArgs PROGRAMS)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "${options}" "${oneValueArgs}" "${multiValueArgs}")

  foreach(program ${ARG_PROGRAMS})
    if(NOT IS_ABSOLUTE ${program})
      set(program ${CMAKE_CURRENT_SOURCE_DIR}/${program})
    endif()

    # 安装到指定目录
    install(PROGRAMS ${program}
      DESTINATION ${ARG_DESTINATION}
      PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
                  GROUP_EXECUTE GROUP_READ
                  WORLD_EXECUTE WORLD_READ
    )
  endforeach()
endfunction()

# catkin_python_setup() 替换 - 空实现，Python包安装由add_python_export_library处理
function(catkin_python_setup)
  # 空实现，避免CMake错误
  message(STATUS "catkin_python_setup() called - skipping for standalone build")
endfunction()

# kalibr_python_setup() 替换 - 用于Python包配置
function(kalibr_python_setup)
  set(options)
  set(oneValueArgs PACKAGE_DIR)
  set(multiValueArgs PACKAGES)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "${options}" "${oneValueArgs}" "${multiValueArgs}")

  # 简单处理 - 实际Python包安装由install处理
  message(STATUS "kalibr_python_setup() called for packages: ${ARG_PACKAGES}")
endfunction()

# catkin_add_gtest() 替换
function(catkin_add_gtest target_name)
  if(NOT TARGET gtest OR NOT TARGET gtest_main)
    message(WARNING "GTest not available, skipping test ${target_name}")
    return()
  endif()

  set(options)
  set(oneValueArgs)
  set(multiValueArgs)
  cmake_parse_arguments(PARSE_ARGV 1 ARG "${options}" "${oneValueArgs}" "${multiValueArgs}")

  set(SOURCE_FILES ${ARG_UNPARSED_ARGUMENTS})

  add_executable(${target_name} ${SOURCE_FILES})
  target_link_libraries(${target_name} gtest gtest_main ${KALIBR_LIBRARIES})

  # 添加到测试
  add_test(NAME ${target_name}
           COMMAND ${target_name}
           WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
endfunction()
