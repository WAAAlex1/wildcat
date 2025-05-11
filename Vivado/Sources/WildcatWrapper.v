module WildcatWrapper(
    input           clock,
    input           reset,
    
    // SPI connections
    inout   [3:0]   sio, // bidirectional signal for qspi
    output          spiClk,
    output          CS0,
    output          CS1,
    output          CS2,
    
    // other WildcatTopPhysical connections
    input           rx,
    output          tx,
    output  [15:0]  led
);
    
    wire    gen_clk;
    
    clk_wiz instance_name
    (
    .clk_gen(gen_clk),   // Output 60MHz Clock
    .reset(reset), 
    .clk_in1(clock)      // Input 100MHz Clock
    );
    
    wire [3:0] io_inSio;
    wire [3:0] io_outSio;
    wire       io_dir;
    
    WildcatTopPhysical dut (
        .clock      (gen_clk),
        .reset      (reset),
        .io_inSio   (io_inSio),
        .io_outSio  (io_outSio),
        .io_spiClk  (spiClk),
        .io_CS0     (CS0),
        .io_CS1     (CS1),
        .io_CS2     (CS2),
        .io_dir     (io_dir),
        .io_rx         (rx),
        .io_tx         (tx),
        .io_led        (led)
    );
        
    // Tri-state buffer logic
    genvar i;
    generate
      for (i = 0; i < 4; i = i + 1) begin
        assign sio[i] = io_dir ? io_outSio[i] : 1'bz;  // Drive only when writing
        assign io_inSio[i] = sio[i];                   // Always sample input from sio
      end
    endgenerate    
    
endmodule 
