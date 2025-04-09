#
# BARE BONES EXCEPTION/TRAP HANDLER FOR THE WILDCAT MCU.
#
# NEEDED FOR HANDLING EXCEPTIONS BEFORE uCLinux TAKES OVER WITH ITS OWN EXCEPTION HANDLER.
#
# CURRENTLY SUPPORTS:
# 1. ECALL EXCEPTION
# 2. ILLEGAL INSTRUCTION EXCEPTION
#
# IN THE FUTURE ADD SUPPORT FOR:
# 1. LOAD/STORE FAULTS
# 2. DEBUGGING VIA UART (OR THE LIKE).

# HOW IT WORKS:
# UPON AN EXCEPTION, THE CPU SAVES THE TRAP CAUSE IN MCAUSE
# UPON AN EXCEPTION, THE CPU SAVES THE RETURN ADDR IN MEPC
# WE CHECK IF THE ENCODED TRAP CAUSE MATCHES (ECALL = 11).
# IF SO HANDLE THE ECALL (SIMPLY SKIP THE INSTRUCTION, RETURN TO CONTINUE OPERATION)
# ELSE TERMINATE (UNKNOWN EXCEPTION, HANG PROGRAM TO TERMINATE OPERATION, NEVER RETURN).


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
    csrw mepc, a1          # Write updated return address
    mret                   # Return from exception

handle_illegal:
    csrr a2, mtval         # mtval contains the instruction bits
    # Optionally skip or crash
    addi a1, a1, 4         # Try skipping (another solution could be to terminate)
    csrw mepc, a1
    mret