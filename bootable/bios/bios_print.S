// Copyright 2026 DuckestOS contributors
// SPDX-License-Identifier: Apache-2.0

.code16

.section .init, "ax", @progbits

.global biosPrintStr
// Prints a string using the BIOS TTY service.
// %esi: pointer to the string
// %cx: number of characters to print
biosPrintStr:
    pushl %esi
    pushl %ebx

    movw $0x0007, %bx

.LprintChar:
    lodsb
    movb $0x0e, %ah
    int $0x10
    loop .LprintChar

    popl %ebx
    popl %esi
    retl