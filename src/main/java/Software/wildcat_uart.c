// Suggested filename: drivers/tty/serial/wildcat_uart.c
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/serial_core.h>
#include <linux/of.h> // For Device Tree parsing
#include <linux/console.h>
#include <linux/delay.h> // For udelay

#define DRIVER_NAME "wildcat_uart" // Renamed
#define DEVICE_NAME "ttyWC"      // Renamed (Wildcat)

// Register Offsets (relative to base address)
#define REG_STAT 0x0
#define REG_DATA 0x4

// Status Register Bits (Adjust if necessary)
#define STAT_RX_VALID (1 << 1) // 0x02
#define STAT_TX_READY (1 << 0) // 0x01

// Define max number of ports this driver can handle
#define WILDCAT_UART_MAX_PORTS 1 // Renamed

// --- Forward Declarations ---
static void wildcat_uart_console_write(struct console *co, const char *s, unsigned int count); // Renamed
static int wildcat_uart_probe(struct platform_device *pdev); // Renamed
static int wildcat_uart_remove(struct platform_device *pdev); // Renamed

// --- Port Data Structure ---
struct wildcat_uart_port { // Renamed
    struct uart_port port;
    // Add any custom fields needed later
};

static struct wildcat_uart_port wildcat_ports[WILDCAT_UART_MAX_PORTS]; // Renamed

// --- Low-level Access Functions ---

// Check if TX fifo is ready to accept a character
static bool wildcat_uart_tx_ready(struct uart_port *port) { // Renamed
    return (readb(port->membase + REG_STAT) & STAT_TX_READY);
}

// Write one character (polling)
static void wildcat_uart_putc(struct uart_port *port, unsigned char c) { // Renamed
    // Poll until TX is ready - add timeout?
    while (!wildcat_uart_tx_ready(port)) { // Renamed call
        cpu_relax(); // Don't hammer the bus too hard
        // Consider adding udelay(1) or a proper timeout mechanism
        // if the hardware might lock up. For early console, spinning might be ok.
    }
    writeb(c, port->membase + REG_DATA);
}

// Check if RX fifo has a character
static bool wildcat_uart_rx_valid(struct uart_port *port) { // Renamed
    return (readb(port->membase + REG_STAT) & STAT_RX_VALID);
}

// Read one character (polling) - Needed for TTY input, not strictly for console output
static unsigned char wildcat_uart_getc(struct uart_port *port) { // Renamed
    // Poll until RX is valid - add timeout?
    while (!wildcat_uart_rx_valid(port)) { // Renamed call
        cpu_relax();
        // Consider udelay or timeout
    }
    return readb(port->membase + REG_DATA);
}


// --- UART Operations (`struct uart_ops`) ---

// Check if transmitter is empty (ready for more data)
static unsigned int wildcat_uart_tx_empty(struct uart_port *port) { // Renamed
    // Return non-zero (true) if ready, zero (false) if not.
    return wildcat_uart_tx_ready(port) ? TIOCSER_TEMT : 0; // Renamed call
}

// Start transmitting (called by serial core)
static void wildcat_uart_start_tx(struct uart_port *port) { // Renamed
    struct circ_buf *xmit = &port->state->xmit;
    unsigned char c;

    // Send characters from buffer until TX fifo is full or buffer is empty
    while (wildcat_uart_tx_ready(port)) { // Renamed call
        if (uart_circ_empty(xmit)) {
            break; // No more data to send
        }
        c = xmit->buf[xmit->tail];
        xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
        writeb(c, port->membase + REG_DATA);
    }
    // Note: No interrupt needed/used to trigger more sending.
    // The core might call start_tx periodically if needed, or rely on tx_empty.
    // For polling, this simple approach might suffice.
}

// Stop transmitting (called by serial core - can be empty for polling)
static void wildcat_uart_stop_tx(struct uart_port *port) { // Renamed
    // Nothing specific needed for simple polling TX.
}

// Stop receiving (called by serial core - can be empty if no RX needed/handled)
static void wildcat_uart_stop_rx(struct uart_port *port) { // Renamed
    // Nothing specific needed if not handling RX interrupts/DMA.
}

