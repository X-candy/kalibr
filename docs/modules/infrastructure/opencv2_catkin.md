# opencv2_catkin 模块文档

> OpenCV 库的 ROS catkin 封装包，提供简单易用的接口

---

## 1. 📋 功能说明

### 1.1 定位
opencv2_catkin 是 Kalibr 基础设施模块中的计算机视觉库封装包，使用 catkin_simple 框架对 OpenCV 库进行封装，提供 ROS catkin 构建系统的标准接口，简化 OpenCV 在 ROS 项目中的使用。

### 1.2 核心能力
- **OpenCV 版本抽象**：自动检测系统上的 OpenCV 库
- **统一的接口**：提供标准化的 include 和 link 接口
- **自动配置**：通过 CMake 自动配置 OpenCV 依赖
- **简化的使用**：只需添加 build_depend 即可使用，无需手动配置

---

## 2. 🏗️ 架构设计

opencv2_catkin 采用轻量级封装设计，使用 catkin_simple 框架简化 OpenCV 的 ROS 集成。

```plantuml
@startuml

package "opencv2_catkin" {
    [opencv2-extras.cmake.in] <<CMake配置>>
    [CMakeLists.txt] <<构建配置>>
    [package.xml] <<包元信息>>
}

[opencv2-extras.cmake.in] --> [CMakeLists.txt]
[package.xml] --> [CMakeLists.txt]
[CMakeLists.txt] --> [catkin_simple]

@enduml
```

### 2.1 主要组件划分
1. **OpenCV 检测层**：通过 find_package(OpenCV) 自动检测系统 OpenCV
2. **变量导出层**：将 OpenCV 的变量转换为 catkin 可识别的格式
3. **CMake 配置**：通过 opencv2-extras.cmake 提供自动配置支持

### 2.2 数据流走向
```
find_package(OpenCV) → 变量转换 → catkin 变量导出 → 下游包使用
```

### 2.3 关键设计模式
- **适配器模式**：将 OpenCV 的 CMake 变量适配为 catkin 标准格式
- **轻量级封装**：无编译代码，仅 CMake 配置

---

## 3. 🔑 关键方法

### 3.1 OpenCV 自动检测
```cmake
find_package(OpenCV)
set(opencv2_catkin_LIBRARY_DIRS ${OpenCV_LIB_DIR})
set(opencv2_catkin_LIBRARIES ${OpenCV_LIBS})
set(opencv2_catkin_INCLUDE_DIRS ${OpenCV_INCLUDE_DIRS})
message(STATUS "-- Using OpenCV library directory ${opencv2_catkin_LIBRARY_DIRS}")
message(STATUS "-- Found OpenCV include directory ${opencv2_catkin_INCLUDE_DIRS}")
message(STATUS "-- Found OpenCV libraries ${opencv2_catkin_LIBRARIES}")
```
**原理**：在 CMake 配置阶段自动调用 find_package(OpenCV)，然后将结果转换为 catkin 变量

**实现位置**：`cmake/opencv2-extras.cmake.in`

```plantuml
@startuml
start
:find_package(OpenCV);
if (OpenCV_FOUND?) then (yes)
    :设置 opencv2_catkin_INCLUDE_DIRS;
    :设置 opencv2_catkin_LIBRARIES;
    :设置 opencv2_catkin_LIBRARY_DIRS;
    :输出状态信息;
else (no)
    :警告: OpenCV 未找到;
endif
stop
@enduml
```

---

### 3.2 构建系统集成
**原理**：使用 catkin_simple 简化构建配置，自动处理依赖和安装

**实现位置**：`CMakeLists.txt`

**关键代码**：
```cmake
cmake_minimum_required(VERSION 3.0.2)
project(opencv2_catkin)

find_package(catkin_simple REQUIRED)

catkin_simple()

cs_install()
cs_export(CFG_EXTRAS opencv2-extras.cmake)
```

---

## 4. 🔌 对外接口

### 4.1 CMake 配置

#### 4.1.1 `find_package(opencv2_catkin REQUIRED)`
**用途**：查找并配置 OpenCV 依赖

**功能**：
- 自动 find_package(OpenCV)
- 提供 opencv2_catkin_INCLUDE_DIRS 变量
- 提供 opencv2_catkin_LIBRARIES 变量
- 提供 opencv2_catkin_LIBRARY_DIRS 变量

**输入输出接口定义**：
```
输入:
  - 无参数，自动检测系统 OpenCV

输出:
  - opencv2_catkin_INCLUDE_DIRS: OpenCV include 目录
  - opencv2_catkin_LIBRARIES: OpenCV 库列表
  - opencv2_catkin_LIBRARY_DIRS: OpenCV 库目录
```

---

### 4.2 导出的变量

#### 4.2.1 `opencv2_catkin_INCLUDE_DIRS`
**用途**：OpenCV 库的 include 目录
**值**：自动从 OpenCV_INCLUDE_DIRS 获取

#### 4.2.2 `opencv2_catkin_LIBRARIES`
**用途**：需要链接的 OpenCV 库列表
**值**：自动从 OpenCV_LIBS 获取

#### 4.2.3 `opencv2_catkin_LIBRARY_DIRS`
**用途**：OpenCV 库文件的目录
**值**：自动从 OpenCV_LIB_DIR 获取

---

## 5. 📦 依赖关系

### 5.1 内部依赖
- **catkin_simple** — 简化的 catkin 构建系统

### 5.2 外部依赖
- **libopencv-dev** — OpenCV 库的系统包
- **OpenCV** — 系统安装的 OpenCV 库（通过 find_package 自动查找）

---

## 6. 💡 使用示例

### 6.1 基本用法（在 ROS 包中）

#### 6.1.1 package.xml 配置
```xml
<?xml version="1.0"?>
<package>
  <name>my_opencv_package</name>
  <version>0.1.0</version>
  <buildtool_depend>catkin</buildtool_depend>
  <build_depend>catkin_simple</build_depend>
  <build_depend>opencv2_catkin</build_depend>

  <run_depend>catkin</run_depend>
  <run_depend>opencv2_catkin</run_depend>
</package>
```

#### 6.1.2 CMakeLists.txt 配置
```cmake
cmake_minimum_required(VERSION 3.0.2)
project(my_opencv_package)

find_package(catkin_simple REQUIRED)
find_package(opencv2_catkin REQUIRED)
catkin_simple()

# 创建库（自动链接 OpenCV）
cs_add_library(opencv_example src/opencv_example.cpp)

# 或者创建可执行文件
cs_add_executable(opencv_demo src/opencv_demo.cpp)
target_link_libraries(opencv_demo opencv_example)

cs_install()
cs_export()
```

#### 6.1.3 C++ 代码使用
```cpp
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

int main(int argc, char** argv) {
    // 读取图像
    cv::Mat image = cv::imread("image.jpg", CV_LOAD_IMAGE_COLOR);

    // 显示图像
    cv::namedWindow("Display window", CV_WINDOW_AUTOSIZE);
    cv::imshow("Display window", image);

    // 等待按键
    cv::waitKey(0);

    return 0;
}
```

---

## 7. 🔗 相关模块
- [catkin_simple](./catkin_simple.md) — 构建系统封装库

---

## 8. 📄 核心文件列表

| 文件 | 职责 |
|------|------|
| `CMakeLists.txt` | opencv2_catkin 自身的构建配置 |
| `package.xml` | 包元信息和依赖声明 |
| `cmake/opencv2-extras.cmake.in` | OpenCV 自动配置模板 |
