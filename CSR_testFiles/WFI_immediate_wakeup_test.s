# RISC-V Assembly code demonstrating timer interrupts and WFI
# Corrected version with 'success' and 'exit' labels
# Reduced timer offset, added mcause debugging, and added pre-WFI delay

.section .text
.global _start

_start:
    # --- Setup ---
    # Set up trap vector address
    la      x5, trap_handler    # Load address of the trap handler function into x5
    csrw    mtvec, x5           # Write x5 to the Machine Trap Vector CSR (mtvec)

    # Initialize test registers
    li      x10, 0              # Test result register (0 = fail, 1 = success)
    li      x20, 0              # Interrupt handler execution counter
    li      x21, 0              # Execution progress marker
    li      x22, 0              # Register to store mcause value seen by handler

    # --- Enable Interrupts ---
    # Enable Machine-mode interrupts globally in mstatus CSR
    li      x6, 0x8             # MIE bit (Machine Interrupt Enable, bit 3)
    csrs    mstatus, x6         # Set the MIE bit in mstatus (using csrs for atomic set)

    # Enable Machine Timer Interrupt specifically in mie CSR
    li      x7, 0x80            # MTIE bit (Machine Timer Interrupt Enable, bit 7)
    csrs    mie, x7             # Set the MTIE bit in mie (using csrs for atomic set)

    # --- First Timer Interrupt Setup ---
    # Read current time from mtime register
    li      x6, 0x0200BFF8      # MTIME Address (use correct platform address)
    lw      x7, 0(x6)           # Read low 32 bits of mtime into x7

    # Set mtimecmp slightly in the future (100 ticks)
    addi    x7, x7, 100         # Add offset
    li      x8, 0               # High word = 0
    li      x6, 0x02004004      # MTIMECMP_HART0_ADDR_H
    sw      x8, 0(x6)           # Write high 32 bits
    li      x6, 0x02004000      # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)           # Write low 32 bits

    # --- Wait for First Interrupt ---
    li      x21, 1              # Mark pre-first-interrupt point
    # NOPs to allow interrupt processing
    nop
    nop
    nop
    nop
    # At this point, the first interrupt should have occurred (x20 should be 1).

    # --- Second Timer Interrupt Setup ---
    # Read current time again
    li      x6, 0x0200BFF8      # MTIME Address
    lw      x7, 0(x6)           # Read low 32 bits of mtime

    # Set mtimecmp again, slightly in the future (100 ticks)
    addi    x7, x7, 100         # Add offset
    li      x6, 0x02004000      # MTIMECMP_HART0_ADDR_L
    sw      x7, 0(x6)           # Write low 32 bits

    # --- Execute WFI (Wait For Interrupt) ---
    # The second interrupt should be pending now or become pending very shortly.

    # *** ADDED DELAY LOOP BEFORE WFI ***
    # Insert a small delay to ensure mtime >= mtimecmp and the
    # interrupt is actively pending before executing wfi.
    li      x6, 10             # Small delay counter (adjust if needed)
delay_loop_wfi:
    addi    x6, x6, -1          # Decrement counter
    bnez    x6, delay_loop_wfi  # Loop if counter not zero

    # Now execute WFI. If the setup is correct, an interrupt is pending,
    # WFI should wake immediately, and the handler should be called.
    wfi

    # --- Post-WFI Check ---
    # If WFI returned and the handler ran, x20 should be 2.
    li      x21, 2              # Mark post-WFI execution point

    # Assume success initially if we passed WFI
    li      x10, 1              # Set success code

    # Verify that the interrupt handler executed exactly twice
    li      x7, 2               # Expected interrupt count
    beq     x20, x7, success    # Branch to 'success' label if x20 == 2

    # --- Failure Path ---
    # If x20 is not 2, clear success flag.
    li      x10, 0              # Explicitly mark as failure

    # Fall through to exit

success:
    # The 'success' label target for the beq instruction.
    nop                         # Placeholder

exit:
    # End of the program
    j       exit                # Infinite loop


# --- Trap Handler ---
.align 4                        # Ensure handler starts on a 4-byte boundary
trap_handler:
    # Save registers
    addi    sp, sp, -16
    sw      ra, 12(sp)
    sw      t0, 8(sp)
    sw      t1, 4(sp)
    sw      t2, 0(sp)

    # Check mcause
    csrr    t0, mcause
    mv      x22, t0             # Save mcause for debugging
    li      t1, 0x80000007      # Machine Timer Interrupt cause code
    bne     t0, t1, wrong_interrupt

    # --- Timer Interrupt Handling ---
    addi    x20, x20, 1         # Increment handler execution counter

wrong_interrupt:
    # Restore registers
    lw      ra, 12(sp)
    lw      t0, 8(sp)
    lw      t1, 4(sp)
    lw      t2, 0(sp)
    addi    sp, sp, 16

    mret                        # Return from trap
