# Test program for RISC-V CLINT mtime/mtimecmp functionality (RV32IA)
#
# Results are stored in registers:
# a0: mtime read test result (1 = pass, 0 = fail/stuck)
# a1: Interrupt handler execution flag (1 = handler ran, 0 = did not run)
# a2: mtimecmp/interrupt test result (1 = pass, 0 = fail/timeout)

.section .text
.global _start

# --- Constants ---
.equ CLINT_BASE,      0xF2000000
.equ CLINT_MTIMECMP,  CLINT_BASE + 0x4000 # Hart 0 mtimecmp
.equ CLINT_MTIME,     CLINT_BASE + 0xBFF8 # mtime

.equ MSTATUS_ADDR,    0x300
.equ MIE_ADDR,        0x304
.equ MTVEC_ADDR,      0x305
.equ MEPC_ADDR,       0x341
.equ MCAUSE_ADDR,     0x342
.equ MIP_ADDR,        0x344

.equ MSTATUS_MIE,     0x00000008 # Global M-mode Interrupt Enable (Bit 3)
.equ MIE_MTIE,        0x00000080 # Machine Timer Interrupt Enable (Bit 7)
.equ MIP_MTIP,        0x00000080 # Machine Timer Interrupt Pending (Bit 7)

.equ MTI_CAUSE,       7          # mcause value for Machine Timer Interrupt

.equ TEST_PASS,       1
.equ TEST_FAIL,       0

.equ DELAY_LOOP_COUNT, 100      # Simple delay loop iterations
.equ MTIMECMP_DELTA,   10  # How far in the future to set mtimecmp (adjust based on mtime freq) current frq = 100instr pr mtime incr
.equ TIMEOUT_COUNT,    5000  # Timeout for waiting for interrupt

# --- Code Start ---
_start:
    # Initialize result registers to fail state
    li a0, TEST_FAIL
    li a1, TEST_FAIL
    li a2, TEST_FAIL

    # --- Setup Interrupts ---
    # 1. Set mtvec to point to the trap handler
    la t0, trap_handler
    csrw MTVEC_ADDR, t0

    # 2. Enable Machine Timer Interrupts in MIE CSR
    li t0, MIE_MTIE
    csrrs x0, MIE_ADDR, t0      # Set MTIE bit

    # 3. Enable Global Interrupts in MSTATUS CSR
    li t0, MSTATUS_MIE
    csrrs x0, MSTATUS_ADDR, t0  # Set MIE bit

    # --- Test 1: Read mtime and check if it increments ---
    # Read initial mtime (low then high)
    li t0, CLINT_MTIME
    lw t1, 0(t0)                # Read mtime low
    lw t2, 4(t0)                # Read mtime high

    # Simple delay loop
    li t3, DELAY_LOOP_COUNT
delay1_loop:
    addi t3, t3, -1
    bnez t3, delay1_loop

    # Read mtime again (low then high)
    lw t4, 0(t0)                # Read mtime low again
    lw t5, 4(t0)                # Read mtime high again

    # Compare - Check if time increased (simple check, ignores rollover for test)
    # If high word increased OR (high word same AND low word increased)
    blt t2, t5, mtime_passed    # Branch if initial high < final high
    beq t2, t5, mtime_check_low # If high words equal, check low
    j mtime_failed              # If initial high > final high (rollover?), treat as fail for simplicity

mtime_check_low:
    bltu t1, t4, mtime_passed   # Branch if initial low < final low
    # If we reach here, time didn't increase or went backwards (error)
mtime_failed:
    li a0, TEST_FAIL
    j test2_setup

mtime_passed:
    li a0, TEST_PASS            # Store pass result in a0

    # --- Test 2: Set mtimecmp and wait for interrupt ---
test2_setup:
    # Read current mtime (low then high)
    li t0, CLINT_MTIME
    lw t1, 0(t0)                # mtime low
    lw t2, 4(t0)                # mtime high

    # Calculate future time for mtimecmp
    # target_low = mtime_low + DELTA
    # target_high = mtime_high + (carry from low word addition)
    li t3, MTIMECMP_DELTA
    add t4, t1, t3              # target_low = mtime_low + delta
    sltu t5, t4, t1             # t5 = 1 if overflow occurred (target_low < mtime_low)
    add t5, t2, t5              # target_high = mtime_high + carry

    # Write to mtimecmp (low then high)
    li t0, CLINT_MTIMECMP
    sw t4, 0(t0)                # Write target low
    sw t5, 4(t0)                # Write target high
                                # Writing mtimecmp should clear mip.MTIP if set

    # Wait for interrupt (check mip.MTIP or flag set by handler)
    # Use a timeout loop to prevent infinite wait if interrupt fails
    li t6, TIMEOUT_COUNT
wait_for_interrupt:
    # Check if handler already ran and set a1
    li t0, TEST_PASS
    beq a1, t0, interrupt_occurred

    # Optional: Check MIP.MTIP directly (might race with handler)
    # csrr t0, MIP_ADDR
    # andi t0, t0, MIP_MTIP
    # bnez t0, interrupt_occurred # Branch if MTIP is set

    # Decrement timeout counter
    addi t6, t6, -1
    bnez t6, wait_for_interrupt

    # If loop finishes, timeout occurred
    li a2, TEST_FAIL            # Interrupt test failed (timeout)
    j end_test

interrupt_occurred:
    # Check if a1 was set by the handler (redundant if branch taken above, but good check)
    li t0, TEST_PASS
    beq a1, t0, interrupt_passed
    # If a1 is not PASS, something went wrong even if we thought interrupt occurred
    li a2, TEST_FAIL
    j end_test

interrupt_passed:
    li a2, TEST_PASS            # Interrupt test passed

end_test:
    # --- End of Tests ---
    # Results are in a0, a1, a2
    # Enter infinite loop
end_loop:
    j end_loop

# --- Trap Handler ---
# Simple handler: Checks cause, sets flag if MTI, returns.
# Does not save/restore registers as it only modifies a1.
.align 2 # Ensure handler starts on 4-byte boundary
trap_handler:
    # Read mcause
    csrr t0, MCAUSE_ADDR

    # Check if cause is Machine Timer Interrupt (7)
    li t1, MTI_CAUSE
    bne t0, t1, other_trap

    # It's an MTI! Set flag in a1
    li a1, TEST_PASS


    # Set mtimecmp far into the future (e.g., max value)
    # This effectively clears the timer interrupt condition.
    li t0, CLINT_MTIMECMP
    li t1, -1 # Max value for low word (0xFFFFFFFF)
    li t2, -1 # Max value for high word (0xFFFFFFFF)
    sw t1, 0(t0)
    sw t2, 4(t0)

    # Return from trap
    mret

other_trap:
    # Handle other traps if necessary, or just loop/halt
    # For this test, just return without setting the flag
    mret