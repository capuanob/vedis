add_executable(vedis-fuzz fuzz.c)

target_link_libraries(vedis-fuzz vedis)
target_compile_options(vedis-fuzz PUBLIC -fsanitize=fuzzer)
target_link_options(vedis-fuzz PUBLIC -fsanitize=fuzzer)
