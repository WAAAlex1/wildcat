#!/bin/bash

# Create bin directory if it doesn't exist
mkdir -p bin

# Compile CSR full test
# -Ttext=0 sets the starting address to 0 without needing a linker script
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -Ttext=0 -o temp.elf asm/CSR_full_test.s
riscv64-unknown-elf-objcopy -O binary temp.elf bin/CSR_full_test.bin

# Compile Exception test
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -Ttext=0 -o temp.elf asm/Exception_test.s
riscv64-unknown-elf-objcopy -O binary temp.elf bin/Exception_test.bin

# Compile CSR edge cases test
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -Ttext=0 -o temp.elf asm/CSR_edgecases_test.s
riscv64-unknown-elf-objcopy -O binary temp.elf bin/CSR_edgecases_test.bin

# Clean up temporary files
rm -f temp.elf

echo "Compilation complete. Binary files are in the bin directory."