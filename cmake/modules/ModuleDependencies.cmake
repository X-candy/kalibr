# 模块依赖管理 - 替代find_package()在同一项目内部的使用

# 注册一个模块，使其在项目中可用
function(kalibr_register_module module_name)
  if(NOT TARGET ${module_name})
    message(WARNING "Module ${module_name} not found as a target")
    return()
  endif()

  # 设置变量，使其可以像find_package()一样使用
  set(${module_name}_FOUND TRUE PARENT_SCOPE)
  set(${module_name}_INCLUDE_DIRS "" PARENT_SCOPE)
  set(${module_name}_LIBRARIES ${module_name} PARENT_SCOPE)

  # 从目标中获取包含目录
  get_target_property(target_includes ${module_name} INTERFACE_INCLUDE_DIRECTORIES)
  if(target_includes)
    set(${module_name}_INCLUDE_DIRS ${target_includes} PARENT_SCOPE)
  endif()

  # 同时也尝试从源目录查找（对于构建中的模块）
  # 搜索模块的源目录
  set(possible_dirs
    "${CMAKE_SOURCE_DIR}/Schweizer-Messer/${module_name}/include"
    "${CMAKE_SOURCE_DIR}/Schweizer-Messer/${module_name}"
    "${CMAKE_SOURCE_DIR}/aslam_optimizer/${module_name}/include"
    "${CMAKE_SOURCE_DIR}/aslam_optimizer/${module_name}"
    "${CMAKE_SOURCE_DIR}/aslam_cv/${module_name}/include"
    "${CMAKE_SOURCE_DIR}/aslam_cv/${module_name}"
    "${CMAKE_SOURCE_DIR}/aslam_nonparametric_estimation/${module_name}/include"
    "${CMAKE_SOURCE_DIR}/aslam_nonparametric_estimation/${module_name}"
    "${CMAKE_SOURCE_DIR}/aslam_incremental_calibration/${module_name}/include"
    "${CMAKE_SOURCE_DIR}/aslam_incremental_calibration/${module_name}"
    "${CMAKE_SOURCE_DIR}/aslam_offline_calibration/${module_name}/include"
    "${CMAKE_SOURCE_DIR}/aslam_offline_calibration/${module_name}"
  )

  foreach(dir ${possible_dirs})
    if(EXISTS "${dir}")
      list(APPEND ${module_name}_INCLUDE_DIRS "${dir}")
    endif()
  endforeach()

  if(${module_name}_INCLUDE_DIRS)
    set(${module_name}_INCLUDE_DIRS ${${module_name}_INCLUDE_DIRS} PARENT_SCOPE)
  endif()
endfunction()

# 查找模块 - 在同一项目中使用目标链接替代find_package
function(kalibr_find_module module_name)
  if(TARGET ${module_name})
    kalibr_register_module(${module_name})
    return()
  endif()

  # 如果目标不存在，尝试使用标准的find_package
  find_package(${module_name} QUIET)
endfunction()