// Enable modem control interrupts (not applicable)
static void wildcat_uart_enable_ms(struct uart_port *port) {} // Renamed

// Get modem status lines (not applicable / hardware dependent)
static unsigned int wildcat_uart_get_mctrl(struct uart_port *port) { // Renamed
    // Return TIOCM_CAR | TIOCM_DSR | TIOCM_CTS; if fixed high, otherwise 0
    return TIOCM_CAR | TIOCM_DSR | TIOCM_CTS; // Assume always ready
}

// Set modem status lines (not applicable / hardware dependent)
static void wildcat_uart_set_mctrl(struct uart_port *port, unsigned int mctrl) {} // Renamed

// Handle break condition (not implemented)
static void wildcat_uart_break_ctl(struct uart_port *port, int break_state) {} // Renamed

// Startup the port (called when device is opened)
static int wildcat_uart_startup(struct uart_port *port) { // Renamed
    // This is where you might enable the UART hardware block if needed.
    // Since it's simple polling and always on, maybe nothing needed here.
    // If RX were interrupt-based, you'd request_irq here.
    return 0;
}

// Shutdown the port (called when device is closed)
static void wildcat_uart_shutdown(struct uart_port *port) { // Renamed
    // Disable UART hardware block if applicable.
    // If RX were interrupt-based, you'd free_irq here.
}

// Set termios (baud, bits, parity) - Since fixed in HW, do nothing
static void wildcat_uart_set_termios(struct uart_port *port, struct ktermios *termios, // Renamed
                                    const struct ktermios *old) {
    // Parameters are fixed in hardware, but we should report the fixed settings.
    // The core usually fills termios based on reported uartclk/baud.
    // We can enforce our fixed settings here if needed, but often the core handles it.
    // Keep baud rate 0 to signify it cannot be changed.
    tty_termios_encode_baud_rate(termios, 0, 0);

    // Optionally report fixed settings (e.g., 8N1)
    termios->c_cflag &= ~CSIZE;
    termios->c_cflag |= CS8; // Assume 8 data bits
    termios->c_cflag &= ~PARENB; // Assume no parity
    termios->c_cflag &= ~CSTOPB; // Assume 1 stop bit
    termios->c_cflag |= CREAD; // Enable receiver

    // Update timeout settings etc. if needed by serial core for polling.
    uart_update_timeout(port, termios->c_cflag, 0); // Baud rate 0
}

// Return UART type string
static const char *wildcat_uart_type(struct uart_port *port) { // Renamed
    return DRIVER_NAME; // Use the #define
}

// Request memory region (done in probe using devm)
static void wildcat_uart_release_port(struct uart_port *port) {} // Renamed

// Release memory region (done in probe using devm)
static int wildcat_uart_request_port(struct uart_port *port) { return 0; } // Renamed

// Configure port (called during init - can be empty)
static void wildcat_uart_config_port(struct uart_port *port, int flags) {} // Renamed

// Verify port config (can be empty)
static int wildcat_uart_verify_port(struct uart_port *port, struct serial_struct *ser) { return -EINVAL; } // Renamed - Don't allow changes

// Define the UART operations structure
static struct uart_ops wildcat_uart_ops = { // Renamed
    .tx_empty       = wildcat_uart_tx_empty,
    .set_mctrl      = wildcat_uart_set_mctrl,
    .get_mctrl      = wildcat_uart_get_mctrl,
    .stop_tx        = wildcat_uart_stop_tx,
    .start_tx       = wildcat_uart_start_tx,
    .stop_rx        = wildcat_uart_stop_rx,
    .enable_ms      = wildcat_uart_enable_ms,
    .break_ctl      = wildcat_uart_break_ctl,
    .startup        = wildcat_uart_startup,
    .shutdown       = wildcat_uart_shutdown,
    .set_termios    = wildcat_uart_set_termios,
    .type           = wildcat_uart_type,
    .release_port   = wildcat_uart_release_port,
    .request_port   = wildcat_uart_request_port,
    .config_port    = wildcat_uart_config_port,
    .verify_port    = wildcat_uart_verify_port,
    // Add .write if directly implementing console write op
    // Add RX ops (.rx_chars) if handling input later
};

