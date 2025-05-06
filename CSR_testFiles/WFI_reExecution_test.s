# WFI_Reexecution_Test.s
.section .text
.global _start

_start:
    # Set up trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0           # Test result (will be set to 1 on success)
    li      x20, 0           # Interrupt handler counter
    li      x21, 0           # WFI execution counter
    li      x22, 0           # Current test phase

    # Enable interrupts
    li      x6, 0x8          # MIE bit (bit 3)
    csrw    mstatus, x6      # Set MIE bit
    li      x7, 0x80         # MTIE bit (bit 7)
    csrw    mie, x7          # Set MTIE bit

    # Test Phase 1: First WFI execution
    li      x22, 1

    # Set mtimecmp to trigger after a short delay
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, 10       # Short delay
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    # Execute first WFI
    wfi
    addi    x21, x21, 1      # Increment WFI execution counter

    # Test Phase 2: Second WFI execution - new timer should be set in handler
    li      x22, 2

    # Execute second WFI
    wfi
    addi    x21, x21, 1      # Increment WFI execution counter

    # Test Phase 3: Check results
    li      x22, 3

    # Handler should have run exactly twice
    li      x6, 2
    bne     x20, x6, fail    # Handler should run twice

    # WFI should have completed twice
    li      x6, 2
    bne     x21, x6, fail    # WFI should complete twice

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

# Trap handler - sets up next interrupt
.align 4
trap_handler:
    # Increment handler execution counter
    addi    x20, x20, 1

    # Update mtimecmp based on which interrupt this is
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime

    beq     x20, x2, second_interrupt

    # First interrupt - set another timer for a short delay
    addi    x7, x7, 10       # Short delay for second interrupt
    j       set_timer

second_interrupt:
    # Second interrupt - set timer far in future
    addi    x7, x7, 1000     # Far future to prevent further interrupts

set_timer:
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    mret