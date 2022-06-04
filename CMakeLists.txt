cmake_minimum_required(VERSION 3.3)

set(CMAKE_C_STANDARD 99)

project(vedis C)

add_library(vedis STATIC)
target_compile_options(vedis PUBLIC -fsanitize=fuzzer-no-link)
target_link_options(vedis PUBLIC -fsanitize=fuzzer-no-link)

target_sources(vedis
	PUBLIC
	"${CMAKE_CURRENT_LIST_DIR}/vedis.c"
)
target_include_directories(vedis PUBLIC ${CMAKE_CURRENT_LIST_DIR})

add_subdirectory(fuzz)