// --- Console Structure (`struct console`) ---
// Update Kconfig to use CONFIG_SERIAL_WILDCAT_UART_CONSOLE
#ifdef CONFIG_SERIAL_WILDCAT_UART_CONSOLE
static struct console wildcat_uart_console = { // Renamed
    .name       = DEVICE_NAME, // "ttyWC"
    .write      = wildcat_uart_console_write, // Renamed
    .device     = uart_console_device,
    .setup      = NULL, // We use early platform probe or DT
    .flags      = CON_PRINTBUFFER | CON_POLL, // Indicate it's polled
    .index      = -1, // TTY index (-1 = auto)
    // Link to our uart_driver later in probe if needed, or handled by serial core
};

// Console write function (called directly by printk)
static void wildcat_uart_console_write(struct console *co, const char *s, unsigned int count) { // Renamed
    struct uart_port *port = &wildcat_ports[0].port; // Assume console on port 0 - Renamed array
    unsigned long flags;
    int locked = 1;

    // Basic check if port memory is mapped
    if (!port->membase) return;

    // Need lock for SMP safety if console can be called concurrently
    if (oops_in_progress || port->sysrq || !port->state)
        locked = uart_port_trylock(port, &flags);
    else
        uart_port_lock_irqsave(port, &flags);

    // Pass the renamed putc function
    uart_console_write(port, s, count, wildcat_uart_putc);

    // Consider adding a final poll for TX empty here if needed for some HW

    if (locked)
        uart_port_unlock_irqrestore(port, flags);
}

#define WILDCAT_UART_CONSOLE (&wildcat_uart_console) // Renamed
#else
#define WILDCAT_UART_CONSOLE NULL // Renamed
#endif // CONFIG_SERIAL_WILDCAT_UART_CONSOLE

// --- UART Driver Structure (`struct uart_driver`) ---
static struct uart_driver wildcat_uart_driver = { // Renamed
    .owner          = THIS_MODULE,
    .driver_name    = DRIVER_NAME, // "wildcat_uart"
    .dev_name       = DEVICE_NAME, // "ttyWC"
    .major          = 0, // Dynamically assigned
    .minor          = 0, // Dynamically assigned
    .nr             = WILDCAT_UART_MAX_PORTS, // Renamed define
    .cons           = WILDCAT_UART_CONSOLE, // Link console structure - Renamed define
};

// --- Platform Driver (`struct platform_driver`) ---

// Update Device Tree compatible string to match
static const struct of_device_id wildcat_uart_of_match[] = { // Renamed
    { .compatible = "dtu,wildcat-uart-v1", }, // Renamed compatible string
    { /* Sentinel */ }
};
MODULE_DEVICE_TABLE(of, wildcat_uart_of_match); // Use renamed match table

