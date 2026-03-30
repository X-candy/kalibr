#!/bin/bash
# Kalibr无ROS版本依赖安装脚本
# 执行方式：sudo ./install_dependencies.sh

set -e

echo "🏗️  安装Kalibr依赖..."

# 更新包列表
apt update

# 基础编译工具
apt install -y build-essential cmake git wget curl

# 核心依赖库
apt install -y \
    libboost-all-dev \
    libeigen3-dev \
    libopencv-dev \
    libyaml-cpp-dev \
    libspdlog-dev \
    libsuitesparse-dev \
    libgtest-dev \
    libtbb-dev

# Python依赖
apt install -y \
    python3-dev \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-yaml \
    python3-setuptools \
    python3-pip

# 编译安装GTest（Ubuntu源的GTest需要编译）
cd /usr/src/gtest
cmake .
make -j$(nproc)
cp lib/*.a /usr/lib

echo "✅ 所有依赖安装完成！"
echo ""
echo "📦 已安装版本："
echo "  - Eigen3: $(pkg-config --modversion eigen3)"
echo "  - OpenCV: $(pkg-config --modversion opencv4)"
echo "  - Boost: $(dpkg -s libboost-dev | grep 'Version' | awk '{print $2}')"
echo "  - Python3: $(python3 --version | awk '{print $2}')"
