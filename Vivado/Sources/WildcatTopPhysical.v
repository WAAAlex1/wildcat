module TimerCounter(
  input         clock,
  input         reset,
  input         io_instrComplete,
  input  [63:0] io_mtimecmpValue,
  output [63:0] io_currentTime,
  output        io_timerInterruptPending,
  input  [11:0] io_csrAddr,
  input         io_csrWriteEnable,
  input  [31:0] io_csrWriteData,
  output [31:0] io_csrReadData
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] cycleReg; // @[TimerCounter.scala 37:27]
  reg [63:0] timeReg; // @[TimerCounter.scala 38:27]
  reg [63:0] instretReg; // @[TimerCounter.scala 39:27]
  reg [19:0] timeCounter; // @[TimerCounter.scala 43:28]
  wire [63:0] _cycleReg_T_1 = cycleReg + 64'h1; // @[TimerCounter.scala 45:24]
  wire [63:0] _timeReg_T_1 = timeReg + 64'h1; // @[TimerCounter.scala 48:24]
  wire [19:0] _timeCounter_T_1 = timeCounter + 20'h1; // @[TimerCounter.scala 50:32]
  wire [63:0] _instretReg_T_1 = instretReg + 64'h1; // @[TimerCounter.scala 53:30]
  wire [63:0] _GEN_2 = io_instrComplete ? _instretReg_T_1 : instretReg; // @[TimerCounter.scala 52:26 53:16 39:27]
  wire  isGreaterOrEqual = timeReg >= io_mtimecmpValue; // @[TimerCounter.scala 60:36]
  wire  isValid = io_mtimecmpValue != 64'h0; // @[TimerCounter.scala 61:30]
  wire  _T_7 = 12'hb00 == io_csrAddr; // @[TimerCounter.scala 72:22]
  wire  _T_8 = 12'hb80 == io_csrAddr; // @[TimerCounter.scala 72:22]
  wire  _T_9 = 12'hb02 == io_csrAddr; // @[TimerCounter.scala 72:22]
  wire  _T_10 = 12'hb82 == io_csrAddr; // @[TimerCounter.scala 72:22]
  wire [31:0] _GEN_3 = 12'hb82 == io_csrAddr ? instretReg[63:32] : 32'h0; // @[TimerCounter.scala 72:22 71:33 83:41]
  wire [31:0] _GEN_4 = 12'hb02 == io_csrAddr ? instretReg[31:0] : _GEN_3; // @[TimerCounter.scala 72:22 82:41]
  wire [31:0] _GEN_5 = 12'hb80 == io_csrAddr ? cycleReg[63:32] : _GEN_4; // @[TimerCounter.scala 72:22 81:41]
  wire [31:0] _GEN_6 = 12'hb00 == io_csrAddr ? cycleReg[31:0] : _GEN_5; // @[TimerCounter.scala 72:22 80:41]
  wire [31:0] _GEN_7 = 12'hc82 == io_csrAddr ? instretReg[63:32] : _GEN_6; // @[TimerCounter.scala 72:22 79:41]
  wire [31:0] _GEN_8 = 12'hc02 == io_csrAddr ? instretReg[31:0] : _GEN_7; // @[TimerCounter.scala 72:22 78:41]
  wire [31:0] _GEN_9 = 12'hc81 == io_csrAddr ? timeReg[63:32] : _GEN_8; // @[TimerCounter.scala 72:22 77:41]
  wire [31:0] _GEN_10 = 12'hc01 == io_csrAddr ? timeReg[31:0] : _GEN_9; // @[TimerCounter.scala 72:22 76:41]
  wire [31:0] _GEN_11 = 12'hc80 == io_csrAddr ? cycleReg[63:32] : _GEN_10; // @[TimerCounter.scala 72:22 75:41]
  wire [63:0] _cycleReg_T_3 = {cycleReg[63:32],io_csrWriteData}; // @[Cat.scala 33:92]
  wire [63:0] _cycleReg_T_5 = {io_csrWriteData,cycleReg[31:0]}; // @[Cat.scala 33:92]
  wire [63:0] _instretReg_T_3 = {instretReg[63:32],io_csrWriteData}; // @[Cat.scala 33:92]
  wire [63:0] _instretReg_T_5 = {io_csrWriteData,instretReg[31:0]}; // @[Cat.scala 33:92]
  wire [63:0] _GEN_13 = _T_10 ? _instretReg_T_5 : _GEN_2; // @[TimerCounter.scala 89:24 94:41]
  wire [63:0] _GEN_14 = _T_9 ? _instretReg_T_3 : _GEN_13; // @[TimerCounter.scala 89:24 93:41]
  assign io_currentTime = timeReg; // @[TimerCounter.scala 68:18]
  assign io_timerInterruptPending = isGreaterOrEqual & isValid; // @[TimerCounter.scala 62:48]
  assign io_csrReadData = 12'hc00 == io_csrAddr ? cycleReg[31:0] : _GEN_11; // @[TimerCounter.scala 72:22 74:41]
  always @(posedge clock) begin
    if (reset) begin // @[TimerCounter.scala 37:27]
      cycleReg <= 64'h0; // @[TimerCounter.scala 37:27]
    end else if (io_csrWriteEnable) begin // @[TimerCounter.scala 88:27]
      if (_T_7) begin // @[TimerCounter.scala 89:24]
        cycleReg <= _cycleReg_T_3; // @[TimerCounter.scala 91:39]
      end else if (_T_8) begin // @[TimerCounter.scala 89:24]
        cycleReg <= _cycleReg_T_5; // @[TimerCounter.scala 92:39]
      end else begin
        cycleReg <= _cycleReg_T_1; // @[TimerCounter.scala 45:12]
      end
    end else begin
      cycleReg <= _cycleReg_T_1; // @[TimerCounter.scala 45:12]
    end
    if (reset) begin // @[TimerCounter.scala 38:27]
      timeReg <= 64'h0; // @[TimerCounter.scala 38:27]
    end else if (timeCounter == 20'h927bf) begin // @[TimerCounter.scala 46:56]
      timeReg <= _timeReg_T_1; // @[TimerCounter.scala 48:13]
    end
    if (reset) begin // @[TimerCounter.scala 39:27]
      instretReg <= 64'h0; // @[TimerCounter.scala 39:27]
    end else if (io_csrWriteEnable) begin // @[TimerCounter.scala 88:27]
      if (_T_7) begin // @[TimerCounter.scala 89:24]
        instretReg <= _GEN_2;
      end else if (_T_8) begin // @[TimerCounter.scala 89:24]
        instretReg <= _GEN_2;
      end else begin
        instretReg <= _GEN_14;
      end
    end else begin
      instretReg <= _GEN_2;
    end
    if (reset) begin // @[TimerCounter.scala 43:28]
      timeCounter <= 20'h0; // @[TimerCounter.scala 43:28]
    end else if (timeCounter == 20'h927bf) begin // @[TimerCounter.scala 46:56]
      timeCounter <= 20'h0; // @[TimerCounter.scala 47:17]
    end else begin
      timeCounter <= _timeCounter_T_1; // @[TimerCounter.scala 50:17]
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
  _RAND_0 = {2{`RANDOM}};
  cycleReg = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  timeReg = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  instretReg = _RAND_2[63:0];
  _RAND_3 = {1{`RANDOM}};
  timeCounter = _RAND_3[19:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module InterruptController(
  input         clock,
  input         reset,
  input  [11:0] io_csrReadAddr,
  input  [11:0] io_csrWriteAddr,
  input         io_csrWriteEnable,
  input  [31:0] io_csrWriteData,
  output [31:0] io_csrReadData,
  input         io_timerInterruptPendingIn,
  output        io_interruptRequest,
  output [31:0] io_interruptCause,
  output        io_mstatusInterruptEnable,
  output        io_timerInterruptEnabled,
  input         io_takeTrap,
  input         io_mret_executing
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg  mstatus_mie; // @[InterruptController.scala 40:28]
  reg  mstatus_mpie; // @[InterruptController.scala 41:29]
  reg  mie_mtie; // @[InterruptController.scala 42:28]
  reg  mip_mtip; // @[InterruptController.scala 43:28]
  wire  timerInterruptActive = mstatus_mie & mie_mtie & mip_mtip; // @[InterruptController.scala 49:54]
  wire [31:0] _readDataWire_T_3 = {24'h0,mstatus_mpie,3'h0,mstatus_mie,3'h0}; // @[Cat.scala 33:92]
  wire [31:0] _readDataWire_T_6 = {24'h0,mie_mtie,7'h0}; // @[Cat.scala 33:92]
  wire [31:0] _readDataWire_T_9 = {24'h0,mip_mtip,7'h0}; // @[Cat.scala 33:92]
  wire [31:0] _GEN_0 = 12'h344 == io_csrReadAddr ? _readDataWire_T_9 : 32'h0; // @[InterruptController.scala 59:26 82:20 54:33]
  wire [31:0] _GEN_1 = 12'h304 == io_csrReadAddr ? _readDataWire_T_6 : _GEN_0; // @[InterruptController.scala 59:26 74:20]
  wire [31:0] maskedWriteData = io_csrWriteData & 32'h88; // @[InterruptController.scala 96:45]
  wire [31:0] maskedWriteData_1 = io_csrWriteData & 32'h80; // @[InterruptController.scala 106:47]
  wire  _GEN_7 = io_csrWriteAddr == 12'h300 ? maskedWriteData[3] : mstatus_mie; // @[InterruptController.scala 40:28 93:45]
  wire  _GEN_8 = io_csrWriteAddr == 12'h300 ? maskedWriteData[7] : mstatus_mpie; // @[InterruptController.scala 41:29 93:45]
  wire  _GEN_11 = io_csrWriteEnable ? _GEN_8 : mstatus_mpie; // @[InterruptController.scala 92:27 41:29]
  wire  _T_6 = ~reset; // @[InterruptController.scala 117:11]
  wire  _GEN_13 = io_takeTrap ? mstatus_mie : _GEN_11; // @[InterruptController.scala 114:21 115:18]
  wire  _GEN_16 = io_mret_executing | _GEN_13; // @[InterruptController.scala 122:27 124:18]
  assign io_csrReadData = 12'h300 == io_csrReadAddr ? _readDataWire_T_3 : _GEN_1; // @[InterruptController.scala 59:26 64:20]
  assign io_interruptRequest = mstatus_mie & mie_mtie & mip_mtip; // @[InterruptController.scala 49:54]
  assign io_interruptCause = timerInterruptActive ? 32'h80000007 : 32'h0; // @[InterruptController.scala 51:27]
  assign io_mstatusInterruptEnable = mstatus_mie; // @[InterruptController.scala 129:29]
  assign io_timerInterruptEnabled = mie_mtie; // @[InterruptController.scala 130:28]
  always @(posedge clock) begin
    if (reset) begin // @[InterruptController.scala 40:28]
      mstatus_mie <= 1'h0; // @[InterruptController.scala 40:28]
    end else if (io_mret_executing) begin // @[InterruptController.scala 122:27]
      mstatus_mie <= mstatus_mpie; // @[InterruptController.scala 123:17]
    end else if (io_takeTrap) begin // @[InterruptController.scala 114:21]
      mstatus_mie <= 1'h0; // @[InterruptController.scala 116:17]
    end else if (io_csrWriteEnable) begin // @[InterruptController.scala 92:27]
      mstatus_mie <= _GEN_7;
    end
    mstatus_mpie <= reset | _GEN_16; // @[InterruptController.scala 41:{29,29}]
    if (reset) begin // @[InterruptController.scala 42:28]
      mie_mtie <= 1'h0; // @[InterruptController.scala 42:28]
    end else if (io_csrWriteEnable) begin // @[InterruptController.scala 92:27]
      if (!(io_csrWriteAddr == 12'h300)) begin // @[InterruptController.scala 93:45]
        if (io_csrWriteAddr == 12'h304) begin // @[InterruptController.scala 103:48]
          mie_mtie <= maskedWriteData_1[7];
        end
      end
    end
    if (reset) begin // @[InterruptController.scala 43:28]
      mip_mtip <= 1'h0; // @[InterruptController.scala 43:28]
    end else begin
      mip_mtip <= io_timerInterruptPendingIn; // @[InterruptController.scala 46:12]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_takeTrap & ~reset) begin
          $fwrite(32'h80000002,"[InterruptController] Trap Taken: MIE(%b) -> MPIE, MIE -> false\n",mstatus_mie); // @[InterruptController.scala 117:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_mret_executing & _T_6) begin
          $fwrite(32'h80000002,"[InterruptController] MRET Executing: MIE <- MPIE(%b), MPIE -> true\n",mstatus_mpie); // @[InterruptController.scala 125:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
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
  mstatus_mie = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  mstatus_mpie = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  mie_mtie = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  mip_mtip = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Csr(
  input         clock,
  input         reset,
  input  [11:0] io_readAddress,
  input  [11:0] io_writeAddress,
  input         io_readEnable,
  input         io_writeEnable,
  input  [31:0] io_writeData,
  input         io_instrComplete,
  input  [31:0] io_exceptionCause,
  input         io_takeTrap,
  input         io_trapIsInterrupt,
  input  [31:0] io_trapPC,
  input  [31:0] io_trapInstruction,
  input  [63:0] io_mtimecmpVal,
  input         io_mret_executing,
  output [31:0] io_data,
  output [31:0] io_mretTarget,
  output [31:0] io_trapVector,
  output [63:0] io_timerCounter,
  output        io_interruptRequest,
  output [31:0] io_interruptCause,
  output        io_globalInterruptEnabled,
  output        io_timerInterruptEnabled
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
`endif // RANDOMIZE_REG_INIT
  wire  timerCounter_clock; // @[Csr.scala 51:28]
  wire  timerCounter_reset; // @[Csr.scala 51:28]
  wire  timerCounter_io_instrComplete; // @[Csr.scala 51:28]
  wire [63:0] timerCounter_io_mtimecmpValue; // @[Csr.scala 51:28]
  wire [63:0] timerCounter_io_currentTime; // @[Csr.scala 51:28]
  wire  timerCounter_io_timerInterruptPending; // @[Csr.scala 51:28]
  wire [11:0] timerCounter_io_csrAddr; // @[Csr.scala 51:28]
  wire  timerCounter_io_csrWriteEnable; // @[Csr.scala 51:28]
  wire [31:0] timerCounter_io_csrWriteData; // @[Csr.scala 51:28]
  wire [31:0] timerCounter_io_csrReadData; // @[Csr.scala 51:28]
  wire  interruptController_clock; // @[Csr.scala 60:35]
  wire  interruptController_reset; // @[Csr.scala 60:35]
  wire [11:0] interruptController_io_csrReadAddr; // @[Csr.scala 60:35]
  wire [11:0] interruptController_io_csrWriteAddr; // @[Csr.scala 60:35]
  wire  interruptController_io_csrWriteEnable; // @[Csr.scala 60:35]
  wire [31:0] interruptController_io_csrWriteData; // @[Csr.scala 60:35]
  wire [31:0] interruptController_io_csrReadData; // @[Csr.scala 60:35]
  wire  interruptController_io_timerInterruptPendingIn; // @[Csr.scala 60:35]
  wire  interruptController_io_interruptRequest; // @[Csr.scala 60:35]
  wire [31:0] interruptController_io_interruptCause; // @[Csr.scala 60:35]
  wire  interruptController_io_mstatusInterruptEnable; // @[Csr.scala 60:35]
  wire  interruptController_io_timerInterruptEnabled; // @[Csr.scala 60:35]
  wire  interruptController_io_takeTrap; // @[Csr.scala 60:35]
  wire  interruptController_io_mret_executing; // @[Csr.scala 60:35]
  reg [31:0] csrMem [0:4095]; // @[Csr.scala 78:27]
  wire  csrMem_readDataInternal_MPORT_en; // @[Csr.scala 78:27]
  wire [11:0] csrMem_readDataInternal_MPORT_addr; // @[Csr.scala 78:27]
  wire [31:0] csrMem_readDataInternal_MPORT_data; // @[Csr.scala 78:27]
  wire [31:0] csrMem_MPORT_data; // @[Csr.scala 78:27]
  wire [11:0] csrMem_MPORT_addr; // @[Csr.scala 78:27]
  wire  csrMem_MPORT_mask; // @[Csr.scala 78:27]
  wire  csrMem_MPORT_en; // @[Csr.scala 78:27]
  reg  csrMem_readDataInternal_MPORT_en_pipe_0;
  reg [11:0] csrMem_readDataInternal_MPORT_addr_pipe_0;
  wire  _timerCounter_io_csrWriteEnable_T_3 = io_writeAddress == 12'hc01; // @[Csr.scala 227:13]
  wire  _timerCounter_io_csrWriteEnable_T_4 = io_writeAddress == 12'hc00 | io_writeAddress == 12'hc80 |
    _timerCounter_io_csrWriteEnable_T_3; // @[Csr.scala 226:55]
  wire  _timerCounter_io_csrWriteEnable_T_7 = io_writeAddress == 12'hc02; // @[Csr.scala 228:13]
  wire  _timerCounter_io_csrWriteEnable_T_8 = _timerCounter_io_csrWriteEnable_T_4 | io_writeAddress == 12'hc81 |
    _timerCounter_io_csrWriteEnable_T_7; // @[Csr.scala 227:55]
  wire  _timerCounter_io_csrWriteEnable_T_11 = io_writeAddress == 12'hb00; // @[Csr.scala 229:13]
  wire  _timerCounter_io_csrWriteEnable_T_12 = _timerCounter_io_csrWriteEnable_T_8 | io_writeAddress == 12'hc82 |
    _timerCounter_io_csrWriteEnable_T_11; // @[Csr.scala 228:61]
  wire  _timerCounter_io_csrWriteEnable_T_15 = io_writeAddress == 12'hb02; // @[Csr.scala 230:13]
  wire  _timerCounter_io_csrWriteEnable_T_16 = _timerCounter_io_csrWriteEnable_T_12 | io_writeAddress == 12'hb80 |
    _timerCounter_io_csrWriteEnable_T_15; // @[Csr.scala 229:59]
  wire  _timerCounter_io_csrWriteEnable_T_18 = _timerCounter_io_csrWriteEnable_T_16 | io_writeAddress == 12'hb82; // @[Csr.scala 230:33]
  wire  _interruptController_io_csrWriteEnable_T_3 = io_writeAddress == 12'h344; // @[Csr.scala 234:63]
  wire  _interruptController_io_csrWriteEnable_T_4 = io_writeAddress == 12'h300 | io_writeAddress == 12'h304 |
    io_writeAddress == 12'h344; // @[Csr.scala 234:54]
  reg [31:0] mepcReg; // @[Csr.scala 81:26]
  reg [31:0] mcauseReg; // @[Csr.scala 82:26]
  reg [31:0] mtvalReg; // @[Csr.scala 83:26]
  reg [31:0] mtvecReg; // @[Csr.scala 84:26]
  reg [11:0] lastWriteAddr; // @[Csr.scala 89:30]
  wire [3:0] lastWriteEnable_upperBits = io_writeAddress[11:8]; // @[Csr.scala 214:25]
  wire  lastWriteEnable_isStandardReadOnlyRange = lastWriteEnable_upperBits == 4'hc | lastWriteEnable_upperBits == 4'hd; // @[Csr.scala 216:61]
  wire  _lastWriteEnable_specificReadOnly_T_3 = io_writeAddress == 12'hf10; // @[Csr.scala 220:13]
  wire  _lastWriteEnable_specificReadOnly_T_4 = io_writeAddress == 12'hf12 | io_writeAddress == 12'hf11 |
    _lastWriteEnable_specificReadOnly_T_3; // @[Csr.scala 219:83]
  wire  lastWriteEnable_specificReadOnly = _lastWriteEnable_specificReadOnly_T_4 |
    _interruptController_io_csrWriteEnable_T_3; // @[Csr.scala 220:31]
  wire  _lastWriteEnable_T = lastWriteEnable_isStandardReadOnlyRange | lastWriteEnable_specificReadOnly; // @[Csr.scala 222:29]
  wire  _lastWriteEnable_T_1 = ~_lastWriteEnable_T; // @[Csr.scala 92:51]
  reg  lastWriteEnable; // @[Csr.scala 92:32]
  reg [31:0] lastWriteData; // @[Csr.scala 93:30]
  wire  _lastTrapWriteAddr_T = io_writeAddress == 12'h341; // @[Csr.scala 99:27]
  wire  _lastTrapWriteAddr_T_1 = io_writeAddress == 12'h342; // @[Csr.scala 100:29]
  wire  _lastTrapWriteAddr_T_2 = io_writeAddress == 12'h343; // @[Csr.scala 101:31]
  wire [9:0] _lastTrapWriteAddr_T_3 = io_writeAddress == 12'h343 ? 10'h343 : 10'h0; // @[Csr.scala 101:14]
  reg [9:0] lastTrapWriteAddr; // @[Csr.scala 97:34]
  reg  lastTrapOccurred; // @[Csr.scala 103:33]
  reg [31:0] lastTrapPC; // @[Csr.scala 104:27]
  wire [31:0] _lastTrapCause_T = io_trapIsInterrupt ? io_interruptCause : io_exceptionCause; // @[Csr.scala 105:34]
  reg [31:0] lastTrapCause; // @[Csr.scala 105:30]
  wire [31:0] _lastTrapValue_T = io_trapIsInterrupt ? 32'h0 : io_trapInstruction; // @[Csr.scala 106:34]
  reg [31:0] lastTrapValue; // @[Csr.scala 106:30]
  wire [31:0] _GEN_2 = io_takeTrap ? io_trapPC : mepcReg; // @[Csr.scala 111:21 112:13 81:26]
  wire [31:0] _GEN_3 = io_takeTrap ? _lastTrapCause_T : mcauseReg; // @[Csr.scala 111:21 82:26]
  wire [31:0] _GEN_4 = io_takeTrap ? _lastTrapValue_T : mtvalReg; // @[Csr.scala 111:21 83:26]
  wire  _T_8 = io_readAddress == 12'h300 | io_readAddress == 12'h304 | io_readAddress == 12'h344; // @[Csr.scala 234:54]
  wire  _T_12 = io_readAddress == 12'hc01; // @[Csr.scala 227:13]
  wire  _T_13 = io_readAddress == 12'hc00 | io_readAddress == 12'hc80 | _T_12; // @[Csr.scala 226:55]
  wire  _T_16 = io_readAddress == 12'hc02; // @[Csr.scala 228:13]
  wire  _T_17 = _T_13 | io_readAddress == 12'hc81 | _T_16; // @[Csr.scala 227:55]
  wire  _T_20 = io_readAddress == 12'hb00; // @[Csr.scala 229:13]
  wire  _T_21 = _T_17 | io_readAddress == 12'hc82 | _T_20; // @[Csr.scala 228:61]
  wire  _T_24 = io_readAddress == 12'hb02; // @[Csr.scala 230:13]
  wire  _T_25 = _T_21 | io_readAddress == 12'hb80 | _T_24; // @[Csr.scala 229:59]
  wire  _T_27 = _T_25 | io_readAddress == 12'hb82; // @[Csr.scala 230:33]
  wire [31:0] _GEN_9 = io_readAddress == 12'hf10 ? 32'h0 : csrMem_readDataInternal_MPORT_data; // @[Csr.scala 144:{51,70} 147:24]
  wire  _GEN_10 = io_readAddress == 12'hf10 ? 1'h0 : io_readEnable; // @[Csr.scala 144:51 78:27]
  wire [31:0] _GEN_13 = io_readAddress == 12'h301 ? 32'h40000101 : _GEN_9; // @[Csr.scala 143:{51,70}]
  wire  _GEN_14 = io_readAddress == 12'h301 ? 1'h0 : _GEN_10; // @[Csr.scala 143:51 78:27]
  wire [31:0] _GEN_17 = io_readAddress == 12'hf11 ? 32'h0 : _GEN_13; // @[Csr.scala 142:{51,70}]
  wire  _GEN_18 = io_readAddress == 12'hf11 ? 1'h0 : _GEN_14; // @[Csr.scala 142:51 78:27]
  wire [31:0] _GEN_21 = io_readAddress == 12'hf12 ? 32'h2f : _GEN_17; // @[Csr.scala 141:{51,70}]
  wire  _GEN_22 = io_readAddress == 12'hf12 ? 1'h0 : _GEN_18; // @[Csr.scala 141:51 78:27]
  wire [31:0] _GEN_25 = io_readAddress == 12'h305 ? mtvecReg : _GEN_21; // @[Csr.scala 139:{51,70}]
  wire  _GEN_26 = io_readAddress == 12'h305 ? 1'h0 : _GEN_22; // @[Csr.scala 139:51 78:27]
  wire [31:0] _GEN_29 = io_readAddress == 12'h343 ? mtvalReg : _GEN_25; // @[Csr.scala 138:{51,70}]
  wire  _GEN_30 = io_readAddress == 12'h343 ? 1'h0 : _GEN_26; // @[Csr.scala 138:51 78:27]
  wire [31:0] _GEN_33 = io_readAddress == 12'h342 ? mcauseReg : _GEN_29; // @[Csr.scala 137:{51,70}]
  wire  _GEN_34 = io_readAddress == 12'h342 ? 1'h0 : _GEN_30; // @[Csr.scala 137:51 78:27]
  wire [31:0] _GEN_37 = io_readAddress == 12'h341 ? mepcReg : _GEN_33; // @[Csr.scala 136:{51,70}]
  wire  _GEN_38 = io_readAddress == 12'h341 ? 1'h0 : _GEN_34; // @[Csr.scala 136:51 78:27]
  wire [31:0] _GEN_41 = _T_27 ? timerCounter_io_csrReadData : _GEN_37; // @[Csr.scala 132:44 133:24]
  wire  _GEN_42 = _T_27 ? 1'h0 : _GEN_38; // @[Csr.scala 132:44 78:27]
  wire [31:0] readDataInternal = _T_8 ? interruptController_io_csrReadData : _GEN_41; // @[Csr.scala 130:40 131:22]
  wire  _io_data_T_5 = io_readEnable & io_writeEnable & io_readAddress == io_writeAddress & _lastWriteEnable_T_1; // @[Csr.scala 156:78]
  wire  _io_data_T_6 = io_readEnable & io_takeTrap; // @[Csr.scala 159:20]
  wire [31:0] _io_data_T_10 = 12'h341 == io_readAddress ? io_trapPC : readDataInternal; // @[Mux.scala 81:58]
  wire [31:0] _io_data_T_12 = 12'h342 == io_readAddress ? _lastTrapCause_T : _io_data_T_10; // @[Mux.scala 81:58]
  wire [31:0] _io_data_T_14 = 12'h343 == io_readAddress ? _lastTrapValue_T : _io_data_T_12; // @[Mux.scala 81:58]
  wire  _io_data_T_17 = io_readEnable & lastWriteEnable & io_readAddress == lastWriteAddr; // @[Csr.scala 167:39]
  wire [11:0] _GEN_111 = {{2'd0}, lastTrapWriteAddr}; // @[Csr.scala 170:59]
  wire  _io_data_T_20 = io_readEnable & lastTrapOccurred & io_readAddress == _GEN_111; // @[Csr.scala 170:40]
  wire [31:0] _io_data_T_22 = 12'h341 == io_readAddress ? lastTrapPC : readDataInternal; // @[Mux.scala 81:58]
  wire [31:0] _io_data_T_24 = 12'h342 == io_readAddress ? lastTrapCause : _io_data_T_22; // @[Mux.scala 81:58]
  wire [31:0] _io_data_T_26 = 12'h343 == io_readAddress ? lastTrapValue : _io_data_T_24; // @[Mux.scala 81:58]
  wire [31:0] _io_data_T_27 = _io_data_T_20 ? _io_data_T_26 : readDataInternal; // @[Mux.scala 101:16]
  wire [31:0] _io_data_T_28 = _io_data_T_17 ? lastWriteData : _io_data_T_27; // @[Mux.scala 101:16]
  wire [31:0] _io_data_T_29 = _io_data_T_6 ? _io_data_T_14 : _io_data_T_28; // @[Mux.scala 101:16]
  wire [31:0] _mepcReg_T_1 = io_writeData & 32'hfffffffc; // @[Csr.scala 188:79]
  wire [31:0] _mtvecReg_T_1 = io_writeData & 32'hfffffffe; // @[Csr.scala 191:79]
  wire [31:0] _GEN_54 = io_writeAddress == 12'h305 ? _mtvecReg_T_1 : mtvecReg; // @[Csr.scala 191:{52,63} 84:26]
  wire  _GEN_57 = io_writeAddress == 12'h305 ? 1'h0 : _lastWriteEnable_T_1; // @[Csr.scala 191:52 78:27]
  wire [31:0] _GEN_60 = _lastTrapWriteAddr_T_2 ? io_writeData : _GEN_4; // @[Csr.scala 190:{52,63}]
  wire [31:0] _GEN_61 = _lastTrapWriteAddr_T_2 ? mtvecReg : _GEN_54; // @[Csr.scala 190:52 84:26]
  wire  _GEN_64 = _lastTrapWriteAddr_T_2 ? 1'h0 : _GEN_57; // @[Csr.scala 190:52 78:27]
  wire [31:0] _GEN_67 = _lastTrapWriteAddr_T_1 ? io_writeData : _GEN_3; // @[Csr.scala 189:{52,63}]
  wire [31:0] _GEN_68 = _lastTrapWriteAddr_T_1 ? _GEN_4 : _GEN_60; // @[Csr.scala 189:52]
  wire [31:0] _GEN_69 = _lastTrapWriteAddr_T_1 ? mtvecReg : _GEN_61; // @[Csr.scala 189:52 84:26]
  wire  _GEN_72 = _lastTrapWriteAddr_T_1 ? 1'h0 : _GEN_64; // @[Csr.scala 189:52 78:27]
  wire [31:0] _GEN_75 = _lastTrapWriteAddr_T ? _mepcReg_T_1 : _GEN_2; // @[Csr.scala 188:{52,63}]
  wire [31:0] _GEN_76 = _lastTrapWriteAddr_T ? _GEN_3 : _GEN_67; // @[Csr.scala 188:52]
  wire [31:0] _GEN_77 = _lastTrapWriteAddr_T ? _GEN_4 : _GEN_68; // @[Csr.scala 188:52]
  wire [31:0] _GEN_78 = _lastTrapWriteAddr_T ? mtvecReg : _GEN_69; // @[Csr.scala 188:52 84:26]
  wire  _GEN_81 = _lastTrapWriteAddr_T ? 1'h0 : _GEN_72; // @[Csr.scala 188:52 78:27]
  wire  _GEN_90 = _timerCounter_io_csrWriteEnable_T_18 ? 1'h0 : _GEN_81; // @[Csr.scala 184:47 78:27]
  wire  _GEN_99 = _interruptController_io_csrWriteEnable_T_4 ? 1'h0 : _GEN_90; // @[Csr.scala 182:43 78:27]
  TimerCounter timerCounter ( // @[Csr.scala 51:28]
    .clock(timerCounter_clock),
    .reset(timerCounter_reset),
    .io_instrComplete(timerCounter_io_instrComplete),
    .io_mtimecmpValue(timerCounter_io_mtimecmpValue),
    .io_currentTime(timerCounter_io_currentTime),
    .io_timerInterruptPending(timerCounter_io_timerInterruptPending),
    .io_csrAddr(timerCounter_io_csrAddr),
    .io_csrWriteEnable(timerCounter_io_csrWriteEnable),
    .io_csrWriteData(timerCounter_io_csrWriteData),
    .io_csrReadData(timerCounter_io_csrReadData)
  );
  InterruptController interruptController ( // @[Csr.scala 60:35]
    .clock(interruptController_clock),
    .reset(interruptController_reset),
    .io_csrReadAddr(interruptController_io_csrReadAddr),
    .io_csrWriteAddr(interruptController_io_csrWriteAddr),
    .io_csrWriteEnable(interruptController_io_csrWriteEnable),
    .io_csrWriteData(interruptController_io_csrWriteData),
    .io_csrReadData(interruptController_io_csrReadData),
    .io_timerInterruptPendingIn(interruptController_io_timerInterruptPendingIn),
    .io_interruptRequest(interruptController_io_interruptRequest),
    .io_interruptCause(interruptController_io_interruptCause),
    .io_mstatusInterruptEnable(interruptController_io_mstatusInterruptEnable),
    .io_timerInterruptEnabled(interruptController_io_timerInterruptEnabled),
    .io_takeTrap(interruptController_io_takeTrap),
    .io_mret_executing(interruptController_io_mret_executing)
  );
  assign csrMem_readDataInternal_MPORT_en = csrMem_readDataInternal_MPORT_en_pipe_0;
  assign csrMem_readDataInternal_MPORT_addr = csrMem_readDataInternal_MPORT_addr_pipe_0;
  assign csrMem_readDataInternal_MPORT_data = csrMem[csrMem_readDataInternal_MPORT_addr]; // @[Csr.scala 78:27]
  assign csrMem_MPORT_data = io_writeData;
  assign csrMem_MPORT_addr = io_writeAddress;
  assign csrMem_MPORT_mask = 1'h1;
  assign csrMem_MPORT_en = io_writeEnable & _GEN_99;
  assign io_data = _io_data_T_5 ? io_writeData : _io_data_T_29; // @[Mux.scala 101:16]
  assign io_mretTarget = mepcReg; // @[Csr.scala 204:17]
  assign io_trapVector = mtvecReg; // @[Csr.scala 205:17]
  assign io_timerCounter = timerCounter_io_currentTime; // @[Csr.scala 57:35]
  assign io_interruptRequest = interruptController_io_interruptRequest; // @[Csr.scala 71:23]
  assign io_interruptCause = interruptController_io_interruptCause; // @[Csr.scala 72:23]
  assign io_globalInterruptEnabled = interruptController_io_mstatusInterruptEnable; // @[Csr.scala 206:29]
  assign io_timerInterruptEnabled = interruptController_io_timerInterruptEnabled; // @[Csr.scala 207:28]
  assign timerCounter_clock = clock;
  assign timerCounter_reset = reset;
  assign timerCounter_io_instrComplete = io_instrComplete; // @[Csr.scala 52:35]
  assign timerCounter_io_mtimecmpValue = io_mtimecmpVal; // @[Csr.scala 56:35]
  assign timerCounter_io_csrAddr = io_readAddress; // @[Csr.scala 53:35]
  assign timerCounter_io_csrWriteEnable = io_writeEnable & _timerCounter_io_csrWriteEnable_T_18; // @[Csr.scala 54:53]
  assign timerCounter_io_csrWriteData = io_writeData; // @[Csr.scala 55:35]
  assign interruptController_clock = clock;
  assign interruptController_reset = reset;
  assign interruptController_io_csrReadAddr = io_readAddress; // @[Csr.scala 62:41]
  assign interruptController_io_csrWriteAddr = io_writeAddress; // @[Csr.scala 63:41]
  assign interruptController_io_csrWriteEnable = io_writeEnable & _interruptController_io_csrWriteEnable_T_4; // @[Csr.scala 64:59]
  assign interruptController_io_csrWriteData = io_writeData; // @[Csr.scala 65:41]
  assign interruptController_io_timerInterruptPendingIn = timerCounter_io_timerInterruptPending; // @[Csr.scala 61:50]
  assign interruptController_io_takeTrap = io_takeTrap; // @[Csr.scala 66:41]
  assign interruptController_io_mret_executing = io_mret_executing; // @[Csr.scala 68:41]
  always @(posedge clock) begin
    if (csrMem_MPORT_en & csrMem_MPORT_mask) begin
      csrMem[csrMem_MPORT_addr] <= csrMem_MPORT_data; // @[Csr.scala 78:27]
    end
    if (_T_8) begin
      csrMem_readDataInternal_MPORT_en_pipe_0 <= 1'h0;
    end else if (_T_27) begin // @[Csr.scala 132:44]
      csrMem_readDataInternal_MPORT_en_pipe_0 <= 1'h0; // @[Csr.scala 78:27]
    end else if (io_readAddress == 12'h341) begin // @[Csr.scala 136:51]
      csrMem_readDataInternal_MPORT_en_pipe_0 <= 1'h0; // @[Csr.scala 78:27]
    end else if (io_readAddress == 12'h342) begin // @[Csr.scala 137:51]
      csrMem_readDataInternal_MPORT_en_pipe_0 <= 1'h0; // @[Csr.scala 78:27]
    end else begin
      csrMem_readDataInternal_MPORT_en_pipe_0 <= _GEN_30;
    end
    if (_T_8 ? 1'h0 : _GEN_42) begin
      csrMem_readDataInternal_MPORT_addr_pipe_0 <= io_readAddress;
    end
    if (reset) begin // @[Csr.scala 81:26]
      mepcReg <= 32'h0; // @[Csr.scala 81:26]
    end else if (io_writeEnable) begin // @[Csr.scala 180:24]
      if (_interruptController_io_csrWriteEnable_T_4) begin // @[Csr.scala 182:43]
        mepcReg <= _GEN_2;
      end else if (_timerCounter_io_csrWriteEnable_T_18) begin // @[Csr.scala 184:47]
        mepcReg <= _GEN_2;
      end else begin
        mepcReg <= _GEN_75;
      end
    end else begin
      mepcReg <= _GEN_2;
    end
    if (reset) begin // @[Csr.scala 82:26]
      mcauseReg <= 32'h0; // @[Csr.scala 82:26]
    end else if (io_writeEnable) begin // @[Csr.scala 180:24]
      if (_interruptController_io_csrWriteEnable_T_4) begin // @[Csr.scala 182:43]
        mcauseReg <= _GEN_3;
      end else if (_timerCounter_io_csrWriteEnable_T_18) begin // @[Csr.scala 184:47]
        mcauseReg <= _GEN_3;
      end else begin
        mcauseReg <= _GEN_76;
      end
    end else begin
      mcauseReg <= _GEN_3;
    end
    if (reset) begin // @[Csr.scala 83:26]
      mtvalReg <= 32'h0; // @[Csr.scala 83:26]
    end else if (io_writeEnable) begin // @[Csr.scala 180:24]
      if (_interruptController_io_csrWriteEnable_T_4) begin // @[Csr.scala 182:43]
        mtvalReg <= _GEN_4;
      end else if (_timerCounter_io_csrWriteEnable_T_18) begin // @[Csr.scala 184:47]
        mtvalReg <= _GEN_4;
      end else begin
        mtvalReg <= _GEN_77;
      end
    end else begin
      mtvalReg <= _GEN_4;
    end
    if (reset) begin // @[Csr.scala 84:26]
      mtvecReg <= 32'h0; // @[Csr.scala 84:26]
    end else if (io_writeEnable) begin // @[Csr.scala 180:24]
      if (!(_interruptController_io_csrWriteEnable_T_4)) begin // @[Csr.scala 182:43]
        if (!(_timerCounter_io_csrWriteEnable_T_18)) begin // @[Csr.scala 184:47]
          mtvecReg <= _GEN_78;
        end
      end
    end
    lastWriteAddr <= io_writeAddress; // @[Csr.scala 89:30]
    if (reset) begin // @[Csr.scala 92:32]
      lastWriteEnable <= 1'h0; // @[Csr.scala 92:32]
    end else begin
      lastWriteEnable <= io_writeEnable & ~_lastWriteEnable_T & ~_interruptController_io_csrWriteEnable_T_4 & ~
        _timerCounter_io_csrWriteEnable_T_18; // @[Csr.scala 92:32]
    end
    lastWriteData <= io_writeData; // @[Csr.scala 93:30]
    if (io_takeTrap) begin // @[Csr.scala 97:38]
      if (io_trapIsInterrupt) begin // @[Csr.scala 98:8]
        lastTrapWriteAddr <= 10'h0;
      end else if (io_writeAddress == 12'h341) begin // @[Csr.scala 99:10]
        lastTrapWriteAddr <= 10'h341;
      end else if (io_writeAddress == 12'h342) begin // @[Csr.scala 100:12]
        lastTrapWriteAddr <= 10'h342;
      end else begin
        lastTrapWriteAddr <= _lastTrapWriteAddr_T_3;
      end
    end else begin
      lastTrapWriteAddr <= 10'h0;
    end
    if (reset) begin // @[Csr.scala 103:33]
      lastTrapOccurred <= 1'h0; // @[Csr.scala 103:33]
    end else begin
      lastTrapOccurred <= io_takeTrap; // @[Csr.scala 103:33]
    end
    lastTrapPC <= io_trapPC; // @[Csr.scala 104:27]
    if (io_trapIsInterrupt) begin // @[Csr.scala 105:34]
      lastTrapCause <= io_interruptCause;
    end else begin
      lastTrapCause <= io_exceptionCause;
    end
    if (io_trapIsInterrupt) begin // @[Csr.scala 106:34]
      lastTrapValue <= 32'h0;
    end else begin
      lastTrapValue <= io_trapInstruction;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_takeTrap & ~reset) begin
          $fwrite(32'h80000002,"[Csr] Trap Taken: PC=0x%x, Cause=0x%x, isInterrupt=%b, mtval=0x%x\n",io_trapPC,
            _lastTrapCause_T,io_trapIsInterrupt,_lastTrapValue_T); // @[Csr.scala 121:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
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
    csrMem[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  csrMem_readDataInternal_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  csrMem_readDataInternal_MPORT_addr_pipe_0 = _RAND_2[11:0];
  _RAND_3 = {1{`RANDOM}};
  mepcReg = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  mcauseReg = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  mtvalReg = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  mtvecReg = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  lastWriteAddr = _RAND_7[11:0];
  _RAND_8 = {1{`RANDOM}};
  lastWriteEnable = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  lastWriteData = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  lastTrapWriteAddr = _RAND_10[9:0];
  _RAND_11 = {1{`RANDOM}};
  lastTrapOccurred = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  lastTrapPC = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  lastTrapCause = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  lastTrapValue = _RAND_14[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ThreeCats(
  input         clock,
  input         reset,
  output [31:0] io_imem_address,
  input  [31:0] io_imem_data,
  input         io_imem_stall,
  output [31:0] io_dmem_rdAddress,
  input  [31:0] io_dmem_rdData,
  output        io_dmem_rdEnable,
  output [31:0] io_dmem_wrAddress,
  output [31:0] io_dmem_wrData,
  output        io_dmem_wrEnable_0,
  output        io_dmem_wrEnable_1,
  output        io_dmem_wrEnable_2,
  output        io_dmem_wrEnable_3,
  input         io_dmem_stall,
  input  [63:0] io_mtimecmpVal_in,
  output [63:0] io_timerCounter_out,
  input         io_Bootloader_Stall
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regs [0:31]; // @[Functions.scala 309:29]
  wire  regs_rs1Val_MPORT_en; // @[Functions.scala 309:29]
  wire [4:0] regs_rs1Val_MPORT_addr; // @[Functions.scala 309:29]
  wire [31:0] regs_rs1Val_MPORT_data; // @[Functions.scala 309:29]
  wire  regs_rs2Val_MPORT_en; // @[Functions.scala 309:29]
  wire [4:0] regs_rs2Val_MPORT_addr; // @[Functions.scala 309:29]
  wire [31:0] regs_rs2Val_MPORT_data; // @[Functions.scala 309:29]
  wire [31:0] regs_MPORT_data; // @[Functions.scala 309:29]
  wire [4:0] regs_MPORT_addr; // @[Functions.scala 309:29]
  wire  regs_MPORT_mask; // @[Functions.scala 309:29]
  wire  regs_MPORT_en; // @[Functions.scala 309:29]
  reg  regs_rs1Val_MPORT_en_pipe_0;
  reg [4:0] regs_rs1Val_MPORT_addr_pipe_0;
  reg  regs_rs2Val_MPORT_en_pipe_0;
  reg [4:0] regs_rs2Val_MPORT_addr_pipe_0;
  wire  csr_clock; // @[ThreeCats.scala 132:19]
  wire  csr_reset; // @[ThreeCats.scala 132:19]
  wire [11:0] csr_io_readAddress; // @[ThreeCats.scala 132:19]
  wire [11:0] csr_io_writeAddress; // @[ThreeCats.scala 132:19]
  wire  csr_io_readEnable; // @[ThreeCats.scala 132:19]
  wire  csr_io_writeEnable; // @[ThreeCats.scala 132:19]
  wire [31:0] csr_io_writeData; // @[ThreeCats.scala 132:19]
  wire  csr_io_instrComplete; // @[ThreeCats.scala 132:19]
  wire [31:0] csr_io_exceptionCause; // @[ThreeCats.scala 132:19]
  wire  csr_io_takeTrap; // @[ThreeCats.scala 132:19]
  wire  csr_io_trapIsInterrupt; // @[ThreeCats.scala 132:19]
  wire [31:0] csr_io_trapPC; // @[ThreeCats.scala 132:19]
  wire [31:0] csr_io_trapInstruction; // @[ThreeCats.scala 132:19]
  wire [63:0] csr_io_mtimecmpVal; // @[ThreeCats.scala 132:19]
  wire  csr_io_mret_executing; // @[ThreeCats.scala 132:19]
  wire [31:0] csr_io_data; // @[ThreeCats.scala 132:19]
  wire [31:0] csr_io_mretTarget; // @[ThreeCats.scala 132:19]
  wire [31:0] csr_io_trapVector; // @[ThreeCats.scala 132:19]
  wire [63:0] csr_io_timerCounter; // @[ThreeCats.scala 132:19]
  wire  csr_io_interruptRequest; // @[ThreeCats.scala 132:19]
  wire [31:0] csr_io_interruptCause; // @[ThreeCats.scala 132:19]
  wire  csr_io_globalInterruptEnabled; // @[ThreeCats.scala 132:19]
  wire  csr_io_timerInterruptEnabled; // @[ThreeCats.scala 132:19]
  reg  inSleepMode; // @[ThreeCats.scala 30:28]
  reg  exFwdReg_valid; // @[ThreeCats.scala 41:25]
  reg [4:0] exFwdReg_wbDest; // @[ThreeCats.scala 41:25]
  reg [31:0] exFwdReg_wbData; // @[ThreeCats.scala 41:25]
  reg [31:0] pcReg; // @[ThreeCats.scala 44:22]
  reg  decExReg_valid; // @[ThreeCats.scala 144:25]
  reg  decExReg_decOut_isIllegal; // @[ThreeCats.scala 144:25]
  reg  processorInitialized; // @[ThreeCats.scala 50:37]
  wire  illegalInstr = decExReg_valid & decExReg_decOut_isIllegal & processorInitialized; // @[ThreeCats.scala 156:66]
  reg  decExReg_decOut_isECall; // @[ThreeCats.scala 144:25]
  wire  ecallM = decExReg_valid & decExReg_decOut_isECall; // @[ThreeCats.scala 157:31]
  wire  exceptionOccurred = (illegalInstr | ecallM) & decExReg_valid; // @[ThreeCats.scala 162:49]
  wire  takeInterrupt = csr_io_interruptRequest & ~exceptionOccurred & (decExReg_valid | inSleepMode); // @[ThreeCats.scala 163:66]
  wire  stall = io_dmem_stall | inSleepMode; // @[ThreeCats.scala 31:41]
  wire [31:0] _pcNext_T_3 = pcReg + 32'h4; // @[ThreeCats.scala 45:98]
  reg  decExReg_decOut_isWfi; // @[ThreeCats.scala 144:25]
  reg  decExReg_decOut_isMret; // @[ThreeCats.scala 144:25]
  wire  _T_20 = decExReg_valid & decExReg_decOut_isMret; // @[ThreeCats.scala 230:29]
  reg  decExReg_decOut_isJalr; // @[ThreeCats.scala 144:25]
  reg  decExReg_decOut_isJal; // @[ThreeCats.scala 144:25]
  reg  decExReg_decOut_isBranch; // @[ThreeCats.scala 144:25]
  reg [2:0] decExReg_func3; // @[ThreeCats.scala 144:25]
  wire  _T_24 = 3'h0 == decExReg_func3; // @[Functions.scala 258:20]
  reg [4:0] decExReg_rs1; // @[ThreeCats.scala 144:25]
  reg [31:0] decExReg_rs1Val; // @[ThreeCats.scala 144:25]
  wire [31:0] v1 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs1 ? exFwdReg_wbData : decExReg_rs1Val; // @[ThreeCats.scala 151:15]
  reg [4:0] decExReg_rs2; // @[ThreeCats.scala 144:25]
  reg [31:0] decExReg_rs2Val; // @[ThreeCats.scala 144:25]
  wire [31:0] v2 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs2 ? exFwdReg_wbData : decExReg_rs2Val; // @[ThreeCats.scala 152:15]
  wire  _T_25 = 3'h1 == decExReg_func3; // @[Functions.scala 258:20]
  wire  _T_26 = 3'h4 == decExReg_func3; // @[Functions.scala 258:20]
  wire [31:0] _res_T_2 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs1 ? exFwdReg_wbData : decExReg_rs1Val; // @[Functions.scala 266:20]
  wire [31:0] _res_T_3 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs2 ? exFwdReg_wbData : decExReg_rs2Val; // @[Functions.scala 266:33]
  wire  _T_27 = 3'h5 == decExReg_func3; // @[Functions.scala 258:20]
  wire  _GEN_428 = 3'h7 == decExReg_func3 & v1 >= v2; // @[Functions.scala 258:20 275:13 257:9]
  wire  _GEN_429 = 3'h6 == decExReg_func3 ? v1 < v2 : _GEN_428; // @[Functions.scala 258:20 272:13]
  wire  _GEN_430 = 3'h5 == decExReg_func3 ? $signed(_res_T_2) >= $signed(_res_T_3) : _GEN_429; // @[Functions.scala 258:20 269:13]
  wire  _GEN_431 = 3'h4 == decExReg_func3 ? $signed(_res_T_2) < $signed(_res_T_3) : _GEN_430; // @[Functions.scala 258:20 266:13]
  wire  _GEN_432 = 3'h1 == decExReg_func3 ? v1 != v2 : _GEN_431; // @[Functions.scala 258:20 263:13]
  wire  res = 3'h0 == decExReg_func3 ? v1 == v2 : _GEN_432; // @[Functions.scala 258:20 260:13]
  wire  _T_30 = decExReg_valid & decExReg_decOut_isBranch & res; // @[ThreeCats.scala 239:57]
  wire  _GEN_436 = decExReg_valid & decExReg_decOut_isJal | _T_30; // @[ThreeCats.scala 236:55 237:14]
  wire  _GEN_438 = decExReg_valid & decExReg_decOut_isJalr | _GEN_436; // @[ThreeCats.scala 233:56 234:14]
  wire  _GEN_440 = decExReg_valid & decExReg_decOut_isMret | _GEN_438; // @[ThreeCats.scala 230:56 231:14]
  wire  _GEN_442 = exceptionOccurred | takeInterrupt | _GEN_440; // @[ThreeCats.scala 227:46 228:14]
  wire  _GEN_462 = csr_io_globalInterruptEnabled & csr_io_timerInterruptEnabled | _GEN_442; // @[ThreeCats.scala 262:79 264:16]
  wire  _GEN_465 = csr_io_interruptRequest ? _GEN_442 : _GEN_462; // @[ThreeCats.scala 260:35]
  wire  doBranch = decExReg_valid & decExReg_decOut_isWfi & processorInitialized ? _GEN_465 : _GEN_442; // @[ThreeCats.scala 258:73]
  reg [3:0] decExReg_decOut_aluOp; // @[ThreeCats.scala 144:25]
  reg  decExReg_decOut_isImm; // @[ThreeCats.scala 144:25]
  reg [31:0] decExReg_decOut_imm; // @[ThreeCats.scala 144:25]
  wire [31:0] val2 = decExReg_decOut_isImm ? decExReg_decOut_imm : v2; // @[ThreeCats.scala 199:17]
  wire [31:0] _aluResult_res_T_1 = v1 + val2; // @[Functions.scala 336:18]
  wire [31:0] _aluResult_res_T_3 = v1 - val2; // @[Functions.scala 339:18]
  wire [31:0] _aluResult_res_T_4 = v1 & val2; // @[Functions.scala 342:18]
  wire [31:0] _aluResult_res_T_5 = v1 | val2; // @[Functions.scala 345:18]
  wire [31:0] _aluResult_res_T_6 = v1 ^ val2; // @[Functions.scala 348:18]
  wire [62:0] _GEN_4 = {{31'd0}, v1}; // @[Functions.scala 351:18]
  wire [62:0] _aluResult_res_T_8 = _GEN_4 << val2[4:0]; // @[Functions.scala 351:18]
  wire [31:0] _aluResult_res_T_10 = v1 >> val2[4:0]; // @[Functions.scala 354:18]
  wire [31:0] _aluResult_res_T_14 = $signed(_res_T_2) >>> val2[4:0]; // @[Functions.scala 357:38]
  wire [31:0] _aluResult_res_T_16 = decExReg_decOut_isImm ? decExReg_decOut_imm : v2; // @[Functions.scala 360:30]
  wire  _aluResult_res_T_18 = v1 < val2; // @[Functions.scala 363:19]
  wire  _GEN_415 = 4'h3 == decExReg_decOut_aluOp ? $signed(_res_T_2) < $signed(_aluResult_res_T_16) :
    _aluResult_res_T_18; // @[Functions.scala 334:16 360:13]
  wire [31:0] _GEN_416 = 4'h7 == decExReg_decOut_aluOp ? _aluResult_res_T_14 : {{31'd0}, _GEN_415}; // @[Functions.scala 334:16 357:13]
  wire [31:0] _GEN_417 = 4'h6 == decExReg_decOut_aluOp ? _aluResult_res_T_10 : _GEN_416; // @[Functions.scala 334:16 354:13]
  wire [62:0] _GEN_418 = 4'h2 == decExReg_decOut_aluOp ? _aluResult_res_T_8 : {{31'd0}, _GEN_417}; // @[Functions.scala 334:16 351:13]
  wire [62:0] _GEN_419 = 4'h5 == decExReg_decOut_aluOp ? {{31'd0}, _aluResult_res_T_6} : _GEN_418; // @[Functions.scala 334:16 348:13]
  wire [62:0] _GEN_420 = 4'h8 == decExReg_decOut_aluOp ? {{31'd0}, _aluResult_res_T_5} : _GEN_419; // @[Functions.scala 334:16 345:13]
  wire [62:0] _GEN_421 = 4'h9 == decExReg_decOut_aluOp ? {{31'd0}, _aluResult_res_T_4} : _GEN_420; // @[Functions.scala 334:16 342:13]
  wire [62:0] _GEN_422 = 4'h1 == decExReg_decOut_aluOp ? {{31'd0}, _aluResult_res_T_3} : _GEN_421; // @[Functions.scala 334:16 339:13]
  wire [62:0] _GEN_423 = 4'h0 == decExReg_decOut_aluOp ? {{31'd0}, _aluResult_res_T_1} : _GEN_422; // @[Functions.scala 334:16 336:13]
  wire [31:0] aluResult = _GEN_423[31:0]; // @[Functions.scala 332:19]
  wire [31:0] _branchTarget_T = aluResult & 32'hfffffffe; // @[ThreeCats.scala 235:32]
  reg [31:0] decExReg_pc; // @[ThreeCats.scala 144:25]
  wire [31:0] _branchTarget_T_5 = $signed(decExReg_pc) + $signed(decExReg_decOut_imm); // @[ThreeCats.scala 238:64]
  wire [31:0] _GEN_435 = decExReg_valid & decExReg_decOut_isBranch & res ? _branchTarget_T_5 : _branchTarget_T_5; // @[ThreeCats.scala 239:93 241:18 244:18]
  wire [31:0] _GEN_437 = decExReg_valid & decExReg_decOut_isJal ? _branchTarget_T_5 : _GEN_435; // @[ThreeCats.scala 236:55 238:18]
  wire [31:0] _GEN_439 = decExReg_valid & decExReg_decOut_isJalr ? _branchTarget_T : _GEN_437; // @[ThreeCats.scala 233:56 235:18]
  wire [31:0] _GEN_441 = decExReg_valid & decExReg_decOut_isMret ? csr_io_mretTarget : _GEN_439; // @[ThreeCats.scala 230:56 232:18]
  wire [31:0] _GEN_443 = exceptionOccurred | takeInterrupt ? csr_io_trapVector : _GEN_441; // @[ThreeCats.scala 227:46 229:18]
  wire [31:0] _GEN_463 = csr_io_globalInterruptEnabled & csr_io_timerInterruptEnabled ? decExReg_pc : _GEN_443; // @[ThreeCats.scala 262:79 265:20]
  wire [31:0] _GEN_466 = csr_io_interruptRequest ? _GEN_443 : _GEN_463; // @[ThreeCats.scala 260:35]
  wire [31:0] branchTarget = decExReg_valid & decExReg_decOut_isWfi & processorInitialized ? _GEN_466 : _GEN_443; // @[ThreeCats.scala 258:73]
  wire [31:0] _pcNext_T_4 = doBranch ? branchTarget : _pcNext_T_3; // @[ThreeCats.scala 45:67]
  wire [31:0] _pcNext_T_5 = stall & ~takeInterrupt ? pcReg : _pcNext_T_4; // @[ThreeCats.scala 45:31]
  reg [1:0] initCounter; // @[ThreeCats.scala 51:28]
  wire [1:0] _initCounter_T_1 = initCounter + 2'h1; // @[ThreeCats.scala 53:32]
  wire  _GEN_0 = initCounter == 2'h3 | processorInitialized; // @[ThreeCats.scala 54:32 55:28 50:37]
  reg [31:0] pcRegReg; // @[ThreeCats.scala 73:25]
  reg [31:0] instrReg; // @[ThreeCats.scala 74:25]
  wire [31:0] instr = io_imem_stall | io_Bootloader_Stall ? 32'h13 : io_imem_data; // @[ThreeCats.scala 64:47 65:11 63:26]
  wire [6:0] decOut_opcode = instrReg[6:0]; // @[Functions.scala 17:29]
  wire [2:0] decOut_func3 = instrReg[14:12]; // @[Functions.scala 18:28]
  wire [6:0] decOut_func7 = instrReg[31:25]; // @[Functions.scala 19:28]
  wire [4:0] decOut_rs1 = instrReg[19:15]; // @[Functions.scala 20:26]
  wire [4:0] decOut_rs2 = instrReg[24:20]; // @[Functions.scala 21:26]
  wire [4:0] decOut_rd = instrReg[11:7]; // @[Functions.scala 22:25]
  wire  _decOut_T = 7'h13 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_T_1 = 7'h33 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_T_2 = 7'h63 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_validBranchFunc3_T = decOut_func3 == 3'h0; // @[Functions.scala 78:38]
  wire  _decOut_validBranchFunc3_T_2 = decOut_func3 == 3'h0 | decOut_func3 == 3'h1; // @[Functions.scala 78:48]
  wire  _decOut_validBranchFunc3_T_3 = decOut_func3 == 3'h4; // @[Functions.scala 79:17]
  wire  _decOut_validBranchFunc3_T_4 = decOut_func3 == 3'h0 | decOut_func3 == 3'h1 | _decOut_validBranchFunc3_T_3; // @[Functions.scala 78:67]
  wire  _decOut_validBranchFunc3_T_5 = decOut_func3 == 3'h5; // @[Functions.scala 79:36]
  wire  _decOut_validBranchFunc3_T_7 = decOut_func3 == 3'h6; // @[Functions.scala 80:17]
  wire  _decOut_validBranchFunc3_T_8 = _decOut_validBranchFunc3_T_4 | decOut_func3 == 3'h5 |
    _decOut_validBranchFunc3_T_7; // @[Functions.scala 79:46]
  wire  decOut_validBranchFunc3 = _decOut_validBranchFunc3_T_8 | decOut_func3 == 3'h7; // @[Functions.scala 80:28]
  wire  _decOut_T_3 = 7'h3 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_validLoadFunc3_T_3 = decOut_func3 == 3'h2; // @[Functions.scala 90:17]
  wire  _decOut_validLoadFunc3_T_4 = _decOut_validBranchFunc3_T_2 | _decOut_validLoadFunc3_T_3; // @[Functions.scala 89:63]
  wire  decOut_validLoadFunc3 = _decOut_validLoadFunc3_T_4 | _decOut_validBranchFunc3_T_3 | _decOut_validBranchFunc3_T_5
    ; // @[Functions.scala 90:45]
  wire  _decOut_T_4 = 7'h23 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_T_5 = 7'h37 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_T_6 = 7'h17 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_T_7 = 7'h6f == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_T_8 = 7'h67 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_T_10 = 7'h73 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _decOut_T_13 = instrReg[31:20] == 12'h0; // @[Functions.scala 133:36]
  wire  _decOut_T_16 = decOut_rs1 == 5'h0; // @[Functions.scala 136:61]
  wire  _decOut_T_18 = decOut_rd == 5'h0; // @[Functions.scala 136:75]
  wire  _decOut_T_19 = instrReg[31:20] == 12'h302 & decOut_rs1 == 5'h0 & decOut_rd == 5'h0; // @[Functions.scala 136:69]
  wire  _decOut_T_25 = instrReg[31:20] == 12'h105 & _decOut_T_16 & _decOut_T_18; // @[Functions.scala 139:69]
  wire  _GEN_8 = instrReg[31:20] == 12'h302 & decOut_rs1 == 5'h0 & decOut_rd == 5'h0 | _decOut_T_25; // @[Functions.scala 136:84 138:32]
  wire  _GEN_9 = instrReg[31:20] == 12'h302 & decOut_rs1 == 5'h0 & decOut_rd == 5'h0 ? 1'h0 : _decOut_T_25; // @[Functions.scala 136:84 43:18]
  wire  _GEN_11 = instrReg[31:20] == 12'h0 | _GEN_8; // @[Functions.scala 133:45 135:32]
  wire  _GEN_12 = instrReg[31:20] == 12'h0 ? 1'h0 : _decOut_T_19; // @[Functions.scala 133:45 42:19]
  wire  _GEN_13 = instrReg[31:20] == 12'h0 ? 1'h0 : _GEN_9; // @[Functions.scala 133:45 43:18]
  wire  _decOut_T_28 = 3'h1 == decOut_func3; // @[Functions.scala 146:25]
  wire  _decOut_T_29 = 3'h2 == decOut_func3; // @[Functions.scala 146:25]
  wire  _decOut_T_30 = 3'h3 == decOut_func3; // @[Functions.scala 146:25]
  wire  _decOut_T_31 = 3'h5 == decOut_func3; // @[Functions.scala 146:25]
  wire  _decOut_T_32 = 3'h6 == decOut_func3; // @[Functions.scala 146:25]
  wire  _decOut_T_33 = 3'h7 == decOut_func3; // @[Functions.scala 146:25]
  wire  _GEN_16 = 3'h6 == decOut_func3 | 3'h7 == decOut_func3; // @[Functions.scala 146:25 169:30]
  wire  _GEN_17 = 3'h6 == decOut_func3 ? 1'h0 : 3'h7 == decOut_func3; // @[Functions.scala 146:25 49:21]
  wire  _GEN_19 = 3'h5 == decOut_func3 | _GEN_16; // @[Functions.scala 146:25 164:30]
  wire  _GEN_20 = 3'h5 == decOut_func3 ? 1'h0 : 3'h6 == decOut_func3; // @[Functions.scala 146:25 48:21]
  wire  _GEN_21 = 3'h5 == decOut_func3 ? 1'h0 : _GEN_17; // @[Functions.scala 146:25 49:21]
  wire  _GEN_23 = 3'h3 == decOut_func3 | _GEN_19; // @[Functions.scala 146:25 159:30]
  wire  _GEN_24 = 3'h3 == decOut_func3 ? 1'h0 : 3'h5 == decOut_func3; // @[Functions.scala 146:25 47:21]
  wire  _GEN_25 = 3'h3 == decOut_func3 ? 1'h0 : _GEN_20; // @[Functions.scala 146:25 48:21]
  wire  _GEN_26 = 3'h3 == decOut_func3 ? 1'h0 : _GEN_21; // @[Functions.scala 146:25 49:21]
  wire  _GEN_28 = 3'h2 == decOut_func3 | _GEN_23; // @[Functions.scala 146:25 154:30]
  wire  _GEN_29 = 3'h2 == decOut_func3 ? 1'h0 : 3'h3 == decOut_func3; // @[Functions.scala 146:25 46:20]
  wire  _GEN_30 = 3'h2 == decOut_func3 ? 1'h0 : _GEN_24; // @[Functions.scala 146:25 47:21]
  wire  _GEN_31 = 3'h2 == decOut_func3 ? 1'h0 : _GEN_25; // @[Functions.scala 146:25 48:21]
  wire  _GEN_32 = 3'h2 == decOut_func3 ? 1'h0 : _GEN_26; // @[Functions.scala 146:25 49:21]
  wire  _GEN_34 = 3'h1 == decOut_func3 | _GEN_28; // @[Functions.scala 146:25 149:30]
  wire  _GEN_35 = 3'h1 == decOut_func3 ? 1'h0 : 3'h2 == decOut_func3; // @[Functions.scala 146:25 45:20]
  wire  _GEN_36 = 3'h1 == decOut_func3 ? 1'h0 : _GEN_29; // @[Functions.scala 146:25 46:20]
  wire  _GEN_37 = 3'h1 == decOut_func3 ? 1'h0 : _GEN_30; // @[Functions.scala 146:25 47:21]
  wire  _GEN_38 = 3'h1 == decOut_func3 ? 1'h0 : _GEN_31; // @[Functions.scala 146:25 48:21]
  wire  _GEN_39 = 3'h1 == decOut_func3 ? 1'h0 : _GEN_32; // @[Functions.scala 146:25 49:21]
  wire  _GEN_40 = _decOut_validBranchFunc3_T & _decOut_T_13; // @[Functions.scala 132:30 41:20]
  wire  _GEN_41 = _decOut_validBranchFunc3_T ? _GEN_11 : _GEN_34; // @[Functions.scala 132:30]
  wire  _GEN_42 = _decOut_validBranchFunc3_T & _GEN_12; // @[Functions.scala 132:30 42:19]
  wire  _GEN_43 = _decOut_validBranchFunc3_T & _GEN_13; // @[Functions.scala 132:30 43:18]
  wire  _GEN_44 = _decOut_validBranchFunc3_T ? 1'h0 : _decOut_T_28; // @[Functions.scala 132:30 44:20]
  wire  _GEN_45 = _decOut_validBranchFunc3_T ? 1'h0 : _GEN_34; // @[Functions.scala 132:30 34:20]
  wire  _GEN_46 = _decOut_validBranchFunc3_T ? 1'h0 : _GEN_35; // @[Functions.scala 132:30 45:20]
  wire  _GEN_47 = _decOut_validBranchFunc3_T ? 1'h0 : _GEN_36; // @[Functions.scala 132:30 46:20]
  wire  _GEN_48 = _decOut_validBranchFunc3_T ? 1'h0 : _GEN_37; // @[Functions.scala 132:30 47:21]
  wire  _GEN_49 = _decOut_validBranchFunc3_T ? 1'h0 : _GEN_38; // @[Functions.scala 132:30 48:21]
  wire  _GEN_50 = _decOut_validBranchFunc3_T ? 1'h0 : _GEN_39; // @[Functions.scala 132:30 49:21]
  wire [4:0] decOut_funct5 = decOut_func7[6:2]; // @[Functions.scala 186:29]
  wire  _decOut_T_38 = decOut_rs2 == 5'h0; // @[Functions.scala 188:22]
  wire  _decOut_T_39 = decOut_funct5 == 5'h3; // @[Functions.scala 193:29]
  wire  _GEN_54 = decOut_funct5 == 5'h2 ? _decOut_T_38 : _decOut_T_39; // @[Functions.scala 187:32]
  wire  _GEN_57 = _decOut_validLoadFunc3_T_3 & _GEN_54; // @[Functions.scala 185:29 34:20]
  wire  _GEN_60 = 7'h2f == decOut_opcode & _GEN_57; // @[Functions.scala 34:20 57:20]
  wire  _GEN_62 = 7'hf == decOut_opcode | _GEN_60; // @[Functions.scala 57:20 181:28]
  wire  _GEN_64 = 7'hf == decOut_opcode ? 1'h0 : 7'h2f == decOut_opcode & _GEN_57; // @[Functions.scala 34:20 57:20]
  wire  _GEN_68 = 7'h73 == decOut_opcode ? _GEN_41 : _GEN_62; // @[Functions.scala 57:20]
  wire  _GEN_72 = 7'h73 == decOut_opcode ? _GEN_45 : _GEN_64; // @[Functions.scala 57:20]
  wire  _GEN_80 = 7'h67 == decOut_opcode ? _decOut_validBranchFunc3_T : 7'h73 == decOut_opcode; // @[Functions.scala 57:20]
  wire  _GEN_82 = 7'h67 == decOut_opcode ? _decOut_validBranchFunc3_T : _GEN_72; // @[Functions.scala 57:20]
  wire  _GEN_83 = 7'h67 == decOut_opcode ? _decOut_validBranchFunc3_T : _GEN_68; // @[Functions.scala 57:20]
  wire  _GEN_84 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_40; // @[Functions.scala 41:20 57:20]
  wire  _GEN_85 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_42; // @[Functions.scala 42:19 57:20]
  wire  _GEN_86 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_43; // @[Functions.scala 43:18 57:20]
  wire  _GEN_87 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_44; // @[Functions.scala 44:20 57:20]
  wire  _GEN_88 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_46; // @[Functions.scala 45:20 57:20]
  wire  _GEN_89 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_47; // @[Functions.scala 46:20 57:20]
  wire  _GEN_90 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_48; // @[Functions.scala 57:20 47:21]
  wire  _GEN_91 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_49; // @[Functions.scala 57:20 48:21]
  wire  _GEN_92 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_50; // @[Functions.scala 57:20 49:21]
  wire [2:0] _GEN_95 = 7'h6f == decOut_opcode ? 3'h5 : {{2'd0}, _GEN_80}; // @[Functions.scala 57:20 116:26]
  wire  _GEN_96 = 7'h6f == decOut_opcode | _GEN_82; // @[Functions.scala 57:20 117:24]
  wire  _GEN_98 = 7'h6f == decOut_opcode | _GEN_83; // @[Functions.scala 57:20 119:28]
  wire  _GEN_99 = 7'h6f == decOut_opcode ? 1'h0 : 7'h67 == decOut_opcode & _decOut_validBranchFunc3_T; // @[Functions.scala 33:19 57:20]
  wire  _GEN_100 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_84; // @[Functions.scala 41:20 57:20]
  wire  _GEN_101 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_85; // @[Functions.scala 42:19 57:20]
  wire  _GEN_102 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_86; // @[Functions.scala 43:18 57:20]
  wire  _GEN_103 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_87; // @[Functions.scala 44:20 57:20]
  wire  _GEN_104 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_88; // @[Functions.scala 45:20 57:20]
  wire  _GEN_105 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_89; // @[Functions.scala 46:20 57:20]
  wire  _GEN_106 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_90; // @[Functions.scala 57:20 47:21]
  wire  _GEN_107 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_91; // @[Functions.scala 57:20 48:21]
  wire  _GEN_108 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_92; // @[Functions.scala 57:20 49:21]
  wire [2:0] _GEN_111 = 7'h17 == decOut_opcode ? 3'h4 : _GEN_95; // @[Functions.scala 57:20 110:26]
  wire  _GEN_112 = 7'h17 == decOut_opcode | _GEN_96; // @[Functions.scala 57:20 111:24]
  wire  _GEN_114 = 7'h17 == decOut_opcode | _GEN_98; // @[Functions.scala 57:20 113:28]
  wire  _GEN_115 = 7'h17 == decOut_opcode ? 1'h0 : 7'h6f == decOut_opcode; // @[Functions.scala 32:18 57:20]
  wire  _GEN_116 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_99; // @[Functions.scala 33:19 57:20]
  wire  _GEN_117 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_100; // @[Functions.scala 41:20 57:20]
  wire  _GEN_118 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_101; // @[Functions.scala 42:19 57:20]
  wire  _GEN_119 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_102; // @[Functions.scala 43:18 57:20]
  wire  _GEN_120 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_103; // @[Functions.scala 44:20 57:20]
  wire  _GEN_121 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_104; // @[Functions.scala 45:20 57:20]
  wire  _GEN_122 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_105; // @[Functions.scala 46:20 57:20]
  wire  _GEN_123 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_106; // @[Functions.scala 57:20 47:21]
  wire  _GEN_124 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_107; // @[Functions.scala 57:20 48:21]
  wire  _GEN_125 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_108; // @[Functions.scala 57:20 49:21]
  wire [2:0] _GEN_128 = 7'h37 == decOut_opcode ? 3'h4 : _GEN_111; // @[Functions.scala 57:20 104:26]
  wire  _GEN_129 = 7'h37 == decOut_opcode | _GEN_112; // @[Functions.scala 57:20 105:24]
  wire  _GEN_131 = 7'h37 == decOut_opcode | _GEN_114; // @[Functions.scala 57:20 107:28]
  wire  _GEN_132 = 7'h37 == decOut_opcode ? 1'h0 : 7'h17 == decOut_opcode; // @[Functions.scala 28:20 57:20]
  wire  _GEN_133 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_115; // @[Functions.scala 32:18 57:20]
  wire  _GEN_134 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_116; // @[Functions.scala 33:19 57:20]
  wire  _GEN_135 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_117; // @[Functions.scala 41:20 57:20]
  wire  _GEN_136 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_118; // @[Functions.scala 42:19 57:20]
  wire  _GEN_137 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_119; // @[Functions.scala 43:18 57:20]
  wire  _GEN_138 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_120; // @[Functions.scala 44:20 57:20]
  wire  _GEN_139 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_121; // @[Functions.scala 45:20 57:20]
  wire  _GEN_140 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_122; // @[Functions.scala 46:20 57:20]
  wire  _GEN_141 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_123; // @[Functions.scala 57:20 47:21]
  wire  _GEN_142 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_124; // @[Functions.scala 57:20 48:21]
  wire  _GEN_143 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_125; // @[Functions.scala 57:20 49:21]
  wire [2:0] _GEN_146 = 7'h23 == decOut_opcode ? 3'h2 : _GEN_128; // @[Functions.scala 57:20 96:26]
  wire  _GEN_148 = 7'h23 == decOut_opcode ? _decOut_validLoadFunc3_T_4 : _GEN_131; // @[Functions.scala 57:20 101:28]
  wire  _GEN_149 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_129; // @[Functions.scala 34:20 57:20]
  wire  _GEN_150 = 7'h23 == decOut_opcode ? 1'h0 : 7'h37 == decOut_opcode; // @[Functions.scala 27:18 57:20]
  wire  _GEN_151 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_132; // @[Functions.scala 28:20 57:20]
  wire  _GEN_152 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_133; // @[Functions.scala 32:18 57:20]
  wire  _GEN_153 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_134; // @[Functions.scala 33:19 57:20]
  wire  _GEN_154 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_135; // @[Functions.scala 41:20 57:20]
  wire  _GEN_155 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_136; // @[Functions.scala 42:19 57:20]
  wire  _GEN_156 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_137; // @[Functions.scala 43:18 57:20]
  wire  _GEN_157 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_138; // @[Functions.scala 44:20 57:20]
  wire  _GEN_158 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_139; // @[Functions.scala 45:20 57:20]
  wire  _GEN_159 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_140; // @[Functions.scala 46:20 57:20]
  wire  _GEN_160 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_141; // @[Functions.scala 57:20 47:21]
  wire  _GEN_161 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_142; // @[Functions.scala 57:20 48:21]
  wire  _GEN_162 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_143; // @[Functions.scala 57:20 49:21]
  wire [2:0] _GEN_165 = 7'h3 == decOut_opcode ? 3'h1 : _GEN_146; // @[Functions.scala 57:20 85:26]
  wire  _GEN_167 = 7'h3 == decOut_opcode | _GEN_149; // @[Functions.scala 57:20 87:24]
  wire  _GEN_168 = 7'h3 == decOut_opcode ? decOut_validLoadFunc3 : _GEN_148; // @[Functions.scala 57:20 93:28]
  wire  _GEN_169 = 7'h3 == decOut_opcode ? 1'h0 : 7'h23 == decOut_opcode; // @[Functions.scala 30:20 57:20]
  wire  _GEN_170 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_150; // @[Functions.scala 27:18 57:20]
  wire  _GEN_171 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_151; // @[Functions.scala 28:20 57:20]
  wire  _GEN_172 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_152; // @[Functions.scala 32:18 57:20]
  wire  _GEN_173 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_153; // @[Functions.scala 33:19 57:20]
  wire  _GEN_174 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_154; // @[Functions.scala 41:20 57:20]
  wire  _GEN_175 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_155; // @[Functions.scala 42:19 57:20]
  wire  _GEN_176 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_156; // @[Functions.scala 43:18 57:20]
  wire  _GEN_177 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_157; // @[Functions.scala 44:20 57:20]
  wire  _GEN_178 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_158; // @[Functions.scala 45:20 57:20]
  wire  _GEN_179 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_159; // @[Functions.scala 46:20 57:20]
  wire  _GEN_180 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_160; // @[Functions.scala 57:20 47:21]
  wire  _GEN_181 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_161; // @[Functions.scala 57:20 48:21]
  wire  _GEN_182 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_162; // @[Functions.scala 57:20 49:21]
  wire [2:0] _GEN_185 = 7'h63 == decOut_opcode ? 3'h3 : _GEN_165; // @[Functions.scala 57:20 73:26]
  wire  _GEN_187 = 7'h63 == decOut_opcode ? decOut_validBranchFunc3 : _GEN_168; // @[Functions.scala 57:20 82:28]
  wire  _GEN_188 = 7'h63 == decOut_opcode ? 1'h0 : 7'h3 == decOut_opcode; // @[Functions.scala 29:19 57:20]
  wire  _GEN_189 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_167; // @[Functions.scala 34:20 57:20]
  wire  _GEN_190 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_169; // @[Functions.scala 30:20 57:20]
  wire  _GEN_198 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_177; // @[Functions.scala 44:20 57:20]
  wire  _GEN_199 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_178; // @[Functions.scala 45:20 57:20]
  wire  _GEN_200 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_179; // @[Functions.scala 46:20 57:20]
  wire  _GEN_201 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_180; // @[Functions.scala 57:20 47:21]
  wire  _GEN_202 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_181; // @[Functions.scala 57:20 48:21]
  wire  _GEN_203 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_182; // @[Functions.scala 57:20 49:21]
  wire [2:0] _GEN_206 = 7'h33 == decOut_opcode ? 3'h0 : _GEN_185; // @[Functions.scala 57:20 66:26]
  wire  _GEN_207 = 7'h33 == decOut_opcode | _GEN_189; // @[Functions.scala 57:20 67:24]
  wire  _GEN_209 = 7'h33 == decOut_opcode | _GEN_187; // @[Functions.scala 57:20 70:28]
  wire  _GEN_210 = 7'h33 == decOut_opcode ? 1'h0 : 7'h63 == decOut_opcode; // @[Functions.scala 26:18 57:20]
  wire  _GEN_211 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_188; // @[Functions.scala 29:19 57:20]
  wire  _GEN_212 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_190; // @[Functions.scala 30:20 57:20]
  wire  _GEN_220 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_198; // @[Functions.scala 44:20 57:20]
  wire  _GEN_221 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_199; // @[Functions.scala 45:20 57:20]
  wire  _GEN_222 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_200; // @[Functions.scala 46:20 57:20]
  wire  _GEN_223 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_201; // @[Functions.scala 57:20 47:21]
  wire  _GEN_224 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_202; // @[Functions.scala 57:20 48:21]
  wire  _GEN_225 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_203; // @[Functions.scala 57:20 49:21]
  wire [2:0] decOut_instrType = 7'h13 == decOut_opcode ? 3'h1 : _GEN_206; // @[Functions.scala 57:20 59:26]
  wire  decOut_isImm = 7'h13 == decOut_opcode | _GEN_210; // @[Functions.scala 57:20 60:22]
  wire  decOut_rfWrite = 7'h13 == decOut_opcode | _GEN_207; // @[Functions.scala 57:20 61:24]
  wire  decOut_isRecognizedOpcode = 7'h13 == decOut_opcode | _GEN_209; // @[Functions.scala 57:20 63:28]
  wire  decOut_isLoad = 7'h13 == decOut_opcode ? 1'h0 : _GEN_211; // @[Functions.scala 29:19 57:20]
  wire  decOut_isStore = 7'h13 == decOut_opcode ? 1'h0 : _GEN_212; // @[Functions.scala 30:20 57:20]
  wire  decOut_isCsrrw = 7'h13 == decOut_opcode ? 1'h0 : _GEN_220; // @[Functions.scala 44:20 57:20]
  wire  decOut_isCsrrs = 7'h13 == decOut_opcode ? 1'h0 : _GEN_221; // @[Functions.scala 45:20 57:20]
  wire  decOut_isCsrrc = 7'h13 == decOut_opcode ? 1'h0 : _GEN_222; // @[Functions.scala 46:20 57:20]
  wire  decOut_isCsrrwi = 7'h13 == decOut_opcode ? 1'h0 : _GEN_223; // @[Functions.scala 57:20 47:21]
  wire  decOut_isCsrrsi = 7'h13 == decOut_opcode ? 1'h0 : _GEN_224; // @[Functions.scala 57:20 48:21]
  wire  decOut_isCsrrci = 7'h13 == decOut_opcode ? 1'h0 : _GEN_225; // @[Functions.scala 57:20 49:21]
  wire  decOut_isIllegal = ~decOut_isRecognizedOpcode; // @[Functions.scala 204:25]
  wire  _decOut_decOut_aluOp_T = 3'h0 == decOut_func3; // @[Functions.scala 219:19]
  wire  _decOut_decOut_aluOp_T_5 = decOut_opcode != 7'h13 & decOut_opcode != 7'h67 & decOut_func7 != 7'h0; // @[Functions.scala 222:55]
  wire [2:0] _GEN_253 = decOut_func7 == 7'h0 ? 3'h6 : 3'h7; // @[Functions.scala 239:29 240:17 242:17]
  wire [3:0] _GEN_254 = _decOut_T_33 ? 4'h9 : 4'h0; // @[Functions.scala 219:19 249:15 218:28]
  wire [3:0] _GEN_255 = _decOut_T_32 ? 4'h8 : _GEN_254; // @[Functions.scala 219:19 246:15]
  wire [3:0] _GEN_256 = _decOut_T_31 ? {{1'd0}, _GEN_253} : _GEN_255; // @[Functions.scala 219:19]
  wire [3:0] _GEN_257 = 3'h4 == decOut_func3 ? 4'h5 : _GEN_256; // @[Functions.scala 219:19 236:15]
  wire [3:0] _GEN_258 = _decOut_T_30 ? 4'h4 : _GEN_257; // @[Functions.scala 219:19 233:15]
  wire [11:0] _decOut_decOut_imm_imm_T_1 = instrReg[31:20]; // @[Functions.scala 284:32]
  wire [19:0] _decOut_decOut_imm_imm_T_4 = instrReg[31] ? 20'hfffff : 20'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _decOut_decOut_imm_imm_T_7 = {_decOut_decOut_imm_imm_T_4,instrReg[31:20]}; // @[Functions.scala 287:67]
  wire [31:0] _decOut_decOut_imm_imm_T_15 = {_decOut_decOut_imm_imm_T_4,decOut_func7,decOut_rd}; // @[Functions.scala 290:89]
  wire [18:0] _decOut_decOut_imm_imm_T_18 = instrReg[31] ? 19'h7ffff : 19'h0; // @[Bitwise.scala 77:12]
  wire [30:0] _decOut_decOut_imm_imm_T_26 = {_decOut_decOut_imm_imm_T_18,instrReg[7],instrReg[30:25],instrReg[11:8],1'h0
    }; // @[Functions.scala 293:119]
  wire [31:0] _decOut_decOut_imm_imm_T_30 = {instrReg[31:12],12'h0}; // @[Functions.scala 296:55]
  wire [10:0] _decOut_decOut_imm_imm_T_33 = instrReg[31] ? 11'h7ff : 11'h0; // @[Bitwise.scala 77:12]
  wire [30:0] _decOut_decOut_imm_imm_T_41 = {_decOut_decOut_imm_imm_T_33,instrReg[19:12],instrReg[20],instrReg[30:21],1'h0
    }; // @[Functions.scala 299:121]
  wire [30:0] _GEN_262 = 3'h5 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_41) : $signed({{19{
    _decOut_decOut_imm_imm_T_1[11]}},_decOut_decOut_imm_imm_T_1}); // @[Functions.scala 285:23 299:13 284:9]
  wire [31:0] _GEN_263 = 3'h4 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_30) : $signed({{1{_GEN_262[30]}},
    _GEN_262}); // @[Functions.scala 285:23 296:13]
  wire [31:0] _GEN_264 = 3'h3 == decOut_instrType ? $signed({{1{_decOut_decOut_imm_imm_T_26[30]}},
    _decOut_decOut_imm_imm_T_26}) : $signed(_GEN_263); // @[Functions.scala 285:23 293:13]
  wire [31:0] _GEN_265 = 3'h2 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_15) : $signed(_GEN_264); // @[Functions.scala 285:23 290:13]
  wire [31:0] decOut_decOut_imm_imm = 3'h1 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_7) : $signed(_GEN_265)
    ; // @[Functions.scala 285:23 287:13]
  reg [4:0] rs1Val_REG; // @[Functions.scala 311:31]
  wire [31:0] rs1Val = rs1Val_REG == 5'h0 ? 32'h0 : regs_rs1Val_MPORT_data; // @[Functions.scala 311:23]
  reg [4:0] rs2Val_REG; // @[Functions.scala 312:31]
  wire [31:0] rs2Val = rs2Val_REG == 5'h0 ? 32'h0 : regs_rs2Val_MPORT_data; // @[Functions.scala 312:23]
  reg [4:0] decExReg_rd; // @[ThreeCats.scala 144:25]
  wire  _T_3 = decExReg_rd != 5'h0; // @[Functions.scala 313:24]
  reg  decExReg_decOut_rfWrite; // @[ThreeCats.scala 144:25]
  wire  wrEna = decExReg_valid & decExReg_decOut_rfWrite & _T_3; // @[ThreeCats.scala 223:54]
  wire  _T_4 = wrEna & decExReg_rd != 5'h0; // @[Functions.scala 313:18]
  wire  _T_18 = decExReg_decOut_isJal | decExReg_decOut_isJalr; // @[ThreeCats.scala 219:30]
  wire [31:0] _wbData_T_1 = decExReg_pc + 32'h4; // @[ThreeCats.scala 219:81]
  reg  decExReg_decOut_isLoad; // @[ThreeCats.scala 144:25]
  wire  _T_31 = ~doBranch; // @[ThreeCats.scala 248:34]
  reg [1:0] decExReg_memLow; // @[ThreeCats.scala 144:25]
  wire  _finalResult_T_7 = 2'h0 == decExReg_memLow; // @[Functions.scala 374:24]
  wire [23:0] _finalResult_res_T_2 = io_dmem_rdData[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _finalResult_res_T_4 = {_finalResult_res_T_2,io_dmem_rdData[7:0]}; // @[Functions.scala 376:38]
  wire  _finalResult_T_8 = 2'h1 == decExReg_memLow; // @[Functions.scala 374:24]
  wire [23:0] _finalResult_res_T_7 = io_dmem_rdData[15] ? 24'hffffff : 24'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _finalResult_res_T_9 = {_finalResult_res_T_7,io_dmem_rdData[15:8]}; // @[Functions.scala 379:39]
  wire  _finalResult_T_9 = 2'h2 == decExReg_memLow; // @[Functions.scala 374:24]
  wire [23:0] _finalResult_res_T_12 = io_dmem_rdData[23] ? 24'hffffff : 24'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _finalResult_res_T_14 = {_finalResult_res_T_12,io_dmem_rdData[23:16]}; // @[Functions.scala 382:39]
  wire  _finalResult_T_10 = 2'h3 == decExReg_memLow; // @[Functions.scala 374:24]
  wire [23:0] _finalResult_res_T_17 = io_dmem_rdData[31] ? 24'hffffff : 24'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _finalResult_res_T_19 = {_finalResult_res_T_17,io_dmem_rdData[31:24]}; // @[Functions.scala 386:39]
  wire [31:0] _GEN_444 = 2'h3 == decExReg_memLow ? _finalResult_res_T_19 : io_dmem_rdData; // @[Functions.scala 374:24 386:17 371:9]
  wire [31:0] _GEN_445 = 2'h2 == decExReg_memLow ? _finalResult_res_T_14 : _GEN_444; // @[Functions.scala 374:24 382:17]
  wire [31:0] _GEN_446 = 2'h1 == decExReg_memLow ? _finalResult_res_T_9 : _GEN_445; // @[Functions.scala 374:24 379:17]
  wire [31:0] _GEN_447 = 2'h0 == decExReg_memLow ? _finalResult_res_T_4 : _GEN_446; // @[Functions.scala 374:24 376:17]
  wire [15:0] _finalResult_res_T_22 = io_dmem_rdData[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _finalResult_res_T_24 = {_finalResult_res_T_22,io_dmem_rdData[15:0]}; // @[Functions.scala 393:39]
  wire [15:0] _finalResult_res_T_27 = io_dmem_rdData[31] ? 16'hffff : 16'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _finalResult_res_T_29 = {_finalResult_res_T_27,io_dmem_rdData[31:16]}; // @[Functions.scala 396:39]
  wire [31:0] _GEN_448 = _finalResult_T_9 ? _finalResult_res_T_29 : io_dmem_rdData; // @[Functions.scala 391:24 396:17 371:9]
  wire [31:0] _GEN_449 = _finalResult_T_7 ? _finalResult_res_T_24 : _GEN_448; // @[Functions.scala 391:24 393:17]
  wire [31:0] _GEN_450 = _finalResult_T_10 ? {{24'd0}, io_dmem_rdData[31:24]} : io_dmem_rdData; // @[Functions.scala 401:24 412:17 371:9]
  wire [31:0] _GEN_451 = _finalResult_T_9 ? {{24'd0}, io_dmem_rdData[23:16]} : _GEN_450; // @[Functions.scala 401:24 409:17]
  wire [31:0] _GEN_452 = _finalResult_T_8 ? {{24'd0}, io_dmem_rdData[15:8]} : _GEN_451; // @[Functions.scala 401:24 406:17]
  wire [31:0] _GEN_453 = _finalResult_T_7 ? {{24'd0}, io_dmem_rdData[7:0]} : _GEN_452; // @[Functions.scala 401:24 403:17]
  wire [31:0] _GEN_454 = _finalResult_T_9 ? {{16'd0}, io_dmem_rdData[31:16]} : io_dmem_rdData; // @[Functions.scala 417:24 422:17 371:9]
  wire [31:0] _GEN_455 = _finalResult_T_7 ? {{16'd0}, io_dmem_rdData[15:0]} : _GEN_454; // @[Functions.scala 417:24 419:17]
  wire [31:0] _GEN_456 = _T_27 ? _GEN_455 : io_dmem_rdData; // @[Functions.scala 372:19 371:9]
  wire [31:0] _GEN_457 = _T_26 ? _GEN_453 : _GEN_456; // @[Functions.scala 372:19]
  wire [31:0] _GEN_458 = _T_25 ? _GEN_449 : _GEN_457; // @[Functions.scala 372:19]
  wire [31:0] finalResult_res = _T_24 ? _GEN_447 : _GEN_458; // @[Functions.scala 372:19]
  reg  decExReg_decOut_isCsrrw; // @[ThreeCats.scala 144:25]
  reg  decExReg_decOut_isCsrrs; // @[ThreeCats.scala 144:25]
  wire  _T_13 = decExReg_decOut_isCsrrw | decExReg_decOut_isCsrrs; // @[ThreeCats.scala 206:33]
  reg  decExReg_decOut_isCsrrc; // @[ThreeCats.scala 144:25]
  wire  _T_14 = _T_13 | decExReg_decOut_isCsrrc; // @[ThreeCats.scala 207:33]
  reg  decExReg_decOut_isCsrrwi; // @[ThreeCats.scala 144:25]
  wire  _T_15 = _T_14 | decExReg_decOut_isCsrrwi; // @[ThreeCats.scala 208:33]
  reg  decExReg_decOut_isCsrrsi; // @[ThreeCats.scala 144:25]
  wire  _T_16 = _T_15 | decExReg_decOut_isCsrrsi; // @[ThreeCats.scala 209:33]
  reg  decExReg_decOut_isCsrrci; // @[ThreeCats.scala 144:25]
  wire  _T_17 = _T_16 | decExReg_decOut_isCsrrci; // @[ThreeCats.scala 210:33]
  reg [31:0] decExReg_csr_data; // @[ThreeCats.scala 144:25]
  reg  decExReg_decOut_isAuiPc; // @[ThreeCats.scala 144:25]
  reg  decExReg_decOut_isLui; // @[ThreeCats.scala 144:25]
  wire [31:0] _GEN_424 = decExReg_decOut_isLui ? decExReg_decOut_imm : aluResult; // @[ThreeCats.scala 203:32 204:{33,47}]
  wire [31:0] _GEN_425 = decExReg_decOut_isAuiPc ? _branchTarget_T_5 : _GEN_424; // @[ThreeCats.scala 205:{33,47}]
  wire [31:0] _GEN_426 = _T_17 ? decExReg_csr_data : _GEN_425; // @[ThreeCats.scala 211:31 212:17]
  wire [31:0] finalResult = decExReg_decOut_isLoad & ~doBranch ? finalResult_res : _GEN_426; // @[ThreeCats.scala 248:45 249:17]
  wire [31:0] wbData = decExReg_decOut_isJal | decExReg_decOut_isJalr ? _wbData_T_1 : finalResult; // @[ThreeCats.scala 217:10 219:{57,66}]
  wire [31:0] data = _T_4 & decExReg_rd == decOut_rs2 ? wbData : rs2Val; // @[ThreeCats.scala 113:17]
  wire [31:0] _memAddress_T = _T_4 & decExReg_rd == decOut_rs1 ? wbData : rs1Val; // @[ThreeCats.scala 116:29]
  wire [31:0] memAddress = $signed(_memAddress_T) + $signed(decOut_decOut_imm_imm); // @[ThreeCats.scala 116:50]
  wire [1:0] decEx_memLow = memAddress[1:0]; // @[ThreeCats.scala 117:29]
  wire [31:0] _wrData_T_6 = {data[7:0],data[7:0],data[7:0],data[7:0]}; // @[Functions.scala 435:58]
  wire  _GEN_342 = 2'h0 == decEx_memLow; // @[Functions.scala 436:{26,26} 432:27]
  wire  _GEN_343 = 2'h1 == decEx_memLow; // @[Functions.scala 436:{26,26} 432:27]
  wire  _GEN_344 = 2'h2 == decEx_memLow; // @[Functions.scala 436:{26,26} 432:27]
  wire  _GEN_345 = 2'h3 == decEx_memLow; // @[Functions.scala 436:{26,26} 432:27]
  wire [31:0] _wrData_T_9 = {data[15:0],data[15:0]}; // @[Functions.scala 439:31]
  wire  _GEN_348 = _GEN_342 ? 1'h0 : _GEN_344; // @[Functions.scala 440:24 432:27]
  wire [31:0] _GEN_353 = _decOut_T_28 ? _wrData_T_9 : data; // @[Functions.scala 433:19 439:16 431:29]
  wire  _GEN_354 = _decOut_T_28 ? _GEN_342 : _decOut_T_29; // @[Functions.scala 433:19]
  wire  _GEN_356 = _decOut_T_28 ? _GEN_348 : _decOut_T_29; // @[Functions.scala 433:19]
  wire [31:0] wrd = _decOut_decOut_aluOp_T ? _wrData_T_6 : _GEN_353; // @[Functions.scala 433:19 435:16]
  wire  wre_0 = _decOut_decOut_aluOp_T ? _GEN_342 : _GEN_354; // @[Functions.scala 433:19]
  wire  wre_1 = _decOut_decOut_aluOp_T ? _GEN_343 : _GEN_354; // @[Functions.scala 433:19]
  wire  wre_2 = _decOut_decOut_aluOp_T ? _GEN_344 : _GEN_356; // @[Functions.scala 433:19]
  wire  wre_3 = _decOut_decOut_aluOp_T ? _GEN_345 : _GEN_356; // @[Functions.scala 433:19]
  wire  _csr_io_readEnable_T = decOut_rd != 5'h0; // @[ThreeCats.scala 136:52]
  wire  _csr_io_readEnable_T_5 = decOut_isCsrrwi & _csr_io_readEnable_T; // @[ThreeCats.scala 137:22]
  wire  _csr_io_readEnable_T_6 = decOut_isCsrrw & decOut_rd != 5'h0 | decOut_isCsrrs | decOut_isCsrrc |
    _csr_io_readEnable_T_5; // @[ThreeCats.scala 136:97]
  reg [31:0] decExReg_instruction; // @[ThreeCats.scala 144:25]
  wire [31:0] decEx_csr_data = csr_io_data; // @[ThreeCats.scala 138:18 84:19]
  wire [31:0] _GEN_406 = ecallM ? 32'hb : 32'h0; // @[ThreeCats.scala 160:25 155:35 160:42]
  wire  _csr_io_writeEnable_T = decExReg_rs1 != 5'h0; // @[ThreeCats.scala 171:48]
  wire  _csr_io_writeEnable_T_1 = decExReg_decOut_isCsrrs & decExReg_rs1 != 5'h0; // @[ThreeCats.scala 171:32]
  wire  _csr_io_writeEnable_T_2 = decExReg_decOut_isCsrrw | _csr_io_writeEnable_T_1; // @[ThreeCats.scala 170:29]
  wire  _csr_io_writeEnable_T_4 = decExReg_decOut_isCsrrc & _csr_io_writeEnable_T; // @[ThreeCats.scala 172:32]
  wire  _csr_io_writeEnable_T_5 = _csr_io_writeEnable_T_2 | _csr_io_writeEnable_T_4; // @[ThreeCats.scala 171:57]
  wire  _csr_io_writeEnable_T_6 = _csr_io_writeEnable_T_5 | decExReg_decOut_isCsrrwi; // @[ThreeCats.scala 172:57]
  wire  _csr_io_writeEnable_T_8 = decExReg_decOut_isCsrrsi & _csr_io_writeEnable_T; // @[ThreeCats.scala 174:33]
  wire  _csr_io_writeEnable_T_9 = _csr_io_writeEnable_T_6 | _csr_io_writeEnable_T_8; // @[ThreeCats.scala 173:32]
  wire  _csr_io_writeEnable_T_11 = decExReg_decOut_isCsrrci & _csr_io_writeEnable_T; // @[ThreeCats.scala 175:33]
  wire  _csr_io_writeEnable_T_12 = _csr_io_writeEnable_T_9 | _csr_io_writeEnable_T_11; // @[ThreeCats.scala 174:50]
  wire [31:0] _csr_io_writeData_T = decExReg_csr_data | v1; // @[ThreeCats.scala 179:83]
  wire [31:0] _csr_io_writeData_T_1 = ~v1; // @[ThreeCats.scala 180:86]
  wire [31:0] _csr_io_writeData_T_2 = decExReg_csr_data & _csr_io_writeData_T_1; // @[ThreeCats.scala 180:83]
  wire [31:0] _GEN_477 = {{27'd0}, decExReg_rs1}; // @[ThreeCats.scala 182:83]
  wire [31:0] _csr_io_writeData_T_3 = decExReg_csr_data | _GEN_477; // @[ThreeCats.scala 182:83]
  wire [4:0] _csr_io_writeData_T_4 = ~decExReg_rs1; // @[ThreeCats.scala 183:86]
  wire [31:0] _GEN_478 = {{27'd0}, _csr_io_writeData_T_4}; // @[ThreeCats.scala 183:83]
  wire [31:0] _csr_io_writeData_T_5 = decExReg_csr_data & _GEN_478; // @[ThreeCats.scala 183:83]
  wire [31:0] _GEN_408 = decExReg_decOut_isCsrrci ? _csr_io_writeData_T_5 : 32'h0; // @[ThreeCats.scala 183:{43,62} 184:62]
  wire [31:0] _GEN_409 = decExReg_decOut_isCsrrsi ? _csr_io_writeData_T_3 : _GEN_408; // @[ThreeCats.scala 182:{43,62}]
  wire [31:0] _GEN_410 = decExReg_decOut_isCsrrwi ? {{27'd0}, decExReg_rs1} : _GEN_409; // @[ThreeCats.scala 181:{43,62}]
  wire [31:0] _GEN_411 = decExReg_decOut_isCsrrc ? _csr_io_writeData_T_2 : _GEN_410; // @[ThreeCats.scala 180:{43,62}]
  wire [31:0] _GEN_412 = decExReg_decOut_isCsrrs ? _csr_io_writeData_T : _GEN_411; // @[ThreeCats.scala 179:{43,62}]
  wire  _instrComplete_T = ~stall; // @[ThreeCats.scala 187:41]
  wire  _GEN_461 = csr_io_globalInterruptEnabled & csr_io_timerInterruptEnabled | inSleepMode; // @[ThreeCats.scala 262:79 263:19 30:28]
  wire  debug_isJal = decExReg_decOut_isJal; // @[ThreeCats.scala 297:25 303:15]
  wire  debug_isJalr = decExReg_decOut_isJalr; // @[ThreeCats.scala 298:26 304:16]
  wire  debug_branchInstr = decExReg_decOut_isBranch; // @[ThreeCats.scala 299:31 305:21]
  wire  debug_compareResult = res; // @[Functions.scala 258:20 260:13]
  Csr csr ( // @[ThreeCats.scala 132:19]
    .clock(csr_clock),
    .reset(csr_reset),
    .io_readAddress(csr_io_readAddress),
    .io_writeAddress(csr_io_writeAddress),
    .io_readEnable(csr_io_readEnable),
    .io_writeEnable(csr_io_writeEnable),
    .io_writeData(csr_io_writeData),
    .io_instrComplete(csr_io_instrComplete),
    .io_exceptionCause(csr_io_exceptionCause),
    .io_takeTrap(csr_io_takeTrap),
    .io_trapIsInterrupt(csr_io_trapIsInterrupt),
    .io_trapPC(csr_io_trapPC),
    .io_trapInstruction(csr_io_trapInstruction),
    .io_mtimecmpVal(csr_io_mtimecmpVal),
    .io_mret_executing(csr_io_mret_executing),
    .io_data(csr_io_data),
    .io_mretTarget(csr_io_mretTarget),
    .io_trapVector(csr_io_trapVector),
    .io_timerCounter(csr_io_timerCounter),
    .io_interruptRequest(csr_io_interruptRequest),
    .io_interruptCause(csr_io_interruptCause),
    .io_globalInterruptEnabled(csr_io_globalInterruptEnabled),
    .io_timerInterruptEnabled(csr_io_timerInterruptEnabled)
  );
  assign regs_rs1Val_MPORT_en = regs_rs1Val_MPORT_en_pipe_0;
  assign regs_rs1Val_MPORT_addr = regs_rs1Val_MPORT_addr_pipe_0;
  assign regs_rs1Val_MPORT_data = regs[regs_rs1Val_MPORT_addr]; // @[Functions.scala 309:29]
  assign regs_rs2Val_MPORT_en = regs_rs2Val_MPORT_en_pipe_0;
  assign regs_rs2Val_MPORT_addr = regs_rs2Val_MPORT_addr_pipe_0;
  assign regs_rs2Val_MPORT_data = regs[regs_rs2Val_MPORT_addr]; // @[Functions.scala 309:29]
  assign regs_MPORT_data = _T_18 ? _wbData_T_1 : finalResult;
  assign regs_MPORT_addr = decExReg_rd;
  assign regs_MPORT_mask = 1'h1;
  assign regs_MPORT_en = wrEna & _T_3;
  assign io_imem_address = io_imem_stall | io_Bootloader_Stall ? pcReg : _pcNext_T_5; // @[ThreeCats.scala 64:47 66:12 45:27]
  assign io_dmem_rdAddress = $signed(_memAddress_T) + $signed(decOut_decOut_imm_imm); // @[ThreeCats.scala 116:50]
  assign io_dmem_rdEnable = decOut_isLoad & _T_31; // @[ThreeCats.scala 121:38]
  assign io_dmem_wrAddress = $signed(_memAddress_T) + $signed(decOut_decOut_imm_imm); // @[ThreeCats.scala 116:50]
  assign io_dmem_wrData = decOut_isStore & _T_31 ? wrd : data; // @[ThreeCats.scala 125:37 127:20 123:21]
  assign io_dmem_wrEnable_0 = decOut_isStore & _T_31 & wre_0; // @[ThreeCats.scala 122:21 125:37 128:22]
  assign io_dmem_wrEnable_1 = decOut_isStore & _T_31 & wre_1; // @[ThreeCats.scala 122:21 125:37 128:22]
  assign io_dmem_wrEnable_2 = decOut_isStore & _T_31 & wre_2; // @[ThreeCats.scala 122:21 125:37 128:22]
  assign io_dmem_wrEnable_3 = decOut_isStore & _T_31 & wre_3; // @[ThreeCats.scala 122:21 125:37 128:22]
  assign io_timerCounter_out = csr_io_timerCounter; // @[ThreeCats.scala 133:23]
  assign csr_clock = clock;
  assign csr_reset = reset;
  assign csr_io_readAddress = instrReg[31:20]; // @[ThreeCats.scala 109:28]
  assign csr_io_writeAddress = decExReg_instruction[31:20]; // @[ThreeCats.scala 166:46]
  assign csr_io_readEnable = _csr_io_readEnable_T_6 | decOut_isCsrrsi | decOut_isCsrrci; // @[ThreeCats.scala 137:62]
  assign csr_io_writeEnable = decExReg_valid & _csr_io_writeEnable_T_12; // @[ThreeCats.scala 169:40]
  assign csr_io_writeData = decExReg_decOut_isCsrrw ? v1 : _GEN_412; // @[ThreeCats.scala 178:{41,60}]
  assign csr_io_instrComplete = decExReg_valid & ~stall & ~decExReg_decOut_isECall; // @[ThreeCats.scala 187:48]
  assign csr_io_exceptionCause = illegalInstr ? 32'h2 : _GEN_406; // @[ThreeCats.scala 159:{23,40}]
  assign csr_io_takeTrap = exceptionOccurred | takeInterrupt; // @[ThreeCats.scala 191:41]
  assign csr_io_trapIsInterrupt = csr_io_interruptRequest & ~exceptionOccurred & (decExReg_valid | inSleepMode); // @[ThreeCats.scala 163:66]
  assign csr_io_trapPC = decExReg_pc; // @[ThreeCats.scala 194:17]
  assign csr_io_trapInstruction = decExReg_instruction; // @[ThreeCats.scala 195:26]
  assign csr_io_mtimecmpVal = io_mtimecmpVal_in; // @[ThreeCats.scala 134:22]
  assign csr_io_mret_executing = _T_20 & _instrComplete_T; // @[ThreeCats.scala 196:71]
  always @(posedge clock) begin
    if (regs_MPORT_en & regs_MPORT_mask) begin
      regs[regs_MPORT_addr] <= regs_MPORT_data; // @[Functions.scala 309:29]
    end
    regs_rs1Val_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      regs_rs1Val_MPORT_addr_pipe_0 <= instr[19:15];
    end
    regs_rs2Val_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      regs_rs2Val_MPORT_addr_pipe_0 <= instr[24:20];
    end
    if (reset) begin // @[ThreeCats.scala 30:28]
      inSleepMode <= 1'h0; // @[ThreeCats.scala 30:28]
    end else if (inSleepMode & csr_io_interruptRequest) begin // @[ThreeCats.scala 271:48]
      inSleepMode <= 1'h0; // @[ThreeCats.scala 272:17]
    end else if (decExReg_valid & decExReg_decOut_isWfi & processorInitialized) begin // @[ThreeCats.scala 258:73]
      if (csr_io_interruptRequest) begin // @[ThreeCats.scala 260:35]
        inSleepMode <= 1'h0; // @[ThreeCats.scala 261:19]
      end else begin
        inSleepMode <= _GEN_461;
      end
    end
    if (reset) begin // @[ThreeCats.scala 41:25]
      exFwdReg_valid <= 1'h0; // @[ThreeCats.scala 41:25]
    end else begin
      exFwdReg_valid <= _instrComplete_T & wrEna; // @[ThreeCats.scala 253:18]
    end
    if (reset) begin // @[ThreeCats.scala 41:25]
      exFwdReg_wbDest <= 5'h0; // @[ThreeCats.scala 41:25]
    end else begin
      exFwdReg_wbDest <= decExReg_rd; // @[ThreeCats.scala 254:19]
    end
    if (reset) begin // @[ThreeCats.scala 41:25]
      exFwdReg_wbData <= 32'h0; // @[ThreeCats.scala 41:25]
    end else if (decExReg_decOut_isJal | decExReg_decOut_isJalr) begin // @[ThreeCats.scala 219:57]
      exFwdReg_wbData <= _wbData_T_1; // @[ThreeCats.scala 219:66]
    end else if (decExReg_decOut_isLoad & ~doBranch) begin // @[ThreeCats.scala 248:45]
      if (_T_24) begin // @[Functions.scala 372:19]
        exFwdReg_wbData <= _GEN_447;
      end else begin
        exFwdReg_wbData <= _GEN_458;
      end
    end else if (_T_17) begin // @[ThreeCats.scala 211:31]
      exFwdReg_wbData <= decExReg_csr_data; // @[ThreeCats.scala 212:17]
    end else begin
      exFwdReg_wbData <= _GEN_425;
    end
    if (reset) begin // @[ThreeCats.scala 44:22]
      pcReg <= 32'h0; // @[ThreeCats.scala 44:22]
    end else if (!(io_imem_stall | io_Bootloader_Stall)) begin // @[ThreeCats.scala 64:47]
      if (!(stall & ~takeInterrupt)) begin // @[ThreeCats.scala 45:31]
        if (doBranch) begin // @[ThreeCats.scala 45:67]
          pcReg <= branchTarget;
        end else begin
          pcReg <= _pcNext_T_3;
        end
      end
    end
    if (stall) begin // @[ThreeCats.scala 145:14]
      decExReg_valid <= 1'h0; // @[ThreeCats.scala 147:20]
    end else begin
      decExReg_valid <= _T_31; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_decOut_isIllegal <= decOut_isIllegal; // @[ThreeCats.scala 144:25]
    end
    if (reset) begin // @[ThreeCats.scala 50:37]
      processorInitialized <= 1'h0; // @[ThreeCats.scala 50:37]
    end else if (~processorInitialized) begin // @[ThreeCats.scala 52:32]
      processorInitialized <= _GEN_0;
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isECall <= 1'h0; // @[Functions.scala 41:20]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isECall <= 1'h0; // @[Functions.scala 41:20]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isECall <= 1'h0; // @[Functions.scala 41:20]
      end else begin
        decExReg_decOut_isECall <= _GEN_174;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isWfi <= 1'h0; // @[Functions.scala 43:18]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isWfi <= 1'h0; // @[Functions.scala 43:18]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isWfi <= 1'h0; // @[Functions.scala 43:18]
      end else begin
        decExReg_decOut_isWfi <= _GEN_176;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isMret <= 1'h0; // @[Functions.scala 42:19]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isMret <= 1'h0; // @[Functions.scala 42:19]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isMret <= 1'h0; // @[Functions.scala 42:19]
      end else begin
        decExReg_decOut_isMret <= _GEN_175;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isJalr <= 1'h0; // @[Functions.scala 33:19]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isJalr <= 1'h0; // @[Functions.scala 33:19]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isJalr <= 1'h0; // @[Functions.scala 33:19]
      end else begin
        decExReg_decOut_isJalr <= _GEN_173;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isJal <= 1'h0; // @[Functions.scala 32:18]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isJal <= 1'h0; // @[Functions.scala 32:18]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isJal <= 1'h0; // @[Functions.scala 32:18]
      end else begin
        decExReg_decOut_isJal <= _GEN_172;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isBranch <= 1'h0; // @[Functions.scala 31:21]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isBranch <= 1'h0; // @[Functions.scala 26:18]
      end else begin
        decExReg_decOut_isBranch <= 7'h63 == decOut_opcode;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_func3 <= decOut_func3; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_rs1 <= decOut_rs1; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (rs1Val_REG == 5'h0) begin // @[Functions.scala 311:23]
        decExReg_rs1Val <= 32'h0;
      end else begin
        decExReg_rs1Val <= regs_rs1Val_MPORT_data;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_rs2 <= decOut_rs2; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (rs2Val_REG == 5'h0) begin // @[Functions.scala 312:23]
        decExReg_rs2Val <= 32'h0;
      end else begin
        decExReg_rs2Val <= regs_rs2Val_MPORT_data;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (3'h0 == decOut_func3) begin // @[Functions.scala 219:19]
        decExReg_decOut_aluOp <= {{3'd0}, _decOut_decOut_aluOp_T_5};
      end else if (_decOut_T_28) begin // @[Functions.scala 219:19]
        decExReg_decOut_aluOp <= 4'h2; // @[Functions.scala 227:15]
      end else if (_decOut_T_29) begin // @[Functions.scala 219:19]
        decExReg_decOut_aluOp <= 4'h3; // @[Functions.scala 230:15]
      end else begin
        decExReg_decOut_aluOp <= _GEN_258;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_decOut_isImm <= decOut_isImm; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (3'h1 == decOut_instrType) begin // @[Functions.scala 285:23]
        decExReg_decOut_imm <= _decOut_decOut_imm_imm_T_7; // @[Functions.scala 287:13]
      end else if (3'h2 == decOut_instrType) begin // @[Functions.scala 285:23]
        decExReg_decOut_imm <= _decOut_decOut_imm_imm_T_15; // @[Functions.scala 290:13]
      end else if (3'h3 == decOut_instrType) begin // @[Functions.scala 285:23]
        decExReg_decOut_imm <= {{1{_decOut_decOut_imm_imm_T_26[30]}},_decOut_decOut_imm_imm_T_26}; // @[Functions.scala 293:13]
      end else begin
        decExReg_decOut_imm <= _GEN_263;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_pc <= pcRegReg; // @[ThreeCats.scala 144:25]
    end
    if (reset) begin // @[ThreeCats.scala 51:28]
      initCounter <= 2'h0; // @[ThreeCats.scala 51:28]
    end else if (~processorInitialized) begin // @[ThreeCats.scala 52:32]
      initCounter <= _initCounter_T_1; // @[ThreeCats.scala 53:17]
    end
    pcRegReg <= pcReg; // @[ThreeCats.scala 73:25]
    if (reset) begin // @[ThreeCats.scala 74:25]
      instrReg <= 32'h13; // @[ThreeCats.scala 74:25]
    end else if (doBranch) begin // @[ThreeCats.scala 75:18]
      instrReg <= 32'h13;
    end else if (!(stall)) begin // @[ThreeCats.scala 75:46]
      if (io_imem_stall | io_Bootloader_Stall) begin // @[ThreeCats.scala 64:47]
        instrReg <= 32'h13; // @[ThreeCats.scala 65:11]
      end else begin
        instrReg <= io_imem_data; // @[ThreeCats.scala 63:26]
      end
    end
    rs1Val_REG <= instr[19:15]; // @[ThreeCats.scala 79:18]
    rs2Val_REG <= instr[24:20]; // @[ThreeCats.scala 80:18]
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_rd <= decOut_rd; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_decOut_rfWrite <= decOut_rfWrite; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isLoad <= 1'h0; // @[Functions.scala 29:19]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isLoad <= 1'h0; // @[Functions.scala 29:19]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isLoad <= 1'h0; // @[Functions.scala 29:19]
      end else begin
        decExReg_decOut_isLoad <= 7'h3 == decOut_opcode;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_memLow <= decEx_memLow; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrw <= 1'h0; // @[Functions.scala 44:20]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrw <= 1'h0; // @[Functions.scala 44:20]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrw <= 1'h0; // @[Functions.scala 44:20]
      end else begin
        decExReg_decOut_isCsrrw <= _GEN_177;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrs <= 1'h0; // @[Functions.scala 45:20]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrs <= 1'h0; // @[Functions.scala 45:20]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrs <= 1'h0; // @[Functions.scala 45:20]
      end else begin
        decExReg_decOut_isCsrrs <= _GEN_178;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrc <= 1'h0; // @[Functions.scala 46:20]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrc <= 1'h0; // @[Functions.scala 46:20]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrc <= 1'h0; // @[Functions.scala 46:20]
      end else begin
        decExReg_decOut_isCsrrc <= _GEN_179;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrwi <= 1'h0; // @[Functions.scala 47:21]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrwi <= 1'h0; // @[Functions.scala 47:21]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrwi <= 1'h0; // @[Functions.scala 47:21]
      end else begin
        decExReg_decOut_isCsrrwi <= _GEN_180;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrsi <= 1'h0; // @[Functions.scala 48:21]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrsi <= 1'h0; // @[Functions.scala 48:21]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrsi <= 1'h0; // @[Functions.scala 48:21]
      end else begin
        decExReg_decOut_isCsrrsi <= _GEN_181;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrci <= 1'h0; // @[Functions.scala 49:21]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrci <= 1'h0; // @[Functions.scala 49:21]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isCsrrci <= 1'h0; // @[Functions.scala 49:21]
      end else begin
        decExReg_decOut_isCsrrci <= _GEN_182;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_csr_data <= decEx_csr_data; // @[ThreeCats.scala 144:25]
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isAuiPc <= 1'h0; // @[Functions.scala 28:20]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isAuiPc <= 1'h0; // @[Functions.scala 28:20]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isAuiPc <= 1'h0; // @[Functions.scala 28:20]
      end else begin
        decExReg_decOut_isAuiPc <= _GEN_171;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      if (7'h13 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isLui <= 1'h0; // @[Functions.scala 27:18]
      end else if (7'h33 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isLui <= 1'h0; // @[Functions.scala 27:18]
      end else if (7'h63 == decOut_opcode) begin // @[Functions.scala 57:20]
        decExReg_decOut_isLui <= 1'h0; // @[Functions.scala 27:18]
      end else begin
        decExReg_decOut_isLui <= _GEN_170;
      end
    end
    if (!(stall)) begin // @[ThreeCats.scala 145:14]
      decExReg_instruction <= instrReg; // @[ThreeCats.scala 144:25]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~_decOut_T & ~_decOut_T_1 & ~_decOut_T_2 & ~_decOut_T_3 & ~_decOut_T_4 & ~_decOut_T_5 & ~_decOut_T_6 & ~
          _decOut_T_7 & ~_decOut_T_8 & _decOut_T_10 & _decOut_validBranchFunc3_T & ~_decOut_T_13 & ~_decOut_T_19 &
          _decOut_T_25 & ~reset) begin
          $fwrite(32'h80000002,"WFI instruction decoded"); // @[Functions.scala 143:19]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
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
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    regs[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_rs1Val_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  regs_rs1Val_MPORT_addr_pipe_0 = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  regs_rs2Val_MPORT_en_pipe_0 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  regs_rs2Val_MPORT_addr_pipe_0 = _RAND_4[4:0];
  _RAND_5 = {1{`RANDOM}};
  inSleepMode = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  exFwdReg_valid = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  exFwdReg_wbDest = _RAND_7[4:0];
  _RAND_8 = {1{`RANDOM}};
  exFwdReg_wbData = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  pcReg = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  decExReg_valid = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  decExReg_decOut_isIllegal = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  processorInitialized = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  decExReg_decOut_isECall = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  decExReg_decOut_isWfi = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  decExReg_decOut_isMret = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  decExReg_decOut_isJalr = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  decExReg_decOut_isJal = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  decExReg_decOut_isBranch = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  decExReg_func3 = _RAND_19[2:0];
  _RAND_20 = {1{`RANDOM}};
  decExReg_rs1 = _RAND_20[4:0];
  _RAND_21 = {1{`RANDOM}};
  decExReg_rs1Val = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  decExReg_rs2 = _RAND_22[4:0];
  _RAND_23 = {1{`RANDOM}};
  decExReg_rs2Val = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  decExReg_decOut_aluOp = _RAND_24[3:0];
  _RAND_25 = {1{`RANDOM}};
  decExReg_decOut_isImm = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  decExReg_decOut_imm = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  decExReg_pc = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  initCounter = _RAND_28[1:0];
  _RAND_29 = {1{`RANDOM}};
  pcRegReg = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  instrReg = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  rs1Val_REG = _RAND_31[4:0];
  _RAND_32 = {1{`RANDOM}};
  rs2Val_REG = _RAND_32[4:0];
  _RAND_33 = {1{`RANDOM}};
  decExReg_rd = _RAND_33[4:0];
  _RAND_34 = {1{`RANDOM}};
  decExReg_decOut_rfWrite = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  decExReg_decOut_isLoad = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  decExReg_memLow = _RAND_36[1:0];
  _RAND_37 = {1{`RANDOM}};
  decExReg_decOut_isCsrrw = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  decExReg_decOut_isCsrrs = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  decExReg_decOut_isCsrrc = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  decExReg_decOut_isCsrrwi = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  decExReg_decOut_isCsrrsi = _RAND_41[0:0];
  _RAND_42 = {1{`RANDOM}};
  decExReg_decOut_isCsrrci = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  decExReg_csr_data = _RAND_43[31:0];
  _RAND_44 = {1{`RANDOM}};
  decExReg_decOut_isAuiPc = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  decExReg_decOut_isLui = _RAND_45[0:0];
  _RAND_46 = {1{`RANDOM}};
  decExReg_instruction = _RAND_46[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module TilelinkHost(
  input         clock,
  input         reset,
  output        io_tlMasterTransmitter_valid,
  output [2:0]  io_tlMasterTransmitter_bits_a_opcode,
  output [31:0] io_tlMasterTransmitter_bits_a_address,
  output [3:0]  io_tlMasterTransmitter_bits_a_mask,
  output [31:0] io_tlMasterTransmitter_bits_a_data,
  input         io_tlSlaveReceiver_valid,
  input  [31:0] io_tlSlaveReceiver_bits_d_data,
  output        io_reqIn_ready,
  input         io_reqIn_valid,
  input  [31:0] io_reqIn_bits_addrRequest,
  input  [31:0] io_reqIn_bits_dataRequest,
  input  [3:0]  io_reqIn_bits_activeByteLane,
  input         io_reqIn_bits_isWrite,
  output        io_rspOut_valid,
  output [31:0] io_rspOut_bits_dataResponse
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] addReg; // @[TilelinkHost.scala 19:25]
  wire  _io_tlMasterTransmitter_bits_a_opcode_T_1 = io_reqIn_bits_activeByteLane == 4'hf ? 1'h0 : 1'h1; // @[TilelinkHost.scala 87:83]
  wire [2:0] _io_tlMasterTransmitter_bits_a_opcode_T_2 = io_reqIn_bits_isWrite ? {{2'd0},
    _io_tlMasterTransmitter_bits_a_opcode_T_1} : 3'h4; // @[TilelinkHost.scala 87:56]
  wire  _GEN_47 = io_reqIn_valid ? 1'h0 : 1'h1; // @[TilelinkHost.scala 53:25 26:33]
  assign io_tlMasterTransmitter_valid = io_reqIn_valid; // @[TilelinkHost.scala 53:25 36:45]
  assign io_tlMasterTransmitter_bits_a_opcode = io_reqIn_valid ? _io_tlMasterTransmitter_bits_a_opcode_T_2 : 3'h0; // @[TilelinkHost.scala 53:25 28:45]
  assign io_tlMasterTransmitter_bits_a_address = io_reqIn_valid ? io_reqIn_bits_addrRequest : addReg; // @[TilelinkHost.scala 53:25 30:45]
  assign io_tlMasterTransmitter_bits_a_mask = io_reqIn_valid ? io_reqIn_bits_activeByteLane : 4'h0; // @[TilelinkHost.scala 53:25 34:45]
  assign io_tlMasterTransmitter_bits_a_data = io_reqIn_valid ? io_reqIn_bits_dataRequest : 32'h0; // @[TilelinkHost.scala 53:25 29:45]
  assign io_reqIn_ready = io_tlSlaveReceiver_valid | _GEN_47; // @[TilelinkHost.scala 129:35]
  assign io_rspOut_valid = io_tlSlaveReceiver_valid; // @[TilelinkHost.scala 129:35 134:25 39:45]
  assign io_rspOut_bits_dataResponse = io_tlSlaveReceiver_valid ? io_tlSlaveReceiver_bits_d_data : 32'h0; // @[TilelinkHost.scala 129:35 131:37 37:45]
  always @(posedge clock) begin
    if (reset) begin // @[TilelinkHost.scala 19:25]
      addReg <= 32'h0; // @[TilelinkHost.scala 19:25]
    end else if (io_reqIn_valid) begin // @[TilelinkHost.scala 53:25]
      addReg <= io_reqIn_bits_addrRequest;
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
  addReg = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module TilelinkDevice(
  output        io_tlSlaveTransmitter_valid,
  output [31:0] io_tlSlaveTransmitter_bits_d_data,
  input         io_tlMasterReceiver_valid,
  input  [2:0]  io_tlMasterReceiver_bits_a_opcode,
  input  [31:0] io_tlMasterReceiver_bits_a_address,
  input  [3:0]  io_tlMasterReceiver_bits_a_mask,
  input  [31:0] io_tlMasterReceiver_bits_a_data,
  output        io_reqOut_valid,
  output [31:0] io_reqOut_bits_addrRequest,
  output [31:0] io_reqOut_bits_dataRequest,
  output [3:0]  io_reqOut_bits_activeByteLane,
  output        io_reqOut_bits_isWrite,
  output        io_rspIn_ready,
  input         io_rspIn_valid,
  input  [31:0] io_rspIn_bits_dataResponse
);
  assign io_tlSlaveTransmitter_valid = io_rspIn_valid; // @[TilelinkDevice.scala 68:83]
  assign io_tlSlaveTransmitter_bits_d_data = io_rspIn_valid ? io_rspIn_bits_dataResponse : 32'h0; // @[TilelinkDevice.scala 199:34 205:51 48:45]
  assign io_reqOut_valid = io_tlMasterReceiver_valid; // @[TilelinkDevice.scala 68:83]
  assign io_reqOut_bits_addrRequest = io_tlMasterReceiver_valid ? io_tlMasterReceiver_bits_a_address : 32'h0; // @[TilelinkDevice.scala 164:45 166:40 41:37]
  assign io_reqOut_bits_dataRequest = io_tlMasterReceiver_valid ? io_tlMasterReceiver_bits_a_data : 32'h0; // @[TilelinkDevice.scala 42:37 70:40 80:40]
  assign io_reqOut_bits_activeByteLane = io_tlMasterReceiver_valid ? io_tlMasterReceiver_bits_a_mask : 4'h0; // @[TilelinkDevice.scala 43:37 70:40 81:43]
  assign io_reqOut_bits_isWrite = io_tlMasterReceiver_valid & (io_tlMasterReceiver_bits_a_opcode == 3'h0 |
    io_tlMasterReceiver_bits_a_opcode == 3'h1); // @[TilelinkDevice.scala 164:45 169:36 44:37]
  assign io_rspIn_ready = io_rspIn_valid ? 1'h0 : io_tlMasterReceiver_valid; // @[TilelinkDevice.scala 199:34 218:28]
endmodule
module TilelinkAdapter(
  input         clock,
  input         reset,
  input         io_reqIn_valid,
  input  [31:0] io_reqIn_bits_addrRequest,
  input  [31:0] io_reqIn_bits_dataRequest,
  input  [3:0]  io_reqIn_bits_activeByteLane,
  input         io_reqIn_bits_isWrite,
  output        io_rspOut_valid,
  output [31:0] io_rspOut_bits_dataResponse,
  output        io_reqOut_valid,
  output [31:0] io_reqOut_bits_addrRequest,
  output [31:0] io_reqOut_bits_dataRequest,
  output [3:0]  io_reqOut_bits_activeByteLane,
  output        io_reqOut_bits_isWrite,
  input         io_rspIn_valid,
  input  [31:0] io_rspIn_bits_dataResponse
);
  wire  tlHost_clock; // @[TilelinkAdapter.scala 18:24]
  wire  tlHost_reset; // @[TilelinkAdapter.scala 18:24]
  wire  tlHost_io_tlMasterTransmitter_valid; // @[TilelinkAdapter.scala 18:24]
  wire [2:0] tlHost_io_tlMasterTransmitter_bits_a_opcode; // @[TilelinkAdapter.scala 18:24]
  wire [31:0] tlHost_io_tlMasterTransmitter_bits_a_address; // @[TilelinkAdapter.scala 18:24]
  wire [3:0] tlHost_io_tlMasterTransmitter_bits_a_mask; // @[TilelinkAdapter.scala 18:24]
  wire [31:0] tlHost_io_tlMasterTransmitter_bits_a_data; // @[TilelinkAdapter.scala 18:24]
  wire  tlHost_io_tlSlaveReceiver_valid; // @[TilelinkAdapter.scala 18:24]
  wire [31:0] tlHost_io_tlSlaveReceiver_bits_d_data; // @[TilelinkAdapter.scala 18:24]
  wire  tlHost_io_reqIn_ready; // @[TilelinkAdapter.scala 18:24]
  wire  tlHost_io_reqIn_valid; // @[TilelinkAdapter.scala 18:24]
  wire [31:0] tlHost_io_reqIn_bits_addrRequest; // @[TilelinkAdapter.scala 18:24]
  wire [31:0] tlHost_io_reqIn_bits_dataRequest; // @[TilelinkAdapter.scala 18:24]
  wire [3:0] tlHost_io_reqIn_bits_activeByteLane; // @[TilelinkAdapter.scala 18:24]
  wire  tlHost_io_reqIn_bits_isWrite; // @[TilelinkAdapter.scala 18:24]
  wire  tlHost_io_rspOut_valid; // @[TilelinkAdapter.scala 18:24]
  wire [31:0] tlHost_io_rspOut_bits_dataResponse; // @[TilelinkAdapter.scala 18:24]
  wire  tlSlave_io_tlSlaveTransmitter_valid; // @[TilelinkAdapter.scala 19:25]
  wire [31:0] tlSlave_io_tlSlaveTransmitter_bits_d_data; // @[TilelinkAdapter.scala 19:25]
  wire  tlSlave_io_tlMasterReceiver_valid; // @[TilelinkAdapter.scala 19:25]
  wire [2:0] tlSlave_io_tlMasterReceiver_bits_a_opcode; // @[TilelinkAdapter.scala 19:25]
  wire [31:0] tlSlave_io_tlMasterReceiver_bits_a_address; // @[TilelinkAdapter.scala 19:25]
  wire [3:0] tlSlave_io_tlMasterReceiver_bits_a_mask; // @[TilelinkAdapter.scala 19:25]
  wire [31:0] tlSlave_io_tlMasterReceiver_bits_a_data; // @[TilelinkAdapter.scala 19:25]
  wire  tlSlave_io_reqOut_valid; // @[TilelinkAdapter.scala 19:25]
  wire [31:0] tlSlave_io_reqOut_bits_addrRequest; // @[TilelinkAdapter.scala 19:25]
  wire [31:0] tlSlave_io_reqOut_bits_dataRequest; // @[TilelinkAdapter.scala 19:25]
  wire [3:0] tlSlave_io_reqOut_bits_activeByteLane; // @[TilelinkAdapter.scala 19:25]
  wire  tlSlave_io_reqOut_bits_isWrite; // @[TilelinkAdapter.scala 19:25]
  wire  tlSlave_io_rspIn_ready; // @[TilelinkAdapter.scala 19:25]
  wire  tlSlave_io_rspIn_valid; // @[TilelinkAdapter.scala 19:25]
  wire [31:0] tlSlave_io_rspIn_bits_dataResponse; // @[TilelinkAdapter.scala 19:25]
  TilelinkHost tlHost ( // @[TilelinkAdapter.scala 18:24]
    .clock(tlHost_clock),
    .reset(tlHost_reset),
    .io_tlMasterTransmitter_valid(tlHost_io_tlMasterTransmitter_valid),
    .io_tlMasterTransmitter_bits_a_opcode(tlHost_io_tlMasterTransmitter_bits_a_opcode),
    .io_tlMasterTransmitter_bits_a_address(tlHost_io_tlMasterTransmitter_bits_a_address),
    .io_tlMasterTransmitter_bits_a_mask(tlHost_io_tlMasterTransmitter_bits_a_mask),
    .io_tlMasterTransmitter_bits_a_data(tlHost_io_tlMasterTransmitter_bits_a_data),
    .io_tlSlaveReceiver_valid(tlHost_io_tlSlaveReceiver_valid),
    .io_tlSlaveReceiver_bits_d_data(tlHost_io_tlSlaveReceiver_bits_d_data),
    .io_reqIn_ready(tlHost_io_reqIn_ready),
    .io_reqIn_valid(tlHost_io_reqIn_valid),
    .io_reqIn_bits_addrRequest(tlHost_io_reqIn_bits_addrRequest),
    .io_reqIn_bits_dataRequest(tlHost_io_reqIn_bits_dataRequest),
    .io_reqIn_bits_activeByteLane(tlHost_io_reqIn_bits_activeByteLane),
    .io_reqIn_bits_isWrite(tlHost_io_reqIn_bits_isWrite),
    .io_rspOut_valid(tlHost_io_rspOut_valid),
    .io_rspOut_bits_dataResponse(tlHost_io_rspOut_bits_dataResponse)
  );
  TilelinkDevice tlSlave ( // @[TilelinkAdapter.scala 19:25]
    .io_tlSlaveTransmitter_valid(tlSlave_io_tlSlaveTransmitter_valid),
    .io_tlSlaveTransmitter_bits_d_data(tlSlave_io_tlSlaveTransmitter_bits_d_data),
    .io_tlMasterReceiver_valid(tlSlave_io_tlMasterReceiver_valid),
    .io_tlMasterReceiver_bits_a_opcode(tlSlave_io_tlMasterReceiver_bits_a_opcode),
    .io_tlMasterReceiver_bits_a_address(tlSlave_io_tlMasterReceiver_bits_a_address),
    .io_tlMasterReceiver_bits_a_mask(tlSlave_io_tlMasterReceiver_bits_a_mask),
    .io_tlMasterReceiver_bits_a_data(tlSlave_io_tlMasterReceiver_bits_a_data),
    .io_reqOut_valid(tlSlave_io_reqOut_valid),
    .io_reqOut_bits_addrRequest(tlSlave_io_reqOut_bits_addrRequest),
    .io_reqOut_bits_dataRequest(tlSlave_io_reqOut_bits_dataRequest),
    .io_reqOut_bits_activeByteLane(tlSlave_io_reqOut_bits_activeByteLane),
    .io_reqOut_bits_isWrite(tlSlave_io_reqOut_bits_isWrite),
    .io_rspIn_ready(tlSlave_io_rspIn_ready),
    .io_rspIn_valid(tlSlave_io_rspIn_valid),
    .io_rspIn_bits_dataResponse(tlSlave_io_rspIn_bits_dataResponse)
  );
  assign io_rspOut_valid = tlHost_io_rspOut_valid; // @[TilelinkAdapter.scala 31:15]
  assign io_rspOut_bits_dataResponse = tlHost_io_rspOut_bits_dataResponse; // @[TilelinkAdapter.scala 31:15]
  assign io_reqOut_valid = tlSlave_io_reqOut_valid; // @[TilelinkAdapter.scala 34:15]
  assign io_reqOut_bits_addrRequest = tlSlave_io_reqOut_bits_addrRequest; // @[TilelinkAdapter.scala 34:15]
  assign io_reqOut_bits_dataRequest = tlSlave_io_reqOut_bits_dataRequest; // @[TilelinkAdapter.scala 34:15]
  assign io_reqOut_bits_activeByteLane = tlSlave_io_reqOut_bits_activeByteLane; // @[TilelinkAdapter.scala 34:15]
  assign io_reqOut_bits_isWrite = tlSlave_io_reqOut_bits_isWrite; // @[TilelinkAdapter.scala 34:15]
  assign tlHost_clock = clock;
  assign tlHost_reset = reset;
  assign tlHost_io_tlSlaveReceiver_valid = tlSlave_io_tlSlaveTransmitter_valid; // @[TilelinkAdapter.scala 25:35]
  assign tlHost_io_tlSlaveReceiver_bits_d_data = tlSlave_io_tlSlaveTransmitter_bits_d_data; // @[TilelinkAdapter.scala 25:35]
  assign tlHost_io_reqIn_valid = io_reqIn_valid; // @[TilelinkAdapter.scala 28:21]
  assign tlHost_io_reqIn_bits_addrRequest = io_reqIn_bits_addrRequest; // @[TilelinkAdapter.scala 28:21]
  assign tlHost_io_reqIn_bits_dataRequest = io_reqIn_bits_dataRequest; // @[TilelinkAdapter.scala 28:21]
  assign tlHost_io_reqIn_bits_activeByteLane = io_reqIn_bits_activeByteLane; // @[TilelinkAdapter.scala 28:21]
  assign tlHost_io_reqIn_bits_isWrite = io_reqIn_bits_isWrite; // @[TilelinkAdapter.scala 28:21]
  assign tlSlave_io_tlMasterReceiver_valid = tlHost_io_tlMasterTransmitter_valid; // @[TilelinkAdapter.scala 22:35]
  assign tlSlave_io_tlMasterReceiver_bits_a_opcode = tlHost_io_tlMasterTransmitter_bits_a_opcode; // @[TilelinkAdapter.scala 22:35]
  assign tlSlave_io_tlMasterReceiver_bits_a_address = tlHost_io_tlMasterTransmitter_bits_a_address; // @[TilelinkAdapter.scala 22:35]
  assign tlSlave_io_tlMasterReceiver_bits_a_mask = tlHost_io_tlMasterTransmitter_bits_a_mask; // @[TilelinkAdapter.scala 22:35]
  assign tlSlave_io_tlMasterReceiver_bits_a_data = tlHost_io_tlMasterTransmitter_bits_a_data; // @[TilelinkAdapter.scala 22:35]
  assign tlSlave_io_rspIn_valid = io_rspIn_valid; // @[TilelinkAdapter.scala 37:22]
  assign tlSlave_io_rspIn_bits_dataResponse = io_rspIn_bits_dataResponse; // @[TilelinkAdapter.scala 37:22]
endmodule
module SRAM(
  input         clock,
  input         io_rw,
  input  [7:0]  io_ad,
  input  [20:0] io_DI,
  input         io_EN,
  output [20:0] io_DO
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [20:0] mem [0:255]; // @[SRAM.scala 26:24]
  wire  mem_readValue_en; // @[SRAM.scala 26:24]
  wire [7:0] mem_readValue_addr; // @[SRAM.scala 26:24]
  wire [20:0] mem_readValue_data; // @[SRAM.scala 26:24]
  wire [20:0] mem_MPORT_data; // @[SRAM.scala 26:24]
  wire [7:0] mem_MPORT_addr; // @[SRAM.scala 26:24]
  wire  mem_MPORT_mask; // @[SRAM.scala 26:24]
  wire  mem_MPORT_en; // @[SRAM.scala 26:24]
  reg  mem_readValue_en_pipe_0;
  reg [7:0] mem_readValue_addr_pipe_0;
  wire  _T = ~io_rw; // @[SRAM.scala 34:10]
  assign mem_readValue_en = mem_readValue_en_pipe_0;
  assign mem_readValue_addr = mem_readValue_addr_pipe_0;
  assign mem_readValue_data = mem[mem_readValue_addr]; // @[SRAM.scala 26:24]
  assign mem_MPORT_data = io_DI;
  assign mem_MPORT_addr = io_ad;
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = io_EN & _T;
  assign io_DO = mem_readValue_data; // @[SRAM.scala 31:9]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[SRAM.scala 26:24]
    end
    mem_readValue_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      mem_readValue_addr_pipe_0 <= io_ad;
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
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem[initvar] = _RAND_0[20:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mem_readValue_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  mem_readValue_addr_pipe_0 = _RAND_2[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SRAM_1(
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
  reg [31:0] mem [0:1023]; // @[SRAM.scala 26:24]
  wire  mem_readValue_en; // @[SRAM.scala 26:24]
  wire [9:0] mem_readValue_addr; // @[SRAM.scala 26:24]
  wire [31:0] mem_readValue_data; // @[SRAM.scala 26:24]
  wire [31:0] mem_MPORT_data; // @[SRAM.scala 26:24]
  wire [9:0] mem_MPORT_addr; // @[SRAM.scala 26:24]
  wire  mem_MPORT_mask; // @[SRAM.scala 26:24]
  wire  mem_MPORT_en; // @[SRAM.scala 26:24]
  reg  mem_readValue_en_pipe_0;
  reg [9:0] mem_readValue_addr_pipe_0;
  wire  _T = ~io_rw; // @[SRAM.scala 34:10]
  assign mem_readValue_en = mem_readValue_en_pipe_0;
  assign mem_readValue_addr = mem_readValue_addr_pipe_0;
  assign mem_readValue_data = mem[mem_readValue_addr]; // @[SRAM.scala 26:24]
  assign mem_MPORT_data = io_DI;
  assign mem_MPORT_addr = io_ad;
  assign mem_MPORT_mask = 1'h1;
  assign mem_MPORT_en = io_EN & _T;
  assign io_DO = mem_readValue_data; // @[SRAM.scala 31:9]
  always @(posedge clock) begin
    if (mem_MPORT_en & mem_MPORT_mask) begin
      mem[mem_MPORT_addr] <= mem_MPORT_data; // @[SRAM.scala 26:24]
    end
    mem_readValue_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      mem_readValue_addr_pipe_0 <= io_ad;
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
  mem_readValue_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  mem_readValue_addr_pipe_0 = _RAND_2[9:0];
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
  input  [31:0] io_CPUdataIn,
  output [31:0] io_CPUdataOut,
  output        io_stall,
  output        io_ready,
  input         io_wrEnable_0,
  input         io_wrEnable_1,
  input         io_wrEnable_2,
  input         io_wrEnable_3,
  input  [31:0] io_memDataIn,
  input         io_memReady,
  output [31:0] io_alloAddr,
  output [1:0]  io_memReq
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
`endif // RANDOMIZE_REG_INIT
  wire  tagStore_clock; // @[CacheController.scala 44:24]
  wire  tagStore_io_rw; // @[CacheController.scala 44:24]
  wire [7:0] tagStore_io_ad; // @[CacheController.scala 44:24]
  wire [20:0] tagStore_io_DI; // @[CacheController.scala 44:24]
  wire  tagStore_io_EN; // @[CacheController.scala 44:24]
  wire [20:0] tagStore_io_DO; // @[CacheController.scala 44:24]
  wire  cache_clock; // @[CacheController.scala 45:21]
  wire  cache_io_rw; // @[CacheController.scala 45:21]
  wire [9:0] cache_io_ad; // @[CacheController.scala 45:21]
  wire [31:0] cache_io_DI; // @[CacheController.scala 45:21]
  wire  cache_io_EN; // @[CacheController.scala 45:21]
  wire [31:0] cache_io_DO; // @[CacheController.scala 45:21]
  reg [31:0] lastRead; // @[CacheController.scala 43:25]
  wire [1:0] blockOffset = io_memAdd[3:2]; // @[CacheController.scala 49:30]
  wire [7:0] index = io_memAdd[11:4]; // @[CacheController.scala 50:24]
  reg [19:0] targetTag; // @[CacheController.scala 51:26]
  wire [19:0] actualTag = tagStore_io_DO[20:1]; // @[CacheController.scala 52:33]
  wire  cacheInvalid = ~tagStore_io_DO[0]; // @[CacheController.scala 53:22]
  reg [2:0] rwIndex; // @[CacheController.scala 54:24]
  reg [9:0] cacheWTReg; // @[CacheController.scala 59:27]
  wire [29:0] memWordAdd = io_memAdd[31:2]; // @[CacheController.scala 63:29]
  reg [1:0] memReq; // @[CacheController.scala 65:23]
  reg  rwReg; // @[CacheController.scala 67:22]
  reg [7:0] indexReg; // @[CacheController.scala 68:25]
  reg [31:0] dataInReg; // @[CacheController.scala 69:26]
  reg  wreReg_0; // @[CacheController.scala 70:19]
  reg  wreReg_1; // @[CacheController.scala 70:19]
  reg  wreReg_2; // @[CacheController.scala 70:19]
  reg  wreReg_3; // @[CacheController.scala 70:19]
  wire [9:0] cacheReadAdd = {index,blockOffset}; // @[CacheController.scala 86:25]
  wire [10:0] _cacheAllocationAdd_T = {indexReg,rwIndex}; // @[CacheController.scala 88:34]
  reg [2:0] stateReg; // @[CacheController.scala 102:25]
  wire [9:0] _GEN_3 = io_validReq ? cacheReadAdd : 10'h0; // @[CacheController.scala 109:25 115:18 62:26]
  wire  _GEN_4 = io_validReq ? io_rw : rwReg; // @[CacheController.scala 109:25 119:15 67:22]
  wire [9:0] _GEN_5 = io_validReq ? cacheReadAdd : cacheWTReg; // @[CacheController.scala 109:25 120:20 59:27]
  wire [7:0] _GEN_6 = io_validReq ? index : indexReg; // @[CacheController.scala 109:25 121:18 68:25]
  wire [31:0] _GEN_7 = io_validReq ? io_CPUdataIn : dataInReg; // @[CacheController.scala 109:25 122:19 69:26]
  wire  _GEN_8 = io_validReq ? io_wrEnable_0 : wreReg_0; // @[CacheController.scala 109:25 123:16 70:19]
  wire  _GEN_9 = io_validReq ? io_wrEnable_1 : wreReg_1; // @[CacheController.scala 109:25 123:16 70:19]
  wire  _GEN_10 = io_validReq ? io_wrEnable_2 : wreReg_2; // @[CacheController.scala 109:25 123:16 70:19]
  wire  _GEN_11 = io_validReq ? io_wrEnable_3 : wreReg_3; // @[CacheController.scala 109:25 123:16 70:19]
  wire  _T_6 = actualTag == targetTag; // @[CacheController.scala 137:28]
  wire [1:0] _GEN_12 = io_validReq ? 2'h2 : 2'h0; // @[CacheController.scala 148:28 155:22 157:22]
  wire [1:0] _GEN_13 = rwReg ? 2'h0 : 2'h2; // @[CacheController.scala 142:21 144:18 162:18]
  wire  _GEN_14 = rwReg ? _GEN_4 : rwReg; // @[CacheController.scala 142:21 67:22]
  wire [9:0] _GEN_15 = rwReg ? _GEN_5 : cacheWTReg; // @[CacheController.scala 142:21 59:27]
  wire [7:0] _GEN_16 = rwReg ? _GEN_6 : indexReg; // @[CacheController.scala 142:21 68:25]
  wire [31:0] _GEN_17 = rwReg ? _GEN_7 : dataInReg; // @[CacheController.scala 142:21 69:26]
  wire  _GEN_18 = rwReg ? _GEN_8 : wreReg_0; // @[CacheController.scala 142:21 70:19]
  wire  _GEN_19 = rwReg ? _GEN_9 : wreReg_1; // @[CacheController.scala 142:21 70:19]
  wire  _GEN_20 = rwReg ? _GEN_10 : wreReg_2; // @[CacheController.scala 142:21 70:19]
  wire  _GEN_21 = rwReg ? _GEN_11 : wreReg_3; // @[CacheController.scala 142:21 70:19]
  wire [2:0] _GEN_22 = rwReg ? {{1'd0}, _GEN_12} : 3'h4; // @[CacheController.scala 142:21 165:20]
  wire [9:0] cacheAllocationAdd = _cacheAllocationAdd_T[9:0]; // @[CacheController.scala 60:36 88:22]
  wire [9:0] _GEN_23 = actualTag == targetTag ? cacheReadAdd : cacheAllocationAdd; // @[CacheController.scala 137:43 138:18 168:18]
  wire [31:0] _GEN_25 = actualTag == targetTag ? cache_io_DO : lastRead; // @[CacheController.scala 137:43 140:18 43:25]
  wire [1:0] _GEN_26 = actualTag == targetTag ? _GEN_13 : 2'h1; // @[CacheController.scala 137:43 170:16]
  wire  _GEN_27 = actualTag == targetTag ? _GEN_14 : rwReg; // @[CacheController.scala 137:43 67:22]
  wire [9:0] _GEN_28 = actualTag == targetTag ? _GEN_15 : cacheWTReg; // @[CacheController.scala 137:43 59:27]
  wire [7:0] _GEN_29 = actualTag == targetTag ? _GEN_16 : indexReg; // @[CacheController.scala 137:43 68:25]
  wire [31:0] _GEN_30 = actualTag == targetTag ? _GEN_17 : dataInReg; // @[CacheController.scala 137:43 69:26]
  wire  _GEN_31 = actualTag == targetTag ? _GEN_18 : wreReg_0; // @[CacheController.scala 137:43 70:19]
  wire  _GEN_32 = actualTag == targetTag ? _GEN_19 : wreReg_1; // @[CacheController.scala 137:43 70:19]
  wire  _GEN_33 = actualTag == targetTag ? _GEN_20 : wreReg_2; // @[CacheController.scala 137:43 70:19]
  wire  _GEN_34 = actualTag == targetTag ? _GEN_21 : wreReg_3; // @[CacheController.scala 137:43 70:19]
  wire [2:0] _GEN_35 = actualTag == targetTag ? _GEN_22 : 3'h3; // @[CacheController.scala 137:43 171:18]
  wire  _GEN_36 = actualTag == targetTag ? 1'h0 : 1'h1; // @[CacheController.scala 137:43 77:12 169:18]
  wire [9:0] _GEN_37 = cacheInvalid ? cacheAllocationAdd : _GEN_23; // @[CacheController.scala 132:26 133:18]
  wire  _GEN_38 = cacheInvalid | _GEN_36; // @[CacheController.scala 132:26 134:18]
  wire [1:0] _GEN_39 = cacheInvalid ? 2'h1 : _GEN_26; // @[CacheController.scala 132:26 135:16]
  wire  _GEN_41 = cacheInvalid ? 1'h0 : _T_6; // @[CacheController.scala 132:26 82:15]
  wire [31:0] _GEN_42 = cacheInvalid ? lastRead : _GEN_25; // @[CacheController.scala 132:26 43:25]
  wire  _GEN_43 = cacheInvalid ? rwReg : _GEN_27; // @[CacheController.scala 132:26 67:22]
  wire [9:0] _GEN_44 = cacheInvalid ? cacheWTReg : _GEN_28; // @[CacheController.scala 132:26 59:27]
  wire [7:0] _GEN_45 = cacheInvalid ? indexReg : _GEN_29; // @[CacheController.scala 132:26 68:25]
  wire [31:0] _GEN_46 = cacheInvalid ? dataInReg : _GEN_30; // @[CacheController.scala 132:26 69:26]
  wire  _GEN_47 = cacheInvalid ? wreReg_0 : _GEN_31; // @[CacheController.scala 132:26 70:19]
  wire  _GEN_48 = cacheInvalid ? wreReg_1 : _GEN_32; // @[CacheController.scala 132:26 70:19]
  wire  _GEN_49 = cacheInvalid ? wreReg_2 : _GEN_33; // @[CacheController.scala 132:26 70:19]
  wire  _GEN_50 = cacheInvalid ? wreReg_3 : _GEN_34; // @[CacheController.scala 132:26 70:19]
  wire [2:0] _GEN_51 = rwReg ? {{2'd0}, io_validReq} : 3'h4; // @[CacheController.scala 187:21 206:20]
  wire [2:0] _GEN_64 = _T_6 ? _GEN_51 : 3'h3; // @[CacheController.scala 182:43 212:18]
  wire [2:0] _GEN_69 = cacheInvalid ? 3'h3 : _GEN_64; // @[CacheController.scala 177:26 181:18]
  wire [7:0] modifiedData_readBytes_0 = lastRead[7:0]; // @[CacheFunctions.scala 31:31]
  wire [7:0] modifiedData_writeBytes_0 = dataInReg[7:0]; // @[CacheFunctions.scala 32:33]
  wire [7:0] modifiedData_readBytes_1 = lastRead[15:8]; // @[CacheFunctions.scala 31:31]
  wire [7:0] modifiedData_writeBytes_1 = dataInReg[15:8]; // @[CacheFunctions.scala 32:33]
  wire [7:0] modifiedData_readBytes_2 = lastRead[23:16]; // @[CacheFunctions.scala 31:31]
  wire [7:0] modifiedData_writeBytes_2 = dataInReg[23:16]; // @[CacheFunctions.scala 32:33]
  wire [7:0] modifiedData_readBytes_3 = lastRead[31:24]; // @[CacheFunctions.scala 31:31]
  wire [7:0] modifiedData_writeBytes_3 = dataInReg[31:24]; // @[CacheFunctions.scala 32:33]
  wire [7:0] modifiedData_resultBytes_0 = wreReg_0 ? modifiedData_writeBytes_0 : modifiedData_readBytes_0; // @[CacheFunctions.scala 38:28]
  wire [7:0] modifiedData_resultBytes_1 = wreReg_1 ? modifiedData_writeBytes_1 : modifiedData_readBytes_1; // @[CacheFunctions.scala 38:28]
  wire [7:0] modifiedData_resultBytes_2 = wreReg_2 ? modifiedData_writeBytes_2 : modifiedData_readBytes_2; // @[CacheFunctions.scala 38:28]
  wire [7:0] modifiedData_resultBytes_3 = wreReg_3 ? modifiedData_writeBytes_3 : modifiedData_readBytes_3; // @[CacheFunctions.scala 38:28]
  wire [31:0] _modifiedData_T = {modifiedData_resultBytes_3,modifiedData_resultBytes_2,modifiedData_resultBytes_1,
    modifiedData_resultBytes_0}; // @[Cat.scala 33:92]
  wire [31:0] _GEN_80 = io_memReady ? _modifiedData_T : 32'h0; // @[CacheController.scala 220:25 221:22 64:30]
  wire  _GEN_82 = io_memReady ? 1'h0 : 1'h1; // @[CacheController.scala 220:25 CacheFunctions.scala 16:13 CacheController.scala 81:15]
  wire [31:0] _GEN_110 = 3'h4 == stateReg ? _GEN_80 : 32'h0; // @[CacheController.scala 106:20 64:30]
  wire [31:0] _GEN_135 = 3'h2 == stateReg ? 32'h0 : _GEN_110; // @[CacheController.scala 106:20 64:30]
  wire [31:0] _GEN_155 = 3'h1 == stateReg ? 32'h0 : _GEN_135; // @[CacheController.scala 106:20 64:30]
  wire [31:0] modifiedData = 3'h0 == stateReg ? 32'h0 : _GEN_155; // @[CacheController.scala 106:20 64:30]
  wire [31:0] _GEN_83 = io_memReady ? modifiedData : io_CPUdataIn; // @[CacheController.scala 220:25 223:21 83:15]
  wire [9:0] _GEN_84 = io_memReady ? cacheWTReg : 10'h0; // @[CacheController.scala 220:25 224:18 62:26]
  wire [1:0] _GEN_85 = io_memReady ? 2'h0 : memReq; // @[CacheController.scala 220:25 227:16 65:23]
  wire [2:0] _GEN_86 = io_memReady ? 3'h0 : stateReg; // @[CacheController.scala 220:25 228:18 102:25]
  wire  _T_17 = rwIndex == 3'h3; // @[CacheController.scala 240:22]
  wire [2:0] _rwIndex_T_1 = rwIndex + 3'h1; // @[CacheController.scala 243:30]
  wire [1:0] _GEN_87 = ~rwReg ? 2'h2 : 2'h0; // @[CacheController.scala 244:23 245:20 247:20]
  wire  _GEN_89 = rwIndex == 3'h3 ? 1'h0 : 1'h1; // @[CacheController.scala 240:50 CacheFunctions.scala 16:13 CacheController.scala 78:18]
  wire [2:0] _GEN_90 = rwIndex == 3'h3 ? _rwIndex_T_1 : _rwIndex_T_1; // @[CacheController.scala 240:50 243:19 251:19]
  wire [1:0] _GEN_91 = rwIndex == 3'h3 ? _GEN_87 : memReq; // @[CacheController.scala 240:50 65:23]
  wire  _GEN_92 = io_memReady & _T_17; // @[CacheController.scala 237:25 79:18]
  wire  _GEN_93 = io_memReady ? _GEN_89 : 1'h1; // @[CacheController.scala 237:25 78:18]
  wire [2:0] _GEN_94 = io_memReady ? _GEN_90 : rwIndex; // @[CacheController.scala 237:25 54:24]
  wire [1:0] _GEN_95 = io_memReady ? _GEN_91 : memReq; // @[CacheController.scala 237:25 65:23]
  wire [2:0] _GEN_96 = rwIndex == 3'h4 ? 3'h0 : _GEN_94; // @[CacheController.scala 254:43 255:17]
  wire  _GEN_97 = rwIndex == 3'h4 | io_memReady; // @[CacheController.scala 254:43 CacheFunctions.scala 10:13]
  wire  _GEN_98 = rwIndex == 3'h4 | _GEN_82; // @[CacheController.scala 254:43 CacheFunctions.scala 11:13]
  wire [9:0] _GEN_99 = rwIndex == 3'h4 ? cacheReadAdd : cacheAllocationAdd; // @[CacheController.scala 234:16 254:43 257:18]
  wire [2:0] _GEN_100 = rwIndex == 3'h4 ? 3'h1 : stateReg; // @[CacheController.scala 254:43 258:18 102:25]
  wire [9:0] _GEN_101 = 3'h3 == stateReg ? _GEN_99 : 10'h0; // @[CacheController.scala 106:20 62:26]
  wire [31:0] _GEN_102 = 3'h3 == stateReg ? io_memDataIn : io_CPUdataIn; // @[CacheController.scala 106:20 235:19 83:15]
  wire  _GEN_103 = 3'h3 == stateReg & _GEN_97; // @[CacheController.scala 106:20 82:15]
  wire  _GEN_104 = 3'h3 == stateReg ? _GEN_98 : 1'h1; // @[CacheController.scala 106:20 81:15]
  wire  _GEN_106 = 3'h3 == stateReg ? _GEN_93 : 1'h1; // @[CacheController.scala 106:20 78:18]
  wire [2:0] _GEN_107 = 3'h3 == stateReg ? _GEN_96 : rwIndex; // @[CacheController.scala 106:20 54:24]
  wire [1:0] _GEN_108 = 3'h3 == stateReg ? _GEN_95 : memReq; // @[CacheController.scala 106:20 65:23]
  wire [2:0] _GEN_109 = 3'h3 == stateReg ? _GEN_100 : stateReg; // @[CacheController.scala 106:20 102:25]
  wire  _GEN_111 = 3'h4 == stateReg ? io_memReady : _GEN_103; // @[CacheController.scala 106:20]
  wire  _GEN_112 = 3'h4 == stateReg ? _GEN_82 : _GEN_104; // @[CacheController.scala 106:20]
  wire [31:0] _GEN_113 = 3'h4 == stateReg ? _GEN_83 : _GEN_102; // @[CacheController.scala 106:20]
  wire [9:0] _GEN_114 = 3'h4 == stateReg ? _GEN_84 : _GEN_101; // @[CacheController.scala 106:20]
  wire [1:0] _GEN_115 = 3'h4 == stateReg ? _GEN_85 : _GEN_108; // @[CacheController.scala 106:20]
  wire [2:0] _GEN_116 = 3'h4 == stateReg ? _GEN_86 : _GEN_109; // @[CacheController.scala 106:20]
  wire  _GEN_117 = 3'h4 == stateReg ? 1'h0 : 3'h3 == stateReg & _GEN_92; // @[CacheController.scala 106:20 79:18]
  wire [2:0] _GEN_119 = 3'h4 == stateReg ? rwIndex : _GEN_107; // @[CacheController.scala 106:20 54:24]
  wire  _GEN_120 = 3'h2 == stateReg | _GEN_117; // @[CacheController.scala 106:20 176:22]
  wire [9:0] _GEN_121 = 3'h2 == stateReg ? _GEN_37 : _GEN_114; // @[CacheController.scala 106:20]
  wire  _GEN_122 = 3'h2 == stateReg & _GEN_38; // @[CacheController.scala 106:20 77:12]
  wire  _GEN_125 = 3'h2 == stateReg ? _GEN_41 : _GEN_111; // @[CacheController.scala 106:20]
  wire  _GEN_127 = 3'h2 == stateReg ? _GEN_43 : rwReg; // @[CacheController.scala 106:20 67:22]
  wire [31:0] _GEN_137 = 3'h2 == stateReg ? io_CPUdataIn : _GEN_113; // @[CacheController.scala 106:20 83:15]
  wire  _GEN_140 = 3'h1 == stateReg | _GEN_120; // @[CacheController.scala 106:20 131:22]
  wire [9:0] _GEN_141 = 3'h1 == stateReg ? _GEN_37 : _GEN_121; // @[CacheController.scala 106:20]
  wire  _GEN_142 = 3'h1 == stateReg ? _GEN_38 : _GEN_122; // @[CacheController.scala 106:20]
  wire  _GEN_145 = 3'h1 == stateReg ? _GEN_41 : _GEN_125; // @[CacheController.scala 106:20]
  wire  _GEN_147 = 3'h1 == stateReg ? _GEN_43 : _GEN_127; // @[CacheController.scala 106:20]
  wire  _GEN_156 = 3'h1 == stateReg | (3'h2 == stateReg | _GEN_112); // @[CacheController.scala 106:20 81:15]
  wire [31:0] _GEN_157 = 3'h1 == stateReg ? io_CPUdataIn : _GEN_137; // @[CacheController.scala 106:20 83:15]
  wire  _GEN_158 = 3'h1 == stateReg | (3'h2 == stateReg | (3'h4 == stateReg | _GEN_106)); // @[CacheController.scala 106:20 78:18]
  wire  _GEN_166 = 3'h0 == stateReg ? _GEN_4 : _GEN_147; // @[CacheController.scala 106:20]
  wire [31:0] _io_alloAddr_T = {memWordAdd, 2'h0}; // @[CacheController.scala 272:30]
  wire [5:0] _io_alloAddr_T_1 = rwIndex * 3'h4; // @[CacheController.scala 272:52]
  wire [31:0] _GEN_180 = {{26'd0}, _io_alloAddr_T_1}; // @[CacheController.scala 272:43]
  SRAM tagStore ( // @[CacheController.scala 44:24]
    .clock(tagStore_clock),
    .io_rw(tagStore_io_rw),
    .io_ad(tagStore_io_ad),
    .io_DI(tagStore_io_DI),
    .io_EN(tagStore_io_EN),
    .io_DO(tagStore_io_DO)
  );
  SRAM_1 cache ( // @[CacheController.scala 45:21]
    .clock(cache_clock),
    .io_rw(cache_io_rw),
    .io_ad(cache_io_ad),
    .io_DI(cache_io_DI),
    .io_EN(cache_io_EN),
    .io_DO(cache_io_DO)
  );
  assign io_CPUdataOut = io_ready ? lastRead : cache_io_DO; // @[CacheController.scala 267:23]
  assign io_stall = 3'h0 == stateReg ? 1'h0 : _GEN_142; // @[CacheController.scala 106:20 77:12]
  assign io_ready = stateReg == 3'h0; // @[CacheController.scala 266:24]
  assign io_alloAddr = _io_alloAddr_T + _GEN_180; // @[CacheController.scala 272:43]
  assign io_memReq = memReq; // @[CacheController.scala 84:13]
  assign tagStore_clock = clock;
  assign tagStore_io_rw = 3'h0 == stateReg | _GEN_158; // @[CacheController.scala 106:20]
  assign tagStore_io_ad = io_memAdd[11:4]; // @[CacheController.scala 50:24]
  assign tagStore_io_DI = {targetTag,1'h1}; // @[CacheController.scala 55:30]
  assign tagStore_io_EN = 3'h0 == stateReg ? io_validReq : _GEN_140; // @[CacheController.scala 106:20]
  assign cache_clock = clock;
  assign cache_io_rw = 3'h0 == stateReg | _GEN_156; // @[CacheController.scala 106:20]
  assign cache_io_ad = 3'h0 == stateReg ? _GEN_3 : _GEN_141; // @[CacheController.scala 106:20]
  assign cache_io_DI = 3'h0 == stateReg ? io_CPUdataIn : _GEN_157; // @[CacheController.scala 106:20 83:15]
  assign cache_io_EN = 3'h0 == stateReg ? io_validReq : _GEN_145; // @[CacheController.scala 106:20]
  always @(posedge clock) begin
    if (reset) begin // @[CacheController.scala 43:25]
      lastRead <= 32'h0; // @[CacheController.scala 43:25]
    end else if (!(3'h0 == stateReg)) begin // @[CacheController.scala 106:20]
      if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
        lastRead <= _GEN_42;
      end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
        lastRead <= _GEN_42;
      end
    end
    targetTag <= io_memAdd[31:12]; // @[CacheController.scala 51:36]
    if (reset) begin // @[CacheController.scala 54:24]
      rwIndex <= 3'h0; // @[CacheController.scala 54:24]
    end else if (!(3'h0 == stateReg)) begin // @[CacheController.scala 106:20]
      if (!(3'h1 == stateReg)) begin // @[CacheController.scala 106:20]
        if (!(3'h2 == stateReg)) begin // @[CacheController.scala 106:20]
          rwIndex <= _GEN_119;
        end
      end
    end
    if (reset) begin // @[CacheController.scala 59:27]
      cacheWTReg <= 10'h0; // @[CacheController.scala 59:27]
    end else if (3'h0 == stateReg) begin // @[CacheController.scala 106:20]
      if (io_validReq) begin // @[CacheController.scala 109:25]
        cacheWTReg <= cacheReadAdd; // @[CacheController.scala 120:20]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
      cacheWTReg <= _GEN_44;
    end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
      cacheWTReg <= _GEN_44;
    end
    if (reset) begin // @[CacheController.scala 65:23]
      memReq <= 2'h0; // @[CacheController.scala 65:23]
    end else if (!(3'h0 == stateReg)) begin // @[CacheController.scala 106:20]
      if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
        memReq <= _GEN_39;
      end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
        memReq <= _GEN_39;
      end else begin
        memReq <= _GEN_115;
      end
    end
    rwReg <= reset | _GEN_166; // @[CacheController.scala 67:{22,22}]
    if (reset) begin // @[CacheController.scala 68:25]
      indexReg <= 8'h0; // @[CacheController.scala 68:25]
    end else if (3'h0 == stateReg) begin // @[CacheController.scala 106:20]
      if (io_validReq) begin // @[CacheController.scala 109:25]
        indexReg <= index; // @[CacheController.scala 121:18]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
      indexReg <= _GEN_45;
    end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
      indexReg <= _GEN_45;
    end
    if (reset) begin // @[CacheController.scala 69:26]
      dataInReg <= 32'h0; // @[CacheController.scala 69:26]
    end else if (3'h0 == stateReg) begin // @[CacheController.scala 106:20]
      if (io_validReq) begin // @[CacheController.scala 109:25]
        dataInReg <= io_CPUdataIn; // @[CacheController.scala 122:19]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
      dataInReg <= _GEN_46;
    end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
      dataInReg <= _GEN_46;
    end
    if (3'h0 == stateReg) begin // @[CacheController.scala 106:20]
      if (io_validReq) begin // @[CacheController.scala 109:25]
        wreReg_0 <= io_wrEnable_0; // @[CacheController.scala 123:16]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
      wreReg_0 <= _GEN_47;
    end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
      wreReg_0 <= _GEN_47;
    end
    if (3'h0 == stateReg) begin // @[CacheController.scala 106:20]
      if (io_validReq) begin // @[CacheController.scala 109:25]
        wreReg_1 <= io_wrEnable_1; // @[CacheController.scala 123:16]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
      wreReg_1 <= _GEN_48;
    end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
      wreReg_1 <= _GEN_48;
    end
    if (3'h0 == stateReg) begin // @[CacheController.scala 106:20]
      if (io_validReq) begin // @[CacheController.scala 109:25]
        wreReg_2 <= io_wrEnable_2; // @[CacheController.scala 123:16]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
      wreReg_2 <= _GEN_49;
    end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
      wreReg_2 <= _GEN_49;
    end
    if (3'h0 == stateReg) begin // @[CacheController.scala 106:20]
      if (io_validReq) begin // @[CacheController.scala 109:25]
        wreReg_3 <= io_wrEnable_3; // @[CacheController.scala 123:16]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
      wreReg_3 <= _GEN_50;
    end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
      wreReg_3 <= _GEN_50;
    end
    if (reset) begin // @[CacheController.scala 102:25]
      stateReg <= 3'h0; // @[CacheController.scala 102:25]
    end else if (3'h0 == stateReg) begin // @[CacheController.scala 106:20]
      if (io_validReq) begin // @[CacheController.scala 109:25]
        stateReg <= 3'h1; // @[CacheController.scala 112:18]
      end
    end else if (3'h1 == stateReg) begin // @[CacheController.scala 106:20]
      if (cacheInvalid) begin // @[CacheController.scala 132:26]
        stateReg <= 3'h3; // @[CacheController.scala 136:18]
      end else begin
        stateReg <= _GEN_35;
      end
    end else if (3'h2 == stateReg) begin // @[CacheController.scala 106:20]
      stateReg <= _GEN_69;
    end else begin
      stateReg <= _GEN_116;
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
  targetTag = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  rwIndex = _RAND_2[2:0];
  _RAND_3 = {1{`RANDOM}};
  cacheWTReg = _RAND_3[9:0];
  _RAND_4 = {1{`RANDOM}};
  memReq = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  rwReg = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  indexReg = _RAND_6[7:0];
  _RAND_7 = {1{`RANDOM}};
  dataInReg = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  wreReg_0 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  wreReg_1 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  wreReg_2 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  wreReg_3 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  stateReg = _RAND_12[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CacheTop(
  input         clock,
  input         reset,
  input  [31:0] io_CPUmemIO_rdAddress,
  output [31:0] io_CPUmemIO_rdData,
  input         io_CPUmemIO_rdEnable,
  input  [31:0] io_CPUmemIO_wrAddress,
  input  [31:0] io_CPUmemIO_wrData,
  input         io_CPUmemIO_wrEnable_0,
  input         io_CPUmemIO_wrEnable_1,
  input         io_CPUmemIO_wrEnable_2,
  input         io_CPUmemIO_wrEnable_3,
  output        io_CPUmemIO_stall,
  output        io_CacheReqOut_valid,
  output [31:0] io_CacheReqOut_bits_addrRequest,
  output [31:0] io_CacheReqOut_bits_dataRequest,
  output [3:0]  io_CacheReqOut_bits_activeByteLane,
  output        io_CacheReqOut_bits_isWrite,
  input         io_CacheRspIn_valid,
  input  [31:0] io_CacheRspIn_bits_dataResponse
);
  wire  Controller_clock; // @[CacheTop.scala 34:26]
  wire  Controller_reset; // @[CacheTop.scala 34:26]
  wire  Controller_io_validReq; // @[CacheTop.scala 34:26]
  wire  Controller_io_rw; // @[CacheTop.scala 34:26]
  wire [31:0] Controller_io_memAdd; // @[CacheTop.scala 34:26]
  wire [31:0] Controller_io_CPUdataIn; // @[CacheTop.scala 34:26]
  wire [31:0] Controller_io_CPUdataOut; // @[CacheTop.scala 34:26]
  wire  Controller_io_stall; // @[CacheTop.scala 34:26]
  wire  Controller_io_ready; // @[CacheTop.scala 34:26]
  wire  Controller_io_wrEnable_0; // @[CacheTop.scala 34:26]
  wire  Controller_io_wrEnable_1; // @[CacheTop.scala 34:26]
  wire  Controller_io_wrEnable_2; // @[CacheTop.scala 34:26]
  wire  Controller_io_wrEnable_3; // @[CacheTop.scala 34:26]
  wire [31:0] Controller_io_memDataIn; // @[CacheTop.scala 34:26]
  wire  Controller_io_memReady; // @[CacheTop.scala 34:26]
  wire [31:0] Controller_io_alloAddr; // @[CacheTop.scala 34:26]
  wire [1:0] Controller_io_memReq; // @[CacheTop.scala 34:26]
  wire  _GEN_0 = Controller_io_memReq != 2'h0 | Controller_io_stall; // @[CacheTop.scala 56:21 66:39 67:25]
  wire  _GEN_4 = io_CPUmemIO_rdEnable ? _GEN_0 : Controller_io_stall; // @[CacheTop.scala 56:21 61:29]
  wire [3:0] _T_1 = {io_CPUmemIO_wrEnable_3,io_CPUmemIO_wrEnable_2,io_CPUmemIO_wrEnable_1,io_CPUmemIO_wrEnable_0}; // @[CacheTop.scala 73:29]
  wire  _GEN_5 = ~Controller_io_ready | _GEN_4; // @[CacheTop.scala 78:31 79:25]
  wire  _T_5 = Controller_io_memReq == 2'h2; // @[CacheTop.scala 91:35]
  wire [31:0] _GEN_11 = Controller_io_memReq == 2'h2 ? io_CPUmemIO_wrData : 32'h0; // @[CacheTop.scala 48:35 91:43 94:37]
  wire [31:0] _GEN_12 = Controller_io_memReq == 2'h2 ? io_CPUmemIO_wrAddress : 32'h0; // @[CacheTop.scala 49:35 91:43 95:37]
  wire [3:0] _GEN_13 = Controller_io_memReq == 2'h2 ? _T_1 : 4'h0; // @[CacheTop.scala 51:38 91:43 97:40]
  CacheController Controller ( // @[CacheTop.scala 34:26]
    .clock(Controller_clock),
    .reset(Controller_reset),
    .io_validReq(Controller_io_validReq),
    .io_rw(Controller_io_rw),
    .io_memAdd(Controller_io_memAdd),
    .io_CPUdataIn(Controller_io_CPUdataIn),
    .io_CPUdataOut(Controller_io_CPUdataOut),
    .io_stall(Controller_io_stall),
    .io_ready(Controller_io_ready),
    .io_wrEnable_0(Controller_io_wrEnable_0),
    .io_wrEnable_1(Controller_io_wrEnable_1),
    .io_wrEnable_2(Controller_io_wrEnable_2),
    .io_wrEnable_3(Controller_io_wrEnable_3),
    .io_memDataIn(Controller_io_memDataIn),
    .io_memReady(Controller_io_memReady),
    .io_alloAddr(Controller_io_alloAddr),
    .io_memReq(Controller_io_memReq)
  );
  assign io_CPUmemIO_rdData = Controller_io_CPUdataOut; // @[CacheTop.scala 44:22]
  assign io_CPUmemIO_stall = _T_1 > 4'h0 ? _GEN_5 : _GEN_4; // @[CacheTop.scala 73:42]
  assign io_CacheReqOut_valid = Controller_io_memReq == 2'h1 | _T_5; // @[CacheTop.scala 85:37 87:26]
  assign io_CacheReqOut_bits_addrRequest = Controller_io_memReq == 2'h1 ? Controller_io_alloAddr : _GEN_12; // @[CacheTop.scala 85:37 88:37]
  assign io_CacheReqOut_bits_dataRequest = Controller_io_memReq == 2'h1 ? 32'h0 : _GEN_11; // @[CacheTop.scala 48:35 85:37]
  assign io_CacheReqOut_bits_activeByteLane = Controller_io_memReq == 2'h1 ? 4'hf : _GEN_13; // @[CacheTop.scala 85:37 89:40]
  assign io_CacheReqOut_bits_isWrite = Controller_io_memReq == 2'h1 ? 1'h0 : _T_5; // @[CacheTop.scala 50:31 85:37]
  assign Controller_clock = clock;
  assign Controller_reset = reset;
  assign Controller_io_validReq = _T_1 > 4'h0 | io_CPUmemIO_rdEnable; // @[CacheTop.scala 73:42 74:28]
  assign Controller_io_rw = _T_1 > 4'h0 ? 1'h0 : 1'h1; // @[CacheTop.scala 73:42 75:22]
  assign Controller_io_memAdd = _T_1 > 4'h0 ? io_CPUmemIO_wrAddress : io_CPUmemIO_rdAddress; // @[CacheTop.scala 73:42 76:26]
  assign Controller_io_CPUdataIn = io_CPUmemIO_wrData; // @[CacheTop.scala 42:27]
  assign Controller_io_wrEnable_0 = io_CPUmemIO_wrEnable_0; // @[CacheTop.scala 41:26]
  assign Controller_io_wrEnable_1 = io_CPUmemIO_wrEnable_1; // @[CacheTop.scala 41:26]
  assign Controller_io_wrEnable_2 = io_CPUmemIO_wrEnable_2; // @[CacheTop.scala 41:26]
  assign Controller_io_wrEnable_3 = io_CPUmemIO_wrEnable_3; // @[CacheTop.scala 41:26]
  assign Controller_io_memDataIn = io_CacheRspIn_bits_dataResponse; // @[CacheTop.scala 43:27]
  assign Controller_io_memReady = io_CacheRspIn_valid; // @[CacheTop.scala 36:49]
endmodule
module CacheBusAdapter(
  input         clock,
  input         reset,
  input  [31:0] io_CPUMemIO_rdAddress,
  output [31:0] io_CPUMemIO_rdData,
  input         io_CPUMemIO_rdEnable,
  input  [31:0] io_CPUMemIO_wrAddress,
  input  [31:0] io_CPUMemIO_wrData,
  input         io_CPUMemIO_wrEnable_0,
  input         io_CPUMemIO_wrEnable_1,
  input         io_CPUMemIO_wrEnable_2,
  input         io_CPUMemIO_wrEnable_3,
  output        io_CPUMemIO_stall,
  output        io_reqOut_valid,
  output [31:0] io_reqOut_bits_addrRequest,
  output [31:0] io_reqOut_bits_dataRequest,
  output [3:0]  io_reqOut_bits_activeByteLane,
  output        io_reqOut_bits_isWrite,
  input         io_rspIn_valid,
  input  [31:0] io_rspIn_bits_dataResponse
);
  wire  TL_Adapter_clock; // @[CacheBusAdapter.scala 30:26]
  wire  TL_Adapter_reset; // @[CacheBusAdapter.scala 30:26]
  wire  TL_Adapter_io_reqIn_valid; // @[CacheBusAdapter.scala 30:26]
  wire [31:0] TL_Adapter_io_reqIn_bits_addrRequest; // @[CacheBusAdapter.scala 30:26]
  wire [31:0] TL_Adapter_io_reqIn_bits_dataRequest; // @[CacheBusAdapter.scala 30:26]
  wire [3:0] TL_Adapter_io_reqIn_bits_activeByteLane; // @[CacheBusAdapter.scala 30:26]
  wire  TL_Adapter_io_reqIn_bits_isWrite; // @[CacheBusAdapter.scala 30:26]
  wire  TL_Adapter_io_rspOut_valid; // @[CacheBusAdapter.scala 30:26]
  wire [31:0] TL_Adapter_io_rspOut_bits_dataResponse; // @[CacheBusAdapter.scala 30:26]
  wire  TL_Adapter_io_reqOut_valid; // @[CacheBusAdapter.scala 30:26]
  wire [31:0] TL_Adapter_io_reqOut_bits_addrRequest; // @[CacheBusAdapter.scala 30:26]
  wire [31:0] TL_Adapter_io_reqOut_bits_dataRequest; // @[CacheBusAdapter.scala 30:26]
  wire [3:0] TL_Adapter_io_reqOut_bits_activeByteLane; // @[CacheBusAdapter.scala 30:26]
  wire  TL_Adapter_io_reqOut_bits_isWrite; // @[CacheBusAdapter.scala 30:26]
  wire  TL_Adapter_io_rspIn_valid; // @[CacheBusAdapter.scala 30:26]
  wire [31:0] TL_Adapter_io_rspIn_bits_dataResponse; // @[CacheBusAdapter.scala 30:26]
  wire  Cache_clock; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_reset; // @[CacheBusAdapter.scala 33:21]
  wire [31:0] Cache_io_CPUmemIO_rdAddress; // @[CacheBusAdapter.scala 33:21]
  wire [31:0] Cache_io_CPUmemIO_rdData; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CPUmemIO_rdEnable; // @[CacheBusAdapter.scala 33:21]
  wire [31:0] Cache_io_CPUmemIO_wrAddress; // @[CacheBusAdapter.scala 33:21]
  wire [31:0] Cache_io_CPUmemIO_wrData; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CPUmemIO_wrEnable_0; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CPUmemIO_wrEnable_1; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CPUmemIO_wrEnable_2; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CPUmemIO_wrEnable_3; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CPUmemIO_stall; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CacheReqOut_valid; // @[CacheBusAdapter.scala 33:21]
  wire [31:0] Cache_io_CacheReqOut_bits_addrRequest; // @[CacheBusAdapter.scala 33:21]
  wire [31:0] Cache_io_CacheReqOut_bits_dataRequest; // @[CacheBusAdapter.scala 33:21]
  wire [3:0] Cache_io_CacheReqOut_bits_activeByteLane; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CacheReqOut_bits_isWrite; // @[CacheBusAdapter.scala 33:21]
  wire  Cache_io_CacheRspIn_valid; // @[CacheBusAdapter.scala 33:21]
  wire [31:0] Cache_io_CacheRspIn_bits_dataResponse; // @[CacheBusAdapter.scala 33:21]
  TilelinkAdapter TL_Adapter ( // @[CacheBusAdapter.scala 30:26]
    .clock(TL_Adapter_clock),
    .reset(TL_Adapter_reset),
    .io_reqIn_valid(TL_Adapter_io_reqIn_valid),
    .io_reqIn_bits_addrRequest(TL_Adapter_io_reqIn_bits_addrRequest),
    .io_reqIn_bits_dataRequest(TL_Adapter_io_reqIn_bits_dataRequest),
    .io_reqIn_bits_activeByteLane(TL_Adapter_io_reqIn_bits_activeByteLane),
    .io_reqIn_bits_isWrite(TL_Adapter_io_reqIn_bits_isWrite),
    .io_rspOut_valid(TL_Adapter_io_rspOut_valid),
    .io_rspOut_bits_dataResponse(TL_Adapter_io_rspOut_bits_dataResponse),
    .io_reqOut_valid(TL_Adapter_io_reqOut_valid),
    .io_reqOut_bits_addrRequest(TL_Adapter_io_reqOut_bits_addrRequest),
    .io_reqOut_bits_dataRequest(TL_Adapter_io_reqOut_bits_dataRequest),
    .io_reqOut_bits_activeByteLane(TL_Adapter_io_reqOut_bits_activeByteLane),
    .io_reqOut_bits_isWrite(TL_Adapter_io_reqOut_bits_isWrite),
    .io_rspIn_valid(TL_Adapter_io_rspIn_valid),
    .io_rspIn_bits_dataResponse(TL_Adapter_io_rspIn_bits_dataResponse)
  );
  CacheTop Cache ( // @[CacheBusAdapter.scala 33:21]
    .clock(Cache_clock),
    .reset(Cache_reset),
    .io_CPUmemIO_rdAddress(Cache_io_CPUmemIO_rdAddress),
    .io_CPUmemIO_rdData(Cache_io_CPUmemIO_rdData),
    .io_CPUmemIO_rdEnable(Cache_io_CPUmemIO_rdEnable),
    .io_CPUmemIO_wrAddress(Cache_io_CPUmemIO_wrAddress),
    .io_CPUmemIO_wrData(Cache_io_CPUmemIO_wrData),
    .io_CPUmemIO_wrEnable_0(Cache_io_CPUmemIO_wrEnable_0),
    .io_CPUmemIO_wrEnable_1(Cache_io_CPUmemIO_wrEnable_1),
    .io_CPUmemIO_wrEnable_2(Cache_io_CPUmemIO_wrEnable_2),
    .io_CPUmemIO_wrEnable_3(Cache_io_CPUmemIO_wrEnable_3),
    .io_CPUmemIO_stall(Cache_io_CPUmemIO_stall),
    .io_CacheReqOut_valid(Cache_io_CacheReqOut_valid),
    .io_CacheReqOut_bits_addrRequest(Cache_io_CacheReqOut_bits_addrRequest),
    .io_CacheReqOut_bits_dataRequest(Cache_io_CacheReqOut_bits_dataRequest),
    .io_CacheReqOut_bits_activeByteLane(Cache_io_CacheReqOut_bits_activeByteLane),
    .io_CacheReqOut_bits_isWrite(Cache_io_CacheReqOut_bits_isWrite),
    .io_CacheRspIn_valid(Cache_io_CacheRspIn_valid),
    .io_CacheRspIn_bits_dataResponse(Cache_io_CacheRspIn_bits_dataResponse)
  );
  assign io_CPUMemIO_rdData = Cache_io_CPUmemIO_rdData; // @[CacheBusAdapter.scala 34:21]
  assign io_CPUMemIO_stall = Cache_io_CPUmemIO_stall; // @[CacheBusAdapter.scala 34:21]
  assign io_reqOut_valid = TL_Adapter_io_reqOut_valid; // @[CacheBusAdapter.scala 39:13]
  assign io_reqOut_bits_addrRequest = TL_Adapter_io_reqOut_bits_addrRequest; // @[CacheBusAdapter.scala 39:13]
  assign io_reqOut_bits_dataRequest = TL_Adapter_io_reqOut_bits_dataRequest; // @[CacheBusAdapter.scala 39:13]
  assign io_reqOut_bits_activeByteLane = TL_Adapter_io_reqOut_bits_activeByteLane; // @[CacheBusAdapter.scala 39:13]
  assign io_reqOut_bits_isWrite = TL_Adapter_io_reqOut_bits_isWrite; // @[CacheBusAdapter.scala 39:13]
  assign TL_Adapter_clock = clock;
  assign TL_Adapter_reset = reset;
  assign TL_Adapter_io_reqIn_valid = Cache_io_CacheReqOut_valid; // @[CacheBusAdapter.scala 37:23]
  assign TL_Adapter_io_reqIn_bits_addrRequest = Cache_io_CacheReqOut_bits_addrRequest; // @[CacheBusAdapter.scala 37:23]
  assign TL_Adapter_io_reqIn_bits_dataRequest = Cache_io_CacheReqOut_bits_dataRequest; // @[CacheBusAdapter.scala 37:23]
  assign TL_Adapter_io_reqIn_bits_activeByteLane = Cache_io_CacheReqOut_bits_activeByteLane; // @[CacheBusAdapter.scala 37:23]
  assign TL_Adapter_io_reqIn_bits_isWrite = Cache_io_CacheReqOut_bits_isWrite; // @[CacheBusAdapter.scala 37:23]
  assign TL_Adapter_io_rspIn_valid = io_rspIn_valid; // @[CacheBusAdapter.scala 40:23]
  assign TL_Adapter_io_rspIn_bits_dataResponse = io_rspIn_bits_dataResponse; // @[CacheBusAdapter.scala 40:23]
  assign Cache_clock = clock;
  assign Cache_reset = reset;
  assign Cache_io_CPUmemIO_rdAddress = io_CPUMemIO_rdAddress; // @[CacheBusAdapter.scala 34:21]
  assign Cache_io_CPUmemIO_rdEnable = io_CPUMemIO_rdEnable; // @[CacheBusAdapter.scala 34:21]
  assign Cache_io_CPUmemIO_wrAddress = io_CPUMemIO_wrAddress; // @[CacheBusAdapter.scala 34:21]
  assign Cache_io_CPUmemIO_wrData = io_CPUMemIO_wrData; // @[CacheBusAdapter.scala 34:21]
  assign Cache_io_CPUmemIO_wrEnable_0 = io_CPUMemIO_wrEnable_0; // @[CacheBusAdapter.scala 34:21]
  assign Cache_io_CPUmemIO_wrEnable_1 = io_CPUMemIO_wrEnable_1; // @[CacheBusAdapter.scala 34:21]
  assign Cache_io_CPUmemIO_wrEnable_2 = io_CPUMemIO_wrEnable_2; // @[CacheBusAdapter.scala 34:21]
  assign Cache_io_CPUmemIO_wrEnable_3 = io_CPUMemIO_wrEnable_3; // @[CacheBusAdapter.scala 34:21]
  assign Cache_io_CacheRspIn_valid = TL_Adapter_io_rspOut_valid; // @[CacheBusAdapter.scala 38:23]
  assign Cache_io_CacheRspIn_bits_dataResponse = TL_Adapter_io_rspOut_bits_dataResponse; // @[CacheBusAdapter.scala 38:23]
endmodule
module BusInterconnect(
  input         clock,
  input         reset,
  input  [31:0] io_CPUdCacheMemIO_rdAddress,
  output [31:0] io_CPUdCacheMemIO_rdData,
  input         io_CPUdCacheMemIO_rdEnable,
  input  [31:0] io_CPUdCacheMemIO_wrAddress,
  input  [31:0] io_CPUdCacheMemIO_wrData,
  input         io_CPUdCacheMemIO_wrEnable_0,
  input         io_CPUdCacheMemIO_wrEnable_1,
  input         io_CPUdCacheMemIO_wrEnable_2,
  input         io_CPUdCacheMemIO_wrEnable_3,
  output        io_CPUdCacheMemIO_stall,
  input  [31:0] io_CPUiCacheMemIO_rdAddress,
  output [31:0] io_CPUiCacheMemIO_rdData,
  input         io_CPUiCacheMemIO_rdEnable,
  output        io_CPUiCacheMemIO_stall,
  output        io_dCacheReqOut_valid,
  output [31:0] io_dCacheReqOut_bits_addrRequest,
  output [31:0] io_dCacheReqOut_bits_dataRequest,
  output [3:0]  io_dCacheReqOut_bits_activeByteLane,
  output        io_dCacheReqOut_bits_isWrite,
  input         io_dCacheRspIn_valid,
  input  [31:0] io_dCacheRspIn_bits_dataResponse,
  output        io_iCacheReqOut_valid,
  output [31:0] io_iCacheReqOut_bits_addrRequest,
  output [31:0] io_iCacheReqOut_bits_dataRequest,
  output [3:0]  io_iCacheReqOut_bits_activeByteLane,
  output        io_iCacheReqOut_bits_isWrite,
  input         io_iCacheRspIn_valid,
  input  [31:0] io_iCacheRspIn_bits_dataResponse
);
  wire  dCacheAdapter_clock; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_reset; // @[BusInterconnect.scala 21:29]
  wire [31:0] dCacheAdapter_io_CPUMemIO_rdAddress; // @[BusInterconnect.scala 21:29]
  wire [31:0] dCacheAdapter_io_CPUMemIO_rdData; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_CPUMemIO_rdEnable; // @[BusInterconnect.scala 21:29]
  wire [31:0] dCacheAdapter_io_CPUMemIO_wrAddress; // @[BusInterconnect.scala 21:29]
  wire [31:0] dCacheAdapter_io_CPUMemIO_wrData; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_CPUMemIO_wrEnable_0; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_CPUMemIO_wrEnable_1; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_CPUMemIO_wrEnable_2; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_CPUMemIO_wrEnable_3; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_CPUMemIO_stall; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_reqOut_valid; // @[BusInterconnect.scala 21:29]
  wire [31:0] dCacheAdapter_io_reqOut_bits_addrRequest; // @[BusInterconnect.scala 21:29]
  wire [31:0] dCacheAdapter_io_reqOut_bits_dataRequest; // @[BusInterconnect.scala 21:29]
  wire [3:0] dCacheAdapter_io_reqOut_bits_activeByteLane; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_reqOut_bits_isWrite; // @[BusInterconnect.scala 21:29]
  wire  dCacheAdapter_io_rspIn_valid; // @[BusInterconnect.scala 21:29]
  wire [31:0] dCacheAdapter_io_rspIn_bits_dataResponse; // @[BusInterconnect.scala 21:29]
  wire  iCacheAdapter_clock; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_reset; // @[BusInterconnect.scala 22:29]
  wire [31:0] iCacheAdapter_io_CPUMemIO_rdAddress; // @[BusInterconnect.scala 22:29]
  wire [31:0] iCacheAdapter_io_CPUMemIO_rdData; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_CPUMemIO_rdEnable; // @[BusInterconnect.scala 22:29]
  wire [31:0] iCacheAdapter_io_CPUMemIO_wrAddress; // @[BusInterconnect.scala 22:29]
  wire [31:0] iCacheAdapter_io_CPUMemIO_wrData; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_CPUMemIO_wrEnable_0; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_CPUMemIO_wrEnable_1; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_CPUMemIO_wrEnable_2; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_CPUMemIO_wrEnable_3; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_CPUMemIO_stall; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_reqOut_valid; // @[BusInterconnect.scala 22:29]
  wire [31:0] iCacheAdapter_io_reqOut_bits_addrRequest; // @[BusInterconnect.scala 22:29]
  wire [31:0] iCacheAdapter_io_reqOut_bits_dataRequest; // @[BusInterconnect.scala 22:29]
  wire [3:0] iCacheAdapter_io_reqOut_bits_activeByteLane; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_reqOut_bits_isWrite; // @[BusInterconnect.scala 22:29]
  wire  iCacheAdapter_io_rspIn_valid; // @[BusInterconnect.scala 22:29]
  wire [31:0] iCacheAdapter_io_rspIn_bits_dataResponse; // @[BusInterconnect.scala 22:29]
  CacheBusAdapter dCacheAdapter ( // @[BusInterconnect.scala 21:29]
    .clock(dCacheAdapter_clock),
    .reset(dCacheAdapter_reset),
    .io_CPUMemIO_rdAddress(dCacheAdapter_io_CPUMemIO_rdAddress),
    .io_CPUMemIO_rdData(dCacheAdapter_io_CPUMemIO_rdData),
    .io_CPUMemIO_rdEnable(dCacheAdapter_io_CPUMemIO_rdEnable),
    .io_CPUMemIO_wrAddress(dCacheAdapter_io_CPUMemIO_wrAddress),
    .io_CPUMemIO_wrData(dCacheAdapter_io_CPUMemIO_wrData),
    .io_CPUMemIO_wrEnable_0(dCacheAdapter_io_CPUMemIO_wrEnable_0),
    .io_CPUMemIO_wrEnable_1(dCacheAdapter_io_CPUMemIO_wrEnable_1),
    .io_CPUMemIO_wrEnable_2(dCacheAdapter_io_CPUMemIO_wrEnable_2),
    .io_CPUMemIO_wrEnable_3(dCacheAdapter_io_CPUMemIO_wrEnable_3),
    .io_CPUMemIO_stall(dCacheAdapter_io_CPUMemIO_stall),
    .io_reqOut_valid(dCacheAdapter_io_reqOut_valid),
    .io_reqOut_bits_addrRequest(dCacheAdapter_io_reqOut_bits_addrRequest),
    .io_reqOut_bits_dataRequest(dCacheAdapter_io_reqOut_bits_dataRequest),
    .io_reqOut_bits_activeByteLane(dCacheAdapter_io_reqOut_bits_activeByteLane),
    .io_reqOut_bits_isWrite(dCacheAdapter_io_reqOut_bits_isWrite),
    .io_rspIn_valid(dCacheAdapter_io_rspIn_valid),
    .io_rspIn_bits_dataResponse(dCacheAdapter_io_rspIn_bits_dataResponse)
  );
  CacheBusAdapter iCacheAdapter ( // @[BusInterconnect.scala 22:29]
    .clock(iCacheAdapter_clock),
    .reset(iCacheAdapter_reset),
    .io_CPUMemIO_rdAddress(iCacheAdapter_io_CPUMemIO_rdAddress),
    .io_CPUMemIO_rdData(iCacheAdapter_io_CPUMemIO_rdData),
    .io_CPUMemIO_rdEnable(iCacheAdapter_io_CPUMemIO_rdEnable),
    .io_CPUMemIO_wrAddress(iCacheAdapter_io_CPUMemIO_wrAddress),
    .io_CPUMemIO_wrData(iCacheAdapter_io_CPUMemIO_wrData),
    .io_CPUMemIO_wrEnable_0(iCacheAdapter_io_CPUMemIO_wrEnable_0),
    .io_CPUMemIO_wrEnable_1(iCacheAdapter_io_CPUMemIO_wrEnable_1),
    .io_CPUMemIO_wrEnable_2(iCacheAdapter_io_CPUMemIO_wrEnable_2),
    .io_CPUMemIO_wrEnable_3(iCacheAdapter_io_CPUMemIO_wrEnable_3),
    .io_CPUMemIO_stall(iCacheAdapter_io_CPUMemIO_stall),
    .io_reqOut_valid(iCacheAdapter_io_reqOut_valid),
    .io_reqOut_bits_addrRequest(iCacheAdapter_io_reqOut_bits_addrRequest),
    .io_reqOut_bits_dataRequest(iCacheAdapter_io_reqOut_bits_dataRequest),
    .io_reqOut_bits_activeByteLane(iCacheAdapter_io_reqOut_bits_activeByteLane),
    .io_reqOut_bits_isWrite(iCacheAdapter_io_reqOut_bits_isWrite),
    .io_rspIn_valid(iCacheAdapter_io_rspIn_valid),
    .io_rspIn_bits_dataResponse(iCacheAdapter_io_rspIn_bits_dataResponse)
  );
  assign io_CPUdCacheMemIO_rdData = dCacheAdapter_io_CPUMemIO_rdData; // @[BusInterconnect.scala 24:29]
  assign io_CPUdCacheMemIO_stall = dCacheAdapter_io_CPUMemIO_stall; // @[BusInterconnect.scala 24:29]
  assign io_CPUiCacheMemIO_rdData = iCacheAdapter_io_CPUMemIO_rdData; // @[BusInterconnect.scala 25:29]
  assign io_CPUiCacheMemIO_stall = iCacheAdapter_io_CPUMemIO_stall; // @[BusInterconnect.scala 25:29]
  assign io_dCacheReqOut_valid = dCacheAdapter_io_reqOut_valid; // @[BusInterconnect.scala 28:19]
  assign io_dCacheReqOut_bits_addrRequest = dCacheAdapter_io_reqOut_bits_addrRequest; // @[BusInterconnect.scala 28:19]
  assign io_dCacheReqOut_bits_dataRequest = dCacheAdapter_io_reqOut_bits_dataRequest; // @[BusInterconnect.scala 28:19]
  assign io_dCacheReqOut_bits_activeByteLane = dCacheAdapter_io_reqOut_bits_activeByteLane; // @[BusInterconnect.scala 28:19]
  assign io_dCacheReqOut_bits_isWrite = dCacheAdapter_io_reqOut_bits_isWrite; // @[BusInterconnect.scala 28:19]
  assign io_iCacheReqOut_valid = iCacheAdapter_io_reqOut_valid; // @[BusInterconnect.scala 30:19]
  assign io_iCacheReqOut_bits_addrRequest = iCacheAdapter_io_reqOut_bits_addrRequest; // @[BusInterconnect.scala 30:19]
  assign io_iCacheReqOut_bits_dataRequest = iCacheAdapter_io_reqOut_bits_dataRequest; // @[BusInterconnect.scala 30:19]
  assign io_iCacheReqOut_bits_activeByteLane = iCacheAdapter_io_reqOut_bits_activeByteLane; // @[BusInterconnect.scala 30:19]
  assign io_iCacheReqOut_bits_isWrite = iCacheAdapter_io_reqOut_bits_isWrite; // @[BusInterconnect.scala 30:19]
  assign dCacheAdapter_clock = clock;
  assign dCacheAdapter_reset = reset;
  assign dCacheAdapter_io_CPUMemIO_rdAddress = io_CPUdCacheMemIO_rdAddress; // @[BusInterconnect.scala 24:29]
  assign dCacheAdapter_io_CPUMemIO_rdEnable = io_CPUdCacheMemIO_rdEnable; // @[BusInterconnect.scala 24:29]
  assign dCacheAdapter_io_CPUMemIO_wrAddress = io_CPUdCacheMemIO_wrAddress; // @[BusInterconnect.scala 24:29]
  assign dCacheAdapter_io_CPUMemIO_wrData = io_CPUdCacheMemIO_wrData; // @[BusInterconnect.scala 24:29]
  assign dCacheAdapter_io_CPUMemIO_wrEnable_0 = io_CPUdCacheMemIO_wrEnable_0; // @[BusInterconnect.scala 24:29]
  assign dCacheAdapter_io_CPUMemIO_wrEnable_1 = io_CPUdCacheMemIO_wrEnable_1; // @[BusInterconnect.scala 24:29]
  assign dCacheAdapter_io_CPUMemIO_wrEnable_2 = io_CPUdCacheMemIO_wrEnable_2; // @[BusInterconnect.scala 24:29]
  assign dCacheAdapter_io_CPUMemIO_wrEnable_3 = io_CPUdCacheMemIO_wrEnable_3; // @[BusInterconnect.scala 24:29]
  assign dCacheAdapter_io_rspIn_valid = io_dCacheRspIn_valid; // @[BusInterconnect.scala 29:26]
  assign dCacheAdapter_io_rspIn_bits_dataResponse = io_dCacheRspIn_bits_dataResponse; // @[BusInterconnect.scala 29:26]
  assign iCacheAdapter_clock = clock;
  assign iCacheAdapter_reset = reset;
  assign iCacheAdapter_io_CPUMemIO_rdAddress = io_CPUiCacheMemIO_rdAddress; // @[BusInterconnect.scala 25:29]
  assign iCacheAdapter_io_CPUMemIO_rdEnable = io_CPUiCacheMemIO_rdEnable; // @[BusInterconnect.scala 25:29]
  assign iCacheAdapter_io_CPUMemIO_wrAddress = 32'h0; // @[BusInterconnect.scala 25:29]
  assign iCacheAdapter_io_CPUMemIO_wrData = 32'h0; // @[BusInterconnect.scala 25:29]
  assign iCacheAdapter_io_CPUMemIO_wrEnable_0 = 1'h0; // @[BusInterconnect.scala 25:29]
  assign iCacheAdapter_io_CPUMemIO_wrEnable_1 = 1'h0; // @[BusInterconnect.scala 25:29]
  assign iCacheAdapter_io_CPUMemIO_wrEnable_2 = 1'h0; // @[BusInterconnect.scala 25:29]
  assign iCacheAdapter_io_CPUMemIO_wrEnable_3 = 1'h0; // @[BusInterconnect.scala 25:29]
  assign iCacheAdapter_io_rspIn_valid = io_iCacheRspIn_valid; // @[BusInterconnect.scala 31:26]
  assign iCacheAdapter_io_rspIn_bits_dataResponse = io_iCacheRspIn_bits_dataResponse; // @[BusInterconnect.scala 31:26]
endmodule
module MemoryController(
  input         clock,
  input         reset,
  output        io_dCacheReqOut_ready,
  input         io_dCacheReqOut_valid,
  input  [31:0] io_dCacheReqOut_bits_addrRequest,
  input  [31:0] io_dCacheReqOut_bits_dataRequest,
  input  [3:0]  io_dCacheReqOut_bits_activeByteLane,
  input         io_dCacheReqOut_bits_isWrite,
  output        io_dCacheRspIn_valid,
  output [31:0] io_dCacheRspIn_bits_dataResponse,
  output        io_iCacheReqOut_ready,
  input         io_iCacheReqOut_valid,
  input  [31:0] io_iCacheReqOut_bits_addrRequest,
  input  [31:0] io_iCacheReqOut_bits_dataRequest,
  input  [3:0]  io_iCacheReqOut_bits_activeByteLane,
  input         io_iCacheReqOut_bits_isWrite,
  output        io_iCacheRspIn_valid,
  output [31:0] io_iCacheRspIn_bits_dataResponse,
  output        io_SPIctrl_rw,
  output        io_SPIctrl_en,
  output [23:0] io_SPIctrl_addr,
  output [31:0] io_SPIctrl_dataIn,
  input  [31:0] io_SPIctrl_dataOut,
  input         io_SPIctrl_done,
  output [5:0]  io_SPIctrl_size,
  output        io_moduleSel_0,
  output        io_moduleSel_1,
  output        io_moduleSel_2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  wire  dReqAck = io_dCacheReqOut_valid & io_dCacheReqOut_ready; // @[MemoryController.scala 41:39]
  wire  iReqAck = io_iCacheReqOut_valid & io_iCacheReqOut_ready; // @[MemoryController.scala 42:39]
  reg [31:0] currentReq_addrRequest; // @[MemoryController.scala 43:23]
  reg [31:0] currentReq_dataRequest; // @[MemoryController.scala 43:23]
  reg [3:0] currentReq_activeByteLane; // @[MemoryController.scala 43:23]
  reg  currentReq_isWrite; // @[MemoryController.scala 43:23]
  reg  rspPending; // @[MemoryController.scala 45:27]
  reg  masterID; // @[MemoryController.scala 48:25]
  reg  rspHandled; // @[MemoryController.scala 52:27]
  wire  _T = ~rspPending; // @[MemoryController.scala 75:19]
  wire  _GEN_4 = iReqAck & _T | rspPending; // @[MemoryController.scala 80:37 82:16 45:27]
  wire  _GEN_5 = iReqAck & _T | masterID; // @[MemoryController.scala 80:37 83:14 48:25]
  wire  _GEN_6 = iReqAck & _T ? 1'h0 : rspHandled; // @[MemoryController.scala 80:37 84:16 52:27]
  wire  _GEN_11 = dReqAck & ~rspPending | _GEN_4; // @[MemoryController.scala 75:31 77:16]
  wire  _GEN_13 = dReqAck & ~rspPending ? 1'h0 : _GEN_6; // @[MemoryController.scala 75:31 79:16]
  wire [2:0] _dataSize_T_1 = 4'hf == currentReq_activeByteLane ? 3'h4 : 3'h1; // @[Mux.scala 81:58]
  wire [2:0] _dataSize_T_3 = 4'hc == currentReq_activeByteLane ? 3'h2 : _dataSize_T_1; // @[Mux.scala 81:58]
  wire [2:0] _dataSize_T_5 = 4'h3 == currentReq_activeByteLane ? 3'h2 : _dataSize_T_3; // @[Mux.scala 81:58]
  wire [1:0] _shiftAmount_T_4 = currentReq_activeByteLane[2] ? 2'h2 : 2'h3; // @[Mux.scala 47:70]
  wire [1:0] _shiftAmount_T_5 = currentReq_activeByteLane[1] ? 2'h1 : _shiftAmount_T_4; // @[Mux.scala 47:70]
  wire [1:0] shiftAmount = currentReq_activeByteLane[0] ? 2'h0 : _shiftAmount_T_5; // @[Mux.scala 47:70]
  wire [5:0] _data2write_T = shiftAmount * 4'h8; // @[MemoryController.scala 100:59]
  wire [31:0] _data2write_T_1 = currentReq_dataRequest >> _data2write_T; // @[MemoryController.scala 100:43]
  wire  _T_5 = currentReq_addrRequest[31:28] == 4'hf; // @[MemoryController.scala 106:41]
  wire  _T_8 = ~currentReq_addrRequest[24]; // @[MemoryController.scala 116:16]
  wire  _GEN_15 = ~currentReq_addrRequest[24] ? 1'h0 : 1'h1; // @[MemoryController.scala 116:45 118:20 122:20]
  wire  _GEN_18 = currentReq_addrRequest[24] ? 1'h0 : _GEN_15; // @[MemoryController.scala 112:44 114:20]
  wire  _GEN_19 = currentReq_addrRequest[24] ? 1'h0 : _T_8; // @[MemoryController.scala 112:44 114:20]
  wire  _GEN_24 = currentReq_addrRequest[31:28] == 4'hf ? 1'h0 : _GEN_18; // @[MemoryController.scala 106:52 38:16]
  wire  _GEN_25 = currentReq_addrRequest[31:28] == 4'hf ? 1'h0 : _GEN_19; // @[MemoryController.scala 106:52 38:16]
  wire  _GEN_26 = currentReq_addrRequest[31:28] == 4'hf ? 1'h0 : currentReq_addrRequest[24]; // @[MemoryController.scala 106:52 38:16]
  wire  _GEN_28 = rspPending & _T_5; // @[MemoryController.scala 105:19 49:26]
  wire  _GEN_30 = rspPending & _GEN_24; // @[MemoryController.scala 105:19 38:16]
  wire  _GEN_31 = rspPending & _GEN_25; // @[MemoryController.scala 105:19 38:16]
  wire  _GEN_32 = rspPending & _GEN_26; // @[MemoryController.scala 105:19 38:16]
  wire [31:0] _GEN_33 = ~currentReq_isWrite ? io_SPIctrl_dataOut : 32'h0; // @[MemoryController.scala 129:31 130:16]
  wire  rspValid = io_SPIctrl_done | _GEN_28; // @[MemoryController.scala 127:25 132:14]
  wire  _GEN_37 = io_SPIctrl_done | _GEN_13; // @[MemoryController.scala 127:25 133:16]
  wire  _GEN_39 = masterID ? 1'h0 : 1'h1; // @[MemoryController.scala 137:19 63:24 140:28]
  assign io_dCacheReqOut_ready = io_dCacheReqOut_valid; // @[MemoryController.scala 55:25]
  assign io_dCacheRspIn_valid = rspValid & _GEN_39; // @[MemoryController.scala 136:17 63:24]
  assign io_dCacheRspIn_bits_dataResponse = io_SPIctrl_done ? _GEN_33 : 32'h0; // @[MemoryController.scala 127:25]
  assign io_iCacheReqOut_ready = ~io_dCacheReqOut_valid & io_iCacheReqOut_valid; // @[MemoryController.scala 56:51]
  assign io_iCacheRspIn_valid = rspValid & masterID; // @[MemoryController.scala 136:17 64:24]
  assign io_iCacheRspIn_bits_dataResponse = io_SPIctrl_done ? _GEN_33 : 32'h0; // @[MemoryController.scala 127:25]
  assign io_SPIctrl_rw = currentReq_isWrite; // @[MemoryController.scala 68:17]
  assign io_SPIctrl_en = rspPending; // @[MemoryController.scala 67:17]
  assign io_SPIctrl_addr = currentReq_addrRequest[23:0]; // @[MemoryController.scala 69:44]
  assign io_SPIctrl_dataIn = currentReq_isWrite ? _data2write_T_1 : 32'h0; // @[MemoryController.scala 100:16 97:27 46:28]
  assign io_SPIctrl_size = {{3'd0}, _dataSize_T_5}; // @[MemoryController.scala 44:26 90:12]
  assign io_moduleSel_0 = rspHandled & _T ? 1'h0 : _GEN_30; // @[MemoryController.scala 146:35 148:18]
  assign io_moduleSel_1 = rspHandled & _T ? 1'h0 : _GEN_31; // @[MemoryController.scala 146:35 148:18]
  assign io_moduleSel_2 = rspHandled & _T ? 1'h0 : _GEN_32; // @[MemoryController.scala 146:35 148:18]
  always @(posedge clock) begin
    if (dReqAck & ~rspPending) begin // @[MemoryController.scala 75:31]
      currentReq_addrRequest <= io_dCacheReqOut_bits_addrRequest; // @[MemoryController.scala 76:16]
    end else if (iReqAck & _T) begin // @[MemoryController.scala 80:37]
      currentReq_addrRequest <= io_iCacheReqOut_bits_addrRequest; // @[MemoryController.scala 81:16]
    end
    if (dReqAck & ~rspPending) begin // @[MemoryController.scala 75:31]
      currentReq_dataRequest <= io_dCacheReqOut_bits_dataRequest; // @[MemoryController.scala 76:16]
    end else if (iReqAck & _T) begin // @[MemoryController.scala 80:37]
      currentReq_dataRequest <= io_iCacheReqOut_bits_dataRequest; // @[MemoryController.scala 81:16]
    end
    if (dReqAck & ~rspPending) begin // @[MemoryController.scala 75:31]
      currentReq_activeByteLane <= io_dCacheReqOut_bits_activeByteLane; // @[MemoryController.scala 76:16]
    end else if (iReqAck & _T) begin // @[MemoryController.scala 80:37]
      currentReq_activeByteLane <= io_iCacheReqOut_bits_activeByteLane; // @[MemoryController.scala 81:16]
    end
    if (dReqAck & ~rspPending) begin // @[MemoryController.scala 75:31]
      currentReq_isWrite <= io_dCacheReqOut_bits_isWrite; // @[MemoryController.scala 76:16]
    end else if (iReqAck & _T) begin // @[MemoryController.scala 80:37]
      currentReq_isWrite <= io_iCacheReqOut_bits_isWrite; // @[MemoryController.scala 81:16]
    end
    if (reset) begin // @[MemoryController.scala 45:27]
      rspPending <= 1'h0; // @[MemoryController.scala 45:27]
    end else if (io_SPIctrl_done) begin // @[MemoryController.scala 127:25]
      rspPending <= 1'h0; // @[MemoryController.scala 128:16]
    end else if (rspPending) begin // @[MemoryController.scala 105:19]
      if (currentReq_addrRequest[31:28] == 4'hf) begin // @[MemoryController.scala 106:52]
        rspPending <= 1'h0; // @[MemoryController.scala 110:18]
      end else begin
        rspPending <= _GEN_11;
      end
    end else begin
      rspPending <= _GEN_11;
    end
    if (reset) begin // @[MemoryController.scala 48:25]
      masterID <= 1'h0; // @[MemoryController.scala 48:25]
    end else if (dReqAck & ~rspPending) begin // @[MemoryController.scala 75:31]
      masterID <= 1'h0; // @[MemoryController.scala 78:14]
    end else begin
      masterID <= _GEN_5;
    end
    rspHandled <= reset | _GEN_37; // @[MemoryController.scala 52:{27,27}]
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
  currentReq_addrRequest = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  currentReq_dataRequest = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  currentReq_activeByteLane = _RAND_2[3:0];
  _RAND_3 = {1{`RANDOM}};
  currentReq_isWrite = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  rspPending = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  masterID = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  rspHandled = _RAND_6[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SerialController(
  input         clock,
  input         reset,
  input  [63:0] io_txData,
  output [31:0] io_rxData,
  input         io_enable,
  input  [8:0]  io_sendLength,
  input  [8:0]  io_numWaitCycles,
  input  [8:0]  io_receiveLength,
  input         io_spiMiso,
  output        io_spiMosi,
  output        io_spiCs,
  output        io_spiClk,
  output        io_done,
  output        io_dir
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] stateReg; // @[SerialController.scala 34:27]
  reg [31:0] spiDataOut; // @[SerialController.scala 36:29]
  reg [63:0] txShiftReg; // @[SerialController.scala 39:29]
  reg [31:0] rxShiftReg; // @[SerialController.scala 40:29]
  reg [7:0] bitCounter; // @[SerialController.scala 41:29]
  reg  csReg; // @[SerialController.scala 43:24]
  reg  clockEnable; // @[SerialController.scala 48:30]
  reg  spiClkReg; // @[SerialController.scala 51:28]
  wire  _spiClkReg_T = ~spiClkReg; // @[SerialController.scala 71:30]
  reg  spiClkRegPrev; // @[SerialController.scala 80:32]
  wire  fallingEdge = _spiClkReg_T & spiClkRegPrev; // @[SerialController.scala 81:34]
  wire  risingEdge = spiClkReg & ~spiClkRegPrev; // @[SerialController.scala 82:32]
  wire [8:0] _totalCycles_T_1 = io_sendLength + io_receiveLength; // @[SerialController.scala 85:34]
  wire [8:0] _totalCycles_T_3 = _totalCycles_T_1 + io_numWaitCycles; // @[SerialController.scala 85:53]
  wire [8:0] _waitReadCycles_T_1 = io_numWaitCycles + io_receiveLength; // @[SerialController.scala 91:40]
  wire [9:0] totalCycles = {{1'd0}, _totalCycles_T_3}; // @[SerialController.scala 84:27 85:17]
  wire [9:0] _bitCounter_T_1 = totalCycles - 10'h1; // @[SerialController.scala 105:39]
  wire [64:0] _txShiftReg_T = {txShiftReg, 1'h0}; // @[SerialController.scala 111:42]
  wire [7:0] _bitCounter_T_3 = bitCounter - 8'h1; // @[SerialController.scala 112:42]
  wire  _T_11 = bitCounter == 8'h0; // @[SerialController.scala 113:34]
  wire  _GEN_7 = io_receiveLength == 9'h0 ? 1'h0 : clockEnable; // @[SerialController.scala 115:53 116:37 48:30]
  wire [2:0] _GEN_8 = io_receiveLength == 9'h0 ? 3'h4 : 3'h2; // @[SerialController.scala 115:53 117:34 119:34]
  wire [7:0] waitReadCycles = _waitReadCycles_T_1[7:0]; // @[SerialController.scala 90:30 91:20]
  wire [7:0] _GEN_9 = bitCounter == 8'h0 ? waitReadCycles : _bitCounter_T_3; // @[SerialController.scala 112:28 113:43 114:32]
  wire  _GEN_10 = bitCounter == 8'h0 ? _GEN_7 : clockEnable; // @[SerialController.scala 113:43 48:30]
  wire [2:0] _GEN_11 = bitCounter == 8'h0 ? _GEN_8 : stateReg; // @[SerialController.scala 113:43 34:27]
  wire [64:0] _GEN_12 = risingEdge ? _txShiftReg_T : {{1'd0}, txShiftReg}; // @[SerialController.scala 110:31 111:28 39:29]
  wire [7:0] _GEN_13 = risingEdge ? _GEN_9 : bitCounter; // @[SerialController.scala 110:31 41:29]
  wire  _GEN_14 = risingEdge ? _GEN_10 : clockEnable; // @[SerialController.scala 110:31 48:30]
  wire [2:0] _GEN_15 = risingEdge ? _GEN_11 : stateReg; // @[SerialController.scala 110:31 34:27]
  wire [32:0] _rxShiftReg_T = {rxShiftReg, 1'h0}; // @[SerialController.scala 127:43]
  wire [32:0] _GEN_54 = {{32'd0}, io_spiMiso}; // @[SerialController.scala 127:56]
  wire [32:0] _rxShiftReg_T_1 = _rxShiftReg_T | _GEN_54; // @[SerialController.scala 127:56]
  wire [32:0] _GEN_16 = fallingEdge ? _rxShiftReg_T_1 : {{1'd0}, rxShiftReg}; // @[SerialController.scala 126:32 127:28 40:29]
  wire [7:0] _GEN_17 = fallingEdge ? _bitCounter_T_3 : bitCounter; // @[SerialController.scala 126:32 128:28 41:29]
  wire [2:0] _GEN_18 = _T_11 ? 3'h4 : stateReg; // @[SerialController.scala 132:43 133:30 34:27]
  wire [2:0] _GEN_19 = risingEdge ? _GEN_18 : stateReg; // @[SerialController.scala 131:31 34:27]
  wire [31:0] _GEN_20 = 3'h4 == stateReg ? rxShiftReg : spiDataOut; // @[SerialController.scala 95:23 138:24 36:29]
  wire  _GEN_21 = 3'h4 == stateReg ? 1'h0 : clockEnable; // @[SerialController.scala 95:23 139:25 48:30]
  wire  _GEN_22 = 3'h4 == stateReg | csReg; // @[SerialController.scala 140:19 95:23 43:24]
  wire [2:0] _GEN_23 = 3'h4 == stateReg ? 3'h0 : stateReg; // @[SerialController.scala 141:22 95:23 34:27]
  wire [32:0] _GEN_24 = 3'h2 == stateReg ? _GEN_16 : {{1'd0}, rxShiftReg}; // @[SerialController.scala 95:23 40:29]
  wire [7:0] _GEN_25 = 3'h2 == stateReg ? _GEN_17 : bitCounter; // @[SerialController.scala 95:23 41:29]
  wire [2:0] _GEN_26 = 3'h2 == stateReg ? _GEN_19 : _GEN_23; // @[SerialController.scala 95:23]
  wire [31:0] _GEN_27 = 3'h2 == stateReg ? spiDataOut : _GEN_20; // @[SerialController.scala 95:23 36:29]
  wire  _GEN_28 = 3'h2 == stateReg ? clockEnable : _GEN_21; // @[SerialController.scala 95:23 48:30]
  wire  _GEN_29 = 3'h2 == stateReg ? csReg : _GEN_22; // @[SerialController.scala 95:23 43:24]
  wire [64:0] _GEN_30 = 3'h3 == stateReg ? _GEN_12 : {{1'd0}, txShiftReg}; // @[SerialController.scala 95:23 39:29]
  wire [7:0] _GEN_31 = 3'h3 == stateReg ? _GEN_13 : _GEN_25; // @[SerialController.scala 95:23]
  wire  _GEN_32 = 3'h3 == stateReg ? _GEN_14 : _GEN_28; // @[SerialController.scala 95:23]
  wire [32:0] _GEN_34 = 3'h3 == stateReg ? {{1'd0}, rxShiftReg} : _GEN_24; // @[SerialController.scala 95:23 40:29]
  wire  _GEN_36 = 3'h3 == stateReg ? csReg : _GEN_29; // @[SerialController.scala 95:23 43:24]
  wire  _GEN_37 = 3'h1 == stateReg ? 1'h0 : _GEN_36; // @[SerialController.scala 102:19 95:23]
  wire  _GEN_38 = 3'h1 == stateReg | _GEN_32; // @[SerialController.scala 95:23 103:25]
  wire [64:0] _GEN_39 = 3'h1 == stateReg ? {{1'd0}, io_txData} : _GEN_30; // @[SerialController.scala 95:23 104:24]
  wire [9:0] _GEN_40 = 3'h1 == stateReg ? _bitCounter_T_1 : {{2'd0}, _GEN_31}; // @[SerialController.scala 95:23 105:24]
  wire [32:0] _GEN_42 = 3'h1 == stateReg ? {{1'd0}, rxShiftReg} : _GEN_34; // @[SerialController.scala 95:23 40:29]
  wire  _GEN_45 = 3'h0 == stateReg ? csReg : _GEN_37; // @[SerialController.scala 95:23 43:24]
  wire [64:0] _GEN_47 = 3'h0 == stateReg ? {{1'd0}, txShiftReg} : _GEN_39; // @[SerialController.scala 95:23 39:29]
  wire [9:0] _GEN_48 = 3'h0 == stateReg ? {{2'd0}, bitCounter} : _GEN_40; // @[SerialController.scala 95:23 41:29]
  wire [32:0] _GEN_49 = 3'h0 == stateReg ? {{1'd0}, rxShiftReg} : _GEN_42; // @[SerialController.scala 95:23 40:29]
  wire [64:0] _GEN_55 = reset ? 65'h0 : _GEN_47; // @[SerialController.scala 39:{29,29}]
  wire [32:0] _GEN_56 = reset ? 33'h0 : _GEN_49; // @[SerialController.scala 40:{29,29}]
  wire [9:0] _GEN_57 = reset ? 10'h0 : _GEN_48; // @[SerialController.scala 41:{29,29}]
  assign io_rxData = spiDataOut; // @[SerialController.scala 93:15]
  assign io_spiMosi = txShiftReg[63]; // @[SerialController.scala 46:29]
  assign io_spiCs = csReg; // @[SerialController.scala 44:14]
  assign io_spiClk = spiClkReg; // @[SerialController.scala 78:15]
  assign io_done = stateReg == 3'h4; // @[SerialController.scala 152:20]
  assign io_dir = stateReg == 3'h2 ? 1'h0 : 1'h1; // @[SerialController.scala 158:18]
  always @(posedge clock) begin
    if (reset) begin // @[SerialController.scala 34:27]
      stateReg <= 3'h0; // @[SerialController.scala 34:27]
    end else if (3'h0 == stateReg) begin // @[SerialController.scala 95:23]
      if (io_enable) begin // @[SerialController.scala 97:30]
        stateReg <= 3'h1; // @[SerialController.scala 98:26]
      end
    end else if (3'h1 == stateReg) begin // @[SerialController.scala 95:23]
      stateReg <= 3'h3; // @[SerialController.scala 106:22]
    end else if (3'h3 == stateReg) begin // @[SerialController.scala 95:23]
      stateReg <= _GEN_15;
    end else begin
      stateReg <= _GEN_26;
    end
    if (reset) begin // @[SerialController.scala 36:29]
      spiDataOut <= 32'h0; // @[SerialController.scala 36:29]
    end else if (!(3'h0 == stateReg)) begin // @[SerialController.scala 95:23]
      if (!(3'h1 == stateReg)) begin // @[SerialController.scala 95:23]
        if (!(3'h3 == stateReg)) begin // @[SerialController.scala 95:23]
          spiDataOut <= _GEN_27;
        end
      end
    end
    txShiftReg <= _GEN_55[63:0]; // @[SerialController.scala 39:{29,29}]
    rxShiftReg <= _GEN_56[31:0]; // @[SerialController.scala 40:{29,29}]
    bitCounter <= _GEN_57[7:0]; // @[SerialController.scala 41:{29,29}]
    csReg <= reset | _GEN_45; // @[SerialController.scala 43:{24,24}]
    if (reset) begin // @[SerialController.scala 48:30]
      clockEnable <= 1'h0; // @[SerialController.scala 48:30]
    end else if (!(3'h0 == stateReg)) begin // @[SerialController.scala 95:23]
      clockEnable <= _GEN_38;
    end
    if (reset) begin // @[SerialController.scala 51:28]
      spiClkReg <= 1'h0; // @[SerialController.scala 51:28]
    end else if (clockEnable) begin // @[SerialController.scala 65:24]
      spiClkReg <= _spiClkReg_T;
    end
    spiClkRegPrev <= spiClkReg; // @[SerialController.scala 80:32]
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
  stateReg = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  spiDataOut = _RAND_1[31:0];
  _RAND_2 = {2{`RANDOM}};
  txShiftReg = _RAND_2[63:0];
  _RAND_3 = {1{`RANDOM}};
  rxShiftReg = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  bitCounter = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  csReg = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  clockEnable = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  spiClkReg = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  spiClkRegPrev = _RAND_8[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module QuadController(
  input         clock,
  input         reset,
  input  [63:0] io_txData,
  output [31:0] io_rxData,
  input         io_enable,
  input  [6:0]  io_sendLength,
  input  [6:0]  io_numWaitCycles,
  input  [6:0]  io_receiveLength,
  input  [3:0]  io_inSio,
  output [3:0]  io_outSio,
  output        io_spiCs,
  output        io_spiClk,
  output        io_done,
  output        io_dir
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] stateReg; // @[QuadController.scala 34:27]
  reg [31:0] spiDataOut; // @[QuadController.scala 36:29]
  reg  csReg; // @[QuadController.scala 39:24]
  reg [63:0] txShiftReg; // @[QuadController.scala 42:29]
  reg [31:0] rxShiftReg; // @[QuadController.scala 43:29]
  reg [7:0] bitCounter; // @[QuadController.scala 44:29]
  reg  clockEnable; // @[QuadController.scala 48:30]
  reg  spiClkReg; // @[QuadController.scala 52:28]
  wire  _spiClkReg_T = ~spiClkReg; // @[QuadController.scala 72:30]
  wire  _GEN_5 = clockEnable & _spiClkReg_T; // @[QuadController.scala 66:24 78:19]
  reg  spiClkRegPrev; // @[QuadController.scala 82:32]
  wire  fallingEdge = _spiClkReg_T & spiClkRegPrev; // @[QuadController.scala 83:34]
  wire  risingEdge = spiClkReg & ~spiClkRegPrev; // @[QuadController.scala 84:32]
  wire [6:0] _waitReadCycles_T_1 = io_numWaitCycles + io_receiveLength; // @[QuadController.scala 93:40]
  wire [7:0] writeCycles = {{1'd0}, io_sendLength}; // @[QuadController.scala 89:27 90:17]
  wire [7:0] _bitCounter_T_1 = writeCycles - 8'h1; // @[QuadController.scala 105:39]
  wire [67:0] _txShiftReg_T = {txShiftReg, 4'h0}; // @[QuadController.scala 110:42]
  wire [7:0] _bitCounter_T_3 = bitCounter - 8'h1; // @[QuadController.scala 111:42]
  wire  _T_11 = bitCounter == 8'h0; // @[QuadController.scala 112:34]
  wire  _GEN_7 = io_receiveLength == 7'h0 ? 1'h0 : clockEnable; // @[QuadController.scala 114:53 115:37 48:30]
  wire [2:0] _GEN_8 = io_receiveLength == 7'h0 ? 3'h4 : 3'h3; // @[QuadController.scala 114:53 116:34 118:34]
  wire [7:0] waitReadCycles = {{1'd0}, _waitReadCycles_T_1}; // @[QuadController.scala 92:30 93:20]
  wire [7:0] _GEN_9 = bitCounter == 8'h0 ? waitReadCycles : _bitCounter_T_3; // @[QuadController.scala 111:28 112:43 113:32]
  wire  _GEN_10 = bitCounter == 8'h0 ? _GEN_7 : clockEnable; // @[QuadController.scala 112:43 48:30]
  wire [2:0] _GEN_11 = bitCounter == 8'h0 ? _GEN_8 : stateReg; // @[QuadController.scala 112:43 34:27]
  wire [67:0] _GEN_12 = risingEdge ? _txShiftReg_T : {{4'd0}, txShiftReg}; // @[QuadController.scala 109:31 110:28 42:29]
  wire [7:0] _GEN_13 = risingEdge ? _GEN_9 : bitCounter; // @[QuadController.scala 109:31 44:29]
  wire  _GEN_14 = risingEdge ? _GEN_10 : clockEnable; // @[QuadController.scala 109:31 48:30]
  wire [2:0] _GEN_15 = risingEdge ? _GEN_11 : stateReg; // @[QuadController.scala 109:31 34:27]
  wire [31:0] _rxShiftReg_T_1 = {io_inSio, 28'h0}; // @[QuadController.scala 128:68]
  wire [31:0] _GEN_62 = {{4'd0}, rxShiftReg[31:4]}; // @[QuadController.scala 128:56]
  wire [31:0] _rxShiftReg_T_2 = _GEN_62 | _rxShiftReg_T_1; // @[QuadController.scala 128:56]
  wire [7:0] _GEN_16 = fallingEdge ? _bitCounter_T_3 : bitCounter; // @[QuadController.scala 126:32 127:28 44:29]
  wire [31:0] _GEN_17 = fallingEdge ? _rxShiftReg_T_2 : rxShiftReg; // @[QuadController.scala 126:32 128:28 43:29]
  wire  _GEN_18 = _T_11 ? 1'h0 : clockEnable; // @[QuadController.scala 132:43 133:33 48:30]
  wire [2:0] _GEN_19 = _T_11 ? 3'h4 : stateReg; // @[QuadController.scala 132:43 134:30 34:27]
  wire  _GEN_20 = risingEdge ? _GEN_18 : clockEnable; // @[QuadController.scala 131:31 48:30]
  wire [2:0] _GEN_21 = risingEdge ? _GEN_19 : stateReg; // @[QuadController.scala 131:31 34:27]
  wire [31:0] reordered = {rxShiftReg[31:28],rxShiftReg[3:0],rxShiftReg[23:20],rxShiftReg[27:24],rxShiftReg[15:12],
    rxShiftReg[19:16],rxShiftReg[7:4],rxShiftReg[11:8]}; // @[Cat.scala 33:92]
  wire [27:0] _rxShiftReg_T_3 = {io_inSio, 24'h0}; // @[QuadController.scala 150:49]
  wire [31:0] _GEN_63 = {{4'd0}, _rxShiftReg_T_3}; // @[QuadController.scala 150:37]
  wire [31:0] _rxShiftReg_T_4 = reordered | _GEN_63; // @[QuadController.scala 150:37]
  wire [31:0] _GEN_22 = 3'h4 == stateReg ? _rxShiftReg_T_4 : rxShiftReg; // @[QuadController.scala 95:23 150:24 43:29]
  wire [31:0] _GEN_23 = 3'h4 == stateReg ? _rxShiftReg_T_4 : spiDataOut; // @[QuadController.scala 95:23 151:24 36:29]
  wire  _GEN_25 = 3'h4 == stateReg | csReg; // @[QuadController.scala 155:19 95:23 39:24]
  wire  _GEN_26 = 3'h4 == stateReg ? 1'h0 : clockEnable; // @[QuadController.scala 95:23 156:25 48:30]
  wire [2:0] _GEN_27 = 3'h4 == stateReg ? 3'h0 : stateReg; // @[QuadController.scala 157:22 95:23 34:27]
  wire [7:0] _GEN_28 = 3'h3 == stateReg ? _GEN_16 : bitCounter; // @[QuadController.scala 95:23 44:29]
  wire [31:0] _GEN_29 = 3'h3 == stateReg ? _GEN_17 : _GEN_22; // @[QuadController.scala 95:23]
  wire  _GEN_30 = 3'h3 == stateReg ? _GEN_20 : _GEN_26; // @[QuadController.scala 95:23]
  wire [2:0] _GEN_31 = 3'h3 == stateReg ? _GEN_21 : _GEN_27; // @[QuadController.scala 95:23]
  wire [31:0] _GEN_32 = 3'h3 == stateReg ? spiDataOut : _GEN_23; // @[QuadController.scala 95:23 36:29]
  wire  _GEN_34 = 3'h3 == stateReg ? csReg : _GEN_25; // @[QuadController.scala 95:23 39:24]
  wire [67:0] _GEN_35 = 3'h2 == stateReg ? _GEN_12 : {{4'd0}, txShiftReg}; // @[QuadController.scala 95:23 42:29]
  wire  _GEN_37 = 3'h2 == stateReg ? _GEN_14 : _GEN_30; // @[QuadController.scala 95:23]
  wire [31:0] _GEN_40 = 3'h2 == stateReg ? spiDataOut : _GEN_32; // @[QuadController.scala 95:23 36:29]
  wire  _GEN_42 = 3'h2 == stateReg ? csReg : _GEN_34; // @[QuadController.scala 95:23 39:24]
  wire  _GEN_43 = 3'h1 == stateReg ? 1'h0 : _GEN_42; // @[QuadController.scala 102:19 95:23]
  wire  _GEN_44 = 3'h1 == stateReg | _GEN_37; // @[QuadController.scala 95:23 103:25]
  wire [67:0] _GEN_45 = 3'h1 == stateReg ? {{4'd0}, io_txData} : _GEN_35; // @[QuadController.scala 95:23 104:24]
  wire [31:0] _GEN_49 = 3'h1 == stateReg ? spiDataOut : _GEN_40; // @[QuadController.scala 95:23 36:29]
  wire  _GEN_52 = 3'h0 == stateReg ? csReg : _GEN_43; // @[QuadController.scala 95:23 39:24]
  wire [67:0] _GEN_54 = 3'h0 == stateReg ? {{4'd0}, txShiftReg} : _GEN_45; // @[QuadController.scala 95:23 42:29]
  wire [67:0] _GEN_66 = reset ? 68'h0 : _GEN_54; // @[QuadController.scala 42:{29,29}]
  assign io_rxData = 3'h0 == stateReg ? spiDataOut : _GEN_49; // @[QuadController.scala 37:15 95:23]
  assign io_outSio = txShiftReg[63:60]; // @[QuadController.scala 46:28]
  assign io_spiCs = csReg; // @[QuadController.scala 40:14]
  assign io_spiClk = spiClkReg; // @[QuadController.scala 80:15]
  assign io_done = stateReg == 3'h4; // @[QuadController.scala 166:20]
  assign io_dir = stateReg == 3'h3 ? 1'h0 : 1'h1; // @[QuadController.scala 172:18]
  always @(posedge clock) begin
    if (reset) begin // @[QuadController.scala 34:27]
      stateReg <= 3'h0; // @[QuadController.scala 34:27]
    end else if (3'h0 == stateReg) begin // @[QuadController.scala 95:23]
      if (io_enable) begin // @[QuadController.scala 97:30]
        stateReg <= 3'h1; // @[QuadController.scala 98:26]
      end
    end else if (3'h1 == stateReg) begin // @[QuadController.scala 95:23]
      stateReg <= 3'h2; // @[QuadController.scala 106:22]
    end else if (3'h2 == stateReg) begin // @[QuadController.scala 95:23]
      stateReg <= _GEN_15;
    end else begin
      stateReg <= _GEN_31;
    end
    if (reset) begin // @[QuadController.scala 36:29]
      spiDataOut <= 32'h0; // @[QuadController.scala 36:29]
    end else if (!(3'h0 == stateReg)) begin // @[QuadController.scala 95:23]
      if (!(3'h1 == stateReg)) begin // @[QuadController.scala 95:23]
        if (!(3'h2 == stateReg)) begin // @[QuadController.scala 95:23]
          spiDataOut <= _GEN_32;
        end
      end
    end
    csReg <= reset | _GEN_52; // @[QuadController.scala 39:{24,24}]
    txShiftReg <= _GEN_66[63:0]; // @[QuadController.scala 42:{29,29}]
    if (reset) begin // @[QuadController.scala 43:29]
      rxShiftReg <= 32'h0; // @[QuadController.scala 43:29]
    end else if (!(3'h0 == stateReg)) begin // @[QuadController.scala 95:23]
      if (!(3'h1 == stateReg)) begin // @[QuadController.scala 95:23]
        if (!(3'h2 == stateReg)) begin // @[QuadController.scala 95:23]
          rxShiftReg <= _GEN_29;
        end
      end
    end
    if (reset) begin // @[QuadController.scala 44:29]
      bitCounter <= 8'h0; // @[QuadController.scala 44:29]
    end else if (!(3'h0 == stateReg)) begin // @[QuadController.scala 95:23]
      if (3'h1 == stateReg) begin // @[QuadController.scala 95:23]
        bitCounter <= _bitCounter_T_1; // @[QuadController.scala 105:24]
      end else if (3'h2 == stateReg) begin // @[QuadController.scala 95:23]
        bitCounter <= _GEN_13;
      end else begin
        bitCounter <= _GEN_28;
      end
    end
    if (reset) begin // @[QuadController.scala 48:30]
      clockEnable <= 1'h0; // @[QuadController.scala 48:30]
    end else if (!(3'h0 == stateReg)) begin // @[QuadController.scala 95:23]
      clockEnable <= _GEN_44;
    end
    if (reset) begin // @[QuadController.scala 52:28]
      spiClkReg <= 1'h0; // @[QuadController.scala 52:28]
    end else begin
      spiClkReg <= _GEN_5;
    end
    spiClkRegPrev <= spiClkReg; // @[QuadController.scala 82:32]
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
  stateReg = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  spiDataOut = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  csReg = _RAND_2[0:0];
  _RAND_3 = {2{`RANDOM}};
  txShiftReg = _RAND_3[63:0];
  _RAND_4 = {1{`RANDOM}};
  rxShiftReg = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  bitCounter = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  clockEnable = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  spiClkReg = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  spiClkRegPrev = _RAND_8[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SpiControllerTop(
  input         clock,
  input         reset,
  input  [3:0]  io_inSio,
  output [3:0]  io_outSio,
  output        io_spiClk,
  output        io_CS0,
  output        io_CS1,
  output        io_CS2,
  input         io_moduleSel_0,
  input         io_moduleSel_1,
  input         io_moduleSel_2,
  input         io_SPIctrl_rw,
  input         io_SPIctrl_en,
  input  [23:0] io_SPIctrl_addr,
  input  [31:0] io_SPIctrl_dataIn,
  output [31:0] io_SPIctrl_dataOut,
  output        io_SPIctrl_done,
  input  [5:0]  io_SPIctrl_size,
  output        io_startup,
  output        io_dir
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
`endif // RANDOMIZE_REG_INIT
  wire  SController_clock; // @[SpiControllerTop.scala 33:29]
  wire  SController_reset; // @[SpiControllerTop.scala 33:29]
  wire [63:0] SController_io_txData; // @[SpiControllerTop.scala 33:29]
  wire [31:0] SController_io_rxData; // @[SpiControllerTop.scala 33:29]
  wire  SController_io_enable; // @[SpiControllerTop.scala 33:29]
  wire [8:0] SController_io_sendLength; // @[SpiControllerTop.scala 33:29]
  wire [8:0] SController_io_numWaitCycles; // @[SpiControllerTop.scala 33:29]
  wire [8:0] SController_io_receiveLength; // @[SpiControllerTop.scala 33:29]
  wire  SController_io_spiMiso; // @[SpiControllerTop.scala 33:29]
  wire  SController_io_spiMosi; // @[SpiControllerTop.scala 33:29]
  wire  SController_io_spiCs; // @[SpiControllerTop.scala 33:29]
  wire  SController_io_spiClk; // @[SpiControllerTop.scala 33:29]
  wire  SController_io_done; // @[SpiControllerTop.scala 33:29]
  wire  SController_io_dir; // @[SpiControllerTop.scala 33:29]
  wire  QController_clock; // @[SpiControllerTop.scala 34:29]
  wire  QController_reset; // @[SpiControllerTop.scala 34:29]
  wire [63:0] QController_io_txData; // @[SpiControllerTop.scala 34:29]
  wire [31:0] QController_io_rxData; // @[SpiControllerTop.scala 34:29]
  wire  QController_io_enable; // @[SpiControllerTop.scala 34:29]
  wire [6:0] QController_io_sendLength; // @[SpiControllerTop.scala 34:29]
  wire [6:0] QController_io_numWaitCycles; // @[SpiControllerTop.scala 34:29]
  wire [6:0] QController_io_receiveLength; // @[SpiControllerTop.scala 34:29]
  wire [3:0] QController_io_inSio; // @[SpiControllerTop.scala 34:29]
  wire [3:0] QController_io_outSio; // @[SpiControllerTop.scala 34:29]
  wire  QController_io_spiCs; // @[SpiControllerTop.scala 34:29]
  wire  QController_io_spiClk; // @[SpiControllerTop.scala 34:29]
  wire  QController_io_done; // @[SpiControllerTop.scala 34:29]
  wire  QController_io_dir; // @[SpiControllerTop.scala 34:29]
  reg [2:0] state; // @[SpiControllerTop.scala 31:24]
  reg  quadReg; // @[SpiControllerTop.scala 36:26]
  reg [7:0] cmdReg; // @[SpiControllerTop.scala 39:25]
  reg [23:0] addrReg; // @[SpiControllerTop.scala 40:26]
  reg [31:0] dataReg; // @[SpiControllerTop.scala 41:26]
  reg [6:0] sendLengthReg; // @[SpiControllerTop.scala 42:32]
  reg [6:0] waitCyclesReg; // @[SpiControllerTop.scala 43:32]
  reg [6:0] receiveLengthReg; // @[SpiControllerTop.scala 44:35]
  reg [31:0] delayCounter; // @[SpiControllerTop.scala 45:31]
  reg  startupDone; // @[SpiControllerTop.scala 46:30]
  reg [31:0] dataOutReg; // @[SpiControllerTop.scala 47:29]
  reg [31:0] dataInReg; // @[SpiControllerTop.scala 51:28]
  wire [31:0] flippedDataIn = {dataInReg[7:0],dataInReg[15:8],dataInReg[23:16],dataInReg[31:24]}; // @[Cat.scala 33:92]
  wire [31:0] _dataReg_T = io_SPIctrl_rw ? flippedDataIn : 32'h0; // @[SpiControllerTop.scala 57:19]
  wire [3:0] _io_outSio_T = {3'h0,SController_io_spiMosi}; // @[Cat.scala 33:92]
  wire [31:0] dataRead = quadReg ? QController_io_rxData : SController_io_rxData; // @[SpiControllerTop.scala 59:20 63:18 70:18]
  wire  _io_CS0_T = quadReg ? QController_io_spiCs : SController_io_spiCs; // @[SpiControllerTop.scala 75:38]
  wire [31:0] txDataReg_hi = {cmdReg,addrReg}; // @[Cat.scala 33:92]
  wire [31:0] _delayCounter_T_1 = delayCounter + 32'h1; // @[SpiControllerTop.scala 98:42]
  wire [6:0] _GEN_9 = delayCounter == 32'hf ? 7'h8 : sendLengthReg; // @[SpiControllerTop.scala 103:31 42:32 99:43]
  wire [6:0] _GEN_11 = delayCounter == 32'hf ? 7'h0 : receiveLengthReg; // @[SpiControllerTop.scala 105:34 44:35 99:43]
  wire  _GEN_13 = SController_io_done | quadReg; // @[SpiControllerTop.scala 115:40 116:25 36:26]
  wire [7:0] _GEN_14 = delayCounter == 32'h22 ? 8'hc0 : cmdReg; // @[SpiControllerTop.scala 119:62 120:24 39:25]
  wire [23:0] _GEN_15 = delayCounter == 32'h22 ? 24'h0 : addrReg; // @[SpiControllerTop.scala 119:62 121:25 40:26]
  wire [31:0] _GEN_16 = delayCounter == 32'h22 ? 32'h0 : _dataReg_T; // @[SpiControllerTop.scala 119:62 122:25 57:13]
  wire [6:0] _GEN_17 = delayCounter == 32'h22 ? 7'h2 : sendLengthReg; // @[SpiControllerTop.scala 119:62 123:31 42:32]
  wire [6:0] _GEN_18 = delayCounter == 32'h22 ? 7'h0 : waitCyclesReg; // @[SpiControllerTop.scala 119:62 124:31 43:32]
  wire [6:0] _GEN_19 = delayCounter == 32'h22 ? 7'h0 : receiveLengthReg; // @[SpiControllerTop.scala 119:62 125:34 44:35]
  wire [2:0] _GEN_20 = delayCounter == 32'h22 ? 3'h3 : state; // @[SpiControllerTop.scala 119:62 126:23 31:24]
  wire [7:0] _receiveLengthReg_T = io_SPIctrl_size * 2'h2; // @[SpiControllerTop.scala 140:53]
  wire [7:0] _sendLengthReg_T_2 = 8'h8 + _receiveLengthReg_T; // @[SpiControllerTop.scala 146:38]
  wire [7:0] _GEN_21 = io_SPIctrl_en & io_SPIctrl_rw ? 8'h38 : cmdReg; // @[SpiControllerTop.scala 143:56 144:24 39:25]
  wire [23:0] _GEN_22 = io_SPIctrl_en & io_SPIctrl_rw ? io_SPIctrl_addr : addrReg; // @[SpiControllerTop.scala 143:56 145:25 40:26]
  wire [7:0] _GEN_23 = io_SPIctrl_en & io_SPIctrl_rw ? _sendLengthReg_T_2 : {{1'd0}, sendLengthReg}; // @[SpiControllerTop.scala 143:56 146:31 42:32]
  wire [6:0] _GEN_24 = io_SPIctrl_en & io_SPIctrl_rw ? 7'h0 : waitCyclesReg; // @[SpiControllerTop.scala 143:56 147:31 43:32]
  wire [6:0] _GEN_25 = io_SPIctrl_en & io_SPIctrl_rw ? 7'h0 : receiveLengthReg; // @[SpiControllerTop.scala 143:56 148:34 44:35]
  wire [2:0] _GEN_26 = io_SPIctrl_en & io_SPIctrl_rw ? 3'h5 : state; // @[SpiControllerTop.scala 143:56 149:23 31:24]
  wire [7:0] _GEN_27 = io_SPIctrl_en & ~io_SPIctrl_rw ? 8'heb : _GEN_21; // @[SpiControllerTop.scala 135:52 136:24]
  wire [23:0] _GEN_28 = io_SPIctrl_en & ~io_SPIctrl_rw ? io_SPIctrl_addr : _GEN_22; // @[SpiControllerTop.scala 135:52 137:25]
  wire [7:0] _GEN_29 = io_SPIctrl_en & ~io_SPIctrl_rw ? 8'h8 : _GEN_23; // @[SpiControllerTop.scala 135:52 138:31]
  wire [6:0] _GEN_30 = io_SPIctrl_en & ~io_SPIctrl_rw ? 7'h7 : _GEN_24; // @[SpiControllerTop.scala 135:52 139:31]
  wire [7:0] _GEN_31 = io_SPIctrl_en & ~io_SPIctrl_rw ? _receiveLengthReg_T : {{1'd0}, _GEN_25}; // @[SpiControllerTop.scala 135:52 140:34]
  wire [2:0] _GEN_32 = io_SPIctrl_en & ~io_SPIctrl_rw ? 3'h5 : _GEN_26; // @[SpiControllerTop.scala 135:52 141:23]
  wire [2:0] _GEN_33 = QController_io_done ? 3'h7 : state; // @[SpiControllerTop.scala 157:40 158:23 31:24]
  wire  _GEN_34 = QController_io_done | startupDone; // @[SpiControllerTop.scala 157:40 159:29 46:30]
  wire [31:0] _GEN_35 = 3'h7 == state ? dataRead : dataOutReg; // @[SpiControllerTop.scala 96:20 163:24 47:29]
  wire [2:0] _GEN_36 = 3'h7 == state ? 3'h4 : state; // @[SpiControllerTop.scala 165:19 96:20 31:24]
  wire [2:0] _GEN_37 = 3'h6 == state ? _GEN_33 : _GEN_36; // @[SpiControllerTop.scala 96:20]
  wire  _GEN_38 = 3'h6 == state ? _GEN_34 : startupDone; // @[SpiControllerTop.scala 96:20 46:30]
  wire [31:0] _GEN_39 = 3'h6 == state ? dataOutReg : _GEN_35; // @[SpiControllerTop.scala 96:20 47:29]
  wire [2:0] _GEN_41 = 3'h5 == state ? 3'h6 : _GEN_37; // @[SpiControllerTop.scala 154:19 96:20]
  wire  _GEN_42 = 3'h5 == state ? startupDone : _GEN_38; // @[SpiControllerTop.scala 96:20 46:30]
  wire [31:0] _GEN_43 = 3'h5 == state ? dataOutReg : _GEN_39; // @[SpiControllerTop.scala 96:20 47:29]
  wire [7:0] _GEN_44 = 3'h4 == state ? _GEN_27 : cmdReg; // @[SpiControllerTop.scala 96:20 39:25]
  wire [23:0] _GEN_45 = 3'h4 == state ? _GEN_28 : addrReg; // @[SpiControllerTop.scala 96:20 40:26]
  wire [7:0] _GEN_46 = 3'h4 == state ? _GEN_29 : {{1'd0}, sendLengthReg}; // @[SpiControllerTop.scala 96:20 42:32]
  wire [6:0] _GEN_47 = 3'h4 == state ? _GEN_30 : waitCyclesReg; // @[SpiControllerTop.scala 96:20 43:32]
  wire [7:0] _GEN_48 = 3'h4 == state ? _GEN_31 : {{1'd0}, receiveLengthReg}; // @[SpiControllerTop.scala 96:20 44:35]
  wire [2:0] _GEN_49 = 3'h4 == state ? _GEN_32 : _GEN_41; // @[SpiControllerTop.scala 96:20]
  wire  _GEN_50 = 3'h4 == state ? 1'h0 : 3'h5 == state; // @[SpiControllerTop.scala 96:20 94:27]
  wire  _GEN_51 = 3'h4 == state ? startupDone : _GEN_42; // @[SpiControllerTop.scala 96:20 46:30]
  wire [31:0] _GEN_52 = 3'h4 == state ? dataOutReg : _GEN_43; // @[SpiControllerTop.scala 96:20 47:29]
  wire [31:0] _GEN_53 = 3'h3 == state ? 32'h0 : delayCounter; // @[SpiControllerTop.scala 96:20 130:26 45:31]
  wire  _GEN_54 = 3'h3 == state | _GEN_50; // @[SpiControllerTop.scala 96:20 131:35]
  wire [2:0] _GEN_55 = 3'h3 == state ? 3'h6 : _GEN_49; // @[SpiControllerTop.scala 132:19 96:20]
  wire [7:0] _GEN_56 = 3'h3 == state ? cmdReg : _GEN_44; // @[SpiControllerTop.scala 96:20 39:25]
  wire [23:0] _GEN_57 = 3'h3 == state ? addrReg : _GEN_45; // @[SpiControllerTop.scala 96:20 40:26]
  wire [7:0] _GEN_58 = 3'h3 == state ? {{1'd0}, sendLengthReg} : _GEN_46; // @[SpiControllerTop.scala 96:20 42:32]
  wire [6:0] _GEN_59 = 3'h3 == state ? waitCyclesReg : _GEN_47; // @[SpiControllerTop.scala 96:20 43:32]
  wire [7:0] _GEN_60 = 3'h3 == state ? {{1'd0}, receiveLengthReg} : _GEN_48; // @[SpiControllerTop.scala 96:20 44:35]
  wire  _GEN_61 = 3'h3 == state ? startupDone : _GEN_51; // @[SpiControllerTop.scala 96:20 46:30]
  wire [31:0] _GEN_62 = 3'h3 == state ? dataOutReg : _GEN_52; // @[SpiControllerTop.scala 96:20 47:29]
  wire [7:0] _GEN_68 = 3'h2 == state ? {{1'd0}, _GEN_17} : _GEN_58; // @[SpiControllerTop.scala 96:20]
  wire [7:0] _GEN_70 = 3'h2 == state ? {{1'd0}, _GEN_19} : _GEN_60; // @[SpiControllerTop.scala 96:20]
  wire  _GEN_72 = 3'h2 == state ? 1'h0 : _GEN_54; // @[SpiControllerTop.scala 96:20 94:27]
  wire [31:0] _GEN_74 = 3'h2 == state ? dataOutReg : _GEN_62; // @[SpiControllerTop.scala 96:20 47:29]
  wire [7:0] _GEN_82 = 3'h1 == state ? {{1'd0}, sendLengthReg} : _GEN_68; // @[SpiControllerTop.scala 96:20 42:32]
  wire [7:0] _GEN_84 = 3'h1 == state ? {{1'd0}, receiveLengthReg} : _GEN_70; // @[SpiControllerTop.scala 96:20 44:35]
  wire  _GEN_85 = 3'h1 == state ? 1'h0 : _GEN_72; // @[SpiControllerTop.scala 96:20 94:27]
  wire [31:0] _GEN_87 = 3'h1 == state ? dataOutReg : _GEN_74; // @[SpiControllerTop.scala 96:20 47:29]
  wire [7:0] _GEN_92 = 3'h0 == state ? {{1'd0}, _GEN_9} : _GEN_82; // @[SpiControllerTop.scala 96:20]
  wire [7:0] _GEN_94 = 3'h0 == state ? {{1'd0}, _GEN_11} : _GEN_84; // @[SpiControllerTop.scala 96:20]
  wire [7:0] _GEN_101 = reset ? 8'h0 : _GEN_92; // @[SpiControllerTop.scala 42:{32,32}]
  wire [7:0] _GEN_102 = reset ? 8'h0 : _GEN_94; // @[SpiControllerTop.scala 44:{35,35}]
  SerialController SController ( // @[SpiControllerTop.scala 33:29]
    .clock(SController_clock),
    .reset(SController_reset),
    .io_txData(SController_io_txData),
    .io_rxData(SController_io_rxData),
    .io_enable(SController_io_enable),
    .io_sendLength(SController_io_sendLength),
    .io_numWaitCycles(SController_io_numWaitCycles),
    .io_receiveLength(SController_io_receiveLength),
    .io_spiMiso(SController_io_spiMiso),
    .io_spiMosi(SController_io_spiMosi),
    .io_spiCs(SController_io_spiCs),
    .io_spiClk(SController_io_spiClk),
    .io_done(SController_io_done),
    .io_dir(SController_io_dir)
  );
  QuadController QController ( // @[SpiControllerTop.scala 34:29]
    .clock(QController_clock),
    .reset(QController_reset),
    .io_txData(QController_io_txData),
    .io_rxData(QController_io_rxData),
    .io_enable(QController_io_enable),
    .io_sendLength(QController_io_sendLength),
    .io_numWaitCycles(QController_io_numWaitCycles),
    .io_receiveLength(QController_io_receiveLength),
    .io_inSio(QController_io_inSio),
    .io_outSio(QController_io_outSio),
    .io_spiCs(QController_io_spiCs),
    .io_spiClk(QController_io_spiClk),
    .io_done(QController_io_done),
    .io_dir(QController_io_dir)
  );
  assign io_outSio = quadReg ? QController_io_outSio : _io_outSio_T; // @[SpiControllerTop.scala 59:20 60:19 67:19]
  assign io_spiClk = quadReg ? QController_io_spiClk : SController_io_spiClk; // @[SpiControllerTop.scala 59:20 62:19 69:19]
  assign io_CS0 = io_moduleSel_0 ? _io_CS0_T : 1'h1; // @[SpiControllerTop.scala 75:18]
  assign io_CS1 = io_moduleSel_1 ? _io_CS0_T : 1'h1; // @[SpiControllerTop.scala 76:18]
  assign io_CS2 = io_moduleSel_2 ? _io_CS0_T : 1'h1; // @[SpiControllerTop.scala 77:18]
  assign io_SPIctrl_dataOut = 3'h0 == state ? dataOutReg : _GEN_87; // @[SpiControllerTop.scala 96:20 47:29]
  assign io_SPIctrl_done = state == 3'h7; // @[SpiControllerTop.scala 169:30]
  assign io_startup = ~startupDone; // @[SpiControllerTop.scala 171:19]
  assign io_dir = quadReg ? QController_io_dir : SController_io_dir; // @[SpiControllerTop.scala 59:20 64:16 71:16]
  assign SController_clock = clock;
  assign SController_reset = reset;
  assign SController_io_txData = {txDataReg_hi,dataReg}; // @[Cat.scala 33:92]
  assign SController_io_enable = 3'h0 == state ? 1'h0 : 3'h1 == state; // @[SpiControllerTop.scala 96:20 93:27]
  assign SController_io_sendLength = {{2'd0}, sendLengthReg}; // @[SpiControllerTop.scala 82:31]
  assign SController_io_numWaitCycles = {{2'd0}, waitCyclesReg}; // @[SpiControllerTop.scala 83:34]
  assign SController_io_receiveLength = {{2'd0}, receiveLengthReg}; // @[SpiControllerTop.scala 84:34]
  assign SController_io_spiMiso = quadReg ? 1'h0 : io_inSio[1]; // @[SpiControllerTop.scala 59:20 65:32 68:32]
  assign QController_clock = clock;
  assign QController_reset = reset;
  assign QController_io_txData = {txDataReg_hi,dataReg}; // @[Cat.scala 33:92]
  assign QController_io_enable = 3'h0 == state ? 1'h0 : _GEN_85; // @[SpiControllerTop.scala 96:20 94:27]
  assign QController_io_sendLength = sendLengthReg; // @[SpiControllerTop.scala 88:31]
  assign QController_io_numWaitCycles = waitCyclesReg; // @[SpiControllerTop.scala 89:34]
  assign QController_io_receiveLength = receiveLengthReg; // @[SpiControllerTop.scala 90:34]
  assign QController_io_inSio = quadReg ? io_inSio : 4'h0; // @[SpiControllerTop.scala 59:20 61:30 72:30]
  always @(posedge clock) begin
    if (reset) begin // @[SpiControllerTop.scala 31:24]
      state <= 3'h0; // @[SpiControllerTop.scala 31:24]
    end else if (3'h0 == state) begin // @[SpiControllerTop.scala 96:20]
      if (delayCounter == 32'hf) begin // @[SpiControllerTop.scala 99:43]
        state <= 3'h1; // @[SpiControllerTop.scala 106:23]
      end
    end else if (3'h1 == state) begin // @[SpiControllerTop.scala 96:20]
      state <= 3'h2; // @[SpiControllerTop.scala 112:19]
    end else if (3'h2 == state) begin // @[SpiControllerTop.scala 96:20]
      state <= _GEN_20;
    end else begin
      state <= _GEN_55;
    end
    if (reset) begin // @[SpiControllerTop.scala 36:26]
      quadReg <= 1'h0; // @[SpiControllerTop.scala 36:26]
    end else if (!(3'h0 == state)) begin // @[SpiControllerTop.scala 96:20]
      if (!(3'h1 == state)) begin // @[SpiControllerTop.scala 96:20]
        if (3'h2 == state) begin // @[SpiControllerTop.scala 96:20]
          quadReg <= _GEN_13;
        end
      end
    end
    if (reset) begin // @[SpiControllerTop.scala 39:25]
      cmdReg <= 8'h0; // @[SpiControllerTop.scala 39:25]
    end else if (3'h0 == state) begin // @[SpiControllerTop.scala 96:20]
      if (delayCounter == 32'hf) begin // @[SpiControllerTop.scala 99:43]
        cmdReg <= 8'h35; // @[SpiControllerTop.scala 100:24]
      end
    end else if (!(3'h1 == state)) begin // @[SpiControllerTop.scala 96:20]
      if (3'h2 == state) begin // @[SpiControllerTop.scala 96:20]
        cmdReg <= _GEN_14;
      end else begin
        cmdReg <= _GEN_56;
      end
    end
    if (reset) begin // @[SpiControllerTop.scala 40:26]
      addrReg <= 24'h0; // @[SpiControllerTop.scala 40:26]
    end else if (3'h0 == state) begin // @[SpiControllerTop.scala 96:20]
      if (delayCounter == 32'hf) begin // @[SpiControllerTop.scala 99:43]
        addrReg <= 24'h0; // @[SpiControllerTop.scala 101:25]
      end
    end else if (!(3'h1 == state)) begin // @[SpiControllerTop.scala 96:20]
      if (3'h2 == state) begin // @[SpiControllerTop.scala 96:20]
        addrReg <= _GEN_15;
      end else begin
        addrReg <= _GEN_57;
      end
    end
    if (reset) begin // @[SpiControllerTop.scala 41:26]
      dataReg <= 32'h0; // @[SpiControllerTop.scala 41:26]
    end else if (3'h0 == state) begin // @[SpiControllerTop.scala 96:20]
      if (delayCounter == 32'hf) begin // @[SpiControllerTop.scala 99:43]
        dataReg <= 32'h0; // @[SpiControllerTop.scala 102:25]
      end else begin
        dataReg <= _dataReg_T; // @[SpiControllerTop.scala 57:13]
      end
    end else if (3'h1 == state) begin // @[SpiControllerTop.scala 96:20]
      dataReg <= _dataReg_T; // @[SpiControllerTop.scala 57:13]
    end else if (3'h2 == state) begin // @[SpiControllerTop.scala 96:20]
      dataReg <= _GEN_16;
    end else begin
      dataReg <= _dataReg_T; // @[SpiControllerTop.scala 57:13]
    end
    sendLengthReg <= _GEN_101[6:0]; // @[SpiControllerTop.scala 42:{32,32}]
    if (reset) begin // @[SpiControllerTop.scala 43:32]
      waitCyclesReg <= 7'h0; // @[SpiControllerTop.scala 43:32]
    end else if (3'h0 == state) begin // @[SpiControllerTop.scala 96:20]
      if (delayCounter == 32'hf) begin // @[SpiControllerTop.scala 99:43]
        waitCyclesReg <= 7'h0; // @[SpiControllerTop.scala 104:31]
      end
    end else if (!(3'h1 == state)) begin // @[SpiControllerTop.scala 96:20]
      if (3'h2 == state) begin // @[SpiControllerTop.scala 96:20]
        waitCyclesReg <= _GEN_18;
      end else begin
        waitCyclesReg <= _GEN_59;
      end
    end
    receiveLengthReg <= _GEN_102[6:0]; // @[SpiControllerTop.scala 44:{35,35}]
    if (reset) begin // @[SpiControllerTop.scala 45:31]
      delayCounter <= 32'h0; // @[SpiControllerTop.scala 45:31]
    end else if (3'h0 == state) begin // @[SpiControllerTop.scala 96:20]
      delayCounter <= _delayCounter_T_1; // @[SpiControllerTop.scala 98:26]
    end else if (3'h1 == state) begin // @[SpiControllerTop.scala 96:20]
      delayCounter <= 32'h0; // @[SpiControllerTop.scala 110:26]
    end else if (3'h2 == state) begin // @[SpiControllerTop.scala 96:20]
      delayCounter <= _delayCounter_T_1; // @[SpiControllerTop.scala 118:26]
    end else begin
      delayCounter <= _GEN_53;
    end
    if (reset) begin // @[SpiControllerTop.scala 46:30]
      startupDone <= 1'h0; // @[SpiControllerTop.scala 46:30]
    end else if (!(3'h0 == state)) begin // @[SpiControllerTop.scala 96:20]
      if (!(3'h1 == state)) begin // @[SpiControllerTop.scala 96:20]
        if (!(3'h2 == state)) begin // @[SpiControllerTop.scala 96:20]
          startupDone <= _GEN_61;
        end
      end
    end
    if (reset) begin // @[SpiControllerTop.scala 47:29]
      dataOutReg <= 32'h0; // @[SpiControllerTop.scala 47:29]
    end else if (!(3'h0 == state)) begin // @[SpiControllerTop.scala 96:20]
      if (!(3'h1 == state)) begin // @[SpiControllerTop.scala 96:20]
        if (!(3'h2 == state)) begin // @[SpiControllerTop.scala 96:20]
          dataOutReg <= _GEN_62;
        end
      end
    end
    if (reset) begin // @[SpiControllerTop.scala 51:28]
      dataInReg <= 32'h0; // @[SpiControllerTop.scala 51:28]
    end else begin
      dataInReg <= io_SPIctrl_dataIn; // @[SpiControllerTop.scala 52:15]
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
  state = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  quadReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  cmdReg = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  addrReg = _RAND_3[23:0];
  _RAND_4 = {1{`RANDOM}};
  dataReg = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  sendLengthReg = _RAND_5[6:0];
  _RAND_6 = {1{`RANDOM}};
  waitCyclesReg = _RAND_6[6:0];
  _RAND_7 = {1{`RANDOM}};
  receiveLengthReg = _RAND_7[6:0];
  _RAND_8 = {1{`RANDOM}};
  delayCounter = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  startupDone = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  dataOutReg = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  dataInReg = _RAND_11[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module MemoryControllerTopPhysical(
  input         clock,
  input         reset,
  input         io_dCacheReqOut_valid,
  input  [31:0] io_dCacheReqOut_bits_addrRequest,
  input  [31:0] io_dCacheReqOut_bits_dataRequest,
  input  [3:0]  io_dCacheReqOut_bits_activeByteLane,
  input         io_dCacheReqOut_bits_isWrite,
  output        io_dCacheRspIn_valid,
  output [31:0] io_dCacheRspIn_bits_dataResponse,
  input         io_iCacheReqOut_valid,
  input  [31:0] io_iCacheReqOut_bits_addrRequest,
  input  [31:0] io_iCacheReqOut_bits_dataRequest,
  input  [3:0]  io_iCacheReqOut_bits_activeByteLane,
  input         io_iCacheReqOut_bits_isWrite,
  output        io_iCacheRspIn_valid,
  output [31:0] io_iCacheRspIn_bits_dataResponse,
  output        io_CS0,
  output        io_CS1,
  output        io_CS2,
  output        io_dir,
  input  [3:0]  io_inSio,
  output [3:0]  io_outSio,
  output        io_spiClk
);
  wire  MemCtrl_clock; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_reset; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_dCacheReqOut_ready; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_dCacheReqOut_valid; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [31:0] MemCtrl_io_dCacheReqOut_bits_addrRequest; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [31:0] MemCtrl_io_dCacheReqOut_bits_dataRequest; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [3:0] MemCtrl_io_dCacheReqOut_bits_activeByteLane; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_dCacheReqOut_bits_isWrite; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_dCacheRspIn_valid; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [31:0] MemCtrl_io_dCacheRspIn_bits_dataResponse; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_iCacheReqOut_ready; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_iCacheReqOut_valid; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [31:0] MemCtrl_io_iCacheReqOut_bits_addrRequest; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [31:0] MemCtrl_io_iCacheReqOut_bits_dataRequest; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [3:0] MemCtrl_io_iCacheReqOut_bits_activeByteLane; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_iCacheReqOut_bits_isWrite; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_iCacheRspIn_valid; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [31:0] MemCtrl_io_iCacheRspIn_bits_dataResponse; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_SPIctrl_rw; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_SPIctrl_en; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [23:0] MemCtrl_io_SPIctrl_addr; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [31:0] MemCtrl_io_SPIctrl_dataIn; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [31:0] MemCtrl_io_SPIctrl_dataOut; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_SPIctrl_done; // @[MemoryControllerTopPhysical.scala 37:23]
  wire [5:0] MemCtrl_io_SPIctrl_size; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_moduleSel_0; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_moduleSel_1; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  MemCtrl_io_moduleSel_2; // @[MemoryControllerTopPhysical.scala 37:23]
  wire  SpiCtrl_clock; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_reset; // @[MemoryControllerTopPhysical.scala 45:23]
  wire [3:0] SpiCtrl_io_inSio; // @[MemoryControllerTopPhysical.scala 45:23]
  wire [3:0] SpiCtrl_io_outSio; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_spiClk; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_CS0; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_CS1; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_CS2; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_moduleSel_0; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_moduleSel_1; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_moduleSel_2; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_SPIctrl_rw; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_SPIctrl_en; // @[MemoryControllerTopPhysical.scala 45:23]
  wire [23:0] SpiCtrl_io_SPIctrl_addr; // @[MemoryControllerTopPhysical.scala 45:23]
  wire [31:0] SpiCtrl_io_SPIctrl_dataIn; // @[MemoryControllerTopPhysical.scala 45:23]
  wire [31:0] SpiCtrl_io_SPIctrl_dataOut; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_SPIctrl_done; // @[MemoryControllerTopPhysical.scala 45:23]
  wire [5:0] SpiCtrl_io_SPIctrl_size; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_startup; // @[MemoryControllerTopPhysical.scala 45:23]
  wire  SpiCtrl_io_dir; // @[MemoryControllerTopPhysical.scala 45:23]
  MemoryController MemCtrl ( // @[MemoryControllerTopPhysical.scala 37:23]
    .clock(MemCtrl_clock),
    .reset(MemCtrl_reset),
    .io_dCacheReqOut_ready(MemCtrl_io_dCacheReqOut_ready),
    .io_dCacheReqOut_valid(MemCtrl_io_dCacheReqOut_valid),
    .io_dCacheReqOut_bits_addrRequest(MemCtrl_io_dCacheReqOut_bits_addrRequest),
    .io_dCacheReqOut_bits_dataRequest(MemCtrl_io_dCacheReqOut_bits_dataRequest),
    .io_dCacheReqOut_bits_activeByteLane(MemCtrl_io_dCacheReqOut_bits_activeByteLane),
    .io_dCacheReqOut_bits_isWrite(MemCtrl_io_dCacheReqOut_bits_isWrite),
    .io_dCacheRspIn_valid(MemCtrl_io_dCacheRspIn_valid),
    .io_dCacheRspIn_bits_dataResponse(MemCtrl_io_dCacheRspIn_bits_dataResponse),
    .io_iCacheReqOut_ready(MemCtrl_io_iCacheReqOut_ready),
    .io_iCacheReqOut_valid(MemCtrl_io_iCacheReqOut_valid),
    .io_iCacheReqOut_bits_addrRequest(MemCtrl_io_iCacheReqOut_bits_addrRequest),
    .io_iCacheReqOut_bits_dataRequest(MemCtrl_io_iCacheReqOut_bits_dataRequest),
    .io_iCacheReqOut_bits_activeByteLane(MemCtrl_io_iCacheReqOut_bits_activeByteLane),
    .io_iCacheReqOut_bits_isWrite(MemCtrl_io_iCacheReqOut_bits_isWrite),
    .io_iCacheRspIn_valid(MemCtrl_io_iCacheRspIn_valid),
    .io_iCacheRspIn_bits_dataResponse(MemCtrl_io_iCacheRspIn_bits_dataResponse),
    .io_SPIctrl_rw(MemCtrl_io_SPIctrl_rw),
    .io_SPIctrl_en(MemCtrl_io_SPIctrl_en),
    .io_SPIctrl_addr(MemCtrl_io_SPIctrl_addr),
    .io_SPIctrl_dataIn(MemCtrl_io_SPIctrl_dataIn),
    .io_SPIctrl_dataOut(MemCtrl_io_SPIctrl_dataOut),
    .io_SPIctrl_done(MemCtrl_io_SPIctrl_done),
    .io_SPIctrl_size(MemCtrl_io_SPIctrl_size),
    .io_moduleSel_0(MemCtrl_io_moduleSel_0),
    .io_moduleSel_1(MemCtrl_io_moduleSel_1),
    .io_moduleSel_2(MemCtrl_io_moduleSel_2)
  );
  SpiControllerTop SpiCtrl ( // @[MemoryControllerTopPhysical.scala 45:23]
    .clock(SpiCtrl_clock),
    .reset(SpiCtrl_reset),
    .io_inSio(SpiCtrl_io_inSio),
    .io_outSio(SpiCtrl_io_outSio),
    .io_spiClk(SpiCtrl_io_spiClk),
    .io_CS0(SpiCtrl_io_CS0),
    .io_CS1(SpiCtrl_io_CS1),
    .io_CS2(SpiCtrl_io_CS2),
    .io_moduleSel_0(SpiCtrl_io_moduleSel_0),
    .io_moduleSel_1(SpiCtrl_io_moduleSel_1),
    .io_moduleSel_2(SpiCtrl_io_moduleSel_2),
    .io_SPIctrl_rw(SpiCtrl_io_SPIctrl_rw),
    .io_SPIctrl_en(SpiCtrl_io_SPIctrl_en),
    .io_SPIctrl_addr(SpiCtrl_io_SPIctrl_addr),
    .io_SPIctrl_dataIn(SpiCtrl_io_SPIctrl_dataIn),
    .io_SPIctrl_dataOut(SpiCtrl_io_SPIctrl_dataOut),
    .io_SPIctrl_done(SpiCtrl_io_SPIctrl_done),
    .io_SPIctrl_size(SpiCtrl_io_SPIctrl_size),
    .io_startup(SpiCtrl_io_startup),
    .io_dir(SpiCtrl_io_dir)
  );
  assign io_dCacheRspIn_valid = MemCtrl_io_dCacheRspIn_valid; // @[MemoryControllerTopPhysical.scala 41:18]
  assign io_dCacheRspIn_bits_dataResponse = MemCtrl_io_dCacheRspIn_bits_dataResponse; // @[MemoryControllerTopPhysical.scala 41:18]
  assign io_iCacheRspIn_valid = MemCtrl_io_iCacheRspIn_valid; // @[MemoryControllerTopPhysical.scala 43:18]
  assign io_iCacheRspIn_bits_dataResponse = MemCtrl_io_iCacheRspIn_bits_dataResponse; // @[MemoryControllerTopPhysical.scala 43:18]
  assign io_CS0 = SpiCtrl_io_CS0; // @[MemoryControllerTopPhysical.scala 53:10]
  assign io_CS1 = SpiCtrl_io_CS1; // @[MemoryControllerTopPhysical.scala 54:10]
  assign io_CS2 = SpiCtrl_io_CS2; // @[MemoryControllerTopPhysical.scala 55:10]
  assign io_dir = SpiCtrl_io_dir; // @[MemoryControllerTopPhysical.scala 57:10]
  assign io_outSio = SpiCtrl_io_outSio; // @[MemoryControllerTopPhysical.scala 59:13]
  assign io_spiClk = SpiCtrl_io_spiClk; // @[MemoryControllerTopPhysical.scala 56:13]
  assign MemCtrl_clock = clock;
  assign MemCtrl_reset = reset;
  assign MemCtrl_io_dCacheReqOut_valid = io_dCacheReqOut_valid; // @[MemoryControllerTopPhysical.scala 40:27]
  assign MemCtrl_io_dCacheReqOut_bits_addrRequest = io_dCacheReqOut_bits_addrRequest; // @[MemoryControllerTopPhysical.scala 40:27]
  assign MemCtrl_io_dCacheReqOut_bits_dataRequest = io_dCacheReqOut_bits_dataRequest; // @[MemoryControllerTopPhysical.scala 40:27]
  assign MemCtrl_io_dCacheReqOut_bits_activeByteLane = io_dCacheReqOut_bits_activeByteLane; // @[MemoryControllerTopPhysical.scala 40:27]
  assign MemCtrl_io_dCacheReqOut_bits_isWrite = io_dCacheReqOut_bits_isWrite; // @[MemoryControllerTopPhysical.scala 40:27]
  assign MemCtrl_io_iCacheReqOut_valid = io_iCacheReqOut_valid; // @[MemoryControllerTopPhysical.scala 42:27]
  assign MemCtrl_io_iCacheReqOut_bits_addrRequest = io_iCacheReqOut_bits_addrRequest; // @[MemoryControllerTopPhysical.scala 42:27]
  assign MemCtrl_io_iCacheReqOut_bits_dataRequest = io_iCacheReqOut_bits_dataRequest; // @[MemoryControllerTopPhysical.scala 42:27]
  assign MemCtrl_io_iCacheReqOut_bits_activeByteLane = io_iCacheReqOut_bits_activeByteLane; // @[MemoryControllerTopPhysical.scala 42:27]
  assign MemCtrl_io_iCacheReqOut_bits_isWrite = io_iCacheReqOut_bits_isWrite; // @[MemoryControllerTopPhysical.scala 42:27]
  assign MemCtrl_io_SPIctrl_dataOut = SpiCtrl_io_SPIctrl_dataOut; // @[MemoryControllerTopPhysical.scala 46:22]
  assign MemCtrl_io_SPIctrl_done = SpiCtrl_io_SPIctrl_done; // @[MemoryControllerTopPhysical.scala 46:22]
  assign SpiCtrl_clock = clock;
  assign SpiCtrl_reset = reset;
  assign SpiCtrl_io_inSio = io_inSio; // @[MemoryControllerTopPhysical.scala 58:20]
  assign SpiCtrl_io_moduleSel_0 = SpiCtrl_io_startup ? 1'h0 : MemCtrl_io_moduleSel_0; // @[MemoryControllerTopPhysical.scala 47:24 49:27 50:26]
  assign SpiCtrl_io_moduleSel_1 = SpiCtrl_io_startup | MemCtrl_io_moduleSel_1; // @[MemoryControllerTopPhysical.scala 47:24 49:27 50:26]
  assign SpiCtrl_io_moduleSel_2 = SpiCtrl_io_startup | MemCtrl_io_moduleSel_2; // @[MemoryControllerTopPhysical.scala 47:24 49:27 50:26]
  assign SpiCtrl_io_SPIctrl_rw = MemCtrl_io_SPIctrl_rw; // @[MemoryControllerTopPhysical.scala 46:22]
  assign SpiCtrl_io_SPIctrl_en = MemCtrl_io_SPIctrl_en; // @[MemoryControllerTopPhysical.scala 46:22]
  assign SpiCtrl_io_SPIctrl_addr = MemCtrl_io_SPIctrl_addr; // @[MemoryControllerTopPhysical.scala 46:22]
  assign SpiCtrl_io_SPIctrl_dataIn = MemCtrl_io_SPIctrl_dataIn; // @[MemoryControllerTopPhysical.scala 46:22]
  assign SpiCtrl_io_SPIctrl_size = MemCtrl_io_SPIctrl_size; // @[MemoryControllerTopPhysical.scala 46:22]
endmodule
module Tx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] shiftReg; // @[Uart.scala 30:25]
  reg [19:0] cntReg; // @[Uart.scala 31:23]
  reg [3:0] bitsReg; // @[Uart.scala 32:24]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[Uart.scala 34:31]
  wire [9:0] shift = shiftReg[10:1]; // @[Uart.scala 41:28]
  wire [10:0] _shiftReg_T_1 = {1'h1,shift}; // @[Cat.scala 33:92]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[Uart.scala 43:26]
  wire [10:0] _shiftReg_T_3 = {2'h3,io_channel_bits,1'h0}; // @[Cat.scala 33:92]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[Uart.scala 54:22]
  assign io_txd = shiftReg[0]; // @[Uart.scala 35:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[Uart.scala 34:40]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 30:25]
      shiftReg <= 11'h7ff; // @[Uart.scala 30:25]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 37:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 40:27]
        shiftReg <= _shiftReg_T_1; // @[Uart.scala 42:16]
      end else if (io_channel_valid) begin // @[Uart.scala 45:30]
        shiftReg <= _shiftReg_T_3; // @[Uart.scala 46:18]
      end else begin
        shiftReg <= 11'h7ff; // @[Uart.scala 49:18]
      end
    end
    if (reset) begin // @[Uart.scala 31:23]
      cntReg <= 20'h0; // @[Uart.scala 31:23]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 37:24]
      cntReg <= 20'h208; // @[Uart.scala 39:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[Uart.scala 54:12]
    end
    if (reset) begin // @[Uart.scala 32:24]
      bitsReg <= 4'h0; // @[Uart.scala 32:24]
    end else if (_io_channel_ready_T) begin // @[Uart.scala 37:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 40:27]
        bitsReg <= _bitsReg_T_1; // @[Uart.scala 43:15]
      end else if (io_channel_valid) begin // @[Uart.scala 45:30]
        bitsReg <= 4'hb; // @[Uart.scala 47:17]
      end
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
  shiftReg = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Buffer(
  input        clock,
  input        reset,
  output       io_in_ready,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  input        io_out_ready,
  output       io_out_valid,
  output [7:0] io_out_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[Uart.scala 117:25]
  reg [7:0] dataReg; // @[Uart.scala 118:24]
  wire  _io_in_ready_T = ~stateReg; // @[Uart.scala 120:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[Uart.scala 124:23 126:16 117:25]
  assign io_in_ready = ~stateReg; // @[Uart.scala 120:27]
  assign io_out_valid = stateReg; // @[Uart.scala 121:28]
  assign io_out_bits = dataReg; // @[Uart.scala 133:15]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 117:25]
      stateReg <= 1'h0; // @[Uart.scala 117:25]
    end else if (_io_in_ready_T) begin // @[Uart.scala 123:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[Uart.scala 129:24]
      stateReg <= 1'h0; // @[Uart.scala 130:16]
    end
    if (reset) begin // @[Uart.scala 118:24]
      dataReg <= 8'h0; // @[Uart.scala 118:24]
    end else if (_io_in_ready_T) begin // @[Uart.scala 123:28]
      if (io_in_valid) begin // @[Uart.scala 124:23]
        dataReg <= io_in_bits; // @[Uart.scala 125:15]
      end
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
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BufferedTx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
  wire  tx_clock; // @[Uart.scala 144:18]
  wire  tx_reset; // @[Uart.scala 144:18]
  wire  tx_io_txd; // @[Uart.scala 144:18]
  wire  tx_io_channel_ready; // @[Uart.scala 144:18]
  wire  tx_io_channel_valid; // @[Uart.scala 144:18]
  wire [7:0] tx_io_channel_bits; // @[Uart.scala 144:18]
  wire  buf__clock; // @[Uart.scala 145:19]
  wire  buf__reset; // @[Uart.scala 145:19]
  wire  buf__io_in_ready; // @[Uart.scala 145:19]
  wire  buf__io_in_valid; // @[Uart.scala 145:19]
  wire [7:0] buf__io_in_bits; // @[Uart.scala 145:19]
  wire  buf__io_out_ready; // @[Uart.scala 145:19]
  wire  buf__io_out_valid; // @[Uart.scala 145:19]
  wire [7:0] buf__io_out_bits; // @[Uart.scala 145:19]
  Tx tx ( // @[Uart.scala 144:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf_ ( // @[Uart.scala 145:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[Uart.scala 149:10]
  assign io_channel_ready = buf__io_in_ready; // @[Uart.scala 147:13]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[Uart.scala 148:17]
  assign tx_io_channel_bits = buf__io_out_bits; // @[Uart.scala 148:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_channel_valid; // @[Uart.scala 147:13]
  assign buf__io_in_bits = io_channel_bits; // @[Uart.scala 147:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[Uart.scala 148:17]
endmodule
module Rx(
  input        clock,
  input        reset,
  input        io_rxd,
  input        io_channel_ready,
  output       io_channel_valid,
  output [7:0] io_channel_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  reg  rxReg_REG; // @[Uart.scala 76:30]
  reg  rxReg; // @[Uart.scala 76:22]
  reg  falling_REG; // @[Uart.scala 77:35]
  wire  falling = ~rxReg & falling_REG; // @[Uart.scala 77:24]
  reg [7:0] shiftReg; // @[Uart.scala 79:25]
  reg [19:0] cntReg; // @[Uart.scala 80:23]
  reg [3:0] bitsReg; // @[Uart.scala 81:24]
  reg  valReg; // @[Uart.scala 82:23]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[Uart.scala 85:22]
  wire [7:0] _shiftReg_T_1 = {rxReg,shiftReg[7:1]}; // @[Cat.scala 33:92]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[Uart.scala 89:24]
  wire  _GEN_0 = bitsReg == 4'h1 | valReg; // @[Uart.scala 91:27 92:14 82:23]
  assign io_channel_valid = valReg; // @[Uart.scala 104:20]
  assign io_channel_bits = shiftReg; // @[Uart.scala 103:19]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 76:30]
      rxReg_REG <= 1'h0; // @[Uart.scala 76:30]
    end else begin
      rxReg_REG <= io_rxd; // @[Uart.scala 76:30]
    end
    if (reset) begin // @[Uart.scala 76:22]
      rxReg <= 1'h0; // @[Uart.scala 76:22]
    end else begin
      rxReg <= rxReg_REG; // @[Uart.scala 76:22]
    end
    falling_REG <= rxReg; // @[Uart.scala 77:35]
    if (reset) begin // @[Uart.scala 79:25]
      shiftReg <= 8'h0; // @[Uart.scala 79:25]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 84:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 86:31]
        shiftReg <= _shiftReg_T_1; // @[Uart.scala 88:14]
      end
    end
    if (reset) begin // @[Uart.scala 80:23]
      cntReg <= 20'h208; // @[Uart.scala 80:23]
    end else if (cntReg != 20'h0) begin // @[Uart.scala 84:24]
      cntReg <= _cntReg_T_1; // @[Uart.scala 85:12]
    end else if (bitsReg != 4'h0) begin // @[Uart.scala 86:31]
      cntReg <= 20'h208; // @[Uart.scala 87:12]
    end else if (falling) begin // @[Uart.scala 94:23]
      cntReg <= 20'h30b; // @[Uart.scala 95:12]
    end
    if (reset) begin // @[Uart.scala 81:24]
      bitsReg <= 4'h0; // @[Uart.scala 81:24]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 84:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 86:31]
        bitsReg <= _bitsReg_T_1; // @[Uart.scala 89:13]
      end else if (falling) begin // @[Uart.scala 94:23]
        bitsReg <= 4'h8; // @[Uart.scala 96:13]
      end
    end
    if (reset) begin // @[Uart.scala 82:23]
      valReg <= 1'h0; // @[Uart.scala 82:23]
    end else if (valReg & io_channel_ready) begin // @[Uart.scala 99:36]
      valReg <= 1'h0; // @[Uart.scala 100:12]
    end else if (!(cntReg != 20'h0)) begin // @[Uart.scala 84:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 86:31]
        valReg <= _GEN_0;
      end
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
  rxReg_REG = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  rxReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  falling_REG = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  shiftReg = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  cntReg = _RAND_4[19:0];
  _RAND_5 = {1{`RANDOM}};
  bitsReg = _RAND_5[3:0];
  _RAND_6 = {1{`RANDOM}};
  valReg = _RAND_6[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CLINT(
  input         clock,
  input         reset,
  input         io_link_enable,
  input         io_link_isWrite,
  input  [31:0] io_link_address,
  input  [31:0] io_link_wrData,
  output [31:0] io_link_rdData,
  input  [63:0] io_currentTimeIn,
  output [63:0] io_mtimecmpValueOut
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] mtimecmpReg; // @[CLINT.scala 40:28]
  reg [31:0] tempMtimecmpHigh; // @[CLINT.scala 47:29]
  reg  highWordWritten; // @[CLINT.scala 48:32]
  wire  _isMtimecmpAccess_T = io_link_address == 32'hf0104000; // @[CLINT.scala 51:35]
  wire  _isMtimecmpAccess_T_1 = io_link_address == 32'hf0104004; // @[CLINT.scala 51:86]
  wire  isMtimecmpAccess = io_link_address == 32'hf0104000 | io_link_address == 32'hf0104004; // @[CLINT.scala 51:74]
  wire  _isMtimeAccess_T = io_link_address == 32'hf010bff8; // @[CLINT.scala 52:35]
  wire  _isMtimeAccess_T_1 = io_link_address == 32'hf010bffc; // @[CLINT.scala 52:77]
  wire  isMtimeAccess = io_link_address == 32'hf010bff8 | io_link_address == 32'hf010bffc; // @[CLINT.scala 52:65]
  wire  isLowWordAccess = _isMtimecmpAccess_T | _isMtimeAccess_T; // @[CLINT.scala 53:74]
  wire  isHighWordAccess = _isMtimecmpAccess_T_1 | _isMtimeAccess_T_1; // @[CLINT.scala 54:74]
  wire  _T = io_link_enable & io_link_isWrite; // @[CLINT.scala 58:23]
  wire  _T_2 = ~reset; // @[CLINT.scala 65:15]
  wire [63:0] _mtimecmpReg_T = {tempMtimecmpHigh,io_link_wrData}; // @[Cat.scala 33:92]
  wire [63:0] _mtimecmpReg_T_2 = {mtimecmpReg[63:32],io_link_wrData}; // @[Cat.scala 33:92]
  wire [63:0] _GEN_0 = highWordWritten ? _mtimecmpReg_T : _mtimecmpReg_T_2; // @[CLINT.scala 69:31 70:23 77:23]
  wire  _GEN_1 = highWordWritten ? 1'h0 : highWordWritten; // @[CLINT.scala 69:31 71:27 48:32]
  wire [63:0] _GEN_2 = isLowWordAccess ? _GEN_0 : mtimecmpReg; // @[CLINT.scala 40:28 66:35]
  wire  _GEN_3 = isLowWordAccess ? _GEN_1 : highWordWritten; // @[CLINT.scala 48:32 66:35]
  wire  _GEN_5 = isHighWordAccess | _GEN_3; // @[CLINT.scala 61:30 64:25]
  wire [31:0] _rdDataWire_T_2 = isLowWordAccess ? mtimecmpReg[31:0] : mtimecmpReg[63:32]; // @[CLINT.scala 96:24]
  wire [31:0] _rdDataWire_T_5 = isLowWordAccess ? io_currentTimeIn[31:0] : io_currentTimeIn[63:32]; // @[CLINT.scala 99:24]
  wire [31:0] _GEN_13 = isMtimeAccess ? _rdDataWire_T_5 : 32'h0; // @[CLINT.scala 104:18 98:31 99:18]
  wire [31:0] _GEN_14 = isMtimecmpAccess ? _rdDataWire_T_2 : _GEN_13; // @[CLINT.scala 95:28 96:18]
  wire  _GEN_16 = _T & isMtimecmpAccess; // @[CLINT.scala 65:15]
  wire  _GEN_21 = _GEN_16 & ~isHighWordAccess & isLowWordAccess; // @[CLINT.scala 72:17]
  assign io_link_rdData = io_link_enable & ~io_link_isWrite ? _GEN_14 : 32'h0; // @[CLINT.scala 43:31 94:44]
  assign io_mtimecmpValueOut = mtimecmpReg; // @[CLINT.scala 110:23]
  always @(posedge clock) begin
    if (reset) begin // @[CLINT.scala 40:28]
      mtimecmpReg <= 64'h0; // @[CLINT.scala 40:28]
    end else if (io_link_enable & io_link_isWrite) begin // @[CLINT.scala 58:43]
      if (isMtimecmpAccess) begin // @[CLINT.scala 59:28]
        if (!(isHighWordAccess)) begin // @[CLINT.scala 61:30]
          mtimecmpReg <= _GEN_2;
        end
      end
    end
    if (io_link_enable & io_link_isWrite) begin // @[CLINT.scala 58:43]
      if (isMtimecmpAccess) begin // @[CLINT.scala 59:28]
        if (isHighWordAccess) begin // @[CLINT.scala 61:30]
          tempMtimecmpHigh <= io_link_wrData; // @[CLINT.scala 63:26]
        end
      end
    end
    if (reset) begin // @[CLINT.scala 48:32]
      highWordWritten <= 1'h0; // @[CLINT.scala 48:32]
    end else if (io_link_enable & io_link_isWrite) begin // @[CLINT.scala 58:43]
      if (isMtimecmpAccess) begin // @[CLINT.scala 59:28]
        highWordWritten <= _GEN_5;
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T & isMtimecmpAccess & isHighWordAccess & ~reset) begin
          $fwrite(32'h80000002,"[CLINT] Write mtimecmp_H (staged): Addr=0x%x, Data=0x%x\n",io_link_address,
            io_link_wrData); // @[CLINT.scala 65:15]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_16 & ~isHighWordAccess & isLowWordAccess & highWordWritten & _T_2) begin
          $fwrite(32'h80000002,"[CLINT] Write mtimecmp_L (commit): Addr=0x%x, Data=0x%x, Full=0x%x\n",io_link_address,
            io_link_wrData,_mtimecmpReg_T); // @[CLINT.scala 72:17]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_21 & ~highWordWritten & _T_2) begin
          $fwrite(32'h80000002,"[CLINT] Write mtimecmp_L (low only): Addr=0x%x, Data=0x%x\n",io_link_address,
            io_link_wrData); // @[CLINT.scala 78:17]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
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
  _RAND_0 = {2{`RANDOM}};
  mtimecmpReg = _RAND_0[63:0];
  _RAND_1 = {1{`RANDOM}};
  tempMtimecmpHigh = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  highWordWritten = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BootBuffer(
  input         clock,
  input         reset,
  input         io_saveCtrl,
  input  [7:0]  io_dataIn,
  output [63:0] io_dataOut
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] buffer; // @[BootBuffer.scala 21:23]
  wire [63:0] _buffer_T_1 = {io_dataIn,buffer[63:8]}; // @[BootBuffer.scala 25:25]
  assign io_dataOut = buffer; // @[BootBuffer.scala 27:14]
  always @(posedge clock) begin
    if (reset) begin // @[BootBuffer.scala 21:23]
      buffer <= 64'h0; // @[BootBuffer.scala 21:23]
    end else if (io_saveCtrl) begin // @[BootBuffer.scala 23:28]
      buffer <= _buffer_T_1; // @[BootBuffer.scala 25:12]
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
  _RAND_0 = {2{`RANDOM}};
  buffer = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Bootloader(
  input         clock,
  input         reset,
  output [31:0] io_instrData,
  output [31:0] io_instrAddr,
  output        io_wrEnabled,
  input         io_rx,
  input         io_sleep
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire  rx_clock; // @[Bootloader.scala 26:18]
  wire  rx_reset; // @[Bootloader.scala 26:18]
  wire  rx_io_rxd; // @[Bootloader.scala 26:18]
  wire  rx_io_channel_ready; // @[Bootloader.scala 26:18]
  wire  rx_io_channel_valid; // @[Bootloader.scala 26:18]
  wire [7:0] rx_io_channel_bits; // @[Bootloader.scala 26:18]
  wire  buffer_clock; // @[Bootloader.scala 27:22]
  wire  buffer_reset; // @[Bootloader.scala 27:22]
  wire  buffer_io_saveCtrl; // @[Bootloader.scala 27:22]
  wire [7:0] buffer_io_dataIn; // @[Bootloader.scala 27:22]
  wire [63:0] buffer_io_dataOut; // @[Bootloader.scala 27:22]
  reg  stateReg; // @[Bootloader.scala 33:25]
  reg  incr; // @[Bootloader.scala 35:21]
  reg  save; // @[Bootloader.scala 36:21]
  reg  wrEnabled; // @[Bootloader.scala 37:26]
  reg [3:0] byteCount; // @[Bootloader.scala 38:26]
  wire [3:0] _byteCount_T_1 = byteCount + 4'h1; // @[Bootloader.scala 41:28]
  wire [3:0] _GEN_0 = incr ? _byteCount_T_1 : byteCount; // @[Bootloader.scala 40:21 41:15 38:26]
  wire  _T_8 = byteCount == 4'h8; // @[Bootloader.scala 66:27]
  wire  _GEN_4 = rx_io_channel_valid; // @[Bootloader.scala 70:39 71:13 50:8]
  wire [3:0] _GEN_7 = byteCount == 4'h8 ? 4'h0 : _GEN_0; // @[Bootloader.scala 66:36 68:18]
  wire  _GEN_9 = byteCount == 4'h8 ? 1'h0 : _GEN_4; // @[Bootloader.scala 66:36 50:8]
  wire  _GEN_11 = io_sleep ? 1'h0 : _T_8; // @[Bootloader.scala 52:13 64:21]
  wire  _GEN_13 = io_sleep ? 1'h0 : _GEN_9; // @[Bootloader.scala 64:21 50:8]
  Rx rx ( // @[Bootloader.scala 26:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  BootBuffer buffer ( // @[Bootloader.scala 27:22]
    .clock(buffer_clock),
    .reset(buffer_reset),
    .io_saveCtrl(buffer_io_saveCtrl),
    .io_dataIn(buffer_io_dataIn),
    .io_dataOut(buffer_io_dataOut)
  );
  assign io_instrData = buffer_io_dataOut[63:32]; // @[Bootloader.scala 83:36]
  assign io_instrAddr = buffer_io_dataOut[31:0]; // @[Bootloader.scala 84:36]
  assign io_wrEnabled = wrEnabled; // @[Bootloader.scala 82:16]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rx; // @[Bootloader.scala 85:13]
  assign rx_io_channel_ready = stateReg ? 1'h0 : ~stateReg & _GEN_13; // @[Bootloader.scala 55:19 50:8]
  assign buffer_clock = clock;
  assign buffer_reset = reset;
  assign buffer_io_saveCtrl = save; // @[Bootloader.scala 45:22]
  assign buffer_io_dataIn = rx_io_channel_bits; // @[Bootloader.scala 46:20]
  always @(posedge clock) begin
    if (reset) begin // @[Bootloader.scala 33:25]
      stateReg <= 1'h0; // @[Bootloader.scala 33:25]
    end else if (stateReg) begin // @[Bootloader.scala 55:19]
      if (~io_sleep) begin // @[Bootloader.scala 57:22]
        stateReg <= 1'h0; // @[Bootloader.scala 58:18]
      end else begin
        stateReg <= 1'h1;
      end
    end else if (~stateReg) begin // @[Bootloader.scala 55:19]
      stateReg <= io_sleep;
    end
    if (reset) begin // @[Bootloader.scala 35:21]
      incr <= 1'h0; // @[Bootloader.scala 35:21]
    end else if (stateReg) begin // @[Bootloader.scala 55:19]
      incr <= 1'h0; // @[Bootloader.scala 50:8]
    end else begin
      incr <= ~stateReg & _GEN_13;
    end
    if (reset) begin // @[Bootloader.scala 36:21]
      save <= 1'h0; // @[Bootloader.scala 36:21]
    end else if (stateReg) begin // @[Bootloader.scala 55:19]
      save <= 1'h0; // @[Bootloader.scala 50:8]
    end else begin
      save <= ~stateReg & _GEN_13;
    end
    if (reset) begin // @[Bootloader.scala 37:26]
      wrEnabled <= 1'h0; // @[Bootloader.scala 37:26]
    end else if (stateReg) begin // @[Bootloader.scala 55:19]
      wrEnabled <= 1'h0; // @[Bootloader.scala 52:13]
    end else begin
      wrEnabled <= ~stateReg & _GEN_11;
    end
    if (reset) begin // @[Bootloader.scala 38:26]
      byteCount <= 4'h0; // @[Bootloader.scala 38:26]
    end else if (stateReg) begin // @[Bootloader.scala 55:19]
      byteCount <= _GEN_0;
    end else if (~stateReg) begin // @[Bootloader.scala 55:19]
      if (io_sleep) begin // @[Bootloader.scala 64:21]
        byteCount <= _GEN_0;
      end else begin
        byteCount <= _GEN_7;
      end
    end else begin
      byteCount <= _GEN_0;
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
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  incr = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  save = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  wrEnabled = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  byteCount = _RAND_4[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module WildcatTopPhysical(
  input         clock,
  input         reset,
  output [15:0] io_led,
  output        io_tx,
  input         io_rx,
  output        io_CS0,
  output        io_CS1,
  output        io_CS2,
  output        io_dir,
  input  [3:0]  io_inSio,
  output [3:0]  io_outSio,
  output        io_spiClk
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  wire  cpu_clock; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_reset; // @[WildcatTopPhysical.scala 41:19]
  wire [31:0] cpu_io_imem_address; // @[WildcatTopPhysical.scala 41:19]
  wire [31:0] cpu_io_imem_data; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_io_imem_stall; // @[WildcatTopPhysical.scala 41:19]
  wire [31:0] cpu_io_dmem_rdAddress; // @[WildcatTopPhysical.scala 41:19]
  wire [31:0] cpu_io_dmem_rdData; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_io_dmem_rdEnable; // @[WildcatTopPhysical.scala 41:19]
  wire [31:0] cpu_io_dmem_wrAddress; // @[WildcatTopPhysical.scala 41:19]
  wire [31:0] cpu_io_dmem_wrData; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_io_dmem_wrEnable_0; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_io_dmem_wrEnable_1; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_io_dmem_wrEnable_2; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_io_dmem_wrEnable_3; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_io_dmem_stall; // @[WildcatTopPhysical.scala 41:19]
  wire [63:0] cpu_io_mtimecmpVal_in; // @[WildcatTopPhysical.scala 41:19]
  wire [63:0] cpu_io_timerCounter_out; // @[WildcatTopPhysical.scala 41:19]
  wire  cpu_io_Bootloader_Stall; // @[WildcatTopPhysical.scala 41:19]
  wire  bus_clock; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_reset; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_CPUdCacheMemIO_rdAddress; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_CPUdCacheMemIO_rdData; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_CPUdCacheMemIO_rdEnable; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_CPUdCacheMemIO_wrAddress; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_CPUdCacheMemIO_wrData; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_CPUdCacheMemIO_wrEnable_0; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_CPUdCacheMemIO_wrEnable_1; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_CPUdCacheMemIO_wrEnable_2; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_CPUdCacheMemIO_wrEnable_3; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_CPUdCacheMemIO_stall; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_CPUiCacheMemIO_rdAddress; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_CPUiCacheMemIO_rdData; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_CPUiCacheMemIO_rdEnable; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_CPUiCacheMemIO_stall; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_dCacheReqOut_valid; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_dCacheReqOut_bits_addrRequest; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_dCacheReqOut_bits_dataRequest; // @[WildcatTopPhysical.scala 47:19]
  wire [3:0] bus_io_dCacheReqOut_bits_activeByteLane; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_dCacheReqOut_bits_isWrite; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_dCacheRspIn_valid; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_dCacheRspIn_bits_dataResponse; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_iCacheReqOut_valid; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_iCacheReqOut_bits_addrRequest; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_iCacheReqOut_bits_dataRequest; // @[WildcatTopPhysical.scala 47:19]
  wire [3:0] bus_io_iCacheReqOut_bits_activeByteLane; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_iCacheReqOut_bits_isWrite; // @[WildcatTopPhysical.scala 47:19]
  wire  bus_io_iCacheRspIn_valid; // @[WildcatTopPhysical.scala 47:19]
  wire [31:0] bus_io_iCacheRspIn_bits_dataResponse; // @[WildcatTopPhysical.scala 47:19]
  wire  MCU_clock; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_reset; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_dCacheReqOut_valid; // @[WildcatTopPhysical.scala 48:19]
  wire [31:0] MCU_io_dCacheReqOut_bits_addrRequest; // @[WildcatTopPhysical.scala 48:19]
  wire [31:0] MCU_io_dCacheReqOut_bits_dataRequest; // @[WildcatTopPhysical.scala 48:19]
  wire [3:0] MCU_io_dCacheReqOut_bits_activeByteLane; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_dCacheReqOut_bits_isWrite; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_dCacheRspIn_valid; // @[WildcatTopPhysical.scala 48:19]
  wire [31:0] MCU_io_dCacheRspIn_bits_dataResponse; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_iCacheReqOut_valid; // @[WildcatTopPhysical.scala 48:19]
  wire [31:0] MCU_io_iCacheReqOut_bits_addrRequest; // @[WildcatTopPhysical.scala 48:19]
  wire [31:0] MCU_io_iCacheReqOut_bits_dataRequest; // @[WildcatTopPhysical.scala 48:19]
  wire [3:0] MCU_io_iCacheReqOut_bits_activeByteLane; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_iCacheReqOut_bits_isWrite; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_iCacheRspIn_valid; // @[WildcatTopPhysical.scala 48:19]
  wire [31:0] MCU_io_iCacheRspIn_bits_dataResponse; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_CS0; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_CS1; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_CS2; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_dir; // @[WildcatTopPhysical.scala 48:19]
  wire [3:0] MCU_io_inSio; // @[WildcatTopPhysical.scala 48:19]
  wire [3:0] MCU_io_outSio; // @[WildcatTopPhysical.scala 48:19]
  wire  MCU_io_spiClk; // @[WildcatTopPhysical.scala 48:19]
  wire  tx_clock; // @[WildcatTopPhysical.scala 89:18]
  wire  tx_reset; // @[WildcatTopPhysical.scala 89:18]
  wire  tx_io_txd; // @[WildcatTopPhysical.scala 89:18]
  wire  tx_io_channel_ready; // @[WildcatTopPhysical.scala 89:18]
  wire  tx_io_channel_valid; // @[WildcatTopPhysical.scala 89:18]
  wire [7:0] tx_io_channel_bits; // @[WildcatTopPhysical.scala 89:18]
  wire  rx_clock; // @[WildcatTopPhysical.scala 90:18]
  wire  rx_reset; // @[WildcatTopPhysical.scala 90:18]
  wire  rx_io_rxd; // @[WildcatTopPhysical.scala 90:18]
  wire  rx_io_channel_ready; // @[WildcatTopPhysical.scala 90:18]
  wire  rx_io_channel_valid; // @[WildcatTopPhysical.scala 90:18]
  wire [7:0] rx_io_channel_bits; // @[WildcatTopPhysical.scala 90:18]
  wire  clint_clock; // @[WildcatTopPhysical.scala 107:21]
  wire  clint_reset; // @[WildcatTopPhysical.scala 107:21]
  wire  clint_io_link_enable; // @[WildcatTopPhysical.scala 107:21]
  wire  clint_io_link_isWrite; // @[WildcatTopPhysical.scala 107:21]
  wire [31:0] clint_io_link_address; // @[WildcatTopPhysical.scala 107:21]
  wire [31:0] clint_io_link_wrData; // @[WildcatTopPhysical.scala 107:21]
  wire [31:0] clint_io_link_rdData; // @[WildcatTopPhysical.scala 107:21]
  wire [63:0] clint_io_currentTimeIn; // @[WildcatTopPhysical.scala 107:21]
  wire [63:0] clint_io_mtimecmpValueOut; // @[WildcatTopPhysical.scala 107:21]
  wire  BL_clock; // @[WildcatTopPhysical.scala 127:18]
  wire  BL_reset; // @[WildcatTopPhysical.scala 127:18]
  wire [31:0] BL_io_instrData; // @[WildcatTopPhysical.scala 127:18]
  wire [31:0] BL_io_instrAddr; // @[WildcatTopPhysical.scala 127:18]
  wire  BL_io_wrEnabled; // @[WildcatTopPhysical.scala 127:18]
  wire  BL_io_rx; // @[WildcatTopPhysical.scala 127:18]
  wire  BL_io_sleep; // @[WildcatTopPhysical.scala 127:18]
  reg [7:0] ledReg; // @[WildcatTopPhysical.scala 84:23]
  reg [1:0] uartStatusReg; // @[WildcatTopPhysical.scala 101:30]
  reg [7:0] bootloaderStatusReg; // @[WildcatTopPhysical.scala 102:36]
  reg [31:0] memAddressReg; // @[WildcatTopPhysical.scala 103:30]
  reg [31:0] writeAddressReg; // @[WildcatTopPhysical.scala 104:32]
  wire  _isClintAccess_T_1 = memAddressReg < 32'hf010c000; // @[WildcatTopPhysical.scala 109:20]
  reg  isClintAccess; // @[WildcatTopPhysical.scala 108:30]
  wire [3:0] _isClintWrite_T = {cpu_io_dmem_wrEnable_3,cpu_io_dmem_wrEnable_2,cpu_io_dmem_wrEnable_1,
    cpu_io_dmem_wrEnable_0}; // @[WildcatTopPhysical.scala 110:51]
  wire  _isClintWrite_T_2 = writeAddressReg >= 32'hf0100000; // @[WildcatTopPhysical.scala 111:22]
  wire  _isClintWrite_T_3 = |_isClintWrite_T & _isClintWrite_T_2; // @[WildcatTopPhysical.scala 110:62]
  wire  _isClintWrite_T_4 = writeAddressReg < 32'hf010c000; // @[WildcatTopPhysical.scala 112:22]
  reg  isClintWrite; // @[WildcatTopPhysical.scala 110:29]
  reg [31:0] clintWriteDataReg; // @[WildcatTopPhysical.scala 113:34]
  wire  BL_Stall = ~bootloaderStatusReg[0]; // @[WildcatTopPhysical.scala 128:18]
  wire [7:0] _GEN_0 = memAddressReg == 32'hf1000000 ? bootloaderStatusReg : 8'h0; // @[WildcatTopPhysical.scala 150:50 151:26 153:26]
  wire [7:0] _GEN_1 = memAddressReg == 32'hf0100000 ? ledReg : _GEN_0; // @[WildcatTopPhysical.scala 148:50 149:26]
  wire [7:0] _GEN_2 = memAddressReg == 32'hf0000004 ? rx_io_channel_bits : _GEN_1; // @[WildcatTopPhysical.scala 145:50 146:26]
  wire  _GEN_3 = memAddressReg == 32'hf0000004 & cpu_io_dmem_rdEnable; // @[WildcatTopPhysical.scala 145:50 147:27 96:23]
  wire [7:0] _GEN_4 = memAddressReg == 32'hf0000000 ? {{6'd0}, uartStatusReg} : _GEN_2; // @[WildcatTopPhysical.scala 143:50 144:26]
  wire  _GEN_5 = memAddressReg == 32'hf0000000 ? 1'h0 : _GEN_3; // @[WildcatTopPhysical.scala 143:50 96:23]
  wire [31:0] _GEN_6 = isClintAccess ? clint_io_link_rdData : {{24'd0}, _GEN_4}; // @[WildcatTopPhysical.scala 140:25 142:26]
  wire  _GEN_7 = isClintAccess ? 1'h0 : _GEN_5; // @[WildcatTopPhysical.scala 140:25 96:23]
  wire  _T_11 = cpu_io_dmem_wrAddress == 32'hf0000004; // @[WildcatTopPhysical.scala 161:40]
  wire [7:0] _GEN_10 = cpu_io_dmem_wrAddress == 32'hf1000000 ? cpu_io_dmem_wrData[7:0] : bootloaderStatusReg; // @[WildcatTopPhysical.scala 165:60 166:27 102:36]
  wire [7:0] _GEN_11 = cpu_io_dmem_wrAddress == 32'hf0100000 ? cpu_io_dmem_wrData[7:0] : ledReg; // @[WildcatTopPhysical.scala 163:60 164:14 84:23]
  wire [7:0] _GEN_12 = cpu_io_dmem_wrAddress == 32'hf0100000 ? bootloaderStatusReg : _GEN_10; // @[WildcatTopPhysical.scala 102:36 163:60]
  wire  _GEN_16 = isClintWrite ? 1'h0 : _T_11; // @[WildcatTopPhysical.scala 159:25 95:23]
  reg [7:0] io_led_REG; // @[WildcatTopPhysical.scala 172:39]
  ThreeCats cpu ( // @[WildcatTopPhysical.scala 41:19]
    .clock(cpu_clock),
    .reset(cpu_reset),
    .io_imem_address(cpu_io_imem_address),
    .io_imem_data(cpu_io_imem_data),
    .io_imem_stall(cpu_io_imem_stall),
    .io_dmem_rdAddress(cpu_io_dmem_rdAddress),
    .io_dmem_rdData(cpu_io_dmem_rdData),
    .io_dmem_rdEnable(cpu_io_dmem_rdEnable),
    .io_dmem_wrAddress(cpu_io_dmem_wrAddress),
    .io_dmem_wrData(cpu_io_dmem_wrData),
    .io_dmem_wrEnable_0(cpu_io_dmem_wrEnable_0),
    .io_dmem_wrEnable_1(cpu_io_dmem_wrEnable_1),
    .io_dmem_wrEnable_2(cpu_io_dmem_wrEnable_2),
    .io_dmem_wrEnable_3(cpu_io_dmem_wrEnable_3),
    .io_dmem_stall(cpu_io_dmem_stall),
    .io_mtimecmpVal_in(cpu_io_mtimecmpVal_in),
    .io_timerCounter_out(cpu_io_timerCounter_out),
    .io_Bootloader_Stall(cpu_io_Bootloader_Stall)
  );
  BusInterconnect bus ( // @[WildcatTopPhysical.scala 47:19]
    .clock(bus_clock),
    .reset(bus_reset),
    .io_CPUdCacheMemIO_rdAddress(bus_io_CPUdCacheMemIO_rdAddress),
    .io_CPUdCacheMemIO_rdData(bus_io_CPUdCacheMemIO_rdData),
    .io_CPUdCacheMemIO_rdEnable(bus_io_CPUdCacheMemIO_rdEnable),
    .io_CPUdCacheMemIO_wrAddress(bus_io_CPUdCacheMemIO_wrAddress),
    .io_CPUdCacheMemIO_wrData(bus_io_CPUdCacheMemIO_wrData),
    .io_CPUdCacheMemIO_wrEnable_0(bus_io_CPUdCacheMemIO_wrEnable_0),
    .io_CPUdCacheMemIO_wrEnable_1(bus_io_CPUdCacheMemIO_wrEnable_1),
    .io_CPUdCacheMemIO_wrEnable_2(bus_io_CPUdCacheMemIO_wrEnable_2),
    .io_CPUdCacheMemIO_wrEnable_3(bus_io_CPUdCacheMemIO_wrEnable_3),
    .io_CPUdCacheMemIO_stall(bus_io_CPUdCacheMemIO_stall),
    .io_CPUiCacheMemIO_rdAddress(bus_io_CPUiCacheMemIO_rdAddress),
    .io_CPUiCacheMemIO_rdData(bus_io_CPUiCacheMemIO_rdData),
    .io_CPUiCacheMemIO_rdEnable(bus_io_CPUiCacheMemIO_rdEnable),
    .io_CPUiCacheMemIO_stall(bus_io_CPUiCacheMemIO_stall),
    .io_dCacheReqOut_valid(bus_io_dCacheReqOut_valid),
    .io_dCacheReqOut_bits_addrRequest(bus_io_dCacheReqOut_bits_addrRequest),
    .io_dCacheReqOut_bits_dataRequest(bus_io_dCacheReqOut_bits_dataRequest),
    .io_dCacheReqOut_bits_activeByteLane(bus_io_dCacheReqOut_bits_activeByteLane),
    .io_dCacheReqOut_bits_isWrite(bus_io_dCacheReqOut_bits_isWrite),
    .io_dCacheRspIn_valid(bus_io_dCacheRspIn_valid),
    .io_dCacheRspIn_bits_dataResponse(bus_io_dCacheRspIn_bits_dataResponse),
    .io_iCacheReqOut_valid(bus_io_iCacheReqOut_valid),
    .io_iCacheReqOut_bits_addrRequest(bus_io_iCacheReqOut_bits_addrRequest),
    .io_iCacheReqOut_bits_dataRequest(bus_io_iCacheReqOut_bits_dataRequest),
    .io_iCacheReqOut_bits_activeByteLane(bus_io_iCacheReqOut_bits_activeByteLane),
    .io_iCacheReqOut_bits_isWrite(bus_io_iCacheReqOut_bits_isWrite),
    .io_iCacheRspIn_valid(bus_io_iCacheRspIn_valid),
    .io_iCacheRspIn_bits_dataResponse(bus_io_iCacheRspIn_bits_dataResponse)
  );
  MemoryControllerTopPhysical MCU ( // @[WildcatTopPhysical.scala 48:19]
    .clock(MCU_clock),
    .reset(MCU_reset),
    .io_dCacheReqOut_valid(MCU_io_dCacheReqOut_valid),
    .io_dCacheReqOut_bits_addrRequest(MCU_io_dCacheReqOut_bits_addrRequest),
    .io_dCacheReqOut_bits_dataRequest(MCU_io_dCacheReqOut_bits_dataRequest),
    .io_dCacheReqOut_bits_activeByteLane(MCU_io_dCacheReqOut_bits_activeByteLane),
    .io_dCacheReqOut_bits_isWrite(MCU_io_dCacheReqOut_bits_isWrite),
    .io_dCacheRspIn_valid(MCU_io_dCacheRspIn_valid),
    .io_dCacheRspIn_bits_dataResponse(MCU_io_dCacheRspIn_bits_dataResponse),
    .io_iCacheReqOut_valid(MCU_io_iCacheReqOut_valid),
    .io_iCacheReqOut_bits_addrRequest(MCU_io_iCacheReqOut_bits_addrRequest),
    .io_iCacheReqOut_bits_dataRequest(MCU_io_iCacheReqOut_bits_dataRequest),
    .io_iCacheReqOut_bits_activeByteLane(MCU_io_iCacheReqOut_bits_activeByteLane),
    .io_iCacheReqOut_bits_isWrite(MCU_io_iCacheReqOut_bits_isWrite),
    .io_iCacheRspIn_valid(MCU_io_iCacheRspIn_valid),
    .io_iCacheRspIn_bits_dataResponse(MCU_io_iCacheRspIn_bits_dataResponse),
    .io_CS0(MCU_io_CS0),
    .io_CS1(MCU_io_CS1),
    .io_CS2(MCU_io_CS2),
    .io_dir(MCU_io_dir),
    .io_inSio(MCU_io_inSio),
    .io_outSio(MCU_io_outSio),
    .io_spiClk(MCU_io_spiClk)
  );
  BufferedTx tx ( // @[WildcatTopPhysical.scala 89:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Rx rx ( // @[WildcatTopPhysical.scala 90:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  CLINT clint ( // @[WildcatTopPhysical.scala 107:21]
    .clock(clint_clock),
    .reset(clint_reset),
    .io_link_enable(clint_io_link_enable),
    .io_link_isWrite(clint_io_link_isWrite),
    .io_link_address(clint_io_link_address),
    .io_link_wrData(clint_io_link_wrData),
    .io_link_rdData(clint_io_link_rdData),
    .io_currentTimeIn(clint_io_currentTimeIn),
    .io_mtimecmpValueOut(clint_io_mtimecmpValueOut)
  );
  Bootloader BL ( // @[WildcatTopPhysical.scala 127:18]
    .clock(BL_clock),
    .reset(BL_reset),
    .io_instrData(BL_io_instrData),
    .io_instrAddr(BL_io_instrAddr),
    .io_wrEnabled(BL_io_wrEnabled),
    .io_rx(BL_io_rx),
    .io_sleep(BL_io_sleep)
  );
  assign io_led = {8'h80,io_led_REG}; // @[WildcatTopPhysical.scala 172:29]
  assign io_tx = tx_io_txd; // @[WildcatTopPhysical.scala 91:9]
  assign io_CS0 = MCU_io_CS0; // @[WildcatTopPhysical.scala 56:10]
  assign io_CS1 = MCU_io_CS1; // @[WildcatTopPhysical.scala 57:10]
  assign io_CS2 = MCU_io_CS2; // @[WildcatTopPhysical.scala 58:10]
  assign io_dir = MCU_io_dir; // @[WildcatTopPhysical.scala 60:10]
  assign io_outSio = MCU_io_outSio; // @[WildcatTopPhysical.scala 62:13]
  assign io_spiClk = MCU_io_spiClk; // @[WildcatTopPhysical.scala 59:13]
  assign cpu_clock = clock;
  assign cpu_reset = reset;
  assign cpu_io_imem_data = bus_io_CPUiCacheMemIO_rdData; // @[WildcatTopPhysical.scala 68:20]
  assign cpu_io_imem_stall = bus_io_CPUiCacheMemIO_stall; // @[WildcatTopPhysical.scala 69:21]
  assign cpu_io_dmem_rdData = memAddressReg[31:28] == 4'hf ? _GEN_6 : bus_io_CPUdCacheMemIO_rdData; // @[WildcatTopPhysical.scala 139:41 65:15]
  assign cpu_io_dmem_stall = bus_io_CPUdCacheMemIO_stall; // @[WildcatTopPhysical.scala 65:15]
  assign cpu_io_mtimecmpVal_in = clint_io_mtimecmpValueOut; // @[WildcatTopPhysical.scala 122:25]
  assign cpu_io_Bootloader_Stall = ~bootloaderStatusReg[0]; // @[WildcatTopPhysical.scala 128:18]
  assign bus_clock = clock;
  assign bus_reset = reset;
  assign bus_io_CPUdCacheMemIO_rdAddress = cpu_io_dmem_rdAddress; // @[WildcatTopPhysical.scala 65:15]
  assign bus_io_CPUdCacheMemIO_rdEnable = BL_Stall ? 1'h0 : cpu_io_dmem_rdEnable; // @[WildcatTopPhysical.scala 177:28 187:37 65:15]
  assign bus_io_CPUdCacheMemIO_wrAddress = BL_Stall ? BL_io_instrAddr : cpu_io_dmem_wrAddress; // @[WildcatTopPhysical.scala 177:28 184:37 65:15]
  assign bus_io_CPUdCacheMemIO_wrData = BL_Stall ? BL_io_instrData : cpu_io_dmem_wrData; // @[WildcatTopPhysical.scala 177:28 185:37 65:15]
  assign bus_io_CPUdCacheMemIO_wrEnable_0 = BL_Stall ? BL_io_wrEnabled : cpu_io_dmem_wrEnable_0; // @[WildcatTopPhysical.scala 177:28 186:37 65:15]
  assign bus_io_CPUdCacheMemIO_wrEnable_1 = BL_Stall ? BL_io_wrEnabled : cpu_io_dmem_wrEnable_1; // @[WildcatTopPhysical.scala 177:28 186:37 65:15]
  assign bus_io_CPUdCacheMemIO_wrEnable_2 = BL_Stall ? BL_io_wrEnabled : cpu_io_dmem_wrEnable_2; // @[WildcatTopPhysical.scala 177:28 186:37 65:15]
  assign bus_io_CPUdCacheMemIO_wrEnable_3 = BL_Stall ? BL_io_wrEnabled : cpu_io_dmem_wrEnable_3; // @[WildcatTopPhysical.scala 177:28 186:37 65:15]
  assign bus_io_CPUiCacheMemIO_rdAddress = cpu_io_imem_address; // @[WildcatTopPhysical.scala 73:35]
  assign bus_io_CPUiCacheMemIO_rdEnable = BL_Stall ? 1'h0 : 1'h1; // @[WildcatTopPhysical.scala 177:28 189:36 72:34]
  assign bus_io_dCacheRspIn_valid = MCU_io_dCacheRspIn_valid; // @[WildcatTopPhysical.scala 51:22]
  assign bus_io_dCacheRspIn_bits_dataResponse = MCU_io_dCacheRspIn_bits_dataResponse; // @[WildcatTopPhysical.scala 51:22]
  assign bus_io_iCacheRspIn_valid = MCU_io_iCacheRspIn_valid; // @[WildcatTopPhysical.scala 53:22]
  assign bus_io_iCacheRspIn_bits_dataResponse = MCU_io_iCacheRspIn_bits_dataResponse; // @[WildcatTopPhysical.scala 53:22]
  assign MCU_clock = clock;
  assign MCU_reset = reset;
  assign MCU_io_dCacheReqOut_valid = bus_io_dCacheReqOut_valid; // @[WildcatTopPhysical.scala 50:23]
  assign MCU_io_dCacheReqOut_bits_addrRequest = bus_io_dCacheReqOut_bits_addrRequest; // @[WildcatTopPhysical.scala 50:23]
  assign MCU_io_dCacheReqOut_bits_dataRequest = bus_io_dCacheReqOut_bits_dataRequest; // @[WildcatTopPhysical.scala 50:23]
  assign MCU_io_dCacheReqOut_bits_activeByteLane = bus_io_dCacheReqOut_bits_activeByteLane; // @[WildcatTopPhysical.scala 50:23]
  assign MCU_io_dCacheReqOut_bits_isWrite = bus_io_dCacheReqOut_bits_isWrite; // @[WildcatTopPhysical.scala 50:23]
  assign MCU_io_iCacheReqOut_valid = bus_io_iCacheReqOut_valid; // @[WildcatTopPhysical.scala 52:23]
  assign MCU_io_iCacheReqOut_bits_addrRequest = bus_io_iCacheReqOut_bits_addrRequest; // @[WildcatTopPhysical.scala 52:23]
  assign MCU_io_iCacheReqOut_bits_dataRequest = bus_io_iCacheReqOut_bits_dataRequest; // @[WildcatTopPhysical.scala 52:23]
  assign MCU_io_iCacheReqOut_bits_activeByteLane = bus_io_iCacheReqOut_bits_activeByteLane; // @[WildcatTopPhysical.scala 52:23]
  assign MCU_io_iCacheReqOut_bits_isWrite = bus_io_iCacheReqOut_bits_isWrite; // @[WildcatTopPhysical.scala 52:23]
  assign MCU_io_inSio = io_inSio; // @[WildcatTopPhysical.scala 61:16]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = cpu_io_dmem_wrAddress[31:28] == 4'hf & _isClintWrite_T > 4'h0 & _GEN_16; // @[WildcatTopPhysical.scala 158:91 95:23]
  assign tx_io_channel_bits = cpu_io_dmem_wrData[7:0]; // @[WildcatTopPhysical.scala 94:43]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rx; // @[WildcatTopPhysical.scala 92:13]
  assign rx_io_channel_ready = memAddressReg[31:28] == 4'hf & _GEN_7; // @[WildcatTopPhysical.scala 139:41 96:23]
  assign clint_clock = clock;
  assign clint_reset = reset;
  assign clint_io_link_enable = isClintAccess; // @[WildcatTopPhysical.scala 116:24]
  assign clint_io_link_isWrite = isClintWrite; // @[WildcatTopPhysical.scala 117:25]
  assign clint_io_link_address = isClintWrite ? writeAddressReg : memAddressReg; // @[WildcatTopPhysical.scala 118:31]
  assign clint_io_link_wrData = clintWriteDataReg; // @[WildcatTopPhysical.scala 119:24]
  assign clint_io_currentTimeIn = cpu_io_timerCounter_out; // @[WildcatTopPhysical.scala 121:26]
  assign BL_clock = clock;
  assign BL_reset = reset;
  assign BL_io_rx = io_rx; // @[WildcatTopPhysical.scala 130:12]
  assign BL_io_sleep = ~bootloaderStatusReg[0]; // @[WildcatTopPhysical.scala 128:18]
  always @(posedge clock) begin
    if (reset) begin // @[WildcatTopPhysical.scala 84:23]
      ledReg <= 8'h0; // @[WildcatTopPhysical.scala 84:23]
    end else if (cpu_io_dmem_wrAddress[31:28] == 4'hf & _isClintWrite_T > 4'h0) begin // @[WildcatTopPhysical.scala 158:91]
      if (!(isClintWrite)) begin // @[WildcatTopPhysical.scala 159:25]
        if (!(cpu_io_dmem_wrAddress == 32'hf0000004)) begin // @[WildcatTopPhysical.scala 161:60]
          ledReg <= _GEN_11;
        end
      end
    end
    uartStatusReg <= {rx_io_channel_valid,tx_io_channel_ready}; // @[WildcatTopPhysical.scala 101:51]
    if (reset) begin // @[WildcatTopPhysical.scala 102:36]
      bootloaderStatusReg <= 8'h0; // @[WildcatTopPhysical.scala 102:36]
    end else if (cpu_io_dmem_wrAddress[31:28] == 4'hf & _isClintWrite_T > 4'h0) begin // @[WildcatTopPhysical.scala 158:91]
      if (!(isClintWrite)) begin // @[WildcatTopPhysical.scala 159:25]
        if (!(cpu_io_dmem_wrAddress == 32'hf0000004)) begin // @[WildcatTopPhysical.scala 161:60]
          bootloaderStatusReg <= _GEN_12;
        end
      end
    end
    memAddressReg <= cpu_io_dmem_rdAddress; // @[WildcatTopPhysical.scala 103:30]
    writeAddressReg <= cpu_io_dmem_wrAddress; // @[WildcatTopPhysical.scala 104:32]
    isClintAccess <= memAddressReg >= 32'hf0100000 & _isClintAccess_T_1; // @[WildcatTopPhysical.scala 108:73]
    isClintWrite <= _isClintWrite_T_3 & _isClintWrite_T_4; // @[WildcatTopPhysical.scala 111:49]
    clintWriteDataReg <= cpu_io_dmem_wrData; // @[WildcatTopPhysical.scala 113:34]
    io_led_REG <= ledReg; // @[WildcatTopPhysical.scala 172:39]
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
  ledReg = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  uartStatusReg = _RAND_1[1:0];
  _RAND_2 = {1{`RANDOM}};
  bootloaderStatusReg = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  memAddressReg = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  writeAddressReg = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  isClintAccess = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  isClintWrite = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  clintWriteDataReg = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  io_led_REG = _RAND_8[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
