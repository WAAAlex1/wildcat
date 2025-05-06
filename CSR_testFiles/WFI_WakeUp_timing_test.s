# WFI_Wakeup_Timing_Test_Modified.s
# Test designed to complete within approximately 600 main clock cycles.
# mtime increments at 100Hz, main clock is 10000Hz.
# 1 mtime tick = 100 main clock cycles.
# Target delay: 5 mtime ticks = 500 main clock cycles for WFI.

.section .text
.global _start

_start:
    # Set up trap vector
    # Loads the address of trap_handler into x5 and sets it as the machine trap vector.
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0           # Test result (will be set to 1 on success, 0 on fail)
    li      x20, 0           # Interrupt handler counter
    li      x21, 0           # Execution flow tracker (for debugging)
    li      x22, 0           # Timer start value (mtimecmp value set)
    li      x23, 0           # Timer end value (mtime value after WFI)

    # Enable interrupts
    # MIE (Machine Interrupt Enable) is bit 3 of mstatus.
    li      x6, 0x8          # Value to set MIE bit in mstatus
    csrw    mstatus, x6      # Set MIE bit in mstatus to enable interrupts globally
    # MTIE (Machine Timer Interrupt Enable) is bit 7 of mie.
    li      x7, 0x80         # Value to set MTIE bit in mie
    csrw    mie, x7          # Set MTIE bit in mie to enable machine timer interrupts

    # Set mtimecmp to trigger after a short delay
    # MTIME_ADDR_L and MTIMECMP addresses are assumed as per the problem context.
    li      x6, 0xF010BFF8   # MTIME_ADDR_L (Low word of mtime register)
    lw      x7, 0(x6)        # Read current mtime (low word)

    # MODIFICATION: Changed delay from 20 to 5 mtime ticks.
    # 5 mtime ticks * 100 main_clock_cycles/mtime_tick = 500 main_clock_cycles delay.
    addi    x7, x7, 5        # Set to trigger after 5 mtime ticks
    mv      x22, x7          # Save mtimecmp value for later comparison

    # Write to mtimecmp (Hart 0). Write high word first for safety, though 0 here.
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H (High word of mtimecmp for Hart 0)
    sw      x0, 0(x6)        # Write 0 to high word of mtimecmp
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L (Low word of mtimecmp for Hart 0)
    sw      x7, 0(x6)        # Write the calculated trigger time to low word of mtimecmp

    # Mark execution point before WFI
    li      x21, 1

    # Execute WFI - should wait until timer interrupt
    wfi

    # Mark execution point after WFI (resumed after interrupt)
    li      x21, 2

    # Read mtime to see how much time has passed
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x23, 0(x6)       # Read current mtime (low word)

    # Check conditions for test success:
    # 1. Interrupt handler should have run exactly once.
    li      x7, 1
    bne     x20, x7, fail    # If x20 (handler counter) is not 1, branch to fail

    # 2. Current mtime (x23) should be greater than or equal to the mtimecmp value we set (x22).
    #    This confirms the timer did trigger at or after the set point.
    bltu    x23, x22, fail   # If x23 < x22, branch to fail (unsigned comparison)

    # If we got here, the test passed
    li      x10, 1           # Set test result to 1 (success)
    j       test_complete    # Jump to test completion

fail:
    li      x10, 0           # Set test result to 0 (failure)
    # Fall through to test_complete

test_complete:
    # Final marker to confirm test completed its logic path
    li      x29, 0xDEADBEEF  # Arbitrary marker value

exit:
    # Infinite loop to halt execution after test completion
    j       exit

# Simple trap handler
.align 4 # Ensure handler is aligned to a 4-byte boundary
trap_handler:
    # Increment handler execution counter
    addi    x20, x20, 1

    # Update mtimecmp to prevent more interrupts from the same setting.
    # Set it far into the future.
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, 1000     # Add a large offset to push next interrupt far away
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    # Return from machine trap
    mret
