cmake_minimum_required(VERSION 3.20)

project(brainfuck-compiler C)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

get_filename_component(src "${CMAKE_SOURCE_DIR}" REALPATH)
get_filename_component(bin "${CMAKE_BINARY_DIR}" REALPATH)

if ("${src}" STREQUAL "${bin}")
    message(FATAL_ERROR "Don't create a build in the same directory as the source. Use the -B argument to specify a build directory (first remove \"CMakeCache.txt\" and \"CMakeFiles\")")
endif()

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/main.bf.out"
    DEPENDS "${CMAKE_CURRENT_LIST_DIR}/main.bf"
    COMMAND "${CMAKE_COMMAND}"
        ARGS
            "-DBRAINFUCK_SOURCE_FILE=${CMAKE_CURRENT_LIST_DIR}/main.bf"
            "-DBRAINFUCK_PREPROCESSED_OUTPUT_PATH=${CMAKE_CURRENT_BINARY_DIR}/main.bf.out"
            "-P" "${CMAKE_CURRENT_LIST_DIR}/preprocess-brainfuck.cmake"
    COMMENT "Preprocessing brainfuck source code for use with the C preprocessor..."
    VERBATIM
)

add_executable(brainfuck-program
    main.c
    
    main.bf
    main.bf.out
)
target_compile_definitions(brainfuck-program
    PRIVATE
        "BRAINFUCK_PREPROCESSED_SOURCE_CODE_FILE=\"${CMAKE_CURRENT_BINARY_DIR}/main.bf.out\""
)

set_property(
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    PROPERTY VS_STARTUP_PROJECT brainfuck-program
)
