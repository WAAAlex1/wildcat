`timescale 1ns / 1ps

module IOBUFFER_tb;
  reg dir;
  reg out_data;
  wire io;
  wire in_data;
  
  // Instantiate the IOBUFFER module
  IOBUFFER uut (
    .io(io),
    .dir(dir),
    .out_data(out_data),
    .in_data(in_data)
  );

  initial begin
    $dumpfile("IOBUFFER_tb.vcd");  // Dump waveform for GTKWave
    $dumpvars(0, IOBUFFER_tb);

    // Test Output Mode (Drive io)
    dir = 1; out_data = 1;
    #10;
    if (io !== 1) $display("FAIL: io should be 1");
    
    out_data = 0;
    #10;
    if (io !== 0) $display("FAIL: io should be 0");

    // Test Input Mode (High-Z)
    dir = 0;
    #10;
    if (in_data !== io) $display("FAIL: in should match io");

    $display("Test Complete.");
    $finish;
  end
endmodule
