# Exception Test - Testing exception handling and MRET
# This test verifies proper exception handling by:
# 1. Setting up trap vector
# 2. Triggering an exception
# 3. Verifying the exception handler was executed
# 4. Verifying proper return via MRET

_start:
    # Set trap vector address
    la t0, _trap_vector
    csrw mtvec, t0

    # Initialize test registers
    li a0, 0
    li t2, 0            # This will be set to 42 by the handler (if success)

    # Test 1: Trigger ECALL exception
    ecall               # This should jump to _trap_vector and return

    # Test 2: Check if trap handler executed properly
    li t0, 42
    bne t2, t0, fail    # t2 should be 42 now if handler ran

    # Test 3: Trigger illegal instruction exception
    .word 0xFEFEFEFE    # Illegal instruction (not a valid RISC-V opcode)

    # If we get here, the handler for illegal instruction worked
    li t3, 0x55         # Mark successful illegal instruction handling

    # End of test with success
    li a0, 1            # Success code
    ecall               # Exit

fail:
    li a0, 0            # Failure code
    ecall               # Exit

# Trap handler - using your provided code
_trap_vector:
    csrr a0, mcause        # Read trap cause
    csrr a1, mepc          # Read return address

    li   t0, 11            # Machine-mode ECALL
    beq  a0, t0, handle_ecall

    li   t0, 2             # Illegal instruction
    beq  a0, t0, handle_illegal

    # Unknown trap — hang or print via UART
fatal_trap:
    j fatal_trap

handle_ecall:
    addi a1, a1, 4         # Skip the 'ecall' instruction
    li t2, 42              # Marker to see that ecall actually was processed (for testing)
    csrw mepc, a1          # Write updated return address
    mret                   # Return from exception

handle_illegal:
    csrr a2, mtval         # mtval contains the instruction bits
    # Optionally skip or crash
    addi a1, a1, 4         # Try skipping (another solution could be to terminate)
    csrw mepc, a1
    mret