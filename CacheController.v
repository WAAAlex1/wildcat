module RAM(
  input         clock,
  input         io_rw,
  input  [8:0]  io_ad,
  input  [31:0] io_DI,
  input         io_EN,
  output [31:0] io_DO
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] mem [0:511]; // @[RAM.scala 24:24]
  wire  mem_io_DO_MPORT_en; // @[RAM.scala 24:24]
  wire [8:0] mem_io_DO_MPORT_addr; // @[RAM.scala 24:24]
  wire [31:0] mem_io_DO_MPORT_data; // @[RAM.scala 24:24]
  wire [31:0] mem_MPORT_data; // @[RAM.scala 24:24]
  wire [8:0] mem_MPORT_addr; // @[RAM.scala 24:24]
  wire  mem_MPORT_mask; // @[RAM.scala 24:24]
  wire  mem_MPORT_en; // @[RAM.scala 24:24]
  reg  mem_io_DO_MPORT_en_pipe_0;
  reg [8:0] mem_io_DO_MPORT_addr_pipe_0;
  wire  _T = io_rw & io_EN; // @[RAM.scala 26:14]
  wire  _T_2 = ~io_rw & io_EN; // @[RAM.scala 28:21]
  assign mem_io_DO_MPORT_en = mem_io_DO_MPORT_en_pipe_0;
  assign mem_io_DO_MPORT_addr = mem_io_DO_MPORT_addr_pipe_0;
  assign mem_io_DO_MPORT_data = mem[mem_io_DO_MPORT_addr]; // @[RAM.scala 24:24]
  assign mem_MPORT_data = io_DI;
  assign mem_MPORT_addr = io_ad;
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = _T ? 1'h0 : _T_2;
  assign io_DO = io_rw & io_EN ? mem_io_DO_MPORT_data : 32'h0; // @[RAM.scala 26:23 27:11]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[RAM.scala 24:24]
    end
    mem_io_DO_MPORT_en_pipe_0 <= io_rw & io_EN;
    if (io_rw & io_EN) begin
      mem_io_DO_MPORT_addr_pipe_0 <= io_ad;
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
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    mem[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mem_io_DO_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  mem_io_DO_MPORT_addr_pipe_0 = _RAND_2[8:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module RAM_1(
  input         clock,
  input         io_rw,
  input  [9:0]  io_ad,
  input  [31:0] io_DI,
  input         io_EN,
  output [31:0] io_DO
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] mem [0:1023]; // @[RAM.scala 24:24]
  wire  mem_io_DO_MPORT_en; // @[RAM.scala 24:24]
  wire [9:0] mem_io_DO_MPORT_addr; // @[RAM.scala 24:24]
  wire [31:0] mem_io_DO_MPORT_data; // @[RAM.scala 24:24]
  wire [31:0] mem_MPORT_data; // @[RAM.scala 24:24]
  wire [9:0] mem_MPORT_addr; // @[RAM.scala 24:24]
  wire  mem_MPORT_mask; // @[RAM.scala 24:24]
  wire  mem_MPORT_en; // @[RAM.scala 24:24]
  reg  mem_io_DO_MPORT_en_pipe_0;
  reg [9:0] mem_io_DO_MPORT_addr_pipe_0;
  wire  _T = io_rw & io_EN; // @[RAM.scala 26:14]
  wire  _T_2 = ~io_rw & io_EN; // @[RAM.scala 28:21]
  assign mem_io_DO_MPORT_en = mem_io_DO_MPORT_en_pipe_0;
  assign mem_io_DO_MPORT_addr = mem_io_DO_MPORT_addr_pipe_0;
  assign mem_io_DO_MPORT_data = mem[mem_io_DO_MPORT_addr]; // @[RAM.scala 24:24]
  assign mem_MPORT_data = io_DI;
  assign mem_MPORT_addr = io_ad;
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = _T ? 1'h0 : _T_2;
  assign io_DO = io_rw & io_EN ? mem_io_DO_MPORT_data : 32'h0; // @[RAM.scala 26:23 27:11]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[RAM.scala 24:24]
    end
    mem_io_DO_MPORT_en_pipe_0 <= io_rw & io_EN;
    if (io_rw & io_EN) begin
      mem_io_DO_MPORT_addr_pipe_0 <= io_ad;
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
    mem[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mem_io_DO_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  mem_io_DO_MPORT_addr_pipe_0 = _RAND_2[9:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module RAM_2(
  input         clock,
  input         io_rw,
  input  [11:0] io_ad,
  input  [31:0] io_DI,
  input         io_EN,
  output [31:0] io_DO
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] mem [0:4095]; // @[RAM.scala 24:24]
  wire  mem_io_DO_MPORT_en; // @[RAM.scala 24:24]
  wire [11:0] mem_io_DO_MPORT_addr; // @[RAM.scala 24:24]
  wire [31:0] mem_io_DO_MPORT_data; // @[RAM.scala 24:24]
  wire [31:0] mem_MPORT_data; // @[RAM.scala 24:24]
  wire [11:0] mem_MPORT_addr; // @[RAM.scala 24:24]
  wire  mem_MPORT_mask; // @[RAM.scala 24:24]
  wire  mem_MPORT_en; // @[RAM.scala 24:24]
  reg  mem_io_DO_MPORT_en_pipe_0;
  reg [11:0] mem_io_DO_MPORT_addr_pipe_0;
  wire  _T = io_rw & io_EN; // @[RAM.scala 26:14]
  wire  _T_2 = ~io_rw & io_EN; // @[RAM.scala 28:21]
  assign mem_io_DO_MPORT_en = mem_io_DO_MPORT_en_pipe_0;
  assign mem_io_DO_MPORT_addr = mem_io_DO_MPORT_addr_pipe_0;
  assign mem_io_DO_MPORT_data = mem[mem_io_DO_MPORT_addr]; // @[RAM.scala 24:24]
  assign mem_MPORT_data = io_DI;
  assign mem_MPORT_addr = io_ad;
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = _T ? 1'h0 : _T_2;
  assign io_DO = io_rw & io_EN ? mem_io_DO_MPORT_data : 32'h0; // @[RAM.scala 26:23 27:11]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[RAM.scala 24:24]
    end
    mem_io_DO_MPORT_en_pipe_0 <= io_rw & io_EN;
    if (io_rw & io_EN) begin
      mem_io_DO_MPORT_addr_pipe_0 <= io_ad;
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
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    mem[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mem_io_DO_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  mem_io_DO_MPORT_addr_pipe_0 = _RAND_2[11:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CacheController(
  input         clock,
  input         reset,
  input         io_validReq,
  input         io_rw,
  input  [31:0] io_memAdd,
  input  [31:0] io_DI,
  output [31:0] io_DO,
  output        io_ready,
  input         io_memReady,
  output        io_cacheMiss,
  output        io_cacheValid
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  wire  tagStore_clock; // @[CacheController.scala 34:24]
  wire  tagStore_io_rw; // @[CacheController.scala 34:24]
  wire [8:0] tagStore_io_ad; // @[CacheController.scala 34:24]
  wire [31:0] tagStore_io_DI; // @[CacheController.scala 34:24]
  wire  tagStore_io_EN; // @[CacheController.scala 34:24]
  wire [31:0] tagStore_io_DO; // @[CacheController.scala 34:24]
  wire  cache_clock; // @[CacheController.scala 35:21]
  wire  cache_io_rw; // @[CacheController.scala 35:21]
  wire [9:0] cache_io_ad; // @[CacheController.scala 35:21]
  wire [31:0] cache_io_DI; // @[CacheController.scala 35:21]
  wire  cache_io_EN; // @[CacheController.scala 35:21]
  wire [31:0] cache_io_DO; // @[CacheController.scala 35:21]
  wire  extMem_clock; // @[CacheController.scala 36:22]
  wire  extMem_io_rw; // @[CacheController.scala 36:22]
  wire [11:0] extMem_io_ad; // @[CacheController.scala 36:22]
  wire [31:0] extMem_io_DI; // @[CacheController.scala 36:22]
  wire  extMem_io_EN; // @[CacheController.scala 36:22]
  wire [31:0] extMem_io_DO; // @[CacheController.scala 36:22]
  reg [31:0] lastRead; // @[CacheController.scala 33:25]
  wire [1:0] blockOffset = io_memAdd[3:2]; // @[CacheController.scala 42:30]
  wire [7:0] index = io_memAdd[11:4]; // @[CacheController.scala 43:24]
  wire [19:0] targetTag = io_memAdd[31:12]; // @[CacheController.scala 44:28]
  wire [19:0] actualTag = tagStore_io_DO[31:12]; // @[CacheController.scala 46:33]
  wire  cacheValid = tagStore_io_DO[11]; // @[CacheController.scala 47:34]
  reg [2:0] writeIndex; // @[CacheController.scala 48:27]
  reg [31:0] updatedTag; // @[CacheController.scala 49:27]
  wire [29:0] memWordAdd = io_memAdd[31:2]; // @[CacheController.scala 55:29]
  wire [9:0] cacheReadAdd = {index,blockOffset}; // @[CacheController.scala 71:25]
  wire [10:0] _cacheWriteAdd_T = {index,writeIndex}; // @[CacheController.scala 72:26]
  wire [31:0] targetTagWord = {targetTag, 12'h0}; // @[CacheController.scala 75:30]
  reg [2:0] stateReg; // @[CacheController.scala 87:25]
  wire [9:0] _GEN_3 = io_validReq ? cacheReadAdd : 10'h0; // @[CacheController.scala 106:25 108:18 54:26]
  wire  _GEN_8 = io_validReq ? io_rw : 1'h1; // @[CacheController.scala 100:13 106:25]
  wire  _T_7 = actualTag == targetTag; // @[CacheController.scala 134:28]
  wire [31:0] _GEN_10 = io_rw ? cache_io_DO : lastRead; // @[CacheController.scala 137:21 140:20 33:25]
  wire [2:0] _GEN_11 = io_rw ? 3'h0 : 3'h4; // @[CacheController.scala 137:21 141:20 146:20]
  wire [9:0] cacheWriteAdd = _cacheWriteAdd_T[9:0]; // @[CacheController.scala 51:31 72:17]
  wire [9:0] _GEN_12 = actualTag == targetTag ? cacheReadAdd : cacheWriteAdd; // @[CacheController.scala 134:43 135:18 149:18]
  wire [31:0] _GEN_14 = actualTag == targetTag ? _GEN_10 : lastRead; // @[CacheController.scala 134:43 33:25]
  wire [2:0] _GEN_15 = actualTag == targetTag ? _GEN_11 : 3'h2; // @[CacheController.scala 134:43 152:18]
  wire  _GEN_16 = actualTag == targetTag ? io_rw : 1'h1; // @[CacheController.scala 134:43 61:15]
  wire  _GEN_18 = actualTag == targetTag ? 1'h0 : 1'h1; // @[CacheController.scala 134:43 67:16 150:22]
  wire [9:0] _GEN_20 = ~cacheValid ? cacheWriteAdd : _GEN_12; // @[CacheController.scala 129:25 130:18]
  wire  _GEN_21 = ~cacheValid | _GEN_18; // @[CacheController.scala 129:25 91:13]
  wire  _GEN_24 = ~cacheValid ? 1'h0 : _T_7; // @[CacheController.scala 129:25 62:15]
  wire  _GEN_26 = ~cacheValid | _GEN_16; // @[CacheController.scala 129:25 61:15]
  wire  _GEN_28 = ~cacheValid ? 1'h0 : _GEN_18; // @[CacheController.scala 129:25 67:16]
  wire [2:0] _GEN_29 = io_memReady ? 3'h0 : stateReg; // @[CacheController.scala 164:25 165:18 87:25]
  wire [29:0] _GEN_88 = {{27'd0}, writeIndex}; // @[CacheController.scala 173:34]
  wire [29:0] _extMem_io_ad_T_1 = memWordAdd + _GEN_88; // @[CacheController.scala 173:34]
  wire [29:0] _extMem_io_ad_T_3 = _extMem_io_ad_T_1 + 30'h1; // @[CacheController.scala 173:47]
  wire [31:0] _updatedTag_T = targetTagWord | 32'h800; // @[CacheController.scala 176:35]
  wire  _T_14 = writeIndex == 3'h3; // @[CacheController.scala 178:38]
  wire  _T_15 = io_memReady & writeIndex == 3'h3; // @[CacheController.scala 178:24]
  wire [2:0] _writeIndex_T_1 = writeIndex + 3'h1; // @[CacheController.scala 186:34]
  wire [2:0] _GEN_30 = ~io_memReady & _T_14 ? 3'h3 : _writeIndex_T_1; // @[CacheController.scala 183:54 184:20 186:20]
  wire  _GEN_32 = io_memReady & writeIndex == 3'h3 ? 1'h0 : 1'h1; // @[CacheController.scala 178:47 96:13 59:18]
  wire [2:0] _GEN_33 = io_memReady & writeIndex == 3'h3 ? 3'h1 : stateReg; // @[CacheController.scala 178:47 181:18 87:25]
  wire [2:0] _GEN_34 = io_memReady & writeIndex == 3'h3 ? 3'h0 : _GEN_30; // @[CacheController.scala 178:47 182:20]
  wire  _GEN_36 = 3'h2 == stateReg ? 1'h0 : 1'h1; // @[CacheController.scala 103:20 96:13 61:15]
  wire [9:0] _GEN_37 = 3'h2 == stateReg ? cacheWriteAdd : 10'h0; // @[CacheController.scala 103:20 171:16 54:26]
  wire [29:0] _GEN_38 = 3'h2 == stateReg ? _extMem_io_ad_T_3 : memWordAdd; // @[CacheController.scala 103:20 173:20 66:16]
  wire [31:0] _GEN_39 = 3'h2 == stateReg ? extMem_io_DO : io_DI; // @[CacheController.scala 103:20 174:19 63:15]
  wire [31:0] _GEN_40 = 3'h2 == stateReg ? _updatedTag_T : updatedTag; // @[CacheController.scala 103:20 176:18 49:27]
  wire  _GEN_42 = 3'h2 == stateReg ? _GEN_32 : 1'h1; // @[CacheController.scala 103:20 59:18]
  wire [2:0] _GEN_43 = 3'h2 == stateReg ? _GEN_33 : stateReg; // @[CacheController.scala 103:20 87:25]
  wire [2:0] _GEN_44 = 3'h2 == stateReg ? _GEN_34 : writeIndex; // @[CacheController.scala 103:20 48:27]
  wire [9:0] _GEN_45 = 3'h4 == stateReg ? cacheReadAdd : _GEN_37; // @[CacheController.scala 103:20 159:16]
  wire  _GEN_46 = 3'h4 == stateReg ? 1'h0 : 1'h1; // @[CacheController.scala 103:20 160:20 64:15]
  wire  _GEN_47 = 3'h4 == stateReg | 3'h2 == stateReg; // @[CacheController.scala 103:20 161:20]
  wire [31:0] _GEN_48 = 3'h4 == stateReg ? io_DI : 32'h0; // @[CacheController.scala 103:20 162:17 53:27]
  wire  _GEN_50 = 3'h4 == stateReg ? 1'h0 : 3'h2 == stateReg; // @[CacheController.scala 103:20 62:15]
  wire  _GEN_51 = 3'h4 == stateReg | _GEN_36; // @[CacheController.scala 103:20 61:15]
  wire [29:0] _GEN_52 = 3'h4 == stateReg ? memWordAdd : _GEN_38; // @[CacheController.scala 103:20 66:16]
  wire [31:0] _GEN_53 = 3'h4 == stateReg ? io_DI : _GEN_39; // @[CacheController.scala 103:20 63:15]
  wire  _GEN_55 = 3'h4 == stateReg ? 1'h0 : 3'h2 == stateReg & _T_15; // @[CacheController.scala 103:20 60:18]
  wire  _GEN_58 = 3'h1 == stateReg | _GEN_55; // @[CacheController.scala 103:20 128:22]
  wire [9:0] _GEN_59 = 3'h1 == stateReg ? _GEN_20 : _GEN_45; // @[CacheController.scala 103:20]
  wire  _GEN_60 = 3'h1 == stateReg ? _GEN_21 : _GEN_47; // @[CacheController.scala 103:20]
  wire  _GEN_63 = 3'h1 == stateReg ? _GEN_24 : _GEN_50; // @[CacheController.scala 103:20]
  wire  _GEN_65 = 3'h1 == stateReg ? _GEN_26 : _GEN_51; // @[CacheController.scala 103:20]
  wire [31:0] _GEN_66 = 3'h1 == stateReg ? io_DI : _GEN_53; // @[CacheController.scala 103:20]
  wire [31:0] _GEN_68 = 3'h1 == stateReg ? 32'h0 : _GEN_48; // @[CacheController.scala 103:20 53:27]
  wire [29:0] _GEN_69 = 3'h1 == stateReg ? memWordAdd : _GEN_52; // @[CacheController.scala 103:20 66:16]
  wire  _GEN_71 = 3'h1 == stateReg | (3'h4 == stateReg | _GEN_42); // @[CacheController.scala 103:20 59:18]
  wire [29:0] _GEN_85 = 3'h0 == stateReg ? memWordAdd : _GEN_69; // @[CacheController.scala 103:20 66:16]
  RAM tagStore ( // @[CacheController.scala 34:24]
    .clock(tagStore_clock),
    .io_rw(tagStore_io_rw),
    .io_ad(tagStore_io_ad),
    .io_DI(tagStore_io_DI),
    .io_EN(tagStore_io_EN),
    .io_DO(tagStore_io_DO)
  );
  RAM_1 cache ( // @[CacheController.scala 35:21]
    .clock(cache_clock),
    .io_rw(cache_io_rw),
    .io_ad(cache_io_ad),
    .io_DI(cache_io_DI),
    .io_EN(cache_io_EN),
    .io_DO(cache_io_DO)
  );
  RAM_2 extMem ( // @[CacheController.scala 36:22]
    .clock(extMem_clock),
    .io_rw(extMem_io_rw),
    .io_ad(extMem_io_ad),
    .io_DI(extMem_io_DI),
    .io_EN(extMem_io_EN),
    .io_DO(extMem_io_DO)
  );
  assign io_DO = lastRead; // @[CacheController.scala 197:9]
  assign io_ready = stateReg == 3'h0; // @[CacheController.scala 194:24]
  assign io_cacheMiss = 3'h0 == stateReg ? 1'h0 : 3'h1 == stateReg & _GEN_28; // @[CacheController.scala 103:20 67:16]
  assign io_cacheValid = tagStore_io_DO[11]; // @[CacheController.scala 47:34]
  assign tagStore_clock = clock;
  assign tagStore_io_rw = 3'h0 == stateReg | _GEN_71; // @[CacheController.scala 103:20]
  assign tagStore_io_ad = {{1'd0}, index}; // @[CacheController.scala 78:18]
  assign tagStore_io_DI = updatedTag; // @[CacheController.scala 196:18]
  assign tagStore_io_EN = 3'h0 == stateReg ? io_validReq : _GEN_58; // @[CacheController.scala 103:20]
  assign cache_clock = clock;
  assign cache_io_rw = 3'h0 == stateReg ? _GEN_8 : _GEN_65; // @[CacheController.scala 103:20]
  assign cache_io_ad = 3'h0 == stateReg ? _GEN_3 : _GEN_59; // @[CacheController.scala 103:20]
  assign cache_io_DI = 3'h0 == stateReg ? io_DI : _GEN_66; // @[CacheController.scala 103:20]
  assign cache_io_EN = 3'h0 == stateReg ? io_validReq : _GEN_63; // @[CacheController.scala 103:20]
  assign extMem_clock = clock;
  assign extMem_io_rw = 3'h0 == stateReg | (3'h1 == stateReg | _GEN_46); // @[CacheController.scala 100:13 103:20]
  assign extMem_io_ad = _GEN_85[11:0];
  assign extMem_io_DI = 3'h0 == stateReg ? 32'h0 : _GEN_68; // @[CacheController.scala 103:20 53:27]
  assign extMem_io_EN = 3'h0 == stateReg ? 1'h0 : _GEN_60; // @[CacheController.scala 103:20 99:13]
  always @(posedge clock) begin
    if (reset) begin // @[CacheController.scala 33:25]
      lastRead <= 32'h0; // @[CacheController.scala 33:25]
    end else if (!(3'h0 == stateReg)) begin // @[CacheController.scala 103:20]
      if (3'h1 == stateReg) begin // @[CacheController.scala 103:20]
        if (!(~cacheValid)) begin // @[CacheController.scala 129:25]
          lastRead <= _GEN_14;
        end
      end
    end
    if (reset) begin // @[CacheController.scala 48:27]
      writeIndex <= 3'h0; // @[CacheController.scala 48:27]
    end else if (!(3'h0 == stateReg)) begin // @[CacheController.scala 103:20]
      if (!(3'h1 == stateReg)) begin // @[CacheController.scala 103:20]
        if (!(3'h4 == stateReg)) begin // @[CacheController.scala 103:20]
          writeIndex <= _GEN_44;
        end
      end
    end
    if (reset) begin // @[CacheController.scala 49:27]
      updatedTag <= 32'h0; // @[CacheController.scala 49:27]
    end else if (!(3'h0 == stateReg)) begin // @[CacheController.scala 103:20]
      if (!(3'h1 == stateReg)) begin // @[CacheController.scala 103:20]
        if (!(3'h4 == stateReg)) begin // @[CacheController.scala 103:20]
          updatedTag <= _GEN_40;
        end
      end
    end
    if (reset) begin // @[CacheController.scala 87:25]
      stateReg <= 3'h0; // @[CacheController.scala 87:25]
    end else if (3'h0 == stateReg) begin // @[CacheController.scala 103:20]
      if (io_validReq) begin // @[CacheController.scala 106:25]
        stateReg <= 3'h1; // @[CacheController.scala 110:18]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 103:20]
      if (~cacheValid) begin // @[CacheController.scala 129:25]
        stateReg <= 3'h2; // @[CacheController.scala 133:18]
      end else begin
        stateReg <= _GEN_15;
      end
    end else if (3'h4 == stateReg) begin // @[CacheController.scala 103:20]
      stateReg <= _GEN_29;
    end else begin
      stateReg <= _GEN_43;
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
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  lastRead = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  writeIndex = _RAND_1[2:0];
  _RAND_2 = {1{`RANDOM}};
  updatedTag = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  stateReg = _RAND_3[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
