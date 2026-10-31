// Copyright 2026 DuckestOS contributors
// SPDX-License-Identifier: Apache-2.0

#include "bios_print.inc"

#ifndef IMAGE_FOOTER_SIGNATURE
#define IMAGE_FOOTER_SIGNATURE 0x4b435544
#endif

.code16

// This section must be placed at the beginning of the DuckestOS boot image.
.section .init.start, "ax", @progbits

// Entry point for BIOS-based boot methods, such as El Torito or MBR.
biosRealModeEntry:
    cli

    // Set up the stack before calling any routines.
    //
    // In real mode, memory is accessed using a segment:offset pair.
    // The physical address is calculated as (segment * 16) + offset.
    // Convert the stack address so it can be used in this format.
    movl $earlyBootstrapStack, %esp
    shrl $4, %esp
    movw %sp, %ss
    movw $(earlyBootstrapStackTop - earlyBootstrapStack), %sp

    // The BIOS is supposed to load the entire boot image into memory.
    // However, this doesn't always happen as expected.
    //
    // We place a small signature at the end of the image and check for it
    // here. If the signature is missing, we know something went wrong
    // during loading and should not continue with the bootstrap.
    movl $imageFooterSignature, %edi
    movl %edi, %eax
    shrl $4, %eax
    movw %ax, %ds
    andw $0xf, %di

    cmpl $IMAGE_FOOTER_SIGNATURE, (%di)
    je 1f

    biosFail "The boot image was not fully loaded into memory."
1:
    // Restore the data segments before continuing with the bootstrap.
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es

    // Use a 32-bit call to match the -m16 ABI.
    // The bootstrap entry point is not expected to return.
    calll realModeBootstrapMain

.Lhalt:
    hlt
    jmp .Lhalt

.section .init.stack, "aw", @nobits
.balign 16
earlyBootstrapStack:
    .space 2048
earlyBootstrapStackTop:

// This signature marks the end of the boot image and is used
// to check whether the BIOS loaded it completely.
.section .footer, "a", @progbits
.balign 4
imageFooterSignature:
    .long IMAGE_FOOTER_SIGNATURE