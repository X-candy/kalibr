# Kalibr Catkin到CMake批量迁移执行手册
**版本**：1.0
**执行总时长**：8小时（3人并行）
**文档生效时间**：2026-03-30
**负责人**：解决方案架构师

---

## 一、36个模块迁移优先级排序（按依赖层级）
### 优先级定义
- P0：核心基础模块，被所有其他模块依赖，必须最先完成
- P1：基础工具模块，被核心算法依赖
- P2：核心算法模块，被应用层依赖
- P3：应用层模块，无下游依赖

| 优先级 | 模块组 | 模块名称 | 预计改造时间 | 依赖模块 | 验收标准 |
|--------|--------|----------|--------------|----------|----------|
| **P0** | 基础设施层 | sm_common | 10分钟 | boost | 可独立编译，单元测试100%通过 |
| **P0** | 基础设施层 | sm_logging | 10分钟 | boost, spdlog | 可独立编译，日志功能正常 |
| **P0** | 基础设施层 | sm_boost | 8分钟 | boost | 可独立编译 |
| **P0** | 基础设施层 | numpy_eigen | 15分钟 | eigen3, python3, numpy | 可独立编译，Python绑定可用 |
| **P0** | 基础设施层 | python_module | 12分钟 | python3 | 可独立编译 |
| **P1** | 基础设施层 | sm_eigen | 10分钟 | eigen3, sm_common | 可独立编译，单元测试通过 |
| **P1** | 基础设施层 | sm_kinematics | 12分钟 | eigen3, sm_common, sm_eigen | 可独立编译，几何运算测试通过 |
| **P1** | 基础设施层 | sm_random | 8分钟 | boost, sm_common | 可独立编译 |
| **P1** | 基础设施层 | sm_property_tree | 15分钟 | boost, yaml-cpp | 可独立编译，YAML解析功能正常 |
| **P1** | 基础设施层 | sm_matrix_archive | 10分钟 | eigen3, sm_common | 可独立编译 |
| **P1** | 基础设施层 | sm_timing | 8分钟 | boost, sm_common | 可独立编译 |
| **P1** | 基础设施层 | sm_opencv | 12分钟 | opencv, sm_common, sm_eigen | 可独立编译，OpenCV接口正常 |
| **P1** | 基础设施层 | sm_python | 12分钟 | python3, numpy_eigen | 可独立编译 |
| **P2** | 核心算法层 | sparse_block_matrix | 10分钟 | eigen3, sm_common | 可独立编译 |
| **P2** | 核心算法层 | aslam_backend | 15分钟 | sparse_block_matrix, sm_common, sm_eigen, sm_logging | 可独立编译 |
| **P2** | 核心算法层 | aslam_backend_expressions | 12分钟 | aslam_backend, sm_common | 可独立编译 |
| **P2** | 核心算法层 | aslam_backend_python | 12分钟 | aslam_backend, python_module, sm_python | 可独立编译 |
| **P2** | 核心算法层 | aslam_time | 8分钟 | sm_common | 可独立编译 |
| **P2** | 核心算法层 | aslam_cameras | 15分钟 | opencv, eigen3, sm_common, sm_eigen, sm_property_tree | 可独立编译 |
| **P2** | 核心算法层 | ethz_apriltag2 | 10分钟 | opencv | 可独立编译 |
| **P2** | 核心算法层 | aslam_cameras_april | 12分钟 | aslam_cameras, ethz_apriltag2 | 可独立编译 |
| **P2** | 核心算法层 | aslam_imgproc | 12分钟 | opencv, sm_common, sm_opencv, aslam_cameras | 可独立编译 |
| **P2** | 核心算法层 | aslam_cv_error_terms | 12分钟 | aslam_backend, aslam_cameras, sm_eigen | 可独立编译 |
| **P2** | 核心算法层 | aslam_cv_backend | 15分钟 | aslam_backend, aslam_cv_error_terms, aslam_cameras | 可独立编译 |
| **P2** | 核心算法层 | aslam_cv_backend_python | 12分钟 | aslam_cv_backend, python_module, sm_python | 可独立编译 |
| **P2** | 核心算法层 | aslam_cv_python | 12分钟 | aslam_cv, python_module, sm_python | 可独立编译 |
| **P2** | 核心算法层 | aslam_cv_serialization | 10分钟 | aslam_cv, boost_serialization | 可独立编译 |
| **P2** | 核心算法层 | bsplines | 10分钟 | eigen3, sm_common | 可独立编译 |
| **P2** | 核心算法层 | bsplines_python | 10分钟 | bsplines, python_module, sm_python | 可独立编译 |
| **P2** | 核心算法层 | aslam_splines | 12分钟 | bsplines, aslam_backend, sm_kinematics | 可独立编译 |
| **P2** | 核心算法层 | aslam_splines_python | 10分钟 | aslam_splines, python_module, sm_python | 可独立编译 |
| **P2** | 核心算法层 | incremental_calibration | 15分钟 | aslam_backend, aslam_cv, aslam_splines, sm_kinematics | 可独立编译 |
| **P2** | 核心算法层 | incremental_calibration_python | 12分钟 | incremental_calibration, python_module, sm_python | 可独立编译 |
| **P3** | 应用层 | kalibr | 20分钟 | 所有模块 | 可独立编译，命令行工具可用 |
| **P3** | 废弃模块 | opencv2_catkin | - | - | 直接删除，无需迁移 |
| **P3** | 废弃模块 | catkin_simple | - | - | 直接删除，无需迁移 |

