#include <stdio.h>

__declspec(dllimport) void __stdcall raise_illegal_instruction(void);

int main(int argc, char *argv[]) {
	raise_illegal_instruction();
	return 0;
}
