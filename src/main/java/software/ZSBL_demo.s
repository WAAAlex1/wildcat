#
# Zero-stage bootloader for the Wildcat processor demo program. Small program that runs as as the first thing after hardware bootloader finishes.
#
#  - CSR registers should be set as: | mtvec = (address of exception handler) |
#       - Top of allocated stack: 0x00FF_0000
#       - Addr of exception handler: 0x0030_0000
#       - Addr of Program: 0x0040_0000


lui     t0,0xf0010
li      t1,51
sb      t1,0(t0) # 0xfffffffff0010000
lui     sp,0xff0
lui     t0,0x300
csrw    mtvec,t0
li      t0,256
jr      t0 # 0x300000
nop
nop
nop
nop
lui     t0,0xf0010
li      t1,136
sb      t1,0(t0) # 0xfffffffff0010000