**总预计改造时间**：396分钟 ≈ 6.6小时，加上验证时间总时长8小时

---

## 二、每个模块标准化改造Checklist（12步必过）
```markdown
✅ 1. CMake版本升级：cmake_minimum_required → 3.10，添加VERSION 0.0.1
✅ 2. 移除Catkin依赖：删除find_package(catkin)和catkin_package()
✅ 3. 显式依赖声明：替换为具体的find_package(依赖包 REQUIRED)
✅ 4. 路径替换：${catkin_INCLUDE_DIRS} → 具体依赖的INCLUDE_DIRS
✅ 5. 库替换：${catkin_LIBRARIES} → 具体依赖的LIBRARIES
✅ 6. 头文件导出：添加target_include_directories PUBLIC配置
✅ 7. 安装路径替换：CATKIN_PACKAGE_*_DESTINATION → CMAKE_INSTALL_*
✅ 8. Config文件生成：添加CMakePackageConfigHelpers配置
✅ 9. 测试开关替换：CATKIN_ENABLE_TESTING → BUILD_TESTING
✅ 10. 测试宏替换：catkin_add_gtest → 标准add_executable + add_test
✅ 11. 编译验证：mkdir build && cd build && cmake .. && make -j4 无错误无警告
✅ 12. 测试验证：make test 通过率100%（如有测试）
```

---

## 三、并行执行任务分配方案（3人并行，8小时完成）
### 任务组划分（按依赖层级无交叉分配）
| 开发工程师 | 负责模块组 | 模块数量 | 预计总耗时 | 具体模块 |
|------------|------------|----------|------------|----------|
| 开发A | P0 + 部分P1基础模块 | 12个 | 2小时10分钟 | sm_common, sm_logging, sm_boost, numpy_eigen, python_module, sm_random, sm_matrix_archive, sm_timing, sm_property_tree, sm_opencv, sm_python, sm_eigen |
| 开发B | 核心算法层P2模块 | 12个 | 2小时35分钟 | sparse_block_matrix, aslam_backend, aslam_backend_expressions, aslam_backend_python, aslam_time, aslam_cameras, ethz_apriltag2, aslam_cameras_april, aslam_imgproc, aslam_cv_error_terms, aslam_cv_backend, aslam_cv_serialization |
| 开发C | Python绑定 + 应用层P3模块 | 12个 | 2小时21分钟 | sm_kinematics, aslam_cv_backend_python, aslam_cv_python, bsplines, bsplines_python, aslam_splines, aslam_splines_python, incremental_calibration, incremental_calibration_python, kalibr, opencv2_catkin(删除), catkin_simple(删除) |

