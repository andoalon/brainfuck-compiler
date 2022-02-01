#include <stdio.h>
#include <stdint.h>

#define p /* + */ ++*a;
#define m /* - */ --*a;
#define i /* , */ *a = getchar();
#define o /* . */ putchar(*a);
#define r /* > */ ++a;
#define l /* < */ --a;
#define d /* [ */ while (*a != 0) {
#define w /* ] */ --*a; }

static uint8_t memory[16384]; /* static memory is zero-initialized */

int main(void)
{
    uint8_t* a = &memory[0];

#ifndef BRAINFUCK_PREPROCESSED_SOURCE_CODE_FILE
#   error BRAINFUCK_PREPROCESSED_SOURCE_CODE_FILE is not defined
#endif

#include BRAINFUCK_PREPROCESSED_SOURCE_CODE_FILE

    return 0;
}
