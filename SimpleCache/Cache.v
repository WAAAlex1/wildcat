module Cache(
  input         clock,
  input         reset,
  input         io_rw,
  input  [9:0]  io_ad,
  input  [31:0] io_DI,
  output [31:0] io_DO
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] mem [0:1023]; // @[Cache.scala 12:24]
  wire  mem_memVal_en; // @[Cache.scala 12:24]
  wire [9:0] mem_memVal_addr; // @[Cache.scala 12:24]
  wire [7:0] mem_memVal_data; // @[Cache.scala 12:24]
  wire [7:0] mem_MPORT_data; // @[Cache.scala 12:24]
  wire [9:0] mem_MPORT_addr; // @[Cache.scala 12:24]
  wire  mem_MPORT_mask; // @[Cache.scala 12:24]
  wire  mem_MPORT_en; // @[Cache.scala 12:24]
  reg  mem_memVal_en_pipe_0;
  reg [9:0] mem_memVal_addr_pipe_0;
  wire [7:0] _io_DO_T = io_rw ? mem_memVal_data : 8'h0; // @[Cache.scala 16:15]
  assign mem_memVal_en = mem_memVal_en_pipe_0;
  assign mem_memVal_addr = mem_memVal_addr_pipe_0;
  assign mem_memVal_data = mem[mem_memVal_addr]; // @[Cache.scala 12:24]
  assign mem_MPORT_data = io_DI[7:0];
  assign mem_MPORT_addr = io_ad;
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = ~io_rw;
  assign io_DO = {{24'd0}, _io_DO_T}; // @[Cache.scala 16:9]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[Cache.scala 12:24]
    end
    mem_memVal_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      mem_memVal_addr_pipe_0 <= io_ad;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    mem[initvar] = _RAND_0[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mem_memVal_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  mem_memVal_addr_pipe_0 = _RAND_2[9:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
