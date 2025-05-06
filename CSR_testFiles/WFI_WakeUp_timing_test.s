# WFI_Wakeup_Timing_Test.s
.section .text
.global _start

_start:
    # Set up trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0           # Test result (will be set to 1 on success)
    li      x20, 0           # Interrupt handler counter
    li      x21, 0           # Execution flow tracker
    li      x22, 0           # Timer start value
    li      x23, 0           # Timer end value

    # Enable interrupts
    li      x6, 0x8          # MIE bit (bit 3)
    csrw    mstatus, x6      # Set MIE bit
    li      x7, 0x80         # MTIE bit (bit 7)
    csrw    mie, x7          # Set MTIE bit

    # Set mtimecmp to trigger after a short delay
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, 20       # Set to trigger after a delay
    mv      x22, x7          # Save mtimecmp value for comparison
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    # Mark execution point before WFI
    li      x21, 1

    # Execute WFI - should wait until timer interrupt
    wfi

    # Mark execution point after WFI
    li      x21, 2

    # Read mtime to see how much time has passed
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x23, 0(x6)       # Read current mtime

    # If handler has run exactly once and time is at/past mtimecmp, test passed
    li      x7, 1
    bne     x20, x7, fail    # Handler should run exactly once

    # Check time difference (should be >= the mtimecmp value we set)
    bltu    x23, x22, fail   # End time should be >= trigger time

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