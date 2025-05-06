# WFI_Pending_Interrupt_Test.s - Fixed for early boot conditions
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

    # Enable interrupts
    li      x6, 0x8          # MIE bit (bit 3)
    csrw    mstatus, x6      # Set MIE bit
    li      x7, 0x80         # MTIE bit (bit 7)
    csrw    mie, x7          # Set MTIE bit

    # Read current mtime
    li      x6, 0xF010BFF8   # MTIME_ADDR_L
    lw      x7, 0(x6)        # Read current mtime

    # Set mtimecmp to current mtime + 1 to ensure it triggers very soon
    addi    x7, x7, 2        # Just one tick in the future
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first (0)
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)        # Write low word (current time + 1)

    # Small delay to ensure timer advances past mtimecmp
    li      x6, 20
delay_loop:
    addi    x6, x6, -1
    bnez    x6, delay_loop

    # Mark execution point before WFI
    li      x21, 1

    # Execute WFI - should continue immediately due to pending interrupt
    wfi

    # Mark execution point after WFI - should be reached after handler executes
    li      x21, 2

    # Success if handler ran once
    li      x6, 1
    bne     x20, x6, fail    # If handler ran exactly once, succeed

    # If we reach here with handler executed once, test passed
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
    # Save registers
    addi    sp, sp, -16
    sw      ra, 12(sp)
    sw      t0, 8(sp)
    sw      t1, 4(sp)
    sw      t2, 0(sp)

    # Increment handler execution counter
    addi    x20, x20, 1

    # Update mtimecmp to prevent more interrupts
    li      t0, 0xF010BFF8   # MTIME_ADDR_L
    lw      t1, 0(t0)        # Read current mtime
    addi    t1, t1, 1000     # Set far in future
    li      t0, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(t0)        # Write high word first
    li      t0, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      t1, 0(t0)        # Write low word

    # Restore registers
    lw      ra, 12(sp)
    lw      t0, 8(sp)
    lw      t1, 4(sp)
    lw      t2, 0(sp)
    addi    sp, sp, 16

    mret