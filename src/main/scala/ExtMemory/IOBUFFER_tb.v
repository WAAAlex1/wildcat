`timescale 1ns / 1ps

module IOBUFFER_tb;
  reg dir;
  reg out;
  wire io;
  wire in;
  
  // Instantiate the IOBUF module
  IOBUFFER uut (
    .io(io),
    .dir(dir),
    .out(out),
    .in(in)
  );

  initial begin
    $dumpfile("IOBUFFER_tb.vcd");  // Dump waveform for GTKWave
    $dumpvars(0, IOBUFFER_tb);

    // Test Output Mode (Drive io)
    dir = 1; out = 1;
    #10;
    if (io !== 1) $display("FAIL: io should be 1");
    
    out = 0;
    #10;
    if (io !== 0) $display("FAIL: io should be 0");

    // Test Input Mode (High-Z)
    dir = 0;
    #10;
    if (in !== io) $display("FAIL: in should match io");

    $display("Test Complete.");
    $finish;
  end
endmodule
