#!/bin/bash
# Kalibr全量编译脚本
# 执行方式：./build_all.sh

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BUILD_DIR="${SCRIPT_DIR}/build"
INSTALL_DIR="${SCRIPT_DIR}/install"

echo "🏗️  启动Kalibr全量编译..."
echo "📂 构建目录: ${BUILD_DIR}"
echo "📦 安装目录: ${INSTALL_DIR}"

# 清理旧构建
echo "🧹 清理旧构建目录..."
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# CMake配置
echo "⚙️  CMake配置中..."
cmake "${SCRIPT_DIR}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
  -DBUILD_TESTING=OFF \
  -DCMAKE_CXX_FLAGS="-Wno-deprecated -Wno-unused-variable"

# 编译
echo "🔨 启动全量编译（使用$(nproc)个核心）..."
make -j$(nproc)

# 安装
echo "📦 安装中..."
make install

# 验证
echo "✅ 验证安装结果..."
echo ""
echo "📦 已生成可执行文件:"
ls -la "${BUILD_DIR}/bin/kalibr_"*
echo ""
echo "🐍 Python绑定验证:"
export PYTHONPATH="${INSTALL_DIR}/lib/python$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')/site-packages:${PYTHONPATH}"
python3 -c "import kalibr; print('✅ kalibr Python模块导入成功，版本:', kalibr.__version__ if hasattr(kalibr, '__version__') else 'unknown')"

echo ""
echo "🎉 全量编译成功！"
echo "👉 可执行文件位置: ${BUILD_DIR}/bin/"
echo "👉 安装位置: ${INSTALL_DIR}"
echo "👉 环境变量配置:"
echo "   export PATH=${INSTALL_DIR}/bin:\$PATH"
echo "   export LD_LIBRARY_PATH=${INSTALL_DIR}/lib:\$LD_LIBRARY_PATH"
echo "   export PYTHONPATH=${INSTALL_DIR}/lib/python$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')/site-packages:\$PYTHONPATH"
