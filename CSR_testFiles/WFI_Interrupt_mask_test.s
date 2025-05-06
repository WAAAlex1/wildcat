# WFI_Interrupt_Masking_Test.s
.section .text
.global _start

_start:
    # Set up trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0           # Test result (will be set to 1 on success)
    li      x20, 0           # Interrupt handler counter
    li      x21, 0           # Test phase tracker

    # Enable interrupts globally
    li      x6, 0x8          # MIE bit (bit 3)
    csrw    mstatus, x6      # Set MIE bit

    # DISABLE timer interrupt specifically
    li      x7, 0x0          # Clear MTIE bit
    csrw    mie, x7

    # Set mtimecmp to trigger immediately
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, -5       # Make sure it's in the past
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    # Mark test phase 1 - WFI with masked interrupt
    li      x21, 1

    # Execute WFI with masked interrupt
    wfi

    # Should continue immediately since timer interrupt is masked
    li      x21, 2

    # Small delay to ensure WFI didn't actually wait
    li      x6, 20
delay_loop1:
    addi    x6, x6, -1
    bnez    x6, delay_loop1

    # Now ENABLE timer interrupt
    li      x7, 0x80         # MTIE bit (bit 7)
    csrw    mie, x7          # Set MTIE bit

    # Mark test phase 3 - WFI with unmasked interrupt
    li      x21, 3

    # Execute WFI again - should immediately trigger handler
    wfi

    # Should only get here after handler runs
    li      x21, 4

    # Check if handler executed exactly once
    li      x6, 1
    bne     x20, x6, fail    # Handler should run exactly once

    # If we got here, the test passed
    li      x10, 1
    j       test_complete

fail:
    li      x10, 0

test_complete:
    # Final marker to confirm test completed
    li      x29, 0xDEADBEEF

exit:
    j       exit

# Simple trap handler
.align 4
trap_handler:
    # Increment handler execution counter
    addi    x20, x20, 1

    # Update mtimecmp to prevent more interrupts
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, 1000     # Set far in future
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    mret