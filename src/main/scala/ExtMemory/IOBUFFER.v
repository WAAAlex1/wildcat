module IOBUFFER (
    inout wire io,       // QSPI bidirectional line
    input wire dir,      // 1 = Output mode, 0 = Input mode
    input wire out_data,      // Data to drive when output
    output wire in_data  // ✅ Renamed from 'in'
);
    assign io = dir ? out_data : 1'bz; // Drive 'out' if dir=1, else high-Z
    assign in_data = io;          // Always read io
endmodule
