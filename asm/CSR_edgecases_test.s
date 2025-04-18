# CSR Edge Case Test
# This test verifies edge cases and corner behaviors of CSR instructions:
# 1. rs1=x0 for CSRRS/CSRRC (should read but not write)
# 2. zimm=0 for CSRRSI/CSRRCI (should read but not write)
# 3. rd=x0 for CSR operations (should not cause a CSR read)
# 4. Write to read-only CSRs (should be ignored)
# 5. Preserving read-only bits in writable CSRs

.section .text
.global _start

_start:
    # Initialize test registers
    li x1, 0x55AA55AA   # Test pattern
    li x2, 0x0          # Will hold results
    li x3, 0x0          # Will hold more results

    # Setup a known value in a CSR
    li x1, 0x12345678
    csrw mstatus, x1

    # Test Case 1: rs1=x0 for CSRRS (should read but not modify)
    csrrs x2, mstatus, x0
    # x2 should now have 0x12345678, but mstatus should be unchanged

    # Test Case 2: rs1=x0 for CSRRC (should read but not modify)
    csrrc x3, mstatus, x0
    # x3 should also have 0x12345678, still no change to mstatus

    # Verify mstatus was not changed by reading it again
    csrr x4, mstatus
    # x4 should still be 0x12345678

    # Test Case 3: zimm=0 for CSRRSI (should read but not modify)
    csrrsi x5, mstatus, 0
    # x5 should have 0x12345678, no change to mstatus

    # Test Case 4: zimm=0 for CSRRCI (should read but not modify)
    csrrci x6, mstatus, 0
    # x6 should have 0x12345678, no change to mstatus

    # Verify mstatus again
    csrr x7, mstatus
    # x7 should still be 0x12345678

    # Test Case 5: rd=x0 for CSRRW (should write but not read)
    # First set a known value again
    li x1, 0xABCDEF01
    csrw mstatus, x1

    # Now perform the test
    csrrw x0, mstatus, x1
    # No value should be written to x0, but mstatus should be updated

    # Verify mstatus was updated
    csrr x8, mstatus
    # x8 should be 0xABCDEF01

    # Test Case 6: rd=x0 for CSRRS/CSRRC (should update but not read)
    li x1, 0xFF
    csrrs x0, mstatus, x1
    # mstatus should have bits set, but x0 remains 0

    # Read to verify update
    csrr x9, mstatus
    # x9 should have 0xABCDEF01 | 0xFF

    # Test Case 7: Attempt to write to a read-only CSR
    li x1, 0x12345678
    csrrw x10, marchid, x1    # marchid is read-only
    # x10 should have the original marchid value (47)
    # and the write should be ignored

    # Verify marchid didn't change by reading again
    csrr x11, marchid
    # x11 should have the same marchid value as x10

    # Test Case 8: Preserve read-only bits in a partially writable CSR
    # misa has some read-only fields
    csrr x12, misa           # Read current misa
    li x1, 0xFFFFFFFF        # Try to set all bits
    csrrw x13, misa, x1      # This should respect the write mask

    # Read back misa
    csrr x14, misa
    # x14 should have only the writable bits changed, read-only bits preserved

    # Test Case 9: Writing to invalid/unimplemented CSR
    # This might cause an illegal instruction exception
    # If so, you'd need to handle it in your trap handler
    # Commenting out for now to prevent test interruption
    # csrrw x15, 0xDEF, x1    # Unimplemented CSR address

    # End of test
    ecall

    # Test results should be in registers x2-x14
    # Test is successful if:
    # x2 = x3 = x4 = x5 = x6 = x7 = 0x12345678 (unchanged mstatus across rs1=x0 and zimm=0 tests)
    # x8 = 0xABCDEF01 (updated mstatus from CSRRW)
    # x9 = 0xABCDEF01 | 0xFF (updated mstatus from CSRRS with rd=x0)
    # x10 = x11 = marchid value (typically 47) (read-only CSR unchanged)
    # x14 should match x12 in read-only bits, potentially different in writable bits