    .section .text
    .globl _start

_start:
    # Set trap vector
    la x5, _trap_vector
    csrrw x0, mtvec, x5

    # Clear key registers
    li x10, 0          # x10: test result
    li x7, 0           # x7 : will be set to 42 by ecall handler

    # Trigger ECALL exception
    ecall

    # Check if x7 == 42 (ecall handler success)
    li x5, 42
    bne x7, x5, fail

    # Trigger illegal instruction
    .word 0xFEFEFEFE

    # If we reach here, illegal instruction was handled
    li x28, 0x55       # x28 (t3): marker for successful illegal inst handler

    # Move important values to preserved registers
    mv x21, x10        # x21 = final a0 result (should be 1)
    mv x22, x7         # x22 = marker from ecall handler (should be 42)
    mv x23, x12        # x23 = mtval (should be 0xFEFEFEFE)
    mv x24, x28        # x24 = marker from illegal handler (should be 0x55)
    mv x25, x11        # x25 = final mepc (instruction after illegal inst)

    li x10, 1          # Success code
_success_end:
    j _success_end

fail:
    li x10, 0
    mv x21, x10        # Store failure code
    ecall

# Trap handler
_trap_vector:
    csrrs x10, mcause, x0    # x10 = mcause
    csrrs x11, mepc, x0      # x11 = mepc

    li x5, 11
    beq x10, x5, handle_ecall

    li x5, 2
    beq x10, x5, handle_illegal

    j fatal_trap

handle_ecall:
    addi x11, x11, 4
    li x7, 42                # x7 = test marker for ecall
    csrrw x0, mepc, x11
    mret

handle_illegal:
    csrrs x12, mtval, x0     # x12 = offending instruction
    addi x11, x11, 4
    csrrw x0, mepc, x11
    mret

fatal_trap:
    j fatal_trap
