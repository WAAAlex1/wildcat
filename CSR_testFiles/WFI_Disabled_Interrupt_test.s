# WFI_Disabled_Interrupts_Test.s
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

    # DISABLE global interrupts
    li      x6, 0x0          # Clear MIE bit
    csrw    mstatus, x6

    # Still enable timer interrupt in mie (shouldn't matter)
    li      x7, 0x80         # MTIE bit (bit 7)
    csrw    mie, x7          # Set MTIE bit

    # Set mtimecmp to trigger soon
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime
    addi    x7, x7, 5        # Soon but not immediate
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word

    # Mark execution point before WFI
    li      x21, 1

    # Execute WFI - should continue immediately since interrupts disabled
    wfi

    # Mark execution point after WFI - should be reached immediately
    li      x21, 2

    # Small delay to allow potential interrupt
    li      x6, 100
delay_loop:
    addi    x6, x6, -1
    bnez    x6, delay_loop

    # If we reach here without going to handler, the test passed
    li      x10, 1
    beqz    x20, test_passed # x20 should still be 0
    li      x10, 0           # Failed if we went to handler

test_passed:
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