cmake_minimum_required(VERSION 3.14)
project(munasba LANGUAGES CXX)

set(BINARY_NAME "munasba")

cmake_policy(SET CMP0063 NEW)
set(CMAKE_INSTALL_RPATH "\$ORIGIN")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--enable-auto-import")

add_subdirectory("flutter")
add_subdirectory("runner")