static int wildcat_uart_probe(struct platform_device *pdev) { // Renamed
    struct device_node *np = pdev->dev.of_node;
    struct wildcat_uart_port *wcp; // Renamed port struct variable
    struct resource *res;
    int ret;
    int port_index = 0; // Simple case: only one port assumed

    dev_info(&pdev->dev, "Probing Wildcat UART\n"); // Updated message

    // Find an unused port structure (simple fixed array for now)
    if (port_index >= WILDCAT_UART_MAX_PORTS || wildcat_ports[port_index].port.mapbase != 0) { // Renamed check
        dev_err(&pdev->dev, "No free port available or port already configured\n");
        return -ENODEV;
    }
    wcp = &wildcat_ports[port_index]; // Renamed variable

    // Get memory resource from Device Tree
    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
    if (!res) {
        dev_err(&pdev->dev, "Failed to get memory resource\n");
        return -ENODEV;
    }

    // Map the memory-mapped registers
    // Using devm_ variants handles cleanup automatically on failure or remove
    wcp->port.membase = devm_ioremap_resource(&pdev->dev, res);
    if (IS_ERR(wcp->port.membase)) {
        dev_err(&pdev->dev, "Failed to ioremap memory resource\n");
        return PTR_ERR(wcp->port.membase);
    }

    // Initialize the uart_port structure
    spin_lock_init(&wcp->port.lock);
    wcp->port.iotype = UPIO_MEM; // Memory mapped IO
    wcp->port.mapbase = res->start; // Physical base address
    wcp->port.iobase = (unsigned long)wcp->port.membase; // Virtual base address
    wcp->port.irq = NO_IRQ; // Explicitly no interrupt
    wcp->port.uartclk = 0; // Clock frequency (0 = unknown/fixed baud) - Get from DT if possible!
    wcp->port.fifosize = 1; // Assume 1-byte buffer in HW if not specified
    wcp->port.ops = &wildcat_uart_ops; // Use renamed ops struct
    wcp->port.flags = UPF_SKIP_TEST | UPF_BOOT_AUTOCONF | UPF_FIXED_TYPE | UPF_IOREMAP;
    wcp->port.dev = &pdev->dev;
    wcp->port.line = port_index; // Port index (0, 1, ...)
    wcp->port.type = PORT_CUSTOM; // Use PORT_CUSTOM

    // Register the port with the serial core
    ret = uart_add_one_port(&wildcat_uart_driver, &wcp->port); // Use renamed driver struct
    if (ret < 0) {
        dev_err(&pdev->dev, "Failed to add UART port: %d\n", ret);
        // devm_ioremap_resource cleanup is automatic
        return ret;
    }

    // Store pointer to our custom port structure for remove()
    platform_set_drvdata(pdev, wcp);

    dev_info(&pdev->dev, "Wildcat UART registered as %s%d\n", DEVICE_NAME, wcp->port.line); // Updated message

    return 0; // Success
}

static int wildcat_uart_remove(struct platform_device *pdev) { // Renamed
    struct wildcat_uart_port *wcp = platform_get_drvdata(pdev); // Renamed variable

    dev_info(&pdev->dev, "Removing Wildcat UART %s%d\n", DEVICE_NAME, wcp->port.line); // Updated message

    if (wcp) {
        uart_remove_one_port(&wildcat_uart_driver, &wcp->port); // Use renamed driver struct
        // Reset mapbase to allow reuse of the slot (optional)
        wcp->port.mapbase = 0;
    }
    // devm_ioremap_resource handles unmapping automatically

    return 0;
}

// Define the platform driver structure
static struct platform_driver wildcat_uart_platform_driver = { // Renamed
    .probe = wildcat_uart_probe, // Use renamed probe
    .remove = wildcat_uart_remove, // Use renamed remove
    .driver = {
        .name = DRIVER_NAME, // "wildcat_uart"
        .of_match_table = wildcat_uart_of_match, // Use renamed match table
    },
};


// --- Module Init / Exit ---

static int __init wildcat_uart_init(void) { // Renamed
    int ret;

    printk(KERN_INFO "Registering Wildcat UART driver\n"); // Updated message

    // Register the UART driver (allocates major/minor numbers)
    ret = uart_register_driver(&wildcat_uart_driver); // Use renamed driver struct
    if (ret < 0) {
        printk(KERN_ERR "Failed to register Wildcat UART driver: %d\n", ret); // Updated message
        return ret;
    }

    // Register the platform driver (for device tree matching)
    ret = platform_driver_register(&wildcat_uart_platform_driver); // Use renamed platform driver struct
    if (ret < 0) {
        printk(KERN_ERR "Failed to register Wildcat UART platform driver: %d\n", ret); // Updated message
        uart_unregister_driver(&wildcat_uart_driver); // Cleanup - Use renamed driver struct
        return ret;
    }

    return 0;
}

static void __exit wildcat_uart_exit(void) { // Renamed
    printk(KERN_INFO "Unregistering Wildcat UART driver\n"); // Updated message

    // Unregister platform driver first
    platform_driver_unregister(&wildcat_uart_platform_driver); // Use renamed platform driver struct

    // Unregister UART driver
    uart_unregister_driver(&wildcat_uart_driver); // Use renamed driver struct
}

module_init(wildcat_uart_init); // Use renamed init
module_exit(wildcat_uart_exit); // Use renamed exit

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Georg Brink Dyvad");
MODULE_DESCRIPTION("Minimal polling serial driver for Wildcat UART"); // Updated description