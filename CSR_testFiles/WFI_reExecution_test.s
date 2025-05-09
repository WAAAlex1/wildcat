# WFI_Reexecution_Test_Modified.s
# This test verifies that WFI can be re-executed after an interrupt,
# with the handler setting up the next timer interrupt.
# Aiming for completion within ~600 main clock cycles.
# mtime increments at 100Hz, main clock is 10000Hz.
# 1 mtime tick = 100 main clock cycles.
# Target delay for each WFI: 2 mtime ticks = 200 main clock cycles.

.section .text
.global _start

_start:
    # Set up trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0           # Test result (0:fail, 1:pass)
    li      x20, 0           # Interrupt handler counter
    li      x21, 0           # WFI execution counter (counts resumes after WFI)
    li      x22, 0           # Current test phase tracker

    # Enable interrupts globally and machine timer interrupts specifically
    li      x6, 0x8          # MIE bit (bit 3) in mstatus
    csrw    mstatus, x6      # Set MIE bit to enable interrupts globally
    li      x7, 0x80         # MTIE bit (bit 7) in mie
    csrw    mie, x7          # Set MTIE bit to enable machine timer interrupts

    # Test Phase 1: First WFI execution
    li      x22, 1

    # Set mtimecmp to trigger after a short delay (2 mtime ticks)
    li      x6, 0xF010BFF8   # MTIME_ADDR_L (Low word of mtime register)
    lw      x7, 0(x6)        # Read current mtime (low word)
    addi    x7, x7, 2        # MODIFIED: Short delay (2 mtime ticks)
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H (High word for Hart 0)
    sw      x0, 0(x6)        # Write high word first (usually 0 for 32-bit mtimecmp)
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L (Low word for Hart 0)
    sw      x7, 0(x6)        # Write low word for mtimecmp

    # Execute first WFI - processor should wait for timer interrupt
    wfi
    addi    x21, x21, 1      # Increment WFI execution counter after resuming

    # Test Phase 2: Second WFI execution
    # The trap handler will have set up the next timer interrupt.
    li      x22, 2

    # Execute second WFI - processor should wait again
    wfi
    addi    x21, x21, 1      # Increment WFI execution counter after resuming

    # Test Phase 3: Check results
    li      x22, 3

    # Verification:
    # 1. Handler should have run exactly twice.
    li      x6, 2
    bne     x20, x6, fail    # If handler_counter (x20) is not 2, branch to fail

    # 2. WFI should have completed (resumed) exactly twice.
    li      x6, 2
    bne     x21, x6, fail    # If wfi_counter (x21) is not 2, branch to fail

    # If all checks passed
    li      x10, 1           # Set test result to 1 (success)
    j       test_complete    # Jump to test completion

fail:
    li      x10, 0           # Set test result to 0 (failure)
    # Fall through to test_complete

test_complete:
    # Final marker to confirm test completed its logic path
    li      x29, 0xDEADBEEF  # Arbitrary marker value

exit:
    # Infinite loop to halt execution
    j       exit

# Trap handler - responsible for setting up the next interrupt
.align 4 # Ensure handler is aligned to a 4-byte boundary
trap_handler:
    # Increment handler execution counter
    addi    x20, x20, 1

    # Read current mtime to set the next mtimecmp relative to now
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime

    # Check if this is the first or second interrupt
    # x20 will be 1 for the first interrupt, 2 for the second.
    li      x5, 2            # Load immediate 2 for comparison
    beq     x20, x5, setup_second_interrupt_disarm

# This is the first interrupt (x20 was 1): set another timer for a short delay
    addi    x7, x7, 2        # MODIFIED: Short delay (2 mtime ticks) for the second interrupt
    j       apply_mtimecmp_setting

setup_second_interrupt_disarm:
# This is the second interrupt (x20 is 2): set timer far in the future to disarm it
    addi    x7, x7, 1000     # Set far in the future to prevent further interrupts

apply_mtimecmp_setting:
    # Write the new mtimecmp value
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    # Return from machine trap
    mret
