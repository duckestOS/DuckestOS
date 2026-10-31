// Copyright 2026 DuckestOS contributors
// SPDX-License-Identifier: Apache-2.0

// Prints a message using the BIOS TTY service.
.macro biosPrint message:vararg
    .pushsection .init.rodata, "a", @progbits
.LbiosPrintMessage_\@:
    .ascii \message
.LbiosPrintMessageEnd_\@:
    .popsection

    movl $.LbiosPrintMessage_\@, %esi
    movw $(.LbiosPrintMessageEnd_\@ - .LbiosPrintMessage_\@), %cx
    calll biosPrintStr
.endm

// Prints a failure message and halts the CPU.
.macro biosFail message:vararg
    xorw %ax, %ax
    movw %ax, %ds

    biosPrint "Bootstrap fail: "
    biosPrint \message

.LbiosFailHalt_\@:
    hlt
    jmp .LbiosFailHalt_\@
.endm