### 时间线安排
| 时间段 | 进度 | 质量检查点 |
|--------|------|------------|
| 0-2小时 | 所有P0和P1模块完成 | 门禁1：基础设施层全量编译通过 |
| 2-5小时 | 所有P2核心算法模块完成 | 门禁2：核心模块单元测试100%通过 |
| 5-7小时 | 所有P3应用层模块完成 | 门禁3：全项目编译通过 |
| 7-8小时 | 系统测试验证 | 门禁4：端到端标定验证通过 |

### 依赖协调机制
- 依赖未完成时，开发人员优先处理本组内无依赖的模块
- 每30分钟同步一次完成进度到团队群
- 阻塞超过10分钟立即上报架构师协调

---

## 四、质量门禁检查标准（4级门禁，100%通过才能进入下一阶段）
### 🚪 门禁1：基础设施层验收（完成P0+P1所有模块）
**检查项**：
1. ✅ 13个基础模块全部可独立编译
2. ✅ 无任何ROS相关的引用和警告
3. ✅ 所有单元测试通过率100%
4. ✅ 安装目标可以正常执行make install
**验证命令**：
```bash
cd build && make -j13 sm_common sm_logging sm_boost numpy_eigen python_module sm_eigen sm_kinematics sm_random sm_property_tree sm_matrix_archive sm_timing sm_opencv sm_python
```

### 🚪 门禁2：核心算法层验收（完成P2所有模块）
**检查项**：
1. ✅ 19个核心算法模块全部可独立编译
2. ✅ 所有算法单元测试通过率100%
3. ✅ Python绑定可正常导入使用
4. ✅ 无API兼容性问题
**验证命令**：
```bash
cd build && make test ARGS="-L 'unit' -j8"
```

### 🚪 门禁3：应用层验收（完成P3所有模块）
**检查项**：
1. ✅ 全项目一次性编译通过
2. ✅ 所有命令行工具生成在build/bin目录
3. ✅ 所有Python包可正常导入
4. ✅ 无编译警告
**验证命令**：
```bash
cd build && make -j8
ls bin/kalibr_*  # 检查所有命令行工具是否存在
python3 -c "import kalibr"  # 检查Python导入是否正常
```

### 🚪 门禁4：系统级验收（完成所有模块）
**检查项**：
1. ✅ 标定数据集验证：使用标准测试数据集运行kalibr_calibrate_cameras
2. ✅ 结果一致性：输出结果与原Catkin版本的重投影误差差异≤0.01像素
3. ✅ 性能基准：构建时间≤原Catkin构建时间的110%
4. ✅ 安装验证：make install后可全局调用kalibr命令
**验证命令**：
```bash
# 运行标准标定测试
kalibr_calibrate_cameras --target april_6x6.yaml --bag test.bag --topics /cam0/image_raw /cam1/image_raw --models pinhole-radtan pinhole-radtan
```

---

## 五、风险预案
| 风险 | 概率 | 影响 | 应对措施 |
|------|------|------|----------|
| 模块依赖缺失 | 中 | 阻塞编译 | 提前预安装所有依赖：`sudo apt install libboost-all-dev libeigen3-dev libopencv-dev libyaml-cpp-dev libspdlog-dev python3-dev python3-numpy` |
| Python版本不兼容 | 低 | Python绑定编译失败 | 提供Python3.8/3.9/3.10多版本兼容配置 |
| 编译警告未清理 | 中 | 质量不达标 | 开启-Wall -Wextra -Werror编译选项，所有警告必须修复 |
| 单元测试失败 | 中 | 功能异常 | 保留原测试用例，仅修改CMake配置，不改动业务代码 |

---

## 六、完成标准
✅ 所有34个有效模块迁移完成（2个模块直接删除）
✅ 4级质量门禁全部通过
✅ 最终交付物：
1. 全模块CMakeLists.txt修改完成
2. 完整的编译日志
3. 测试报告
4. 性能对比报告
