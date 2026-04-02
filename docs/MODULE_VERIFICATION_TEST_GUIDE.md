# Kalibr 模块验证测试指南

> 本文档提供 Kalibr 项目各模块程序验证的完整测试流程和方法。

## 目录

1. [测试环境准备](#测试环境准备)
2. [构建配置](#构建配置)
3. [模块测试清单](#模块测试清单)
4. [各模块测试指南](#各模块测试指南)
5. [测试结果验证](#测试结果验证)
6. [常见问题排查](#常见问题排查)

---

## 测试环境准备

### 系统要求

- **操作系统**: Ubuntu 18.04 / 20.04 / 22.04
- **编译器**: GCC 7+ 或 Clang 6+
- **CMake**: 3.10+

### 依赖安装

```bash
# 基础依赖
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    cmake \
    libboost-all-dev \
    libeigen3-dev \
    libopencv-dev \
    libgtest-dev \
    git

# 可选：SuiteSparse（稀疏矩阵完整功能）
sudo apt-get install -y libsuitesparse-dev

# 可选：Python 依赖（Python 绑定测试）
sudo apt-get install -y \
    python3-dev \
    python3-numpy \
    python3-opencv
```

### GTest 编译安装

Ubuntu 源中的 `libgtest-dev` 只包含源代码，需要手动编译：

```bash
cd /usr/src/gtest
sudo cmake CMakeLists.txt
sudo make
sudo cp lib/*.a /usr/lib/
```

---

## 构建配置

### 标准 CMake 构建流程

```bash
# 1. 克隆项目
git clone https://github.com/ethz-asl/kalibr.git
cd kalibr

# 2. 创建构建目录
mkdir -p build && cd build

# 3. 配置（启用测试）
cmake .. -DBUILD_TESTING=ON

# 4. 编译
make -j$(nproc)

# 5. 运行测试
ctest --output-on-failure
```

### CMake 配置选项

| 选项 | 默认值 | 说明 |
|------|--------|------|
| `BUILD_TESTING` | ON | 启用测试构建 |
| `CMAKE_BUILD_TYPE` | Release | 构建类型 (Debug/Release/RelWithDebInfo) |
| `CMAKE_INSTALL_PREFIX` | /usr/local | 安装路径 |

### Debug 模式构建（用于调试）

```bash
cmake .. -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug
make -j$(nproc)
```

---

## 模块测试清单

### 第一组：Schweizer-Messer 基础模块 (13个)

| 模块 | 测试可执行文件 | 状态 |
|------|---------------|------|
| sm_common | sm_common-test | ✅ |
| sm_logging | sm_logging-test | ✅ |
| sm_random | sm_random-test | ✅ |
| sm_boost | sm_boost-test | ✅ |
| sm_eigen | sm_eigen-test | ✅ |
| sm_property_tree | sm_property_tree-test | ✅ |
| sm_timing | sm_timing-test | ✅ |
| sm_kinematics | sm_kinematics-test | ✅ |
| sm_matrix_archive | sm_matrix_archive-test | ✅ |
| sm_opencv | sm_opencv-test | ✅ |
| python_module | (Python测试) | ✅ |
| numpy_eigen | numpy_eigen_tests.py | ✅ |
| sm_python | (Python测试) | ✅ |

### 第二组：aslam_optimizer 优化模块 (4个)

| 模块 | 测试可执行文件 | 状态 |
|------|---------------|------|
| sparse_block_matrix | sparse_block_matrix_tests | ✅ |
| aslam_backend | aslam_backend-test | ✅ |
| aslam_backend_expressions | aslam_backend_expressions-test | ✅ |
| aslam_backend_python | (Python测试) | ✅ |

### 第三组：aslam_cv 视觉模块 (9个)

| 模块 | 测试可执行文件 | 状态 |
|------|---------------|------|
| aslam_time | aslam_time-test | ✅ |
| aslam_cameras | aslam_cameras-test | ✅ |
| aslam_cameras_april | aslam_cameras_april-test | ✅ |
| aslam_imgproc | aslam_imgproc-test | ✅ |
| aslam_cv_error_terms | aslam_cv_error_terms-test | ✅ |
| aslam_cv_backend | aslam_cv_backend-test | ✅ |
| aslam_cv_serialization | aslam_cv_serialization-test | ✅ |
| aslam_cv_python | (Python测试) | ✅ |
| aslam_cv_backend_python | (Python测试) | ✅ |

### 第四组：aslam_nonparametric_estimation 非参数估计模块 (4个)

| 模块 | 测试可执行文件 | 状态 |
|------|---------------|------|
| bsplines | bsplines-test | ✅ |
| bsplines_python | (Python测试) | ✅ |
| aslam_splines | aslam_splines-test | ✅ |
| aslam_splines_python | (Python测试) | ✅ |

### 第五组：aslam_incremental_calibration 增量校准模块 (2个)

| 模块 | 测试可执行文件 | 状态 |
|------|---------------|------|
| incremental_calibration | incremental_calibration-test | ✅ |
| incremental_calibration_python | (Python测试) | ✅ |

### 第六组：aslam_offline_calibration 离线校准模块 (2个)

| 模块 | 测试可执行文件 | 状态 |
|------|---------------|------|
| ethz_apriltag2 | ethz_apriltag2-test | ✅ |
| kalibr | kalibr-test | ✅ |

---

## 各模块测试指南

### 1. Schweizer-Messer 基础模块

#### 1.1 sm_common - 公共基础库

**测试位置**: `Schweizer-Messer/sm_common/test/`

**测试内容**:
- 数学工具函数
- 序列化宏
- 数值比较
- Hash ID 生成

**运行方式**:
```bash
cd build/Schweizer-Messer/sm_common
./sm_common-test
```

**预期输出**:
```
[==========] Running X tests from Y test cases.
[----------] Global test environment set-up.
[----------] X tests from Y test cases ran.
[  PASSED  ] X tests.
```

#### 1.2 sm_logging - 日志模块

**测试位置**: `Schweizer-Messer/sm_logging/test/`

**运行方式**:
```bash
cd build/Schweizer-Messer/sm_logging
./sm_logging-test
```

#### 1.3 sm_eigen - Eigen 工具库

**测试位置**: `Schweizer-Messer/sm_eigen/test/`

**测试内容**:
- 矩阵平方根
- Eigen 序列化

**运行方式**:
```bash
cd build/Schweizer-Messer/sm_eigen
./sm_eigen-test
```

#### 1.4 sm_kinematics - 运动学库

**测试位置**: `Schweizer-Messer/sm_kinematics/test/`

**测试内容**:
- 四元数运算
- 变换矩阵
- 齐次坐标
- 不确定变换

**运行方式**:
```bash
cd build/Schweizer-Messer/sm_kinematics
./sm_kinematics-test
```

#### 1.5 numpy_eigen - NumPy-Eigen 绑定

**测试位置**: `Schweizer-Messer/numpy_eigen/test/`

**运行方式**:
```bash
cd build/Schweizer-Messer/numpy_eigen
python3 ../Schweizer-Messer/numpy_eigen/test/numpy_eigen_tests.py
```

### 2. aslam_optimizer 优化模块

#### 2.1 sparse_block_matrix - 稀疏块矩阵

**测试位置**: `aslam_optimizer/sparse_block_matrix/test/`

**测试内容**:
- 稀疏矩阵操作
- 求解器测试

**运行方式**:
```bash
cd build/aslam_optimizer/sparse_block_matrix
./sparse_block_matrix_tests
```

**注意**: 如果安装了 SuiteSparse，会运行更多测试。

#### 2.2 aslam_backend - 优化后端

**测试位置**: `aslam_optimizer/aslam_backend/test/`

**测试内容**:
- 优化问题定义
- 雅可比矩阵计算
- 线性求解器
- 矩阵操作

**运行方式**:
```bash
cd build/aslam_optimizer/aslam_backend
./aslam_backend-test
```

### 3. aslam_cv 视觉模块

#### 3.1 aslam_cameras - 相机模型

**测试位置**: `aslam_cv/aslam_cameras/test/`

**测试内容**:
- 针孔相机模型
- 各种畸变模型（RadialTangential, FOV, EquiDist, DoubleSphere等）
- 三角化测试
- 网格标定

**运行方式**:
```bash
cd build/aslam_cv/aslam_cameras
./aslam_cameras-test
```

**测试数据**: 需要 `testImageCheckerboard.jpg` 和 `testImageCircleGrid.jpg`

#### 3.2 aslam_cv_backend - 视觉优化后端

**测试位置**: `aslam_cv/aslam_cv_backend/test/`

**测试内容**:
- 重投影误差

**运行方式**:
```bash
cd build/aslam_cv/aslam_cv_backend
./aslam_cv_backend-test
```

### 4. aslam_nonparametric_estimation 非参数估计

#### 4.1 bsplines - B样条库

**测试位置**: `aslam_nonparametric_estimation/bsplines/test/`

**测试内容**:
- B样条曲线
- 旋转样条
- 数值积分
- 微分流形样条

**运行方式**:
```bash
cd build/aslam_nonparametric_estimation/bsplines
./bsplines-test
```

#### 4.2 aslam_splines - ASAM样条

**测试位置**: `aslam_nonparametric_estimation/aslam_splines/test/`

**运行方式**:
```bash
cd build/aslam_nonparametric_estimation/aslam_splines
./aslam_splines-test
```

### 5. aslam_incremental_calibration 增量校准

#### 5.1 incremental_calibration

**测试位置**: `aslam_incremental_calibration/incremental_calibration/test/`

**测试内容**:
- 增量优化问题
- 线性求解器
- 算法测试

**运行方式**:
```bash
cd build/aslam_incremental_calibration/incremental_calibration
./incremental_calibration-test
```

### 6. aslam_offline_calibration 离线校准

#### 6.1 kalibr - 主应用

**测试位置**: `aslam_offline_calibration/kalibr/test/`

**测试内容**:
- 误差项测试

**运行方式**:
```bash
cd build/aslam_offline_calibration/kalibr
./kalibr-test
```

---

## 测试结果验证

### 快速运行所有测试

```bash
cd build
ctest -j$(nproc) --output-on-failure
```

### 运行特定模块测试

```bash
# 只运行 sm_common 测试
ctest -R sm_common-test --output-on-failure

# 只运行优化器相关测试
ctest -R "aslam_backend|sparse_block" --output-on-failure
```

### 详细测试报告

```bash
# 生成详细的XML报告
ctest -j$(nproc) --output-on-failure --no-compress-output -T Test

# 使用人类可读的格式
ctest -j$(nproc) --verbose
```

### 测试覆盖率（可选）

如需生成测试覆盖率报告：

```bash
# 重新配置，启用覆盖率
cmake .. -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Debug -DCOVERAGE=ON

# 编译并运行测试
make -j$(nproc)
ctest -j$(nproc)

# 生成覆盖率报告（需要 lcov）
sudo apt-get install lcov
lcov --capture --directory . --output-file coverage.info
genhtml coverage.info --output-directory coverage_report
```

---

## 常见问题排查

### 问题1: 找不到 GTest

**错误信息**:
```
Could NOT find GTest (missing: GTEST_LIBRARY GTEST_INCLUDE_DIR)
```

**解决方案**:
```bash
# 安装并编译 GTest
sudo apt-get install libgtest-dev
cd /usr/src/gtest
sudo cmake CMakeLists.txt
sudo make
sudo cp lib/*.a /usr/lib/
```

### 问题2: SuiteSparse 相关测试失败

**现象**: 稀疏矩阵测试失败

**原因**: 未安装 SuiteSparse 库

**解决方案**:
```bash
sudo apt-get install libsuitesparse-dev
# 重新配置和编译
cd build
cmake ..
make -j$(nproc)
```

### 问题3: Python 导入错误

**现象**: Python 绑定测试无法导入模块

**解决方案**:
```bash
# 设置 PYTHONPATH
export PYTHONPATH=/path/to/kalibr/build/lib:$PYTHONPATH
# 或者使用安装后的版本
sudo make install
```

### 问题4: 测试超时

**现象**: 某些测试运行时间过长

**解决方案**:
```bash
# 延长超时时间
ctest --timeout 300 --output-on-failure

# 或者单独运行慢速测试
ctest -R "slow_test_name" --timeout 600
```

### 问题5: 内存不足导致测试失败

**现象**: 大型测试在编译或运行时 OOM

**解决方案**:
```bash
# 减少并行编译数
make -j2

# 或者逐个运行测试
ctest -j1 --output-on-failure
```

---

## 完整验证流程示例

```bash
#!/bin/bash
# 完整的模块验证脚本

set -e

echo "====================================="
echo "Kalibr 模块验证测试"
echo "====================================="

# 1. 环境检查
echo "[1/6] 检查环境..."
which cmake || { echo "cmake 未安装"; exit 1; }
which g++ || { echo "g++ 未安装"; exit 1; }

# 2. 清理旧构建
echo "[2/6] 清理旧构建..."
rm -rf build && mkdir -p build && cd build

# 3. 配置
echo "[3/6] CMake 配置..."
cmake .. -DBUILD_TESTING=ON -DCMAKE_BUILD_TYPE=Release

# 4. 编译
echo "[4/6] 编译中..."
make -j$(nproc)

# 5. 运行测试
echo "[5/6] 运行测试..."
ctest -j$(nproc) --output-on-failure

# 6. 汇总
echo "[6/6] 验证完成！"
echo "====================================="
echo "所有测试通过！"
echo "====================================="
```

---

## 参考资料

- [CMake 测试文档](https://cmake.org/cmake/help/latest/manual/ctest.1.html)
- [Google Test 文档](https://google.github.io/googletest/)
- [Kalibr Wiki](https://github.com/ethz-asl/kalibr/wiki)
- [CATKIN_TO_CMAKE_MIGRATION_GUIDE.md](./CATKIN_TO_CMAKE_MIGRATION_GUIDE.md)

---

**文档版本**: 1.0
**最后更新**: 2026-04-02
**维护者**: Kalibr 开发团队
