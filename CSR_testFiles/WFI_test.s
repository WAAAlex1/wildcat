# WFI and Timer Interrupt Test - Simplified
.section .text
.global _start

_start:
    # Set up trap vector
    la      x5, trap_handler
    csrw    mtvec, x5

    # Initialize test registers
    li      x10, 0              # Test result (will be set to 1 on success)
    li      x20, 0              # Flag set by interrupt handler

    # Enable interrupts
    li      x6, 0x8             # MIE bit (bit 3)
    csrw    mstatus, x6         # Set MIE bit

    # Set up timer to interrupt soon
    li      x6, 0xF010BFF8      # MTIME_ADDR_L
    lw      x7, 0(x6)           # Read low 32 bits of mtime
    addi    x7, x7, 5           # Add 5 ticks

    # Write mtimecmp
    li      x6, 0xF0104000      # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)           # Write low 32 bits

    # Enable timer interrupt
    li      x7, 0x80            # MTIE bit (bit 7)
    csrw    mie, x7             # Set MTIE bit

    # Execute WFI
    wfi                         # Wait for interrupt

    # After waking up
    li      x10, 1              # Set success flag if we reach here
    li      x29, 0xDEADBEEF     # Test completion marker

    # Loop forever
    j       .

# Trap handler
.align 4
trap_handler:
    # Set flag to indicate interrupt occurred
    li      x20, 1

    # Clear timer interrupt
    li      x6, 0xF010BFF8      # MTIME_ADDR_L
    lw      x7, 0(x6)           # Read current time
    addi    x7, x7, 1000        # Set far in future
    li      x6, 0xF0104000      # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)           # Update mtimecmp

    # Return from trap
    mret