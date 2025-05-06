# WFI_Masking_Delayed_Wakeup_Test.s
# This test verifies WFI behavior with:
# 1. A masked timer interrupt (WFI should not wait).
# 2. An unmasked timer interrupt set to trigger after a short delay (WFI should wait).
# Assumes mtime increments at 100Hz, main clock at 10000Hz.
# 1 mtime tick = 100 main clock cycles.

.section .text
.global _start

_start:
    # Set up trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0           # Test result (0:fail, 1:pass)
    li      x20, 0           # Interrupt handler counter
    li      x21, 0           # Test phase tracker

    # Enable interrupts globally (MIE bit in mstatus)
    li      x6, 0x8          # MIE = bit 3
    csrw    mstatus, x6

    # --- Phase 1: WFI with MASKED timer interrupt ---
    li      x21, 1           # Mark phase 1

    # Specifically DISABLE Machine Timer Interrupt (MTIE bit in mie)
    csrw    mie, x0          # Clear all bits in mie, including MTIE (bit 7)

    # Set mtimecmp to be in the PAST to ensure an interrupt *would* be pending if enabled.
    # This makes sure WFI doesn't wait due to a masked pending interrupt.
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, -10      # Set mtimecmp well in the past
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word (0)
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    # Execute WFI. Since MTIE is disabled, it should not wait for the timer.
    wfi

    # Check if execution continued and handler did NOT run
    li      x21, 2           # Mark execution continued past WFI
    bnez    x20, fail        # If handler_counter (x20) is not zero, masking failed.

    # --- Phase 2: WFI with UNMASKED timer interrupt and a DELAY ---
    li      x21, 3           # Mark phase 3

    # ENABLE Machine Timer Interrupt (MTIE bit in mie)
    li      x7, 0x80         # MTIE = bit 7
    csrw    mie, x7

    # Set mtimecmp to trigger after a SHORT DELAY from current mtime.
    # Delay = 4 mtime ticks = 4 * 100 = 400 main clock cycles.
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, 4        # Set mtimecmp 4 ticks into the future
    # No need to save this mtimecmp for comparison; success is handler running.
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word (0)
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    # Execute WFI. Should wait for mtime to reach mtimecmp, then trap.
    wfi

    # --- Phase 3: Verification after interrupt ---
    li      x21, 4           # Mark execution resumed after second WFI (and interrupt)

    # Check if handler executed exactly once for the second WFI
    li      x6, 1
    bne     x20, x6, fail    # If handler_counter (x20) is not 1, something is wrong.

    # If all checks passed
    li      x10, 1           # Set test result to 1 (success)
    j       test_complete

fail:
    # x10 is already 0 or will be set to 0 if not already.
    li      x10, 0           # Explicitly set test result to 0 (failure)

test_complete:
    # Final marker to confirm test completed its logic path
    li      x29, 0xCAFEBABE  # Arbitrary marker value

exit:
    # Infinite loop to halt execution
    j       exit

# Simple trap handler
.align 4
trap_handler:
    # Increment handler execution counter
    addi    x20, x20, 1

    # Disarm the timer by setting mtimecmp far into the future
    # to prevent immediate re-triggering.
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, 1000     # Add a large offset
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)

    # Return from machine trap
    mret
