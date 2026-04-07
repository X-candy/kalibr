# Kalibr 靶标 YAML 配置文件说明

> 本文档详细说明 Kalibr 校准工具使用的三种靶标配置文件格式：AprilGrid、Checkerboard 和 CircleGrid。

## 目录

1. [概述](#概述)
2. [AprilGrid 配置](#aprilgrid-配置)
3. [Checkerboard 配置](#checkerboard-配置)
4. [CircleGrid 配置](#circlegrid-配置)
5. [配置文件生成](#配置文件生成)
6. [使用示例](#使用示例)
7. [常见问题](#常见问题)

---

## 概述

Kalibr 支持三种类型的校准靶标，每种靶标需要对应的 YAML 配置文件来定义其几何参数：

| 靶标类型 | `target_type` 值 | 适用场景 |
|----------|------------------|----------|
| AprilGrid | `aprilgrid` | 推荐使用，支持部分可见、自动 ID 识别 |
| Checkerboard | `checkerboard` | 传统棋盘格，需要完整可见 |
| CircleGrid | `circlegrid` | 圆点网格，适合高精度场景 |

---

## AprilGrid 配置

### 配置文件格式

```yaml
# AprilGrid 靶标配置示例
target_type: 'aprilgrid'    # 靶标类型，固定为 'aprilgrid'
tagRows: 6                   # AprilTag 的行数（≥3）
tagCols: 6                   # AprilTag 的列数（≥3）
tagSize: 0.088               # 单个 AprilTag 的边长，单位：米
tagSpacing: 0.3               # 标签间距比例（相对 tagSize）
```

### 参数详解

#### `target_type`
- **类型**: 字符串
- **必填**: 是
- **取值**: 固定为 `'aprilgrid'`
- **说明**: 指定靶标类型为 AprilGrid

#### `tagRows`
- **类型**: 整数
- **必填**: 是
- **取值范围**: ≥ 3
- **说明**: AprilTag 网格的行数
- **示例**: `6` 表示纵向有 6 个标签

#### `tagCols`
- **类型**: 整数
- **必填**: 是
- **取值范围**: ≥ 3
- **说明**: AprilTag 网格的列数
- **示例**: `6` 表示横向有 6 个标签

#### `tagSize`
- **类型**: 浮点数
- **必填**: 是
- **取值范围**: > 0.0
- **单位**: 米 (m)
- **说明**: 单个 AprilTag 的物理边长
- **示例**: `0.088` 表示每个标签边长为 8.8 厘米

#### `tagSpacing`
- **类型**: 浮点数
- **必填**: 是
- **取值范围**: 0.0 < tagSpacing ≤ 1.0
- **说明**: 标签间距与标签大小的比例
- **计算方式**: 实际间距 = `tagSize` × `tagSpacing`
- **示例**: `0.3` 表示间距为标签大小的 30%

### 完整示例

```yaml
# AprilGrid 配置示例 - 6x6 网格
target_type: 'aprilgrid'
tagRows: 6
tagCols: 6
tagSize: 0.088
tagSpacing: 0.3
```

### 几何尺寸计算

对于上述配置：
- 标签边长: 8.8 cm
- 标签间距: 8.8 cm × 0.3 = 2.64 cm
- 单个单元格宽度: 8.8 cm + 2.64 cm = 11.44 cm
- 整个网格宽度: 6 × 8.8 cm + 5 × 2.64 cm = 65.76 cm

---

## Checkerboard 配置

### 配置文件格式

```yaml
# Checkerboard 靶标配置示例
target_type: 'checkerboard'   # 靶标类型，固定为 'checkerboard'
targetRows: 8                  # 内部角点的行数（≥3）
targetCols: 10                 # 内部角点的列数（≥3）
rowSpacingMeters: 0.06         # 行间距，单位：米
colSpacingMeters: 0.06         # 列间距，单位：米
```

### 参数详解

#### `target_type`
- **类型**: 字符串
- **必填**: 是
- **取值**: 固定为 `'checkerboard'`
- **说明**: 指定靶标类型为棋盘格

#### `targetRows`
- **类型**: 整数
- **必填**: 是
- **取值范围**: ≥ 3
- **说明**: 内部角点的行数（不是方格数！）
- **重要提示**: 方格数 = 内部角点数 + 1
- **示例**: 9 行方格 → `targetRows: 8`

#### `targetCols`
- **类型**: 整数
- **必填**: 是
- **取值范围**: ≥ 3
- **说明**: 内部角点的列数（不是方格数！）
- **重要提示**: 方格数 = 内部角点数 + 1
- **示例**: 11 列方格 → `targetCols: 10`

#### `rowSpacingMeters`
- **类型**: 浮点数
- **必填**: 是
- **取值范围**: > 0.0
- **单位**: 米 (m)
- **说明**: 相邻两行角点之间的垂直距离（即方格边长）
- **示例**: `0.06` 表示方格边长为 6 厘米

#### `colSpacingMeters`
- **类型**: 浮点数
- **必填**: 是
- **取值范围**: > 0.0
- **单位**: 米 (m)
- **说明**: 相邻两列角点之间的水平距离（即方格边长）
- **示例**: `0.06` 表示方格边长为 6 厘米

### 完整示例

```yaml
# Checkerboard 配置示例 - 9x11 方格（8x10 内角点）
target_type: 'checkerboard'
targetRows: 8
targetCols: 10
rowSpacingMeters: 0.06
colSpacingMeters: 0.06
```

### 与方格数的对应关系

| 实际方格 | `targetRows` | `targetCols` |
|----------|-------------|-------------|
| 8×8 | 7 | 7 |
| 9×11 | 8 | 10 |
| 10×12 | 9 | 11 |
| 12×12 | 11 | 11 |

---

## CircleGrid 配置

### 配置文件格式

```yaml
# CircleGrid 靶标配置示例
target_type: 'circlegrid'       # 靶标类型，固定为 'circlegrid'
targetRows: 8                    # 圆点的行数（≥3）
targetCols: 10                   # 圆点的列数（≥3）
spacingMeters: 0.06              # 圆点间距，单位：米
asymmetricGrid: false             # 是否为非对称网格
```

### 参数详解

#### `target_type`
- **类型**: 字符串
- **必填**: 是
- **取值**: 固定为 `'circlegrid'`
- **说明**: 指定靶标类型为圆点网格

#### `targetRows`
- **类型**: 整数
- **必填**: 是
- **取值范围**: ≥ 3
- **说明**: 圆点的行数
- **示例**: `8` 表示纵向有 8 个圆点

#### `targetCols`
- **类型**: 整数
- **必填**: 是
- **取值范围**: ≥ 3
- **说明**: 圆点的列数
- **示例**: `10` 表示横向有 10 个圆点

#### `spacingMeters`
- **类型**: 浮点数
- **必填**: 是
- **取值范围**: > 0.0
- **单位**: 米 (m)
- **说明**: 相邻圆点中心之间的距离
- **示例**: `0.06` 表示圆点间距为 6 厘米

#### `asymmetricGrid`
- **类型**: 布尔值
- **必填**: 是
- **取值**: `true` 或 `false`
- **说明**: 
  - `false`: 标准对称网格
  - `true`: 非对称网格（每行偏移半个间距）
- **优势**: 非对称网格可以提供更好的方向识别

### 完整示例

```yaml
# CircleGrid 配置示例 - 8x10 对称网格
target_type: 'circlegrid'
targetRows: 8
targetCols: 10
spacingMeters: 0.06
asymmetricGrid: false
```

```yaml
# CircleGrid 配置示例 - 7x7 非对称网格
target_type: 'circlegrid'
targetRows: 7
targetCols: 7
spacingMeters: 0.05
asymmetricGrid: true
```

---

## 配置文件生成

### 使用 kalibr_create_target_pdf 生成靶标

Kalibr 提供了工具生成可打印的靶标 PDF 文件：

```bash
# 生成 AprilGrid 靶标
kalibr_create_target_pdf --type apriltag --nx 6 --ny 6 --tsize 0.088 --tspace 0.3

# 生成 Checkerboard 靶标
kalibr_create_target_pdf --type checkerboard --nx 7 --ny 7 --csize 0.06

# 生成 CircleGrid 靶标
kalibr_create_target_pdf --type circlegrid --nx 7 --ny 7 --csize 0.06
```

### 命令行参数说明

#### AprilGrid 参数
- `--type apriltag`: 指定生成 AprilGrid
- `--nx N`: 标签列数
- `--ny N`: 标签行数
- `--tsize SIZE`: 标签边长（米）
- `--tspace SPACE`: 间距比例（0.0-1.0）

#### Checkerboard 参数
- `--type checkerboard`: 指定生成 Checkerboard
- `--nx N`: 方格列数
- `--ny N`: 方格行数
- `--csize SIZE`: 方格边长（米）

#### CircleGrid 参数
- `--type circlegrid`: 指定生成 CircleGrid
- `--nx N`: 圆格列数
- `--ny N`: 圆点行数
- `--csize SIZE`: 圆点间距（米）

### 生成与配置文件的对应关系

生成靶标时记录参数，然后创建对应的 YAML 配置文件：

| 生成命令参数 | YAML 配置字段 |
|-------------|---------------|
| AprilGrid | |
| `--nx 6` | `tagCols: 6` |
| `--ny 6` | `tagRows: 6` |
| `--tsize 0.088` | `tagSize: 0.088` |
| `--tspace 0.3` | `tagSpacing: 0.3` |
| Checkerboard | |
| `--nx 11` | `targetCols: 10` (nx-1) |
| `--ny 9` | `targetRows: 8` (ny-1) |
| `--csize 0.06` | `rowSpacingMeters: 0.06` |
| | `colSpacingMeters: 0.06` |

---

## 使用示例

### 完整工作流程

#### 1. 准备靶标配置文件

创建 `aprilgrid.yaml`：
```yaml
target_type: 'aprilgrid'
tagRows: 6
tagCols: 6
tagSize: 0.088
tagSpacing: 0.3
```

#### 2. 生成并打印靶标

```bash
kalibr_create_target_pdf --type apriltag --nx 6 --ny 6 --tsize 0.088 --tspace 0.3
# 输出: aprilgrid_6x6_88x88mm.pdf
```

#### 3. 使用靶标进行校准

```bash
# 多相机校准
kalibr_calibrate_cameras \
  --target aprilgrid.yaml \
  --bag cam_data.bag \
  --models pinhole-radtan pinhole-radtan \
  --topics /cam0/image_raw /cam1/image_raw

# 相机-IMU 校准
kalibr_calibrate_imu_camera \
  --target aprilgrid.yaml \
  --bag imu_cam_data.bag \
  --cam camchain.yaml \
  --imu imu.yaml
```

### 多相机校准配置示例

#### 相机配置文件 `camchain.yaml`
```yaml
cam0:
  camera_model: pinhole
  intrinsics: [458.654, 457.296, 367.215, 248.375]
  distortion_model: radtan
  distortion_coeffs: [-0.28340811, 0.07395907, 0.00019359, 1.76187114e-05]
  resolution: [752, 480]
  rostopic: /cam0/image_raw

cam1:
  camera_model: pinhole
  intrinsics: [457.587, 456.134, 379.999, 255.238]
  distortion_model: radtan
  distortion_coeffs: [-0.28368365, 0.07451284, -0.00010473, -3.55590700e-05]
  resolution: [752, 480]
  rostopic: /cam1/image_raw
  T_cn_cnm1:
  - [0.9999972563, -0.0023175421, 0.0003760010, -0.1100739988]
  - [0.0023120691, 0.9998980485, 0.0140898358, -0.0002127766]
  - [-0.0004086140, -0.0140889713, 0.9999006631, 0.0008097633]
  - [0.0, 0.0, 0.0, 1.0]
```

#### IMU 配置文件 `imu.yaml`
```yaml
rostopic: /imu0
update_rate: 200.0
accelerometer_noise_density: 0.01
accelerometer_random_walk: 0.0002
gyroscope_noise_density: 0.005
gyroscope_random_walk: 4.0e-05
```

---

## 常见问题

### Q1: AprilGrid 的 tagRows 和 tagCols 如何确定？

**A**: 数打印出的靶标中 AprilTag 的数量。例如，横向有 6 个标签，纵向有 6 个标签，则设置：
```yaml
tagRows: 6
tagCols: 6
```

### Q2: Checkerboard 的 targetRows 为什么是方格数减 1？

**A**: `targetRows` 和 `targetCols` 指的是**内部角点**的数量，而不是方格数。例如：
- 9×9 方格 → 8×8 内部角点
- 11×11 方格 → 10×10 内部角点

### Q3: 如何精确测量 tagSize？

**A**: 
1. 打印靶标后，使用卡尺测量多个标签的总宽度
2. 除以标签数量得到单个标签的平均尺寸
3. 以米为单位写入配置文件
4. 建议测量至少 3 次取平均值

### Q4: tagSpacing 如何计算？

**A**: 有两种方式：
1. **已知比例**: 如果是用 `kalibr_create_target_pdf` 生成的，直接使用生成时的 `--tspace` 参数
2. **实际测量**: 测量两个相邻标签边缘之间的距离，除以标签大小得到比例

### Q5: 三种靶标该如何选择？

**A**:
- **AprilGrid（推荐）**: 大多数场景的首选，支持部分可见，鲁棒性强
- **Checkerboard**: 简单场景，传统方法，需要完整可见
- **CircleGrid**: 高精度需求，特别是非对称网格

### Q6: 配置文件报错 "Field X missing"？

**A**: 检查 YAML 文件：
1. 确保所有必填字段都存在
2. 检查缩进（YAML 使用空格，不是 Tab）
3. 检查字段名称拼写（区分大小写）
4. 确认数据类型正确（数字不要加引号）

### Q7: 打印时缩放了怎么办？

**A**: 
1. 打印时确保选择"实际大小"或"100%"缩放
2. 不要选择"适应页面"
3. 打印后测量验证尺寸
4. 如果缩放了，按比例修正配置文件中的尺寸参数

### Q8: 靶标可以贴在曲面上吗？

**A**: 不建议。靶标应该贴在**平坦、刚性**的表面上。曲面会引入额外的畸变，影响校准精度。

---

## 附录

### 快速参考表

#### AprilGrid 参数速查

| 参数 | 类型 | 示例 | 说明 |
|------|------|------|------|
| `target_type` | string | `'aprilgrid'` | 固定值 |
| `tagRows` | int | `6` | 标签行数 |
| `tagCols` | int | `6` | 标签列数 |
| `tagSize` | float | `0.088` | 标签边长（米） |
| `tagSpacing` | float | `0.3` | 间距比例 |

#### Checkerboard 参数速查

| 参数 | 类型 | 示例 | 说明 |
|------|------|------|------|
| `target_type` | string | `'checkerboard'` | 固定值 |
| `targetRows` | int | `8` | 内角点行数（方格数-1） |
| `targetCols` | int | `10` | 内角点列数（方格数-1） |
| `rowSpacingMeters` | float | `0.06` | 行间距（米） |
| `colSpacingMeters` | float | `0.06` | 列间距（米） |

#### CircleGrid 参数速查

| 参数 | 类型 | 示例 | 说明 |
|------|------|------|------|
| `target_type` | string | `'circlegrid'` | 固定值 |
| `targetRows` | int | `8` | 圆点数行数 |
| `targetCols` | int | `10` | 圆点数列数 |
| `spacingMeters` | float | `0.06` | 圆点间距（米） |
| `asymmetricGrid` | bool | `false` | 是否非对称 |

### 推荐配置

#### 通用推荐 - AprilGrid 6x6

```yaml
target_type: 'aprilgrid'
tagRows: 6
tagCols: 6
tagSize: 0.088
tagSpacing: 0.3
```

#### 小场景推荐 - AprilGrid 5x5

```yaml
target_type: 'aprilgrid'
tagRows: 5
tagCols: 5
tagSize: 0.055
tagSpacing: 0.2
```

#### 大场景推荐 - AprilGrid 7x7

```yaml
target_type: 'aprilgrid'
tagRows: 7
tagCols: 7
tagSize: 0.12
tagSpacing: 0.3
```

---

**文档版本**: 1.0  
**最后更新**: 2026-04-02  
**维护者**: Kalibr 开发团队  
**相关文档**: [MODULE_VERIFICATION_TEST_GUIDE.md](./MODULE_VERIFICATION_TEST_GUIDE.md)
