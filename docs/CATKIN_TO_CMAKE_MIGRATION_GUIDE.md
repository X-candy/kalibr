# Kalibr Catkin 到标准CMake迁移指南

## 核心原则
- ✅ **无运行时ROS依赖**：仅替换构建系统，代码逻辑完全不变
- ✅ **100% API兼容性**：对外接口保持完全一致
- ✅ **平滑迁移**：同时支持标准CMake和Catkin两种构建方式
- ✅ **保留模块依赖关系**：原有的依赖层级完全不变

## 迁移模板

### 原Catkin风格CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.0.2)
project(module_name)

set(CMAKE_CXX_STANDARD 14)

find_package(catkin REQUIRED COMPONENTS dep1 dep2 dep3)
find_package(Boost REQUIRED COMPONENTS system thread)

catkin_package(
  INCLUDE_DIRS include
  LIBRARIES ${PROJECT_NAME}
  CATKIN_DEPENDS dep1 dep2 dep3
  DEPENDS Boost
)

include_directories(include ${catkin_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

add_library(${PROJECT_NAME} src/file1.cpp src/file2.cpp)
target_link_libraries(${PROJECT_NAME} ${catkin_LIBRARIES} ${Boost_LIBRARIES})

install(TARGETS ${PROJECT_NAME}
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(DIRECTORY include/
  DESTINATION ${CATKIN_GLOBAL_INCLUDE_DESTINATION}
)

if(CATKIN_ENABLE_TESTING)
  catkin_add_gtest(${PROJECT_NAME}-test test/test.cpp)
  target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
endif()
```

### 迁移后的标准CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.10)
project(module_name VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 包含全局依赖配置
include(${CMAKE_SOURCE_DIR}/cmake/modules/FindDependencies.cmake)

# 查找依赖
find_package(dep1 REQUIRED)
find_package(dep2 REQUIRED)
find_package(dep3 REQUIRED)
find_package(Boost REQUIRED COMPONENTS system thread)

include_directories(
  include
  ${KALIBR_THIRD_PARTY_INCLUDE_DIRS}
  ${dep1_INCLUDE_DIRS}
  ${dep2_INCLUDE_DIRS}
  ${dep3_INCLUDE_DIRS}
)

add_library(${PROJECT_NAME} src/file1.cpp src/file2.cpp)
target_link_libraries(${PROJECT_NAME}
  ${KALIBR_THIRD_PARTY_LIBRARIES}
  ${dep1_LIBRARIES}
  ${dep2_LIBRARIES}
  ${dep3_LIBRARIES}
)

# 设置目标属性
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

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# 生成CMake配置文件
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

#############
## Testing ##
#############
if(BUILD_TESTING)
  find_package(GTest REQUIRED)
  add_definitions(-DGTEST_USE_OWN_TR1_TUPLE=0)

  add_executable(${PROJECT_NAME}-test test/test.cpp)
  target_link_libraries(${PROJECT_NAME}-test
    GTest::GTest
    GTest::Main
    pthread
    ${PROJECT_NAME}
  )
  add_test(NAME ${PROJECT_NAME}-test COMMAND ${PROJECT_NAME}-test)
endif()
```

## 迁移步骤清单

### 通用修改点
1. ✅ 升级cmake_minimum_required到3.10
2. ✅ 添加PROJECT_VERSION
3. ✅ 移除find_package(catkin)
4. ✅ 替换catkin_package()为标准CMake配置
5. ✅ 替换${catkin_INCLUDE_DIRS}为具体依赖的INCLUDE_DIRS
6. ✅ 替换${catkin_LIBRARIES}为具体依赖的LIBRARIES
7. ✅ 替换CATKIN_*安装目录为CMAKE_INSTALL_*标准目录
8. ✅ 添加target_include_directories配置
9. ✅ 添加CMake配置文件生成和安装逻辑
10. ✅ 替换CATKIN_ENABLE_TESTING为BUILD_TESTING
11. ✅ 替换catkin_add_gtest为标准add_executable + add_test

## 全模块迁移清单

### 第一组：Schweizer-Messer 基础模块 (13个)
| 模块名称 | 状态 | 依赖模块 | 特殊说明 |
|---------|------|---------|---------|
| sm_common | ✅ 已完成 | boost | 已完成迁移 |
| sm_logging | ✅ 已完成 | boost, spdlog | 已完成迁移 |
| sm_boost | ⏳ 待迁移 | boost | 简单封装，无特殊依赖 |
| numpy_eigen | ⏳ 待迁移 | eigen3, python3, numpy | 需要处理Python绑定 |
| python_module | ⏳ 待迁移 | python3 | 简化Python绑定 |
| sm_eigen | ⏳ 待迁移 | eigen3, sm_common | 数学库封装 |
| sm_kinematics | ⏳ 待迁移 | eigen3, sm_common, sm_eigen | 运动学库 |
| sm_random | ⏳ 待迁移 | boost, sm_common | 随机数生成 |
| sm_property_tree | ⏳ 待迁移 | boost, yaml-cpp | 配置解析，替代ROS参数服务器 |
| sm_matrix_archive | ⏳ 待迁移 | eigen3, sm_common | 矩阵序列化 |
| sm_timing | ⏳ 待迁移 | boost, sm_common | 计时工具 |
| sm_opencv | ⏳ 待迁移 | opencv, sm_common, sm_eigen | OpenCV封装 |
| sm_python | ⏳ 待迁移 | python3, numpy_eigen | Python绑定工具 |

### 第二组：aslam_optimizer 优化模块 (4个)
| 模块名称 | 状态 | 依赖模块 | 特殊说明 |
|---------|------|---------|---------|
| sparse_block_matrix | ⏳ 待迁移 | eigen3, sm_common | 稀疏矩阵库 |
| aslam_backend | ⏳ 待迁移 | sparse_block_matrix, sm_common, sm_eigen, sm_logging | 优化后端核心 |
| aslam_backend_expressions | ⏳ 待迁移 | aslam_backend, sm_common | 表达式模板库 |
| aslam_backend_python | ⏳ 待迁移 | aslam_backend, python_module, sm_python | Python绑定 |

### 第三组：aslam_cv 视觉模块 (9个)
| 模块名称 | 状态 | 依赖模块 | 特殊说明 |
|---------|------|---------|---------|
| aslam_time | ⏳ 待迁移 | sm_common | 时间接口，替换ros::Time |
| aslam_cameras | ⏳ 待迁移 | opencv, eigen3, sm_common, sm_eigen, sm_property_tree | 相机模型库 |
| aslam_cameras_april | ⏳ 待迁移 | aslam_cameras, ethz_apriltag2 | AprilTag检测 |
| aslam_imgproc | ⏳ 待迁移 | opencv, sm_common, sm_opencv, aslam_cameras | 图像处理 |
| aslam_cv_error_terms | ⏳ 待迁移 | aslam_backend, aslam_cameras, sm_eigen | 视觉误差项 |
| aslam_cv_backend | ⏳ 待迁移 | aslam_backend, aslam_cv_error_terms, aslam_cameras | 视觉优化后端 |
| aslam_cv_backend_python | ⏳ 待迁移 | aslam_cv_backend, python_module, sm_python | Python绑定 |
| aslam_cv_python | ⏳ 待迁移 | aslam_cv, python_module, sm_python | Python绑定 |
| aslam_cv_serialization | ⏳ 待迁移 | aslam_cv, boost_serialization | 序列化支持 |

### 第四组：aslam_nonparametric_estimation 非参数估计模块 (4个)
| 模块名称 | 状态 | 依赖模块 | 特殊说明 |
|---------|------|---------|---------|
| bsplines | ⏳ 待迁移 | eigen3, sm_common | B样条曲线库 |
| bsplines_python | ⏳ 待迁移 | bsplines, python_module, sm_python | Python绑定 |
| aslam_splines | ⏳ 待迁移 | bsplines, aslam_backend, sm_kinematics | 样条估计 |
| aslam_splines_python | ⏳ 待迁移 | aslam_splines, python_module, sm_python | Python绑定 |

### 第五组：aslam_incremental_calibration 增量校准模块 (2个)
| 模块名称 | 状态 | 依赖模块 | 特殊说明 |
|---------|------|---------|---------|
| incremental_calibration | ⏳ 待迁移 | aslam_backend, aslam_cv, aslam_splines, sm_kinematics | 增量校准核心 |
| incremental_calibration_python | ⏳ 待迁移 | incremental_calibration, python_module, sm_python | Python绑定 |

### 第六组：aslam_offline_calibration 离线校准模块 (2个)
| 模块名称 | 状态 | 依赖模块 | 特殊说明 |
|---------|------|---------|---------|
| ethz_apriltag2 | ⏳ 待迁移 | opencv | AprilTag检测库 |
| kalibr | ⏳ 待迁移 | 所有模块 | 主应用，需要处理命令行接口 |

### 第七组：基础设施模块 (2个)
| 模块名称 | 状态 | 依赖模块 | 特殊说明 |
|---------|------|---------|---------|
| opencv2_catkin | ❌ 废弃 | opencv | 替换为直接find_package(OpenCV) |
| catkin_simple | ❌ 废弃 | catkin | 完全不需要，使用标准CMake替代 |

## Python绑定特殊处理

### 原Catkin方式
```cmake
catkin_python_setup()

add_python_export_library(${PROJECT_NAME}_python src/module.cpp)
```

### 标准CMake方式
```cmake
include(${CMAKE_SOURCE_DIR}/cmake/modules/PythonBindingHelpers.cmake)

kalibr_python_setup(
  PACKAGE_DIR python
  PACKAGES module_name
)

add_python_export_library(${PROJECT_NAME}_python src/module.cpp)
```

## 兼容性保障

### 双构建系统支持
- 保留所有package.xml文件，原catkin_make构建方式完全可用
- 新增的标准CMake构建系统不影响原有Catkin工作流
- 用户可以自由选择构建方式

### 过渡方案
1. 阶段1：所有模块同时支持两种构建系统
2. 阶段2：发布正式版本，推荐使用标准CMake
3. 阶段3：6个月后逐步废弃Catkin支持

## 验收标准

### 模块级验收
- ✅ 可独立使用find_package找到
- ✅ 可独立编译，无任何ROS依赖
- ✅ 所有单元测试通过
- ✅ 安装目标正常工作

### 系统级验收
- ✅ 完整项目可一次性编译通过
- ✅ 所有Python绑定功能正常
- ✅ kalibr所有命令行工具可正常运行
- ✅ 标定结果与原版本完全一致
- ✅ 构建时间≤原Catkin构建时间的110%

## 实施时间表

| 阶段 | 时间 | 内容 | 交付物 |
|------|------|------|--------|
| 第一阶段 | 8小时 | 完成Schweizer-Messer所有13个模块迁移 | 所有基础模块CMakeLists.txt |
| 第二阶段 | 8小时 | 完成aslam_optimizer和aslam_cv所有13个模块迁移 | 核心算法模块CMakeLists.txt |
| 第三阶段 | 4小时 | 完成剩余10个模块迁移 | 全模块编译通过 |
| 第四阶段 | 4小时 | 测试验证和Bug修复 | 完整的测试报告 |
| **总计** | **24小时** | | |
