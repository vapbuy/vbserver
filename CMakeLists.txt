cmake_minimum_required(VERSION 3.31)

# 1. 项目基础信息
project(vbServer
        VERSION 1.0
        LANGUAGES CXX)

# 2. 强制要求 C++23 标准
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF) # 建议关闭扩展以保持标准兼容性

# 3. 编译器检测与性能优化
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    message(STATUS "使用 Clang 编译器: ${CMAKE_CXX_COMPILER_VERSION}")
    # 开启常见警告并作为错误处理（推荐开发习惯）
    add_compile_options(-Wall -Wextra -Wpedantic -Werror)
    # 强制使用 LLD 链接器以匹配 Clang
    add_link_options("-fuse-ld=lld")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message(STATUS "使用 GCC 编译器: ${CMAKE_CXX_COMPILER_VERSION}")
    add_compile_options(-Wall -Wextra)
endif()

# 4. 查找并配置 jemalloc
find_package(PkgConfig REQUIRED)
pkg_check_modules(JEMALLOC REQUIRED jemalloc)

# 5. 定义源代码宏 (用于在 main.cpp 中检查构建环境)
add_definitions(-DCOMPILER_NAME="${CMAKE_CXX_COMPILER_ID}")
add_definitions(-DCOMPILER_VERSION="${CMAKE_CXX_COMPILER_VERSION}")
add_definitions(-DBUILD_TOOL="${CMAKE_GENERATOR}")


# 6. 可执行文件配置
add_executable(${PROJECT_NAME} main.cpp)

# 7. 链接头文件和库
target_include_directories(${PROJECT_NAME} PRIVATE ${JEMALLOC_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${JEMALLOC_LIBRARIES})

# 8. Ninja 特化配置 (可选)
if(CMAKE_GENERATOR STREQUAL "Ninja")
    message(STATUS "当前使用 Ninja 构建系统，编译速度起飞 🚀")
endif()

