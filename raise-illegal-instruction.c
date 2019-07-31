#include <stdio.h>

__declspec(dllexport) void __stdcall raise_illegal_instruction(void) {
    __asm__ ("ud2");
}
