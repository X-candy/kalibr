# Kalibr 模块文档总览

> 相机标定工具链完整技术文档

---

## 📚 文档架构

```
docs/
├── README.md                          # 本文档 - 总览索引
└── modules/
    ├── schweizer-messer/             # 基础工具库集群
    │   ├── README.md                  # SM 模块总览
    │   ├── sm_common.md
    │   ├── sm_eigen.md
    │   ├── sm_boost.md
    │   ├── sm_kinematics.md
    │   ├── sm_logging.md
    │   ├── sm_timing.md
    │   ├── sm_random.md
    │   ├── sm_property_tree.md
    │   ├── sm_matrix_archive.md
    │   ├── sm_opencv.md
    │   ├── sm_python.md
    │   ├── numpy_eigen.md
    │   └── python_module.md
    ├── aslam_cv/                      # 计算机视觉模块集群
    │   ├── README.md                  # aslam_cv 模块总览
    │   └── aslam_cameras.md
    ├── aslam_incremental_calibration/ # 增量式校准模块集群
    │   └── README.md
    ├── aslam_nonparametric_estimation/ # 非参数估计模块集群
    │   └── README.md
    ├── aslam_offline_calibration/      # 离线校准模块集群
    │   └── README.md
    ├── calibration/                   # 标定核心模块集群
    │   ├── README.md                  # 标定模块总览
    │   └── kalibr.md
    ├── optimizer/                     # 优化器模块集群
    │   └── README.md
    └── infrastructure/                # 基础设施模块集群
        ├── README.md                  # 基础设施总览
        ├── catkin_simple.md
        └── opencv2_catkin.md
```

---

## 🎯 模块集群概览

### 1. Schweizer-Messer — 基础工具库
瑞士军刀级别的 C++ 工具集，提供通用基础设施。

| 模块 | 功能定位 |
|------|----------|
| sm_common | 通用工具与基础类 |
| sm_eigen | Eigen 矩阵库扩展 |
| sm_boost | Boost 库封装与扩展 |
| sm_kinematics | 运动学与几何变换 |
| sm_logging | 日志系统 |
| sm_timing | 计时与性能分析 |
| sm_random | 随机数生成 |
| sm_property_tree | 属性树配置管理 |
| sm_matrix_archive | 矩阵序列化与归档 |
| sm_opencv | OpenCV 集成 |
| sm_python | Python 绑定基础 |
| numpy_eigen | NumPy ↔ Eigen 转换 |
| python_module | Python 模块基础设施 |

---

### 2. aslam_cv — 计算机视觉库
ASL (Autonomous Systems Lab) 计算机视觉基础设施。

| 模块 | 功能定位 |
|------|----------|
| aslam_cameras | 相机模型与几何 |
| aslam_cameras_april | AprilTag 相机支持 |
| aslam_cv_backend | CV 后端基础设施 |
| aslam_cv_error_terms | 视觉误差项 |
| aslam_cv_python | CV 模块 Python 绑定 |
| aslam_cv_backend_python | CV 后端 Python 绑定 |
| aslam_cv_serialization | 序列化支持 |
| aslam_imgproc | 图像处理 |
| aslam_time | 时间同步与处理 |

---

### 3. aslam_incremental_calibration — 增量式校准库
支持在线和增量式传感器校准。

| 模块 | 功能定位 |
|------|----------|
| incremental_calibration | 增量式校准核心算法 |
| incremental_calibration_python | Python 语言绑定 |

---

### 4. aslam_nonparametric_estimation — 非参数估计库
提供 B 样条等非参数建模功能。

| 模块 | 功能定位 |
|------|----------|
| aslam_splines | ASL 样条库 |
| aslam_splines_python | ASL 样条 Python 绑定 |
| bsplines | B 样条核心实现 |
| bsplines_python | B 样条 Python 绑定 |

---

### 5. aslam_offline_calibration — 离线校准库
提供 AprilTag 检测和 Kalibr 核心校准功能。

| 模块 | 功能定位 |
|------|----------|
| ethz_apriltag2 | ETHZ AprilTag 检测库 |
| kalibr | Kalibr 离线校准核心实现 |

---

### 6. Calibration — 标定核心模块
相机与 IMU 标定的核心实现。

| 模块 | 功能定位 |
|------|----------|
| kalibr | Kalibr 标定主程序 |

---

### 7. Optimizer — 优化器模块
非线性优化基础设施。

| 模块 | 功能定位 |
|------|----------|
| aslam_backend | 优化器后端核心 |
| aslam_backend_expressions | 优化表达式 |
| aslam_backend_python | 优化器 Python 绑定 |
| sparse_block_matrix | 稀疏块矩阵 |

---

### 8. Infrastructure — 基础设施
构建系统与第三方依赖封装。

| 模块 | 功能定位 |
|------|----------|
| catkin_simple | Catkin 构建系统简化 |
| opencv2_catkin | OpenCV Catkin 封装 |

---

## 📖 文档编写规范

每个模块文档包含以下章节：

1. **功能说明** — 模块定位与核心能力
2. **对外接口** — 主要类、函数、数据结构
3. **内部实现** — 关键算法与实现逻辑
4. **依赖关系** — 内部/外部依赖梳理
5. **使用示例** — 典型用法代码片段

