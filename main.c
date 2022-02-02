#include <stdio.h>
#include <stdint.h>

static uint8_t memory[30000]; /* static memory is zero-initialized */

int main(void)
{
    uint8_t* a = &memory[0];

#ifndef BRAINFUCK_PREPROCESSED_SOURCE_CODE_FILE
#   error BRAINFUCK_PREPROCESSED_SOURCE_CODE_FILE is not defined
#endif

#include BRAINFUCK_PREPROCESSED_SOURCE_CODE_FILE

    return 0;
}
