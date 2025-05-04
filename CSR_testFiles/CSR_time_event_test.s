# This test verifies the time-event interrupt functionality:
#
# Setup: Initializes the trap vector, enables machine-mode interrupts, and sets mtimecmp to a value close to the current time to trigger an interrupt soon.
# Main Loop: Waits for a specific number of timer interrupts (2 in this case).
# Trap Handler: Handles the timer interrupt, increments a counter, and updates mtimecmp to trigger another interrupt.
# Verification: Success if the expected number of timer interrupts are received.
#
# The test directly accesses the memory-mapped CLINT registers (mtimecmp and mtime) as specified in your CSR.MemoryMap definition.

.section .text
.global _start

_start:
    # Set up the trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test status registers
    li      x10, 0         # Final result (0=fail, 1=success)
    li      x20, 0         # Counter for number of timer interrupts received
    li      x21, 0         # Expected number of timer interrupts
    li      x22, 2         # Number of interrupts to test for

    # Enable machine-mode interrupts globally
    li      x6, 0x8        # MIE bit (bit 3)
    csrw    mstatus, x6    # Set MIE bit

    # Set mtimecmp to a small value to trigger interrupt soon
    # First, read current mtime
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read low 32 bits of mtime
    li      x6, 0xF010BFFC   # MTIME_ADDR_H
    lw      x8, 0(x6)        # Read high 32 bits of mtime

    # Set mtimecmp to current time + small increment (to trigger soon)
    addi    x7, x7, 2        # Add just 2 to low word (at 10kHz/100Hz = ~20 cycles)

    # CORRECTED ORDER: First write high word, then low word
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x8, 0(x6)        # Write high 32 bits of mtimecmp FIRST
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low 32 bits of mtimecmp SECOND

    # Enable machine timer interrupt
    li      x7, 0x80         # MTIE bit (bit 7)
    csrw    mie, x7          # Set MTIE bit

    # Main loop waiting for interrupts
wait_for_interrupts:
    # Check if we've received the expected number of interrupts
    beq     x20, x22, test_passed

    # Much smaller busy wait at 10kHz
    li      x6, 500
busy_wait:
    addi    x6, x6, -1
    bnez    x6, busy_wait

    # Add a bound on iterations to avoid infinite loops during testing
    addi    x21, x21, 1      # Increment iteration counter
    li      x7, 100          # Max iterations before failing
    bge     x21, x7, test_failed

    # Loop back to check interrupt count again
    j       wait_for_interrupts

test_passed:
    li      x10, 1           # Success
    j       exit

test_failed:
    li      x10, 0           # Failure

exit:
    # Disable timer interrupts before exiting
    csrwi   mie, 0           # Clear all interrupt enable bits

    # Final result is in x10 (1=success, 0=failure)
    li      x29, 0xDEADBEEF  # Marker to show we reached the end
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
    # Increment our timer interrupt counter
    addi    x20, x20, 1

    # Update mtimecmp to current time + increment
    # Read current mtime
    li      t0, 0xF010BFF8   # MTIME_ADDR_L
    lw      t1, 0(t0)        # Read low 32 bits of mtime
    li      t0, 0xF010BFFC   # MTIME_ADDR_H
    lw      t2, 0(t0)        # Read high 32 bits of mtime

    # Set mtimecmp to mtime + small increment
    addi    t1, t1, 2        # Add just 2 to low word (at 10kHz/100Hz = ~20 cycles)

    # CORRECTED ORDER: First write high word, then low word
    li      t0, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      t2, 0(t0)        # Write high 32 bits of mtimecmp FIRST
    li      t0, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      t1, 0(t0)        # Write low 32 bits of mtimecmp SECOND

trap_exit:
    # Restore registers
    lw      ra, 0(sp)
    lw      t0, 4(sp)
    lw      t1, 8(sp)
    lw      t2, 12(sp)
    addi    sp, sp, 16

    mret    # Return from trap