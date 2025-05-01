.section .text
.global _start

_start:
    # Initialize test registers
    li x1, 0x55AA55AA       # Test pattern
    li x2, 0x0              # Will hold results
    li x3, 0x0              # Will hold more results

    # Setup a known value in a CSR
    li x1, 0x12345678
    csrrw x0, mcause, x1    # Write mcause with x1, discard old value

    # Test Case 1: rs1=x0 for CSRRS (should read but not modify)
    csrrs x2, mcause, x0    # x2 ← mcause (should be 0x12345678)

    # Test Case 2: rs1=x0 for CSRRC (should read but not modify)
    csrrc x3, mcause, x0    # x3 ← mcause (should still be 0x12345678)

    # Test Case 3: zimm=0 for CSRRSI (should read but not modify)
    csrrsi x4, mcause, 0    # x4 ← mcause (should be 0x12345678)

    # Test Case 4: zimm=0 for CSRRCI (should read but not modify)
    csrrci x5, mcause, 0    # x5 ← mcause (should be 0x12345678)

    # Verify mcause again
    csrr x6, mcause         # x6 ← mcause (should be 0x12345678)

    # Test Case 5: rd=x0 for CSRRW (should write but not read)
    li x1, 0xABCDEF01
    csrrw x0, mcause, x1    # mcause ← 0xABCDEF01

    # Verify mcause was updated
    csrr x8, mcause         # x8 ← mcause (should be 0xABCDEF01)

    # Test Case 6: rd=x0 for CSRRS/CSRRC (should update but not read)
    li x1, 0xFF
    csrrs x0, mcause, x1    # mcause |= 0xFF (rd=x0, result discarded)

    # Read to verify update
    csrr x9, mcause         # x9 ← mcause (should be 0xABCDEF01 | 0xFF)

    # Test Case 7: Attempt to write to a read-only CSR
    li x1, 0x12345678
    csrrw x10, marchid, x1  # marchid is read-only → write ignored, x10 ← marchid

    # Verify marchid didn’t change
    csrr x11, marchid       # x11 ← marchid (should equal x10)

    # Test Case 8: Preserve read-only bits in a partially writable CSR
    li x1, 0xFFFFFFFF
    csrrw x13, misa, x1     # misa ← 0xFFFFFFFF, but write mask will apply
    csrr x14, misa          # x14 ← misa (check write mask preserved read-only bits)

# Infinite loop to halt after test
end:
    j end
