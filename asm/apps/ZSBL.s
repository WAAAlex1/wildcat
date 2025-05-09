#
# Zero-stage bootloader for the Wildcat processor. Small program that runs as as the first thing after hardware bootloader finishes.
#
# Does what the hardware bootloader cannot -> Setting CSR registers, Setting PC, Setting some integer registers
# All of these are needed for setting up uCLinux.
#  - PC Should point to uCLinux Program entry address (after ZSBL has completed running).
#       - uCLinux kernel expects to be placed at a 4MB Aligned address (eg. 0x0040_0000)
#  - CSR registers should be set as: | satp = 0 | mtvec = (address of exception handler) |
#  - General registers should be set as: | a0 = HARTID | a1 = addr of device tree | sp = top of allocated stack |
#       - Top of allocated stack: 0x00FF_0000
#       - Addr of device tree: 0x0010_0000
#       - Addr of exception handler: 0x0030_0000
#       - Addr of kernel: 0x0040_0000
#       - HARTID: 0

_start_zsbl:
# Set up stack (address of stack top = 0x00FF_FFFF)
li sp, 0x00FF_0000

# Set hart ID (a0 = 0)
li a0, 0

# Set device tree address (address = 0x0010_0000)
li a1, 0x00100000

# Disable MMU (set satp = 0) (satp is csr addres 0x180)
csrrw x0, satp, x0

# Setup the trap vector (address = 0x0030_0000) (mtvec is csr address 0x305).
li t0, 0x0030_0000
csrrw t0, mtvec, x1

# Jump to kernel entry (address = 0x0040_0000)
li t0, 0x00400000
jr t0

