# Kalibr项目ROS移除重构顶层方案

## 1. 方案概述

本方案详细描述了将Kalibr项目从ROS/catkin构建系统迁移到纯标准CMake构建系统的顶层架构设计和实施策略。

### 1.1 核心发现

经过全面分析，确认：
- **ROS功能依赖**: 0个 - 项目核心代码不依赖任何ROS运行时功能
- **构建系统依赖**: 完全使用catkin作为构建系统
- **代码耦合**: 核心算法与ROS完全解耦

### 1.2 重构目标

1. **移除构建系统依赖**: 从catkin迁移到纯CMake
2. **保持100% API兼容性**: 所有现有接口保持不变
3. **性能不下降**: 构建时间和运行时性能不低于原系统
4. **平滑过渡**: 提供双构建系统支持过渡期

---

## 2. 架构设计

### 2.1 原有架构

```
┌─────────────────────────────────────────────────────────┐
│                   用户Python脚本                        │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│              kalibr Python模块                          │
├─────────────────────────────────────────────────────────┤
│  aslam_cv_python  │  aslam_backend_python  │  ...    │
└─────────┬──────────────────┬──────────────────┬─────────┘
          │                  │                  │
┌─────────▼─────────┐ ┌──▼───────────────┐ ┌▼──────────┐
│   aslam_cv        │ │  aslam_backend   │ │  ...      │
└─────────┬─────────┘ └──┬───────────────┘ └──┬────────┘
          │                │                    │
┌─────────▼────────────────▼────────────────────▼─────────┐
│              catkin构建系统 (ROS)                       │
└─────────────────────────────────────────────────────────┘
```

### 2.2 目标架构

```
┌─────────────────────────────────────────────────────────┐
│                   用户Python脚本                        │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│              kalibr Python模块                          │
├─────────────────────────────────────────────────────────┤
│  aslam_cv_python  │  aslam_backend_python  │  ...    │
└─────────┬──────────────────┬──────────────────┬─────────┘
          │                  │                  │
┌─────────▼─────────┐ ┌──▼───────────────┐ ┌▼──────────┐
│   aslam_cv        │ │  aslam_backend   │ │  ...      │
└─────────┬─────────┘ └──┬───────────────┘ └──┬────────┘
          │                │                    │
┌─────────▼────────────────▼────────────────────▼─────────┐
│           标准CMake构建系统 + 自定义模块                 │
│  (FindDependencies.cmake, CatkinReplacements.cmake)    │
└─────────────────────────────────────────────────────────┘
```

---

## 3. 实施策略

### 3.1 分阶段实施

#### 阶段1: 基础设施准备 (已完成)
- [x] 创建根CMakeLists.txt
- [x] 实现CatkinReplacements.cmake（替换catkin宏）
- [x] 实现FindDependencies.cmake（统一依赖查找）
- [x] 实现PythonBindingHelpers.cmake（Python绑定辅助）
- [x] 创建CMake模板文件
- [x] 完成sm_common试点模块改造
- [x] 完成sm_logging试点模块改造

#### 阶段2: 基础模块迁移 (进行中)
- [ ] Schweizer-Messer所有13个模块迁移
  - [x] sm_common
  - [x] sm_logging
  - [ ] sm_boost
  - [ ] sm_eigen
  - [ ] sm_kinematics
  - [ ] sm_random
  - [ ] sm_property_tree
  - [ ] sm_matrix_archive
  - [ ] sm_timing
  - [ ] sm_opencv
  - [ ] sm_python
  - [ ] numpy_eigen
  - [ ] python_module

#### 阶段3: 核心模块迁移
- [ ] aslam_optimizer模块迁移 (4个)
- [ ] aslam_cv模块迁移 (9个)
- [ ] aslam_nonparametric_estimation模块迁移 (4个)
- [ ] aslam_incremental_calibration模块迁移 (2个)

#### 阶段4: 应用层模块迁移
- [ ] aslam_offline_calibration模块迁移 (2个)
  - [ ] ethz_apriltag2
  - [ ] kalibr (主应用)

