# Schweizer-Messer 模块集群

> 高性能 C++ 工具库集合

---

## 概述

Schweizer-Messer 是一个模块化的 C++ 工具库集合，为机器人、计算机视觉和状态估计应用提供基础功能。它的名字来源于德语中的"瑞士军刀"，体现了其多功能和实用性的设计理念。

## 模块列表

### 基础模块
- **sm_common** — 基础工具和通用功能（断言、ID、数学工具等）
- **sm_random** — 随机数生成工具
- **sm_logging** — 灵活的日志系统

### 线性代数
- **sm_eigen** — Eigen 库的扩展（序列化、随机、微分等）

### Boost 集成
- **sm_boost** — Boost 库的扩展和封装（可移植归档、作业队列）

### 性能分析
- **sm_timing** — 性能分析和计时工具

### 配置管理
- **sm_property_tree** — 层次化属性配置系统

### 数据存储
- **sm_matrix_archive** — 矩阵数据的二进制存储

### 计算机视觉
- **sm_opencv** — OpenCV 集成和序列化

### 几何与运动学
- **sm_kinematics** — 3D 运动学和变换库（核心模块）

### Python 集成
- **python_module** — Python 模块构建的 CMake 工具
- **numpy_eigen** — NumPy 与 Eigen 矩阵的双向转换
- **sm_python** — Schweizer-Messer 的 Python 绑定

---

## 更多信息

- [Kalibr 主文档](../../README.md)
- 各模块详细文档正在完善中...
