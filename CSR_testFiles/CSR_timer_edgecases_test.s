# Optimized and Enhanced Timer/Counter/Interrupt Edge Case Test v2
# Target Core Clock: 10kHz, mtime Clock: 100Hz (T_mtime = 100 cycles)
#
# Changes:
# - Uses a single volatile interrupt flag (x30) set by the handler.
# - Main code resets x30, performs action, waits, checks x30 *immediately*,
#   and stores the pass/fail result in dedicated registers (x21-x27).
# - All results (x21-x27) can be checked at the end of the test.
# - Handler modified to only increment x30 and re-arm timer far future.

.section .text
.global _start

_start:
    # --- Setup ---
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test status registers (x21-x27 for individual tests)
    li      x10, 0          # Final result (0=fail, 1=success)
    li      x21, 0          # Test 1 Result (Counters)
    li      x22, 0          # Test 2 Result (TIME RO)
    li      x23, 0          # Test 3 Result (mtimecmp=0)
    li      x24, 0          # Test 4 Result (Interrupt Trigger)
    li      x25, 0          # Test 5 Result (Interrupt Clear/Future)
    li      x26, 0          # Test 6 Result (mtimecmp=MAX)
    li      x27, 0          # Test 7 Result (mie disable/enable)

    li      x30, 0          # Volatile interrupt flag (set by handler)

    # -------------------------------------------------------------------------
    # Test 1: Basic counter increments & mcycle writability (Unchanged)
    # -------------------------------------------------------------------------
test1_start:
    csrr    x11, mcycle; csrr x12, minstret; csrr x13, time
    nop; nop; nop; nop; nop
    csrr    x14, mcycle; csrr x15, minstret; csrr x16, time
    bltu    x11, x14, test1_minstret_check
    j       fail_test1
test1_minstret_check:
    addi    x11, x12, 5
    bltu    x15, x11, fail_test1
test1_time_check:
    bltu    x13, x16, test1_mcycle_write
    beq     x13, x16, test1_mcycle_write
    j       fail_test1
test1_mcycle_write:
    csrr    x11, mcycle
    li      x12, 0x12345678
    csrw    mcycle, x12
    csrr    x13, mcycle
    beq     x12, x13, test1_mcycle_restore
    csrw    mcycle, x11 # Restore before fail
    j       fail_test1
test1_mcycle_restore:
    csrw    mcycle, x11
    li      x21, 1          # Test 1 Passed
    j       test2_start
fail_test1:
    li      x21, 0          # Test 1 Failed
    j       test2_start

    # -------------------------------------------------------------------------
    # Test 2: TIME CSR write protection (Unchanged)
    # -------------------------------------------------------------------------
test2_start:
    csrr    x11, time
    li      x12, 0xDEADBEEF
    csrw    time, x12
    csrr    x13, time
    beq     x13, x12, fail_test2 # Fail if write succeeded
    li      x22, 1          # Test 2 Passed
    j       test3_start
fail_test2:
    li      x22, 0          # Test 2 Failed
    j       test3_start

    # -------------------------------------------------------------------------
    # Test 3: Setting mtimecmp=0 should not trigger interrupts
    # -------------------------------------------------------------------------
test3_start:
    li      x30, 0         # Reset volatile interrupt flag

    # Enable interrupts
    li      x6, 0x8; csrs mstatus, x6
    li      x7, 0x80; csrs mie, x7

    # Write 0 to mtimecmp
    li      x6, 0xF0104004; sw x0, 0(x6)
    li      x6, 0xF0104000; sw x0, 0(x6)

    # Short delay loop (~400 cycles)
    li      x6, 100
test3_delay:
    addi    x6, x6, -1
    bnez    x6, test3_delay

    # Check flag immediately after delay
    beqz    x30, test3_passed # Pass if flag is STILL 0
    # Fail path
    li      x23, 0
    j       test4_start
test3_passed:
    li      x23, 1
    j       test4_start

    # -------------------------------------------------------------------------
    # Test 4: Basic timer interrupt trigger
    # -------------------------------------------------------------------------
test4_start:
    li      x30, 0         # Reset volatile interrupt flag

    # Read current mtime -> x8:x7
    li      x6, 0xF010BFF8; lw x7, 0(x6)
    li      x6, 0xF010BFFC; lw x8, 0(x6)

    # Set mtimecmp = mtime + 5 (interval = 500 cycles)
    addi    x7, x7, 5

    # Write mtimecmp
    li      x6, 0xF0104004; sw x8, 0(x6) # High word
    li      x6, 0xF0104000; sw x7, 0(x6) # Low word

    # Delay loop longer than interval (~1200 cycles now)
    li      x6, 300        # Using your increased delay
test4_delay:
    addi    x6, x6, -1
    bnez    x6, test4_delay

    # These are needed for proper timing
    nop
    nop
    nop

    # Check flag immediately after delay
    bnez    x30, test4_passed # Pass if flag is 1 (interrupt occurred)

    # --- Fail path for Test 4 ---
    # If bnez is not taken, it means x30 was 0 (no interrupt handled)
    li      x24, 0          # Set Test 4 result to Fail
    j       test5_start     # Jump to the next test

test4_passed:
    # --- Pass path for Test 4 ---
    li      x24, 1          # Set Test 4 result to Pass
    j       test5_start     # Jump to the next test

    # -------------------------------------------------------------------------
    # Test 5: Interrupt Clearing (future mtimecmp in handler prevents re-trigger)
    # -------------------------------------------------------------------------
