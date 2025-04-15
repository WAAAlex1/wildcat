FIRRTL version 1.1.0
circuit MemoryControllerTester :
  module TestMem :
    input clock : Clock
    input reset : UInt<1>
    input io_rdAddress : UInt<32>
    output io_rdData : UInt<32>
    input io_rdEnable : UInt<1>
    input io_wrAddress : UInt<32>
    input io_wrData : UInt<32>
    input io_wrEnable_0 : UInt<1>
    input io_wrEnable_1 : UInt<1>
    input io_wrEnable_2 : UInt<1>
    input io_wrEnable_3 : UInt<1>

    mem MEM : @[TestMem.scala 24:16]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_rdData_MPORT_3
      writer => MPORT
      read-under-write => new
    mem MEM_1 : @[TestMem.scala 25:16]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_rdData_MPORT_2
      writer => MPORT_1
      read-under-write => new
    mem MEM_2 : @[TestMem.scala 26:16]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_rdData_MPORT_1
      writer => MPORT_2
      read-under-write => new
    mem MEM_3 : @[TestMem.scala 27:16]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_rdData_MPORT
      writer => MPORT_3
      read-under-write => new
    node _io_rdData_T = bits(io_rdAddress, 12, 2) @[TestMem.scala 31:41]
    node _GEN_0 = validif(UInt<1>("h1"), _io_rdData_T) @[TestMem.scala 31:{28,28}]
    node _io_rdData_WIRE = _GEN_0 @[TestMem.scala 31:28]
    node _io_rdData_T_1 = or(_io_rdData_WIRE, UInt<10>("h0")) @[TestMem.scala 31:28]
    node _io_rdData_T_2 = bits(_io_rdData_T_1, 9, 0) @[TestMem.scala 31:28]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[TestMem.scala 27:16 31:{28,28}]
    node _GEN_2 = validif(UInt<1>("h1"), _io_rdData_T_2) @[TestMem.scala 31:{28,28}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[TestMem.scala 31:{28,28}]
    node _io_rdData_T_3 = bits(io_rdAddress, 12, 2) @[TestMem.scala 31:81]
    node _GEN_4 = validif(UInt<1>("h1"), _io_rdData_T_3) @[TestMem.scala 31:{68,68}]
    node _io_rdData_WIRE_1 = _GEN_4 @[TestMem.scala 31:68]
    node _io_rdData_T_4 = or(_io_rdData_WIRE_1, UInt<10>("h0")) @[TestMem.scala 31:68]
    node _io_rdData_T_5 = bits(_io_rdData_T_4, 9, 0) @[TestMem.scala 31:68]
    node _GEN_5 = validif(UInt<1>("h1"), _io_rdData_T_5) @[TestMem.scala 31:{68,68}]
    node _io_rdData_T_6 = cat(MEM_3.io_rdData_MPORT.data, MEM_2.io_rdData_MPORT_1.data) @[TestMem.scala 31:53]
    node _io_rdData_T_7 = bits(io_rdAddress, 12, 2) @[TestMem.scala 31:121]
    node _GEN_6 = validif(UInt<1>("h1"), _io_rdData_T_7) @[TestMem.scala 31:{108,108}]
    node _io_rdData_WIRE_2 = _GEN_6 @[TestMem.scala 31:108]
    node _io_rdData_T_8 = or(_io_rdData_WIRE_2, UInt<10>("h0")) @[TestMem.scala 31:108]
    node _io_rdData_T_9 = bits(_io_rdData_T_8, 9, 0) @[TestMem.scala 31:108]
    node _GEN_7 = validif(UInt<1>("h1"), _io_rdData_T_9) @[TestMem.scala 31:{108,108}]
    node _io_rdData_T_10 = cat(_io_rdData_T_6, MEM_1.io_rdData_MPORT_2.data) @[TestMem.scala 31:93]
    node _io_rdData_T_11 = bits(io_rdAddress, 12, 2) @[TestMem.scala 31:161]
    node _GEN_8 = validif(UInt<1>("h1"), _io_rdData_T_11) @[TestMem.scala 31:{148,148}]
    node _io_rdData_WIRE_3 = _GEN_8 @[TestMem.scala 31:148]
    node _io_rdData_T_12 = or(_io_rdData_WIRE_3, UInt<10>("h0")) @[TestMem.scala 31:148]
    node _io_rdData_T_13 = bits(_io_rdData_T_12, 9, 0) @[TestMem.scala 31:148]
    node _GEN_9 = validif(UInt<1>("h1"), _io_rdData_T_13) @[TestMem.scala 31:{148,148}]
    node _io_rdData_T_14 = cat(_io_rdData_T_10, MEM.io_rdData_MPORT_3.data) @[TestMem.scala 31:133]
    node _T = bits(io_wrAddress, 12, 2) @[TestMem.scala 33:31]
    node _T_1 = bits(io_wrData, 7, 0) @[TestMem.scala 33:52]
    node _T_2 = bits(_T, 9, 0)
    node _GEN_10 = validif(io_wrEnable_0, _T_2) @[TestMem.scala 32:24]
    node _GEN_11 = validif(io_wrEnable_0, clock) @[TestMem.scala 32:24]
    node _GEN_12 = mux(io_wrEnable_0, UInt<1>("h1"), UInt<1>("h0")) @[TestMem.scala 24:16 32:24]
    node _GEN_13 = validif(io_wrEnable_0, UInt<1>("h1")) @[TestMem.scala 32:24]
    node _GEN_14 = validif(io_wrEnable_0, _T_1) @[TestMem.scala 32:24]
    node _T_3 = bits(io_wrAddress, 12, 2) @[TestMem.scala 36:31]
    node _T_4 = bits(io_wrData, 15, 8) @[TestMem.scala 36:52]
    node _T_5 = bits(_T_3, 9, 0)
    node _GEN_15 = validif(io_wrEnable_1, _T_5) @[TestMem.scala 35:24]
    node _GEN_16 = validif(io_wrEnable_1, clock) @[TestMem.scala 35:24]
    node _GEN_17 = mux(io_wrEnable_1, UInt<1>("h1"), UInt<1>("h0")) @[TestMem.scala 25:16 35:24]
    node _GEN_18 = validif(io_wrEnable_1, UInt<1>("h1")) @[TestMem.scala 35:24]
    node _GEN_19 = validif(io_wrEnable_1, _T_4) @[TestMem.scala 35:24]
    node _T_6 = bits(io_wrAddress, 12, 2) @[TestMem.scala 39:31]
    node _T_7 = bits(io_wrData, 23, 16) @[TestMem.scala 39:52]
    node _T_8 = bits(_T_6, 9, 0)
    node _GEN_20 = validif(io_wrEnable_2, _T_8) @[TestMem.scala 38:24]
    node _GEN_21 = validif(io_wrEnable_2, clock) @[TestMem.scala 38:24]
    node _GEN_22 = mux(io_wrEnable_2, UInt<1>("h1"), UInt<1>("h0")) @[TestMem.scala 26:16 38:24]
    node _GEN_23 = validif(io_wrEnable_2, UInt<1>("h1")) @[TestMem.scala 38:24]
    node _GEN_24 = validif(io_wrEnable_2, _T_7) @[TestMem.scala 38:24]
    node _T_9 = bits(io_wrAddress, 12, 2) @[TestMem.scala 42:31]
    node _T_10 = bits(io_wrData, 31, 24) @[TestMem.scala 42:52]
    node _T_11 = bits(_T_9, 9, 0)
    node _GEN_25 = validif(io_wrEnable_3, _T_11) @[TestMem.scala 41:24]
    node _GEN_26 = validif(io_wrEnable_3, clock) @[TestMem.scala 41:24]
    node _GEN_27 = mux(io_wrEnable_3, UInt<1>("h1"), UInt<1>("h0")) @[TestMem.scala 27:16 41:24]
    node _GEN_28 = validif(io_wrEnable_3, UInt<1>("h1")) @[TestMem.scala 41:24]
    node _GEN_29 = validif(io_wrEnable_3, _T_10) @[TestMem.scala 41:24]
    io_rdData <= _io_rdData_T_14 @[TestMem.scala 31:13]
    MEM.io_rdData_MPORT_3.addr <= _GEN_9
    MEM.io_rdData_MPORT_3.en <= _GEN_1
    MEM.io_rdData_MPORT_3.clk <= _GEN_3
    MEM.MPORT.addr <= _GEN_10
    MEM.MPORT.en <= _GEN_12
    MEM.MPORT.clk <= _GEN_11
    MEM.MPORT.data <= _GEN_14
    MEM.MPORT.mask <= _GEN_13
    MEM_1.io_rdData_MPORT_2.addr <= _GEN_7
    MEM_1.io_rdData_MPORT_2.en <= _GEN_1
    MEM_1.io_rdData_MPORT_2.clk <= _GEN_3
    MEM_1.MPORT_1.addr <= _GEN_15
    MEM_1.MPORT_1.en <= _GEN_17
    MEM_1.MPORT_1.clk <= _GEN_16
    MEM_1.MPORT_1.data <= _GEN_19
    MEM_1.MPORT_1.mask <= _GEN_18
    MEM_2.io_rdData_MPORT_1.addr <= _GEN_5
    MEM_2.io_rdData_MPORT_1.en <= _GEN_1
    MEM_2.io_rdData_MPORT_1.clk <= _GEN_3
    MEM_2.MPORT_2.addr <= _GEN_20
    MEM_2.MPORT_2.en <= _GEN_22
    MEM_2.MPORT_2.clk <= _GEN_21
    MEM_2.MPORT_2.data <= _GEN_24
    MEM_2.MPORT_2.mask <= _GEN_23
    MEM_3.io_rdData_MPORT.addr <= _GEN_2
    MEM_3.io_rdData_MPORT.en <= _GEN_1
    MEM_3.io_rdData_MPORT.clk <= _GEN_3
    MEM_3.MPORT_3.addr <= _GEN_25
    MEM_3.MPORT_3.en <= _GEN_27
    MEM_3.MPORT_3.clk <= _GEN_26
    MEM_3.MPORT_3.data <= _GEN_29
    MEM_3.MPORT_3.mask <= _GEN_28

  module MemoryController :
    input clock : Clock
    input reset : UInt<1>
    input io_memIO_rdAddress : UInt<32>
    output io_memIO_rdData : UInt<32>
    input io_memIO_rdEnable : UInt<1>
    input io_memIO_wrAddress : UInt<32>
    input io_memIO_wrData : UInt<32>
    input io_memIO_wrEnable_0 : UInt<1>
    input io_memIO_wrEnable_1 : UInt<1>
    input io_memIO_wrEnable_2 : UInt<1>
    input io_memIO_wrEnable_3 : UInt<1>
    output io_stall : UInt<1>
    input io_bootloading : UInt<1>
    output io_dCacheReqOut_ready : UInt<1>
    input io_dCacheReqOut_valid : UInt<1>
    input io_dCacheReqOut_bits_addrRequest : UInt<32>
    input io_dCacheReqOut_bits_dataRequest : UInt<32>
    input io_dCacheReqOut_bits_activeByteLane : UInt<4>
    input io_dCacheReqOut_bits_isWrite : UInt<1>
    input io_dCacheRspIn_ready : UInt<1>
    output io_dCacheRspIn_valid : UInt<1>
    output io_dCacheRspIn_bits_dataResponse : UInt<32>
    output io_dCacheRspIn_bits_error : UInt<1>
    output io_iCacheReqOut_ready : UInt<1>
    input io_iCacheReqOut_valid : UInt<1>
    input io_iCacheReqOut_bits_addrRequest : UInt<32>
    input io_iCacheReqOut_bits_dataRequest : UInt<32>
    input io_iCacheReqOut_bits_activeByteLane : UInt<4>
    input io_iCacheReqOut_bits_isWrite : UInt<1>
    input io_iCacheRspIn_ready : UInt<1>
    output io_iCacheRspIn_valid : UInt<1>
    output io_iCacheRspIn_bits_dataResponse : UInt<32>
    output io_iCacheRspIn_bits_error : UInt<1>
    output io_SPIctrl_0_rst : UInt<1>
    output io_SPIctrl_0_rw : UInt<1>
    output io_SPIctrl_0_en : UInt<1>
    output io_SPIctrl_0_addr : UInt<24>
    output io_SPIctrl_0_dataIn : UInt<32>
    input io_SPIctrl_0_dataOut : UInt<32>
    input io_SPIctrl_0_done : UInt<1>
    output io_SPIctrl_0_size : UInt<3>
    output io_SPIctrl_1_rst : UInt<1>
    output io_SPIctrl_1_rw : UInt<1>
    output io_SPIctrl_1_en : UInt<1>
    output io_SPIctrl_1_addr : UInt<24>
    output io_SPIctrl_1_dataIn : UInt<32>
    input io_SPIctrl_1_dataOut : UInt<32>
    input io_SPIctrl_1_done : UInt<1>
    output io_SPIctrl_1_size : UInt<3>
    output iReqAck_0 : UInt<1>
    output dReqAck_0 : UInt<1>

    inst memory of TestMem @[MemoryController.scala 39:22]
    node _T = bits(io_memIO_rdAddress, 31, 28) @[MemoryController.scala 43:26]
    node _T_1 = eq(_T, UInt<4>("hf")) @[MemoryController.scala 43:34]
    node _T_2 = bits(io_memIO_rdAddress, 23, 23) @[MemoryController.scala 45:32]
    node _T_3 = eq(_T_2, UInt<1>("h1")) @[MemoryController.scala 45:37]
    node _io_stall_T = or(io_bootloading, UInt<1>("h0")) @[MemoryController.scala 52:30]
    node dReqAck = and(io_dCacheReqOut_valid, io_dCacheReqOut_ready) @[MemoryController.scala 57:39]
    node iReqAck = and(io_iCacheReqOut_valid, io_iCacheReqOut_ready) @[MemoryController.scala 58:39]
    reg currentReq_addrRequest : UInt<32>, clock with :
      reset => (UInt<1>("h0"), currentReq_addrRequest) @[MemoryController.scala 59:23]
    reg currentReq_dataRequest : UInt<32>, clock with :
      reset => (UInt<1>("h0"), currentReq_dataRequest) @[MemoryController.scala 59:23]
    reg currentReq_activeByteLane : UInt<4>, clock with :
      reset => (UInt<1>("h0"), currentReq_activeByteLane) @[MemoryController.scala 59:23]
    reg currentReq_isWrite : UInt<1>, clock with :
      reset => (UInt<1>("h0"), currentReq_isWrite) @[MemoryController.scala 59:23]
    reg rspPending : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rspPending) @[MemoryController.scala 61:27]
    reg masterID : UInt<1>, clock with :
      reset => (UInt<1>("h0"), masterID) @[MemoryController.scala 64:25]
    node _io_dCacheReqOut_ready_T = mux(io_dCacheReqOut_valid, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 70:31]
    node _io_iCacheReqOut_ready_T = eq(io_dCacheReqOut_valid, UInt<1>("h0")) @[MemoryController.scala 71:32]
    node _io_iCacheReqOut_ready_T_1 = and(_io_iCacheReqOut_ready_T, io_iCacheReqOut_valid) @[MemoryController.scala 71:55]
    node _io_iCacheReqOut_ready_T_2 = mux(_io_iCacheReqOut_ready_T_1, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 71:31]
    node _io_SPIctrl_0_addr_T = bits(currentReq_addrRequest, 23, 0) @[MemoryController.scala 87:49]
    node _io_SPIctrl_1_addr_T = bits(currentReq_addrRequest, 23, 0) @[MemoryController.scala 87:49]
    node _GEN_0 = mux(iReqAck, io_iCacheReqOut_bits_addrRequest, currentReq_addrRequest) @[MemoryController.scala 100:16 99:22 59:23]
    node _GEN_1 = mux(iReqAck, io_iCacheReqOut_bits_dataRequest, currentReq_dataRequest) @[MemoryController.scala 100:16 99:22 59:23]
    node _GEN_2 = mux(iReqAck, io_iCacheReqOut_bits_activeByteLane, currentReq_activeByteLane) @[MemoryController.scala 100:16 99:22 59:23]
    node _GEN_3 = mux(iReqAck, io_iCacheReqOut_bits_isWrite, currentReq_isWrite) @[MemoryController.scala 100:16 99:22 59:23]
    node _GEN_4 = mux(iReqAck, UInt<1>("h1"), rspPending) @[MemoryController.scala 101:16 99:22 61:27]
    node _GEN_5 = mux(iReqAck, UInt<1>("h1"), masterID) @[MemoryController.scala 102:14 99:22 64:25]
    node _GEN_6 = mux(dReqAck, io_dCacheReqOut_bits_addrRequest, _GEN_0) @[MemoryController.scala 95:16 96:16]
    node _GEN_7 = mux(dReqAck, io_dCacheReqOut_bits_dataRequest, _GEN_1) @[MemoryController.scala 95:16 96:16]
    node _GEN_8 = mux(dReqAck, io_dCacheReqOut_bits_activeByteLane, _GEN_2) @[MemoryController.scala 95:16 96:16]
    node _GEN_9 = mux(dReqAck, io_dCacheReqOut_bits_isWrite, _GEN_3) @[MemoryController.scala 95:16 96:16]
    node _GEN_10 = mux(dReqAck, UInt<1>("h1"), _GEN_4) @[MemoryController.scala 95:16 97:16]
    node _GEN_11 = mux(dReqAck, UInt<1>("h0"), _GEN_5) @[MemoryController.scala 95:16 98:14]
    node _writeSize_T = eq(UInt<4>("hf"), currentReq_activeByteLane) @[Mux.scala 81:61]
    node _writeSize_T_1 = mux(_writeSize_T, UInt<3>("h4"), UInt<1>("h1")) @[Mux.scala 81:58]
    node _writeSize_T_2 = eq(UInt<4>("hc"), currentReq_activeByteLane) @[Mux.scala 81:61]
    node _writeSize_T_3 = mux(_writeSize_T_2, UInt<2>("h2"), _writeSize_T_1) @[Mux.scala 81:58]
    node _writeSize_T_4 = eq(UInt<2>("h3"), currentReq_activeByteLane) @[Mux.scala 81:61]
    node _writeSize_T_5 = mux(_writeSize_T_4, UInt<2>("h2"), _writeSize_T_3) @[Mux.scala 81:58]
    node _shiftAmount_T = bits(currentReq_activeByteLane, 0, 0) @[OneHot.scala 47:45]
    node _shiftAmount_T_1 = bits(currentReq_activeByteLane, 1, 1) @[OneHot.scala 47:45]
    node _shiftAmount_T_2 = bits(currentReq_activeByteLane, 2, 2) @[OneHot.scala 47:45]
    node _shiftAmount_T_3 = bits(currentReq_activeByteLane, 3, 3) @[OneHot.scala 47:45]
    node _shiftAmount_T_4 = mux(_shiftAmount_T_2, UInt<2>("h2"), UInt<2>("h3")) @[Mux.scala 47:70]
    node _shiftAmount_T_5 = mux(_shiftAmount_T_1, UInt<1>("h1"), _shiftAmount_T_4) @[Mux.scala 47:70]
    node shiftAmount = mux(_shiftAmount_T, UInt<1>("h0"), _shiftAmount_T_5) @[Mux.scala 47:70]
    node _data2write_T = mul(shiftAmount, UInt<4>("h8")) @[MemoryController.scala 116:59]
    node _data2write_T_1 = dshr(currentReq_dataRequest, _data2write_T) @[MemoryController.scala 116:43]
    node _GEN_12 = mux(currentReq_isWrite, _writeSize_T_5, UInt<3>("h0")) @[MemoryController.scala 106:27 108:15 60:27]
    node _GEN_13 = mux(currentReq_isWrite, _data2write_T_1, UInt<32>("h0")) @[MemoryController.scala 106:27 116:16 62:28]
    node _T_4 = bits(currentReq_addrRequest, 31, 28) @[MemoryController.scala 123:32]
    node _T_5 = eq(_T_4, UInt<4>("hf")) @[MemoryController.scala 123:41]
    node _T_6 = bits(currentReq_addrRequest, 24, 24) @[MemoryController.scala 125:38]
    node _T_7 = bits(currentReq_addrRequest, 24, 24) @[MemoryController.scala 129:39]
    node _T_8 = eq(_T_7, UInt<1>("h0")) @[MemoryController.scala 129:16]
    node _GEN_14 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 129:45 131:24 84:22]
    node _GEN_15 = mux(_T_6, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 125:44 127:24 84:22]
    node _GEN_16 = mux(_T_6, UInt<1>("h0"), _GEN_14) @[MemoryController.scala 125:44 84:22]
    node _GEN_17 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[MemoryController.scala 123:53 84:22]
    node _GEN_18 = mux(_T_5, UInt<1>("h0"), _GEN_16) @[MemoryController.scala 123:53 84:22]
    node _GEN_19 = mux(rspPending, _GEN_17, UInt<1>("h0")) @[MemoryController.scala 121:19 84:22]
    node _GEN_20 = mux(rspPending, _GEN_18, UInt<1>("h0")) @[MemoryController.scala 121:19 84:22]
    node _T_9 = eq(currentReq_isWrite, UInt<1>("h0")) @[MemoryController.scala 142:12]
    node _GEN_21 = mux(_T_9, io_SPIctrl_0_dataOut, UInt<32>("h0")) @[MemoryController.scala 142:33 143:18 63:26]
    node _GEN_22 = mux(io_SPIctrl_0_done, UInt<1>("h0"), _GEN_10) @[MemoryController.scala 140:30 141:18]
    node _GEN_23 = mux(io_SPIctrl_0_done, _GEN_21, UInt<32>("h0")) @[MemoryController.scala 140:30 63:26]
    node _GEN_24 = mux(io_SPIctrl_0_done, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 140:30 145:16 65:26]
    node _GEN_25 = mux(masterID, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 151:19 152:28 79:24]
    node _GEN_26 = mux(masterID, UInt<1>("h0"), UInt<1>("h1")) @[MemoryController.scala 151:19 78:24 154:28]
    node rspValid = _GEN_24 @[MemoryController.scala 65:26]
    node _GEN_27 = mux(rspValid, _GEN_25, UInt<1>("h0")) @[MemoryController.scala 150:17 79:24]
    node _GEN_28 = mux(rspValid, _GEN_26, UInt<1>("h0")) @[MemoryController.scala 150:17 78:24]
    node writeSize = _GEN_12 @[MemoryController.scala 60:27]
    node data2write = _GEN_13 @[MemoryController.scala 62:28]
    node readData = _GEN_23 @[MemoryController.scala 63:26]
    io_memIO_rdData <= memory.io_rdData @[MemoryController.scala 40:12]
    io_stall <= _io_stall_T @[MemoryController.scala 52:12]
    io_dCacheReqOut_ready <= _io_dCacheReqOut_ready_T @[MemoryController.scala 70:25]
    io_dCacheRspIn_valid <= _GEN_28
    io_dCacheRspIn_bits_dataResponse <= readData @[MemoryController.scala 74:36]
    io_dCacheRspIn_bits_error <= UInt<1>("h0") @[MemoryController.scala 76:29]
    io_iCacheReqOut_ready <= _io_iCacheReqOut_ready_T_2 @[MemoryController.scala 71:25]
    io_iCacheRspIn_valid <= _GEN_27
    io_iCacheRspIn_bits_dataResponse <= readData @[MemoryController.scala 75:36]
    io_iCacheRspIn_bits_error <= UInt<1>("h0") @[MemoryController.scala 77:29]
    io_SPIctrl_0_rst <= UInt<1>("h0") @[MemoryController.scala 86:23]
    io_SPIctrl_0_rw <= currentReq_isWrite @[MemoryController.scala 85:22]
    io_SPIctrl_0_en <= _GEN_20
    io_SPIctrl_0_addr <= _io_SPIctrl_0_addr_T @[MemoryController.scala 87:24]
    io_SPIctrl_0_dataIn <= data2write @[MemoryController.scala 88:26]
    io_SPIctrl_0_size <= writeSize @[MemoryController.scala 89:24]
    io_SPIctrl_1_rst <= UInt<1>("h0") @[MemoryController.scala 86:23]
    io_SPIctrl_1_rw <= currentReq_isWrite @[MemoryController.scala 85:22]
    io_SPIctrl_1_en <= _GEN_19
    io_SPIctrl_1_addr <= _io_SPIctrl_1_addr_T @[MemoryController.scala 87:24]
    io_SPIctrl_1_dataIn <= data2write @[MemoryController.scala 88:26]
    io_SPIctrl_1_size <= writeSize @[MemoryController.scala 89:24]
    iReqAck_0 <= iReqAck
    dReqAck_0 <= dReqAck
    memory.clock <= clock
    memory.reset <= reset
    memory.io_rdAddress <= io_memIO_rdAddress @[MemoryController.scala 40:12]
    memory.io_rdEnable <= io_memIO_rdEnable @[MemoryController.scala 40:12]
    memory.io_wrAddress <= io_memIO_wrAddress @[MemoryController.scala 40:12]
    memory.io_wrData <= io_memIO_wrData @[MemoryController.scala 40:12]
    memory.io_wrEnable_0 <= io_memIO_wrEnable_0 @[MemoryController.scala 40:12]
    memory.io_wrEnable_1 <= io_memIO_wrEnable_1 @[MemoryController.scala 40:12]
    memory.io_wrEnable_2 <= io_memIO_wrEnable_2 @[MemoryController.scala 40:12]
    memory.io_wrEnable_3 <= io_memIO_wrEnable_3 @[MemoryController.scala 40:12]
    currentReq_addrRequest <= _GEN_6
    currentReq_dataRequest <= _GEN_7
    currentReq_activeByteLane <= _GEN_8
    currentReq_isWrite <= _GEN_9
    rspPending <= mux(reset, UInt<1>("h0"), _GEN_22) @[MemoryController.scala 61:{27,27}]
    masterID <= mux(reset, UInt<1>("h0"), _GEN_11) @[MemoryController.scala 64:{25,25}]

  module MemoryControllerTester :
    input clock : Clock
    input reset : UInt<1>
    output io_dCacheReqOut_ready : UInt<1>
    input io_dCacheReqOut_valid : UInt<1>
    input io_dCacheReqOut_bits_addrRequest : UInt<32>
    input io_dCacheReqOut_bits_dataRequest : UInt<32>
    input io_dCacheReqOut_bits_activeByteLane : UInt<4>
    input io_dCacheReqOut_bits_isWrite : UInt<1>
    input io_dCacheRspIn_ready : UInt<1>
    output io_dCacheRspIn_valid : UInt<1>
    output io_dCacheRspIn_bits_dataResponse : UInt<32>
    output io_dCacheRspIn_bits_error : UInt<1>
    output io_iCacheReqOut_ready : UInt<1>
    input io_iCacheReqOut_valid : UInt<1>
    input io_iCacheReqOut_bits_addrRequest : UInt<32>
    input io_iCacheReqOut_bits_dataRequest : UInt<32>
    input io_iCacheReqOut_bits_activeByteLane : UInt<4>
    input io_iCacheReqOut_bits_isWrite : UInt<1>
    input io_iCacheRspIn_ready : UInt<1>
    output io_iCacheRspIn_valid : UInt<1>
    output io_iCacheRspIn_bits_dataResponse : UInt<32>
    output io_iCacheRspIn_bits_error : UInt<1>
    output io_SPIctrl_0_rst : UInt<1>
    output io_SPIctrl_0_rw : UInt<1>
    output io_SPIctrl_0_en : UInt<1>
    output io_SPIctrl_0_addr : UInt<24>
    output io_SPIctrl_0_dataIn : UInt<32>
    input io_SPIctrl_0_dataOut : UInt<32>
    input io_SPIctrl_0_done : UInt<1>
    output io_SPIctrl_0_size : UInt<3>
    output io_SPIctrl_1_rst : UInt<1>
    output io_SPIctrl_1_rw : UInt<1>
    output io_SPIctrl_1_en : UInt<1>
    output io_SPIctrl_1_addr : UInt<24>
    output io_SPIctrl_1_dataIn : UInt<32>
    input io_SPIctrl_1_dataOut : UInt<32>
    input io_SPIctrl_1_done : UInt<1>
    output io_SPIctrl_1_size : UInt<3>
    output io_dReqAck : UInt<1>
    output io_iReqAck : UInt<1>

    inst CTRL of MemoryController @[MemoryControllerTest.scala 31:20]
    node dReqAck = CTRL.dReqAck_0
    node iReqAck = CTRL.iReqAck_0
    io_dCacheReqOut_ready <= CTRL.io_dCacheReqOut_ready @[MemoryControllerTest.scala 38:24]
    io_dCacheRspIn_valid <= CTRL.io_dCacheRspIn_valid @[MemoryControllerTest.scala 39:18]
    io_dCacheRspIn_bits_dataResponse <= CTRL.io_dCacheRspIn_bits_dataResponse @[MemoryControllerTest.scala 39:18]
    io_dCacheRspIn_bits_error <= CTRL.io_dCacheRspIn_bits_error @[MemoryControllerTest.scala 39:18]
    io_iCacheReqOut_ready <= CTRL.io_iCacheReqOut_ready @[MemoryControllerTest.scala 40:24]
    io_iCacheRspIn_valid <= CTRL.io_iCacheRspIn_valid @[MemoryControllerTest.scala 41:18]
    io_iCacheRspIn_bits_dataResponse <= CTRL.io_iCacheRspIn_bits_dataResponse @[MemoryControllerTest.scala 41:18]
    io_iCacheRspIn_bits_error <= CTRL.io_iCacheRspIn_bits_error @[MemoryControllerTest.scala 41:18]
    io_SPIctrl_0_rst <= CTRL.io_SPIctrl_0_rst @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_0_rw <= CTRL.io_SPIctrl_0_rw @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_0_en <= CTRL.io_SPIctrl_0_en @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_0_addr <= CTRL.io_SPIctrl_0_addr @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_0_dataIn <= CTRL.io_SPIctrl_0_dataIn @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_0_size <= CTRL.io_SPIctrl_0_size @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_1_rst <= CTRL.io_SPIctrl_1_rst @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_1_rw <= CTRL.io_SPIctrl_1_rw @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_1_en <= CTRL.io_SPIctrl_1_en @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_1_addr <= CTRL.io_SPIctrl_1_addr @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_1_dataIn <= CTRL.io_SPIctrl_1_dataIn @[MemoryControllerTest.scala 42:14]
    io_SPIctrl_1_size <= CTRL.io_SPIctrl_1_size @[MemoryControllerTest.scala 42:14]
    io_dReqAck <= dReqAck
    io_iReqAck <= iReqAck
    CTRL.clock <= clock
    CTRL.reset <= reset
    CTRL.io_memIO_rdAddress is invalid
    CTRL.io_memIO_rdEnable is invalid
    CTRL.io_memIO_wrAddress is invalid
    CTRL.io_memIO_wrData is invalid
    CTRL.io_memIO_wrEnable_0 is invalid
    CTRL.io_memIO_wrEnable_1 is invalid
    CTRL.io_memIO_wrEnable_2 is invalid
    CTRL.io_memIO_wrEnable_3 is invalid
    CTRL.io_bootloading <= UInt<1>("h0") @[MemoryControllerTest.scala 32:23]
    CTRL.io_dCacheReqOut_valid <= io_dCacheReqOut_valid @[MemoryControllerTest.scala 38:24]
    CTRL.io_dCacheReqOut_bits_addrRequest <= io_dCacheReqOut_bits_addrRequest @[MemoryControllerTest.scala 38:24]
    CTRL.io_dCacheReqOut_bits_dataRequest <= io_dCacheReqOut_bits_dataRequest @[MemoryControllerTest.scala 38:24]
    CTRL.io_dCacheReqOut_bits_activeByteLane <= io_dCacheReqOut_bits_activeByteLane @[MemoryControllerTest.scala 38:24]
    CTRL.io_dCacheReqOut_bits_isWrite <= io_dCacheReqOut_bits_isWrite @[MemoryControllerTest.scala 38:24]
    CTRL.io_dCacheRspIn_ready <= io_dCacheRspIn_ready @[MemoryControllerTest.scala 39:18]
    CTRL.io_iCacheReqOut_valid <= io_iCacheReqOut_valid @[MemoryControllerTest.scala 40:24]
    CTRL.io_iCacheReqOut_bits_addrRequest <= io_iCacheReqOut_bits_addrRequest @[MemoryControllerTest.scala 40:24]
    CTRL.io_iCacheReqOut_bits_dataRequest <= io_iCacheReqOut_bits_dataRequest @[MemoryControllerTest.scala 40:24]
    CTRL.io_iCacheReqOut_bits_activeByteLane <= io_iCacheReqOut_bits_activeByteLane @[MemoryControllerTest.scala 40:24]
    CTRL.io_iCacheReqOut_bits_isWrite <= io_iCacheReqOut_bits_isWrite @[MemoryControllerTest.scala 40:24]
    CTRL.io_iCacheRspIn_ready <= io_iCacheRspIn_ready @[MemoryControllerTest.scala 41:18]
    CTRL.io_SPIctrl_0_dataOut <= io_SPIctrl_0_dataOut @[MemoryControllerTest.scala 42:14]
    CTRL.io_SPIctrl_0_done <= io_SPIctrl_0_done @[MemoryControllerTest.scala 42:14]
    CTRL.io_SPIctrl_1_dataOut <= io_SPIctrl_1_dataOut @[MemoryControllerTest.scala 42:14]
    CTRL.io_SPIctrl_1_done <= io_SPIctrl_1_done @[MemoryControllerTest.scala 42:14]
