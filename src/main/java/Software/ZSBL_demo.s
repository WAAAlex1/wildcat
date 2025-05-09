#
# Zero-stage bootloader for the Wildcat processor demo program. Small program that runs as as the first thing after hardware bootloader finishes.
#
#  - CSR registers should be set as: | mtvec = (address of exception handler) |
#       - Top of allocated stack: 0x00FF_0000
#       - Addr of exception handler: 0x0030_0000
#       - Addr of Program: 0x0040_0000


# Set up stack (address of stack top = 0x00FF_0000 = 16MB - 64KB)
li sp, 0x00FF0000

# Setup the trap vector (address = 0x0030_0000) (mtvec is csr address 0x305).
li t0, 0x00300000
csrw mtvec, t0

# Jump to program entry (address = 0x0040_0000)
li t0, 0x00000100
jr t0

