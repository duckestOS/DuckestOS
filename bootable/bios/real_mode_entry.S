// Copyright 2026 DuckestOS contributors
// SPDX-License-Identifier: Apache-2.0

.code16

.section .text.start
biosRealModeEntry:
    cli
    cld

    xorw  %ax, %ax
    movw  %ds, %ax
    movw  %es, %ax
