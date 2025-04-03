#
# Zero-stage bootloader for the Wildcat processor. Small program that runs as as the first thing after hardware bootloader finishes.
#
# Does what the hardware bootloader cannot -> Setting CSR registers, Setting PC, Setting some general registers
# All of these are needed for setting up uCLinux.
#  - PC Should point to uCLinux Program entry address (after ZSBL has completed running).
#       - uCLinux kernel expects to be placed at a 4MB Aligned address (eg. 0x0080_0000)
#  - CSR registers should be set as: | satp = 0 |
#  - General registers should be set as: | a0 = HARTID | a1 = addr of device tree | sp = top of allocated stack |
#       - Top of allocated stack:
#       - Addr of device tree:
#       - HARTID:




