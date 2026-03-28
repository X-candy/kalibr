# 基础设施模块集群

Kalibr 项目的基础设施模块集群包含两个核心组件，提供构建系统和计算机视觉库的封装，简化了 Kalibr 框架的开发过程。

---

## 模块概述

| 模块 | 功能描述 | 主要特点 |
|------|----------|----------|
| [catkin_simple](./catkin_simple.md) | 简化的 ROS catkin 构建系统封装 | 自动依赖发现、简化的目标创建、统一的安装接口 |
| [opencv2_catkin](./opencv2_catkin.md) | OpenCV 库的 ROS catkin 封装 | 自动检测配置、简化的依赖管理、标准的 catkin 接口 |

---

## 架构关系

```
┌──────────────────┐     ┌──────────────────┐
│  catkin_simple   │     │ opencv2_catkin   │
└────────┬─────────┘     └────────┬─────────┘
         │                        │
         └────────────┬───────────┘
                      │
        ┌─────────────▼─────────────┐
        │  Kalibr 核心功能模块      │
        └───────────────────────────┘
```

---

## 共同特性

### 简化开发流程
两个基础设施模块都遵循以下原则：
- 自动依赖发现和配置
- 统一的接口设计
- 简化的目标创建和安装
- 自动处理消息、服务和动作文件生成

### 构建系统优势
- 减少了 CMakeLists.txt 的复杂性
- 自动解析 package.xml 中的依赖
- 提供标准化的安装和导出机制
- 简化了跨平台构建配置

---

## 使用要求

### 前置条件
- ROS (Robot Operating System) 已安装
- catkin 工作区已创建
- OpenCV 库已安装（系统级或通过 package manager）

### 基础使用流程

1. 在 package.xml 中添加依赖：
   ```xml
   <build_depend>catkin_simple</build_depend>
   <build_depend>opencv2_catkin</build_depend>
   ```

2. 在 CMakeLists.txt 中配置：
   ```cmake
   find_package(catkin_simple REQUIRED)
   find_package(opencv2_catkin REQUIRED)
   catkin_simple()
   ```

3. 开始开发：
   - 使用 `cs_add_library()` 和 `cs_add_executable()` 创建目标
   - 使用 OpenCV 功能直接 `#include <opencv2/...>`
   - 使用 `cs_install()` 和 `cs_export()` 完成配置

---

## 维护信息

### 开发团队
- **catkin_simple**：William Woodall (william@osrfoundation.org), Dirk Thomas (dthomas@osrfoundation.org)
- **opencv2_catkin**：Paul Furgale (paul.furgale@mavt.ethz.ch)

### 许可证
- catkin_simple：BSD 许可证
- opencv2_catkin：New BSD 许可证

---

## 版本信息

| 模块 | 版本 | 最后更新 |
|------|------|----------|
| catkin_simple | 0.1.0 | 2025-01-01 |
| opencv2_catkin | 0.0.1 | 2025-01-01 |
