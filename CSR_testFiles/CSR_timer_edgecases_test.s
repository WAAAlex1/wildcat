# This test checks several edge cases and specific behaviors:
#
# Zero mtimecmp Test: Verifies that setting mtimecmp to 0 doesn't trigger interrupts, which is a common convention in RISC-V CLINT implementations.
# Counter Overflow Handling: Simulates a 64-bit counter overflow by setting mcycle and mcycleh to maximum values, then verifies that the overflow is handled correctly.
# TIME CSR Write Protection: Verifies that the TIME CSRs are read-only and cannot be modified by software.
# Interrupt Clearing: Tests that setting mtimecmp to a value greater than mtime clears any pending timer interrupt.
#
# Each test stores its result in a separate register, and the final result is the AND of all test results.

.section .text
.global _start

_start:
    # Set up the trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test status registers
    li      x10, 0         # Final result (0=fail, 1=success)

    # -------------------------------------------------------------------------
    # Test 1: Setting mtimecmp to 0 should not trigger interrupts
    # -------------------------------------------------------------------------
    # Enable machine-mode interrupts globally
    li      x6, 0x8        # MIE bit (bit 3)
    csrw    mstatus, x6    # Set MIE bit

    # Enable machine timer interrupt
    li      x7, 0x80       # MTIE bit (bit 7)
    csrw    mie, x7        # Set MTIE bit

    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write 0 to high 32 bits of mtimecmp FIRST
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x0, 0(x6)        # Write 0 to low 32 bits of mtimecmp SECOND

    # Counter for zero mtimecmp test (should remain 0)
    li      x20, 0

    # Delay to see if interrupt occurs
    li      x6, 30000
delay_loop1:
    addi    x6, x6, -1
    bnez    x6, delay_loop1

    # If x20 is still 0, test passed
    beqz    x20, test1_passed
    j       test1_failed

test1_passed:
    li      x21, 1      # Store test 1 result (pass)
    j       test2_start

test1_failed:
    li      x21, 0      # Store test 1 result (fail)

    # -------------------------------------------------------------------------
    # Test 2: 64-bit counter overflow handling (simulated)
    # -------------------------------------------------------------------------
test2_start:
    # Disable interrupts for this test
    csrwi   mie, 0

    # Try to write large values to MCYCLE to simulate near-overflow
    # Write 0xFFFFFFFF to mcycle
    li      x7, 0xFFFFFFFF
    csrw    mcycle, x7

    # Write 0xFFFFFFFF to mcycleh
    csrw    mcycleh, x7

    # Read back the values immediately
    csrr    x11, mcycle
    csrr    x12, mcycleh

    # Execute a few instructions which should cause mcycle to wrap
    nop
    nop
    nop
    nop
    nop

    # Read the values again
    csrr    x13, mcycle
    csrr    x14, mcycleh

    # Check if the counter wrapped properly (low part should now be small)
    li      x7, 10
    bgeu    x13, x7, test2_failed  # If low part is larger than expected, fail

    # Check if high part incremented on overflow
    beq     x12, x14, test2_failed # If high part didn't change, fail

    # Test passed
    li      x22, 1
    j       test3_start

test2_failed:
    li      x22, 0

    # -------------------------------------------------------------------------
    # Test 3: Writing to TIME CSRs should have no effect (they're read-only)
    # -------------------------------------------------------------------------
test3_start:
    # Read current TIME value
    csrr    x11, time

    # Try to write to TIME
    li      x12, 0xDEADBEEF
    csrw    time, x12

    # Read TIME again and verify it wasn't changed by our write
    csrr    x13, time

    # If the values are the same (ignoring normal increment), the test passes
    # We can't do an exact comparison because TIME is always incrementing
    # Instead, we verify that our written value didn't take effect
    li      x14, 0xDEADBEEF
    beq     x13, x14, test3_failed

    # Test passed
    li      x23, 1
    j       test4_start

test3_failed:
    li      x23, 0

    # -------------------------------------------------------------------------
    # Test 4: Setting mtimecmp > mtime should clear any pending interrupt
    # -------------------------------------------------------------------------
