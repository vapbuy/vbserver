#include <iostream>
#include <vector>
#include <print>      // C++23 新特性
#include <expected>   // C++23 新特性
#include <jemalloc/jemalloc.h>

int main() {
    // 1. 使用 C++23 std::print (需要 Clang 17+ / GCC 13+)
    std::print("--- 环境验证报告 ---\n");

    // 2. 检查由 CMake 传入的宏
    std::print("构建工具: {}\n", BUILD_TOOL);
    std::print("编译器: {} {}\n", COMPILER_NAME, COMPILER_VERSION);
    std::print("C++ 标准版本: {}\n", __cplusplus);

    // 3. 验证 jemalloc
    const char* jemalloc_ver;
    size_t sz = sizeof(jemalloc_ver);
    if (mallctl("version", &jemalloc_ver, &sz, NULL, 0) == 0) {
        std::print("内存分配器: jemalloc {}\n", jemalloc_ver);
    }

    // 4. C++23 特性简单演示 (std::expected)
    auto check_even = [](int i) -> std::expected<int, std::string> {
        if (i % 2 == 0) return i;
        return std::unexpected("不是偶数");
    };

    auto result = check_even(10);
    if (result) std::print("C++23 Expected 正常工作: {}\n", *result);

    return 0;
}