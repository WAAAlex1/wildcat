# WFI Immediate Wakeup Test - Revised
.section .text
.global _start

_start:
    # Set up trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0              # Test result (will be set to 1 on success)
    li      x20, 0              # Flag for interrupt handler execution
    li      x21, 0              # Counter for tracking program flow

    # Enable interrupts globally
    li      x6, 0x8             # MIE bit (bit 3)
    csrw    mstatus, x6

    # Enable timer interrupt
    li      x7, 0x80            # MTIE bit (bit 7)
    csrw    mie, x7

    # Set up mtimecmp to a value IN THE PAST
    # This ensures the interrupt is already pending when WFI executes
    li      x6, 0xF010BFF8      # MTIME_ADDR_L
    lw      x7, 0(x6)           # Read current time
    addi    x7, x7, -10         # Set to 10 ticks in the past
    li      x6, 0xF0104000      # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)           # Write low 32 bits

    # Add a small delay to ensure interrupt pending is registered
    li      x6, 10
delay_loop:
    addi    x6, x6, -1
    bnez    x6, delay_loop

    # Mark we're at this point in execution
    addi    x21, x21, 1         # x21 = 1: Before WFI

    # Check if interrupt occurs without WFI first (this is a test of the timer interrupt)
    # This will help us diagnose if the issue is with WFI or with the interrupt mechanism
    li      x8, 100             # Loop counter
no_wfi_wait:
    addi    x8, x8, -1
    bnez    x8, no_wfi_wait

    # Check if interrupt was taken during the loop
    li      x6, 1
    beq     x20, x6, after_wfi  # If interrupt happened, skip WFI

    # If we reach here, no interrupt occurred, try with WFI
    wfi

after_wfi:
    # Mark we reached point after WFI
    addi    x21, x21, 1         # x21 = 2: After WFI (or loop)

    # Now check result
    beqz    x20, fail           # Fail if interrupt never happened

    # All checks passed
    li      x10, 1              # Success
    li      x29, 0xDEADBEEF     # Test completion marker
    j       exit

fail:
    li      x10, 0
    li      x29, 0xBADF00D      # Failure marker

exit:
    j       exit                # Infinite loop

# Trap handler
.align 4
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