test5_start:
    # The handler from Test 4 set mtimecmp far future.
    li      x30, 0         # Reset volatile interrupt flag

    # Short delay loop (~400 cycles)
    li      x6, 100
test5_delay:
    addi    x6, x6, -1
    bnez    x6, test5_delay

    # Check flag immediately after delay
    beqz    x30, test5_passed # Pass if flag is STILL 0
    # Fail path
    li      x25, 0
    j       test6_start
test5_passed:
    li      x25, 1
    j       test6_start

    # -------------------------------------------------------------------------
    # Test 6: mtimecmp = MAX (-1) should disable interrupt
    # -------------------------------------------------------------------------
test6_start:
    li      x30, 0         # Reset volatile interrupt flag

    # Write -1 (0xFFFFFFFF FFFFFFFF) to mtimecmp
    li      x7, -1
    li      x8, -1
    li      x6, 0xF0104004; sw x8, 0(x6)
    li      x6, 0xF0104000; sw x7, 0(x6)

    # Short delay loop (~400 cycles)
    li      x6, 100
test6_delay:
    addi    x6, x6, -1
    bnez    x6, test6_delay

    # Check flag immediately after delay
    beqz    x30, test6_passed # Pass if flag is STILL 0
    # Fail path
    li      x26, 0
    j       test7_start
test6_passed:
    li      x26, 1
    j       test7_start

    # -------------------------------------------------------------------------
    # Test 7: mie.MTIE Disable/Enable
    # -------------------------------------------------------------------------
test7_start:
    li      x30, 0         # Reset volatile interrupt flag

    # Set mtimecmp just ahead (5 ticks = 500 cycles)
    li      x6, 0xF010BFF8; lw x7, 0(x6)
    li      x6, 0xF010BFFC; lw x8, 0(x6)
    addi    x7, x7, 5
    li      x6, 0xF0104004; sw x8, 0(x6)
    li      x6, 0xF0104000; sw x7, 0(x6)

    # Wait ~400 cycles (condition likely met)
    li      x6, 100
test7_wait_pending:
    addi    x6, x6, -1
    bnez    x6, test7_wait_pending

    # Disable timer interrupt
    li      x7, 0x80       # MTIE bit mask
    csrc    mie, x7        # Clear MTIE bit

    # Wait again (~400 cycles)
    li      x6, 100
test7_delay_disabled:
    addi    x6, x6, -1
    bnez    x6, test7_delay_disabled

    # Check flag is still 0 (interrupt masked)
    bnez    x30, fail_test7 # Fail if interrupt occurred

    # Reset flag *before* enabling, wait, check again
    li      x30, 0

    # Re-enable timer interrupt
    li      x7, 0x80       # MTIE bit mask
    csrs    mie, x7        # Set MTIE bit

    # Wait again (~600 cycles, > interval to be sure)
    li      x6, 150
test7_delay_enabled:
    addi    x6, x6, -1
    bnez    x6, test7_delay_enabled

    # Check flag is now 1 (pending interrupt was taken)
    li      x11, 1
    beq     x30, x11, test7_passed # Pass if flag is 1
    # Fail path (fall through)

fail_test7:
    li      x27, 0
    j       all_tests_done
test7_passed:
    li      x27, 1
    # Fall through

    # -------------------------------------------------------------------------
    # Combine Results & Exit (Unchanged)
    # -------------------------------------------------------------------------
all_tests_done:
    li      x10, 1; beqz x21, fail_overall; beqz x22, fail_overall; beqz x23, fail_overall
    beqz    x24, fail_overall; beqz x25, fail_overall; beqz x26, fail_overall; beqz x27, fail_overall
    j       combine_done
fail_overall:
    li      x10, 0
combine_done:
    mv      x11, x21; mv x12, x22; mv x13, x23; mv x14, x24; mv x15, x25; mv x16, x26; mv x17, x27
    mv      a0, x10
exit:
    csrwi   mie, 0
    j       exit

# ---------------------------------------------------------------------------
# Trap handler - Minimal: Increments x30, re-arms timer far future
# ---------------------------------------------------------------------------
.align 4
trap_handler:
    # Save registers
    addi    sp, sp, -24
    sw      ra, 20(sp); sw t0, 16(sp); sw t1, 12(sp); sw t2, 8(sp); sw t3, 4(sp); sw t4, 0(sp)

    csrr    t0, mcause
    li      t1, 0x80000007  # Timer interrupt cause
    bne     t0, t1, trap_exit_new # Skip if not timer interrupt

handle_timer_interrupt_new:
    # Increment the volatile interrupt flag
    addi    x30, x30, 1

    # Re-arm timer FAR in the future
    li      t3, 0xF010BFF8; lw t1, 0(t3)  # Read mtime_l -> t1
    li      t3, 0xF010BFFC; lw t2, 0(t3)  # Read mtime_h -> t2
    li      t4, 20000       # Add large offset (20k ticks = 2M cycles = 200 sec)
    add     t0, t1, t4      # t0 = new_low
    sltu    t1, t0, t1      # t1 = carry (1 if new_low < old_low)
    add     t2, t2, t1      # t2 = new_high
    li      t3, 0xF0104004; sw t2, 0(t3)  # Write new mtimecmp_h
    li      t3, 0xF0104000; sw t0, 0(t3)  # Write new mtimecmp_l

trap_exit_new:
    # Restore registers
    lw      t4, 0(sp); lw t3, 4(sp); lw t2, 8(sp); lw t1, 12(sp); lw t0, 16(sp); lw ra, 20(sp)
    addi    sp, sp, 24

    mret