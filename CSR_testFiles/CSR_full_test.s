    .section .text
    .globl _start

_start:
    # Initialize test patterns
    li x1, 0x55555555         # Test pattern 1 (not directly used here)
    li x2, 0xAAAAAAAA         # Test pattern 2 (not directly used here)
    li x3, 0x0                # Will hold result of CSRRW
    li x4, 0x0                # Will hold result of CSRRS
    li x5, 0x0                # Will hold result of CSRRC
    li x6, 0x0                # Will hold result of CSRRWI
    li x7, 0x0                # Will hold result of CSRRSI
    li x8, 0x0                # Will hold result of CSRRCI

    # Test 1: CSRRW — write x1 to MCAUSE, read previous value into x3
    li x1, 0x1880             # New MCAUSE value (MPP bits set)
    csrrw x3, mcause, x1     # x3 ← old MCAUSE, MCAUSE ← x1

    # Test 2: CSRRS — set bits in MCAUSE (OR with x1), result in x4
    li x1, 0x8                # Only bit 3 (no change to MPP)
    csrrs x4, mcause, x1     # x4 ← old MCAUSE, MCAUSE |= 0x8

    # Test 3: CSRRC — clear bit 12 of MCAUSE, result in x5
    li x2, 0x1000             # Clear MPP high bit (bit 12)
    csrrc x5, mcause, x2     # x5 = MCAUSE before, MCAUSE &= ~0x1000

    # Test 4: CSRRWI — write immediate (0x1C) to MCAUSE, x6 gets old value
    csrrwi x6, mcause, 0x1C  # MCAUSE ← 0x1C, x6 = old MCAUSE

    # Test 5: CSRRSI — set bits 0 and 1 (0x3), x7 gets old value
    csrrsi x7, mcause, 0x3   # MCAUSE |= 0x3, x7 = old MCAUSE (0x1C)

    # Test 6: CSRRCI — clear bits 3 and 4, x8 gets old value
    csrrci x8, mcause, 0xC  # MCAUSE &= ~0xC, x8 = old MCAUSE
    csrrw x9, mcause, x0     # x9 ← MCAUSE, MCAUSE not changed

    # Test 7: Write to mepc and read back
    li x1, 0xABCDEF00
    csrrw x0, mepc, x1        # mepc ← 0xABCDEF00 (no dest reg)
    csrrs x10, mepc, x0       # 10 = mepc
    # Test 8: Read read-only CSRs
    csrrs x11, mvendorid, x0  # x11 = mvendorid (platform-specific)
    csrrs x12, marchid, x0    # x12 = marchid (should be 0x2F or 47 decimal)

# End of test — infinite loop for inspection
end:
    j end