test4_start:
    # Enable interrupts again
    li      x6, 0x8        # MIE bit (bit 3)
    csrw    mstatus, x6    # Set MIE bit
    li      x7, 0x80       # MTIE bit (bit 7)
    csrw    mie, x7        # Set MTIE bit

    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x8, 0(x6)        # Write high 32 bits of mtimecmp FIRST
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low 32 bits of mtimecmp SECOND

    addi    x7, x7, -1       # Subtract 1 from low word to guarantee it's in the past
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low 32 bits of mtimecmp
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x8, 0(x6)        # Write high 32 bits of mtimecmp

    # Interrupt counter, should become 1 when trap handler runs
    li      x25, 0

    # Small delay to let interrupt occur
    li      x6, 1000
delay_loop4a:
    addi    x6, x6, -1
    bnez    x6, delay_loop4a

    # Now check if we got an interrupt
    # x25 should be 1 if interrupt occurred
    li      x6, 1
    bne     x25, x6, test4_failed

    # Now set mtimecmp to a future value to clear the interrupt
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read low 32 bits of mtime
    li      x6, 0xF010BFFC   # MTIME_ADDR_H
    lw      x8, 0(x6)        # Read high 32 bits of mtime

    addi    x7, x7, 1000     # Add 1000 to low word (10 seconds at 100Hz)
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x8, 0(x6)        # Write high 32 bits of mtimecmp FIRST
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low 32 bits of mtimecmp SECOND

    # Reset counter and wait again
    li      x25, 0

    # Another delay - we should NOT get an interrupt this time
    li      x6, 1000
delay_loop4b:
    addi    x6, x6, -1
    bnez    x6, delay_loop4b

    # If x25 is still 0, no interrupt occurred, which is what we want
    beqz    x25, test4_passed
    j       test4_failed

test4_passed:
    li      x24, 1
    j       all_tests_done

test4_failed:
    li      x24, 0

    # -------------------------------------------------------------------------
    # All tests done - calculate overall result
    # -------------------------------------------------------------------------
all_tests_done:
    # Check all test results - only pass if all tests passed
    and     x10, x21, x22       # x10 = x21 AND x22
    and     x10, x10, x23       # x10 = x10 AND x23
    and     x10, x10, x24       # x10 = x10 AND x24

    # Final result is in x10 (1=success, 0=failure)
    # Also store individual test results in specific registers for verification
    # Store final test results in key registers for verification
    mv      x30, x21       # Zero mtimecmp test result
    mv      x31, x22       # Counter overflow test result
    mv      x29, x23       # TIME write protection test result
    mv      x28, x24       # mtimecmp > mtime clears interrupt test result
    mv      a0, x10        # Final result (a0 = x10)

exit:
    # Disable interrupts before exiting
    csrwi   mie, 0

    # Infinite loop to halt execution
    j       exit

# ---------------------------------------------------------------------------
# Trap handler
# ---------------------------------------------------------------------------
.align 4  # Make sure trap handler is aligned to 4 bytes
trap_handler:
    # Save important registers
    addi    sp, sp, -16
    sw      ra, 0(sp)
    sw      t0, 4(sp)
    sw      t1, 8(sp)
    sw      t2, 12(sp)

    # Read mcause to determine what happened
    csrr    t0, mcause

    # Check if this is a timer interrupt (bit 31 set and code=7)
    li      t1, 0x80000007   # Machine timer interrupt
    beq     t0, t1, handle_timer_interrupt

    # Handle other exceptions/interrupts (just ignore for this test)
    j       trap_exit

handle_timer_interrupt:
    # For test 1
    addi    x20, x20, 1

    # For test 4
    addi    x25, x25, 1

trap_exit:
    # Restore registers
    lw      ra, 0(sp)
    lw      t0, 4(sp)
    lw      t1, 8(sp)
    lw      t2, 12(sp)
    addi    sp, sp, 16

    mret    # Return from trap