#### 阶段5: 测试与验证
- [ ] 全量回归测试
- [ ] 跨平台验证
- [ ] 性能基准测试
- [ ] 精度验证

### 3.2 模块迁移策略

每个模块的迁移遵循以下步骤：

1. **备份原有文件**
   ```bash
   cp package.xml package.xml.old
   cp CMakeLists.txt CMakeLists.txt.catkin
   ```

2. **创建CMake配置文件**
   - 创建`cmake/`目录
   - 创建`${MODULE_NAME}Config.cmake.in`模板

3. **重构CMakeLists.txt**
   - 使用提供的模板
   - 替换catkin宏为标准CMake
   - 配置目标属性和安装

4. **验证构建**
   ```bash
   mkdir build && cd build
   cmake ..
   make -j$(nproc)
   make test
   ```

5. **集成到根构建**
   - 在根CMakeLists.txt中添加`add_subdirectory()`

---

## 4. 关键技术决策

### 4.1 构建系统选择

**选择**: 纯标准CMake 3.10+

**理由**:
- 现代、稳定、广泛支持
- 无需额外依赖
- 良好的跨平台支持
- 与现有代码兼容性好

### 4.2 依赖管理策略

**选择**: 统一的FindDependencies.cmake + target_link_libraries

**理由**:
- 集中管理所有第三方依赖
- 使用现代CMake的target-based方法
- 便于依赖版本管理
- 支持find_package的标准方式

### 4.3 Python绑定方案

**选择**: 保留现有的numpy_eigen + 自定义PythonBindingHelpers

**理由**:
- 现有实现已经很完善
- 100% API兼容性
- 避免重写大量绑定代码
- 保持Python/C++接口一致性

### 4.4 双构建系统支持

**选择**: 过渡期同时支持catkin和CMake

**理由**:
- 降低迁移风险
- 允许用户逐步迁移
- 便于问题定位和回滚
- 提供平滑过渡体验

---

## 5. 风险与缓解

详见独立的[风险评估报告](./risk_assessment/risk_assessment_and_mitigation.md)

---

## 6. 验收标准

### 6.1 模块级验收

每个迁移完成的模块必须满足：
- [ ] 可独立使用`find_package(${MODULE_NAME})`找到
- [ ] 可独立编译，无任何ROS依赖
- [ ] 所有单元测试100%通过
- [ ] 安装目标正常工作
- [ ] 头文件安装到正确位置
- [ ] CMake配置文件正确生成

### 6.2 系统级验收

完整系统迁移后必须满足：
- [ ] 完整项目可一次性编译通过
- [ ] 所有Python绑定功能正常
- [ ] kalibr所有命令行工具可正常运行
- [ ] 标定结果与原版本完全一致（数值精度内）
- [ ] 构建时间≤原Catkin构建时间的110%
- [ ] 内存使用≤原版本的110%

### 6.3 跨平台验收

- [ ] Ubuntu 20.04 编译通过
- [ ] Ubuntu 18.04 编译通过
- [ ] Ubuntu 16.04 编译通过（可选）
- [ ] macOS 编译通过（可选）
- [ ] Windows/WSL 编译通过（可选）

---

## 7. 时间规划

| 阶段 | 预估时间 | 交付物 |
|------|---------|--------|
| 基础设施准备 | 4小时 | 根CMake、自定义模块、试点模块 |
| 基础模块迁移 | 8小时 | Schweizer-Messer所有模块 |
| 核心模块迁移 | 8小时 | aslam_optimizer、aslam_cv等 |
| 应用层模块迁移 | 4小时 | kalibr主应用 |
| 测试与验证 | 4小时 | 测试报告、验证结果 |
| **总计** | **28小时** | |

---

## 8. 相关文档

- [完整迁移指南](./CATKIN_TO_CMAKE_MIGRATION_GUIDE.md)
- [迁移SOP](./ros_analysis/catkin_migration_sop.md)
- [风险评估报告](./risk_assessment/risk_assessment_and_mitigation.md)
- [项目综合分析](./risk_assessment/comprehensive_project_analysis.md)
- [ROS依赖分析](./ros_analysis/ros_dependency_analysis_report.md)
