// Copyright 2026 DuckestOS contributors
// SPDX-License-Identifier: Apache-2.0

void realModeBootstrapMain(void) {
  for (;;) __asm__ volatile("hlt");
}