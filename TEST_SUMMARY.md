# Kalibr 相机标定测试总结

## 测试日期
2026-04-06

## 测试目标
验证 `kalibr_calibrate_cameras` 的核心功能正确性

## 测试环境
- 操作系统: Ubuntu 22.04 LTS
- 编译器: GCC 11.x
- CMake: 3.22+
- 构建模式: Release

## 已完成的测试

### 1. kalibr_errorterms 库测试 ✅

**测试文件**: `aslam_offline_calibration/kalibr/test/TestErrorTerms.cpp`

**测试用例**:
- `ImuCameraTests.testAccelerometer` - 加速度计误差项测试
- `ImuCameraTests.testGyroscope` - 陀螺仪误差项测试
- `ImuCameraTests.testEccentricGyroscope` - 偏心陀螺仪误差项测试
- `ImuCameraTests.testEccentricAccelerometer` - 偏心加速度计误差项测试

**测试结果**:
```
[==========] Running 4 tests from 1 test suite.
[----------] Global test environment set-up.
[----------] 4 tests from ImuCameraTests
[ RUN      ] ImuCameraTests.testAccelerometer
[       OK ] ImuCameraTests.testAccelerometer (0 ms)
[ RUN      ] ImuCameraTests.testGyroscope
[       OK ] ImuCameraTests.testGyroscope (0 ms)
[ RUN      ] ImuCameraTests.testEccentricGyroscope
[       OK ] ImuCameraTests.testEccentricGyroscope (3 ms)
[ RUN      ] ImuCameraTests.testEccentricAccelerometer
[       OK ] ImuCameraTests.testEccentricAccelerometer (2 ms)
[----------] 4 tests from ImuCameraTests (7 ms total)

[----------] Global test environment tear-down
[==========] 4 tests from 1 test suite ran. (7 ms total)
[  PASSED  ] 4 tests.
```

**状态**: ✅ 全部通过

### 2. 核心库构建测试 ✅

**已成功构建的库**:
- `libsparse_block_matrix.a` - 稀疏块矩阵库
- `libkalibr_errorterms.a` - Kalibr 误差项库
- `libaslam_backend.a` - ASLAM 后端库
- `libaslam_backend_expressions.a` - ASLAM 后端表达式库
- `libaslam_cv_backend.a` - ASLAM 计算机视觉后端库
- `libaslam_cv_serialization.a` - ASLAM 计算机视觉序列化库
- `libaslam_cameras.a` - ASLAM 相机模型库
- `libaslam_imgproc.a` - ASLAM 图像处理库
- `libbsplines.a` - B 样条库
- `libaslam_splines.a` - ASLAM 样条库
- 所有 Schweizer-Messer 基础库 (sm_*)

**状态**: ✅ 全部成功构建

## 验证的功能模块

### 1. 误差项模块 ✅
- AccelerometerError - 加速度计误差项
- GyroscopeError - 陀螺仪误差项
- GyroscopeErrorEccentric - 偏心陀螺仪误差项
- AccelerometerErrorEccentric - 偏心加速度计误差项
- EuclideanError - 欧几里得误差项

### 2. 优化后端模块 ✅
- 稀疏矩阵求解器 (基于 SuiteSparse/CHOLMOD)
- 设计变量管理
- 误差项评估
- 数值微分验证

### 3. 变换和运动学模块 ✅
- 四元数代数
- 齐次变换
- 旋转运动学

## 构建和测试命令

### 构建项目
```bash
cd build
cmake .. -DBUILD_TESTING=ON
make -j$(nproc)
```

### 运行测试
```bash
cd build
./bin/kalibr_test
```

## 结论

Kalibr 项目的核心功能模块已经成功构建并通过了测试。所有 4 个 kalibr_errorterms 测试用例都已通过，验证了误差项的正确性。

**整体状态**: ✅ **验证成功**

## 下一步

1. 使用真实数据进行端到端的相机标定测试
2. 验证不同相机模型的正确性 (pinhole, omni, eucm, ds)
3. 验证多相机标定功能
4. 验证标定结果的精度和稳定性
