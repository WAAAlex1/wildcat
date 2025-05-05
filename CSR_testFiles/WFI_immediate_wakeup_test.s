# WFI Immediate Wakeup Test - Revised
.section .text
.global _start

_start:
    # Set up trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0              # Test result
    li      x20, 0              # Interrupt handler flag

    # THIS IS IMPORTANT - We need to explicitly enable interrupts
    li      x6, 0x8             # MIE bit (bit 3)
    csrw    mstatus, x6         # Enable machine-mode interrupts

    # Enable timer interrupt
    li      x7, 0x80            # MTIE bit (bit 7)
    csrw    mie, x7             # Enable timer interrupts

    # Read current time, then set mtimecmp SLIGHTLY IN THE FUTURE
    li      x6, 0xF010BFF8      # MTIME_ADDR_L
    lw      x7, 0(x6)           # Read low 32 bits of mtime

    # Set mtimecmp to current time + small value (5)
    addi    x7, x7, 5           # Just a few ticks in the future

    # Write mtimecmp (high word first, then low word)
    li      x8, 0               # High word = 0
    li      x6, 0xF0104004      # MTIMECMP_HART0_ADDR_H
    sw      x8, 0(x6)           # Write high 32 bits FIRST
    li      x6, 0xF0104000      # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)           # Write low 32 bits SECOND

    # Now do a delay loop until we know the interrupt is pending
    li      x6, 50
delay_loop:
    addi    x6, x6, -1
    bnez    x6, delay_loop

    # Add a marker to track execution progress
    li      x21, 1              # Mark pre-WFI execution point

    # Execute WFI - it should immediately continue due to pending interrupt
    wfi

    # Add another marker to track post-WFI execution
    li      x21, 2              # Mark post-WFI execution point

    # If we reach here, WFI didn't wait because the interrupt
    # was pending (SUCCESS for this part of the test)
    li      x10, 1              # Success

    # Check if the interrupt handler executed
    bnez    x20, success        # x20 is set by the handler

    # If no interrupt happened, we still made progress but need to mark it
    li      x29, 0xFEEDFACE     # Special marker - WFI continued but no interrupt
    j       exit

success:
    # Full success marker
    li      x29, 0xDEADBEEF

exit:
    j       exit                # Infinite loop

# Make sure trap_handler is defined in the same file and section
.align 4                        # Ensure proper alignment
trap_handler:
    # Save registers we'll use
    addi    sp, sp, -16
    sw      ra, 0(sp)
    sw      t0, 4(sp)
    sw      t1, 8(sp)

    # Check mcause to ensure it's a timer interrupt
    csrr    t0, mcause
    li      t1, 0x80000007      # Timer interrupt signature
    bne     t0, t1, wrong_interrupt

    # Set flag indicating timer interrupt occurred
    li      x20, 1

    # Update mtimecmp to prevent repeat interrupts
    li      t0, 0xF010BFF8      # MTIME_ADDR_L
    lw      t1, 0(t0)           # Read current time
    addi    t1, t1, 1000        # Set to far future
    li      t0, 0xF0104000      # MTIMECMP_HART0_ADDR_L
    sw      t1, 0(t0)           # Update mtimecmp

wrong_interrupt:
    # Restore registers
    lw      ra, 0(sp)
    lw      t0, 4(sp)
    lw      t1, 8(sp)
    addi    sp, sp, 16

    mret