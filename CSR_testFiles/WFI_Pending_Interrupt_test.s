# WFI_Pending_Interrupt_Test.s - Revised to handle initial mtime=0 case
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

    # Set mtimecmp to 0 to ensure an interrupt is pending
    # Since mtime is likely at 0 or close to it at startup,
    # setting mtimecmp to 0 will cause an immediate interrupt as
    # soon as time advances to 1
    li      x6, 0xF0104004   # MTIMECMP_HART0_ADDR_H
    sw      x0, 0(x6)        # Write high word first (0)
    li      x6, 0xF0104000   # MTIMECMP_HART0_ADDR_L
    sw      x0, 0(x6)        # Write low word (0)

    # Add a small delay to ensure mtime has advanced past 0
    li      x6, 20
delay_loop:
    addi    x6, x6, -1
    bnez    x6, delay_loop

    # Mark execution point before WFI
    li      x21, 1

    # Execute WFI - should continue immediately
    wfi

    # Mark execution point after WFI - should be reached immediately
    li      x21, 2

    # Success if handler ran
    li      x6, 0
    bne     x20, x6, success    # If handler ran, succeed

    # If we reach here without handler running, the test failed
    li      x10, 0
    j       test_complete

success:
    li      x10, 1

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