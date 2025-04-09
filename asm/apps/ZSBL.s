#
# Zero-stage bootloader for the Wildcat processor. Small program that runs as as the first thing after hardware bootloader finishes.
#
# Does what the hardware bootloader cannot -> Setting CSR registers, Setting PC, Setting some integer registers
# All of these are needed for setting up uCLinux.
#  - PC Should point to uCLinux Program entry address (after ZSBL has completed running).
#       - uCLinux kernel expects to be placed at a 4MB Aligned address (eg. 0x0080_0000)
#  - CSR registers should be set as: | satp = 0 | mtvec = (address of exception handler) |
#  - General registers should be set as: | a0 = HARTID | a1 = addr of device tree | sp = top of allocated stack |
#       - Top of allocated stack:
#       - Addr of device tree:
#       - HARTID: 0


# Set up stack (address of stack top = ?)
li sp, ?

# Set hart ID (a0 = 0)
li a0, 0

# Set device tree address (address = ?)
li a1, ?

# Disable MMU (set satp = 0) (satp is csr addres 0x180)
csrrw x0, satp, x0

# Setup the trap vector (address = ?) (mtvec is csr address 0x305).
li t0, ?
csrrw x0, mtvec, x1

# Jump to kernel entry (address = 0x00800000)
li t0, 0x00800000
jr t0

