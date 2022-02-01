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

# We do it in hexadecimal because CMake's regex is broken for
# text containing '[' and ']', as well as lists

file(READ "${BRAINFUCK_SOURCE_FILE}" bf_code HEX)

# Convert string to list of bytes
string(REGEX MATCHALL "[0-9a-f][0-9a-f]" bf_code_list "${bf_code}")

# Ascii values in hexadecimal
set(brainfuck_chars
  "2b" # +
  "2c" # ,
  "2d" # -
  "2e" # .
  "3c" # <
  "3e" # >
  "5b" # [
  "5d" # ]
)

set(bf_code)
set(i 0)

foreach(char IN LISTS bf_code_list)
    if (char IN_LIST brainfuck_chars)
        set(bf_code "${bf_code}${char}")
        
        # For nicer formatting
        math(EXPR i "${i} + 1")
        if ("${i}" GREATER_EQUAL "5")   
            set(i 0)
            set(bf_code "${bf_code}\n")
        endif()
    endif()
endforeach()

string(REPLACE "2b" "p " bf_code "${bf_code}") # +
string(REPLACE "2c" "i " bf_code "${bf_code}") # ,
string(REPLACE "2d" "m " bf_code "${bf_code}") # -
string(REPLACE "2e" "o " bf_code "${bf_code}") # .
string(REPLACE "3c" "l " bf_code "${bf_code}") # <
string(REPLACE "3e" "r " bf_code "${bf_code}") # >
string(REPLACE "5b" "d " bf_code "${bf_code}") # [
string(REPLACE "5d" "w " bf_code "${bf_code}") # ]

file(WRITE "${BRAINFUCK_PREPROCESSED_OUTPUT_PATH}" "${bf_code}")
