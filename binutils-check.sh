#!/bin/bash

# 检查 binutils 是否存在
if command -v ld >/dev/null 2>&1; then
    CURRENT_VERSION=$(ld --version | head -n1 | grep -oP '\d+\.\d+')
    echo "当前 binutils 版本为: $CURRENT_VERSION"
else
    CURRENT_VERSION="none"
    echo "未检测到 binutils，准备安装"
fi

# 如果不是 2.41，则编译安装
if [[ "$CURRENT_VERSION" != "2.41" ]]; then
    echo "正在安装 binutils 2.41..."

    # 安装依赖
    sudo apt update
    sudo apt install -y build-essential wget

    # 下载并解压源码
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.xz
    tar -xf binutils-2.41.tar.xz
    cd binutils-2.41 || exit

    # 创建构建目录
    mkdir build && cd build

    # 配置安装路径
    ../configure --prefix=/usr/local/binutils-2.41

    # 编译和安装
    make -j$(nproc)
    sudo make install

    # 设置临时环境变量（可加到 ~/.bashrc 永久生效）
    export PATH=/usr/local/binutils-2.41/bin:$PATH

    echo "binutils 2.41 安装完成"
    ld --version | head -n1
else
    echo "binutils 已是 2.41，无需安装"
fi
