# 使用 Ubuntu 26.04 基础镜像
FROM ubuntu:26.04

# 避免交互式安装提示
ENV DEBIAN_FRONTEND=noninteractive

# 1. 安装 LLVM/Clang 19+ (Ubuntu 26.04 预计默认版本), Ninja 和 jemalloc
# 注：C++23 完整支持通常需要 Clang 17+
RUN apt-get update && apt-get install -y \
    clang \
    lldb \
    lld \
    ninja-build \
    cmake \
    git \
    pkg-config \
    libjemalloc-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. 配置环境变量
# 设置默认编译器为 Clang
ENV CC=clang
ENV CXX=clang++

# 强制 CMake 默认生成 Ninja 工程文件
ENV CMAKE_GENERATOR=Ninja

# 3. 启用 jemalloc
# 默认通过 LD_PRELOAD 注入，确保运行时性能
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so"
# 优化 jemalloc 配置：开启后台线程清理内存，减少延迟
ENV MALLOC_CONF="background_thread:true,metadata_thp:auto"

# 4. 设置开发工作目录
WORKDIR /workspace

# 验证环境：显示 Clang 版本并确认 Ninja 可用
CMD ["/bin/bash", "-c", "clang++ --version && ninja --version"]