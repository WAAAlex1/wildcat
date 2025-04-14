module IOBUFFER (
    inout wire io,   // QSPI bidirectional line
    input wire dir,  // 1 = Output mode, 0 = Input mode
    input wire out,  // Data to drive when output
    output wire in   // Data read when input
);
    assign io = dir ? out : 1'bz; // Drive 'out' if dir=1, else high-Z
    assign in = io;               // Always read io
endmodule