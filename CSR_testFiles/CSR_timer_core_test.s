# This test verifies the basic functionality of the RISC-V timer/counter CSRs:
#
# CYCLE/MCYCLE Test: Reads the cycle counter, waits a short time, then reads it again to ensure it increments.
# TIME/MTIME Test: Similar to the cycle test, but with a longer delay since time increments at a slower rate (100Hz vs. 100MHz).
# INSTRET/MINSTRET Test: Reads the instruction retirement counter, executes a few NOPs, then verifies that the counter incremented.
# MCYCLE Write Test: Verifies that the MCYCLE CSR is writable by writing a specific value and reading it back.
#
# Each test stores its result (1 for pass, 0 for fail) in a separate register, and the final result is the AND of all test results.

.section .text
.global _start

_start:
    # Set up registers for test
    li      x1, 0
    li      x2, 0
    li      x10, 0         # x10 will hold our success/failure code

    # -------------------------------------------------------------------------
    # Test 1: Verify that CYCLE/MCYCLE registers increment
    # -------------------------------------------------------------------------

    # Read initial counter values
    csrr    x11, mcycle    # Read mcycle (low 32 bits)
    csrr    x12, mcycleh   # Read mcycle (high 32 bits)

    # Delay loop to ensure counter changes
    li      x3, 1000
delay_loop1:
    addi    x3, x3, -1
    bnez    x3, delay_loop1

    # Read counter values again
    csrr    x13, mcycle    # Read mcycle (low 32 bits)
    csrr    x14, mcycleh   # Read mcycle (high 32 bits)

    # Verify that counter increased
    # Success if new value > old value, considering 64-bit comparison
    blt     x11, x13, cycle_check_high # If low word increased, we're good
    beq     x11, x13, check_high_word  # If low word is the same, check high word
    j       fail_cycle_test            # If low word decreased, we failed

check_high_word:
    blt     x12, x14, cycle_check_high # If high word increased, we're good
    j       fail_cycle_test            # Otherwise fail

cycle_check_high:
    # Store result in x20 (success=1, failure=0)
    li      x20, 1
    j       test2_start

fail_cycle_test:
    li      x20, 0

    # -------------------------------------------------------------------------
    # Test 2: Verify that TIME/MTIME registers increment (slower than cycle)
    # -------------------------------------------------------------------------
test2_start:
    # Read initial time values
    csrr    x11, time      # Read time (low 32 bits)
    csrr    x12, timeh     # Read time (high 32 bits)

    # Longer delay loop to ensure time register changes
    # This needs to be much longer due to clock division
    li      x3, 20000
delay_loop2:
    addi    x3, x3, -1
    bnez    x3, delay_loop2

    # Read time values again
    csrr    x13, time      # Read time (low 32 bits)
    csrr    x14, timeh     # Read time (high 32 bits)

    # Verify that time increased
    blt     x11, x13, time_check_high  # If low word increased, we're good
    beq     x11, x13, check_high_time  # If low word is the same, check high word
    j       fail_time_test             # If low word decreased, we failed

check_high_time:
    blt     x12, x14, time_check_high  # If high word increased, we're good
    j       fail_time_test             # Otherwise fail

time_check_high:
    # Store result in x21 (success=1, failure=0)
    li      x21, 1
    j       test3_start

fail_time_test:
    li      x21, 0

    # -------------------------------------------------------------------------
    # Test 3: Verify that INSTRET/MINSTRET registers increment with instructions
    # -------------------------------------------------------------------------
test3_start:
    # Read initial instret values
    csrr    x11, minstret    # Read minstret (low 32 bits)
    csrr    x12, minstreth   # Read minstret (high 32 bits)

    # Execute a fixed number of instructions to ensure counter changes
    nop
    nop
    nop
    nop
    nop

    # Read instret values again
    csrr    x13, minstret    # Read minstret (low 32 bits)
    csrr    x14, minstreth   # Read minstret (high 32 bits)

    # Verify that instret increased, at least by our 5 nops
    sub     x15, x13, x11    # Compute difference
    li      x16, 5           # We executed at least 5 instructions
    bge     x15, x16, instret_check_passed  # If difference >= 5, we're good
    j       fail_instret_test              # Otherwise fail

instret_check_passed:
    # Store result in x22 (success=1, failure=0)
    li      x22, 1
    j       test4_start

fail_instret_test:
    li      x22, 0

    # -------------------------------------------------------------------------
    # Test 4: Verify ability to write to MCYCLE
    # -------------------------------------------------------------------------
test4_start:
    # Save current mcycle for comparison
    csrr    x11, mcycle

    # Write a new value to mcycle
    li      x12, 0x12345678
    csrw    mcycle, x12

    # Read it back to verify
    csrr    x13, mcycle

    # Compare with expected value
    li      x14, 0x12345678
    beq     x13, x14, mcycle_write_passed
    j       fail_mcycle_write

mcycle_write_passed:
    # Restore original value
    csrw    mcycle, x11

    # Store result in x23 (success=1, failure=0)
    li      x23, 1
    j       all_tests_done

fail_mcycle_write:
    li      x23, 0

    # -------------------------------------------------------------------------
    # All tests done - calculate overall result
    # -------------------------------------------------------------------------
all_tests_done:
    # Check all test results - only pass if all tests passed
    and     x10, x20, x21       # x10 = x20 AND x21
    and     x10, x10, x22       # x10 = x10 AND x22
    and     x10, x10, x23       # x10 = x10 AND x23

    # Final result is in x10 (1=success, 0=failure)
    # Store final test results in key registers for verification
    mv      x30, x20       # CYCLE test result
    mv      x31, x21       # TIME test result
    mv      x29, x22       # INSTRET test result
    mv      x28, x23       # MCYCLE write test result
    mv      a0, x10        # Final result (a0 = x10)

exit:
    # Infinite loop to halt execution
    j       exit