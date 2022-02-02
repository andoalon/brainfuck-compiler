cmake_minimum_required(VERSION 3.20)

get_cmake_property(role CMAKE_ROLE)

if (NOT "${role}" STREQUAL "SCRIPT")
    message(FATAL_ERROR "This file is made to be run in script mode (cmake -P)")
endif()

if (NOT DEFINED BRAINFUCK_PREPROCESSED_OUTPUT_PATH)
    message(FATAL_ERROR "'BRAINFUCK_PREPROCESSED_OUTPUT_PATH' must be defined")
endif()

if (NOT DEFINED BRAINFUCK_SOURCE_FILE)
    message(FATAL_ERROR "'BRAINFUCK_SOURCE_FILE' must be defined")
endif()

if (NOT EXISTS "${BRAINFUCK_SOURCE_FILE}")
    message(FATAL_ERROR "'BRAINFUCK_SOURCE_FILE' (${BRAINFUCK_SOURCE_FILE}) must exist")
endif()

# We do it in hexadecimal because CMake's regex and CMake lists
# are broken for text containing '[' and ']'

file(READ "${BRAINFUCK_SOURCE_FILE}" bf_code HEX)

# Convert string to list of bytes
string(REGEX MATCHALL "[0-9a-f][0-9a-f]" bf_code_list "${bf_code}")

# Ascii values in hexadecimal
set(brainfuck_chars
  "0a" # '\n'
  "2b" # +
  "2c" # ,
  "2d" # -
  "2e" # .
  "3c" # <
  "3e" # >
  "5b" # [
  "5d" # ]
)

get_filename_component(source_file_absolute "${BRAINFUCK_SOURCE_FILE}" REALPATH)
set(bf_code "#line 1 \"${source_file_absolute}\"\n")

foreach(char IN LISTS bf_code_list)
    if (char IN_LIST brainfuck_chars)
        set(bf_code "${bf_code}${char}")
    endif()
endforeach()

string(REPLACE "0a" "\n"                 bf_code "${bf_code}") # '\n'
string(REPLACE "2b" "++*a; "             bf_code "${bf_code}") # +
string(REPLACE "2c" "*a = getchar(); "   bf_code "${bf_code}") # ,
string(REPLACE "2d" "--*a; "             bf_code "${bf_code}") # -
string(REPLACE "2e" "putchar(*a); "      bf_code "${bf_code}") # .
string(REPLACE "3c" "--a; "              bf_code "${bf_code}") # <
string(REPLACE "3e" "++a; "              bf_code "${bf_code}") # >
string(REPLACE "5b" "while (*a != 0) { " bf_code "${bf_code}") # [
string(REPLACE "5d" "} "                 bf_code "${bf_code}") # ]

file(WRITE "${BRAINFUCK_PREPROCESSED_OUTPUT_PATH}" "${bf_code}")
