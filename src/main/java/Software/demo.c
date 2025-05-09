// Define UART memory-mapped register addresses
#define UART_STATUS_REG (*(volatile unsigned int *)0xF0000000)
#define UART_TX_REG     (*(volatile unsigned int *)0xF0000004)

// UART Status bits
#define UART_TX_READY   (1 << 0) // Bit 0: Transmitter ready
#define UART_RX_VALID   (1 << 1) // Bit 1: Receiver has valid data (not used in this demo)

// ASCII Art Data
const char *ascii_art =
    "                                                                          \n"
    "WW      WW  IIIIII  LL        DDDDDD   CCCCCC    AAAAAA   TTTTTTTT        \n"
    "WW      WW    II    LL        DD   DD CC    CC  AA    AA     TT           \n"
    "WW   W  WW    II    LL        DD   DD CC        AA    AA     TT           \n"
    "WW  WWW WW    II    LL        DD   DD CC        AAAAAAAA     TT           \n"
    " WWW WWW      II    LL        DD   DD CC    CC  AA    AA     TT           \n"
    "  WWWWWW    IIIIII  LLLLLLLL  DDDDDD   CCCCCC   AA    AA     TT           \n"
    "                                                                          \n"
    "                                                                          \n"
    "    ________________________________________________________________   \n"
    "   /                                                                 \\  \n"
    "  |         Hello from your bare-metal RISC-V Processor!            | \n"
    "  |      This ASCII art is being printed character by character     | \n"
    "  |                     via the memory-mapped UART.                 | \n"
    "  |                                                                 | \n"
    "  |    Processor: Custom RISC-V 32IA_ZICSR                          | \n"
    "  |    Memory:    16 MB                                             | \n"
    "  |    UART Addr: Status 0xF0000000, TX 0xF0000004                  | \n"
    "  |                                                                 | \n"
    "   \\_______________________________________________________________/  \n"
    "                                                                          \n"
    "                   ********* ********* ********* \n"
    "                 *********** *********** *********** \n"
    "                **** **** **** **** **** **** \n"
    "               **** **** **** \n"
    "              **** **** **** \n"
    "             **** **** **** \n"
    "            **** **** **** \n"
    "           **** **** **** \n"
    "          **** **** **** \n"
    "         **** **** **** \n"
    "        **** **** **** \n"
    "       **** **** **** **** **** **** \n"
    "      *********** *********** *********** \n"
    "     ********* ********* ********* \n"
    "                                                                          \n";

// Function to check if UART transmitter is ready
int uart_tx_ready() {
    return (UART_STATUS_REG & UART_TX_READY);
}

// Function to send a single character via UART
void uart_putchar(char c) {
    // Wait until TX is ready
    while (!uart_tx_ready()) {
        // Busy-wait
    }
    // Write the character to the TX register
    UART_TX_REG = (unsigned int)c;
}

// Function to send a null-terminated string via UART
void uart_puts(const char *s) {
    while (*s) {
        if (*s == '\n') {
            uart_putchar('\r'); // Send Carriage Return before Line Feed
        }
        uart_putchar(*s++);
    }
}

// Declare symbols defined by the linker script for .bss section
extern char __bss_start[];
extern char __bss_end[];

// Function to clear the .bss section
static void clear_bss(void) {
    char *p = __bss_start;
    while (p < __bss_end) {
        *p++ = 0;
    }
}

// Forward declaration of main (if _start is defined before main)
int main(void);

// The _start function: program's true entry point
void _start(void) {
    // The ZSBL should have already set up the stack pointer (sp).

    // 1. Clear the .bss section
    clear_bss();

    // 2. Call the C main function
    main();

    // 3. Infinite loop if main returns (it shouldn't in bare-metal)
    while (1) {
        // Halt
    }
}

// Bare-metal entry point
int main() {
    // Infinite loop to halt the processor
    while (1) {
        // Print the ASCII art
        uart_puts(ascii_art);
    }

    return 0; // Should not be reached in bare-metal if halted
}

// Reminder:
// Your Zero-Stage Bootloader (ZSBL) should:
// 1. Initialize the Stack Pointer (sp).
// 2. Set up the exception handler (e.g., mtvec).
// 3. Load this compiled program to its designated memory address.
// 4. Jump to the entry point of this program (which will be `main` or `_start`
//    as defined by your compilation and linking process).

// Linker script considerations (conceptual, adapt to your toolchain/ZSBL):
// - ENTRY(_start) or ensure your ZSBL jumps to `main`.
// - MEMORY { RAM (rwx) : ORIGIN = <load_addr_by_zsbl>, LENGTH = <size_for_app> }
// - SECTIONS { .text : { *(.text .text.*) } > RAM, .rodata : { ... } > RAM, etc. }