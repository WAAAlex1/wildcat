# CSR Test - Testing all CSR instructions
# This test verifies proper operation of all CSR instructions by:
# 1. Writing to various CSRs
# 2. Reading back the values
# 3. Verifying results in regular registers

_start:
    # Initialize test registers
    li x1, 0x55555555   # Pattern for testing set bits
    li x2, 0xAAAAAAAA   # Pattern for testing clear bits
    li x3, 0x0         # Will hold results
    li x4, 0x0         # Will hold more results
    li x5, 0x0         # Will hold even more results
    li x6, 0x0         # Expected value for validation
    li x7, 0x0         # Expected value for validation

    # Test 1: CSRRW - Write to mstatus and read previous value
    li x1, 0x1888       # Value to write (appropriate bits for mstatus)
    csrrw x3, mstatus, x1
    # Since mstatus has default 0, x3 should be 0

    # Test 2: CSRRS - Set bits in mstatus and read
    li x1, 0x8          # Set MPP to machine mode (bits 11-12)
    csrrs x4, mstatus, x1
    # x4 should now have 0x1888

    # Test 3: CSRRC - Clear bits and read
    li x2, 0x1000       # Clear bit 12 of MPP
    csrrc x5, mstatus, x2
    # x5 should have 0x1888 (previous value)

    # Test 4: CSRRWI - Write immediate value
    csrrwi x6, mstatus, 0x1F    # Write immediate 0x1F
    # x6 should have 0x888 (previous value with MPP partially cleared)

    # Test 5: CSRRSI - Set bits with immediate
    csrrsi x7, mstatus, 0x3     # Set lowest 2 bits
    # x7 should have 0x1F (previous value)

    # Test 6: CSRRCI - Clear bits with immediate
    csrrci x8, mstatus, 0x3     # Clear lowest 2 bits
    # x8 should have value in x7 with the 2 extra bits set

    # Test 7: Write to MEPC and read back
    li x1, 0xABCDEF00
    csrrw x0, mepc, x1         # Write without reading previous value
    csrr x9, mepc              # Read back what we wrote
    # x9 should be 0xABCDEF00

    # Test 8: Check read-only CSRs
    csrr x10, mvendorid        # Read vendor ID
    csrr x11, marchid          # Read architecture ID

    # Test result should be in registers x3-x11
    # Test is successful if:
    # x3 = 0 (original mstatus)
    # x4 = 0x1888 (original value after CSRRW)
    # x5 = 0x1888 (value after CSRRS)
    # x6 = 0x888 (value after CSRRC)
    # x7 = 0x1F (value after CSRRWI)
    # x8 = 0x1F with bits [1:0] set
    # x9 = 0xABCDEF00 (MEPC value)
    # x10 = VENDOR_ID (read-only)
    # x11 = MARCHID (read-only, should be 47)

    # End of test
    ecall