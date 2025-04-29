FIRRTL version 1.1.0
circuit MemoryControllerTopTester :
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

    inst memory of TestMem @[MemoryController.scala 38:22]
    node _T = bits(io_memIO_rdAddress, 31, 28) @[MemoryController.scala 42:26]
    node _T_1 = eq(_T, UInt<4>("hf")) @[MemoryController.scala 42:34]
    node _T_2 = bits(io_memIO_rdAddress, 23, 23) @[MemoryController.scala 44:32]
    node _T_3 = eq(_T_2, UInt<1>("h1")) @[MemoryController.scala 44:37]
    node _io_stall_T = or(io_bootloading, UInt<1>("h0")) @[MemoryController.scala 51:30]
    node dReqAck = and(io_dCacheReqOut_valid, io_dCacheReqOut_ready) @[MemoryController.scala 56:39]
    node iReqAck = and(io_iCacheReqOut_valid, io_iCacheReqOut_ready) @[MemoryController.scala 57:39]
    reg currentReq_addrRequest : UInt<32>, clock with :
      reset => (UInt<1>("h0"), currentReq_addrRequest) @[MemoryController.scala 58:23]
    reg currentReq_dataRequest : UInt<32>, clock with :
      reset => (UInt<1>("h0"), currentReq_dataRequest) @[MemoryController.scala 58:23]
    reg currentReq_activeByteLane : UInt<4>, clock with :
      reset => (UInt<1>("h0"), currentReq_activeByteLane) @[MemoryController.scala 58:23]
    reg currentReq_isWrite : UInt<1>, clock with :
      reset => (UInt<1>("h0"), currentReq_isWrite) @[MemoryController.scala 58:23]
    reg rspPending : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rspPending) @[MemoryController.scala 60:27]
    reg masterID : UInt<1>, clock with :
      reset => (UInt<1>("h0"), masterID) @[MemoryController.scala 63:25]
    node _io_dCacheReqOut_ready_T = mux(io_dCacheReqOut_valid, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 69:31]
    node _io_iCacheReqOut_ready_T = eq(io_dCacheReqOut_valid, UInt<1>("h0")) @[MemoryController.scala 70:32]
    node _io_iCacheReqOut_ready_T_1 = and(_io_iCacheReqOut_ready_T, io_iCacheReqOut_valid) @[MemoryController.scala 70:55]
    node _io_iCacheReqOut_ready_T_2 = mux(_io_iCacheReqOut_ready_T_1, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 70:31]
    node _io_SPIctrl_0_addr_T = bits(currentReq_addrRequest, 23, 0) @[MemoryController.scala 86:49]
    node _io_SPIctrl_1_addr_T = bits(currentReq_addrRequest, 23, 0) @[MemoryController.scala 86:49]
    node _GEN_0 = mux(iReqAck, io_iCacheReqOut_bits_addrRequest, currentReq_addrRequest) @[MemoryController.scala 98:22 99:16 58:23]
    node _GEN_1 = mux(iReqAck, io_iCacheReqOut_bits_dataRequest, currentReq_dataRequest) @[MemoryController.scala 98:22 99:16 58:23]
    node _GEN_2 = mux(iReqAck, io_iCacheReqOut_bits_activeByteLane, currentReq_activeByteLane) @[MemoryController.scala 98:22 99:16 58:23]
    node _GEN_3 = mux(iReqAck, io_iCacheReqOut_bits_isWrite, currentReq_isWrite) @[MemoryController.scala 98:22 99:16 58:23]
    node _GEN_4 = mux(iReqAck, UInt<1>("h1"), rspPending) @[MemoryController.scala 100:16 98:22 60:27]
    node _GEN_5 = mux(iReqAck, UInt<1>("h1"), masterID) @[MemoryController.scala 101:14 98:22 63:25]
    node _GEN_6 = mux(dReqAck, io_dCacheReqOut_bits_addrRequest, _GEN_0) @[MemoryController.scala 94:16 95:16]
    node _GEN_7 = mux(dReqAck, io_dCacheReqOut_bits_dataRequest, _GEN_1) @[MemoryController.scala 94:16 95:16]
    node _GEN_8 = mux(dReqAck, io_dCacheReqOut_bits_activeByteLane, _GEN_2) @[MemoryController.scala 94:16 95:16]
    node _GEN_9 = mux(dReqAck, io_dCacheReqOut_bits_isWrite, _GEN_3) @[MemoryController.scala 94:16 95:16]
    node _GEN_10 = mux(dReqAck, UInt<1>("h1"), _GEN_4) @[MemoryController.scala 94:16 96:16]
    node _GEN_11 = mux(dReqAck, UInt<1>("h0"), _GEN_5) @[MemoryController.scala 94:16 97:14]
    node _dataSize_T = eq(UInt<4>("hf"), currentReq_activeByteLane) @[Mux.scala 81:61]
    node _dataSize_T_1 = mux(_dataSize_T, UInt<3>("h4"), UInt<1>("h1")) @[Mux.scala 81:58]
    node _dataSize_T_2 = eq(UInt<4>("hc"), currentReq_activeByteLane) @[Mux.scala 81:61]
    node _dataSize_T_3 = mux(_dataSize_T_2, UInt<2>("h2"), _dataSize_T_1) @[Mux.scala 81:58]
    node _dataSize_T_4 = eq(UInt<2>("h3"), currentReq_activeByteLane) @[Mux.scala 81:61]
    node _dataSize_T_5 = mux(_dataSize_T_4, UInt<2>("h2"), _dataSize_T_3) @[Mux.scala 81:58]
    node _shiftAmount_T = bits(currentReq_activeByteLane, 0, 0) @[OneHot.scala 47:45]
    node _shiftAmount_T_1 = bits(currentReq_activeByteLane, 1, 1) @[OneHot.scala 47:45]
    node _shiftAmount_T_2 = bits(currentReq_activeByteLane, 2, 2) @[OneHot.scala 47:45]
    node _shiftAmount_T_3 = bits(currentReq_activeByteLane, 3, 3) @[OneHot.scala 47:45]
    node _shiftAmount_T_4 = mux(_shiftAmount_T_2, UInt<2>("h2"), UInt<2>("h3")) @[Mux.scala 47:70]
    node _shiftAmount_T_5 = mux(_shiftAmount_T_1, UInt<1>("h1"), _shiftAmount_T_4) @[Mux.scala 47:70]
    node shiftAmount = mux(_shiftAmount_T, UInt<1>("h0"), _shiftAmount_T_5) @[Mux.scala 47:70]
    node _data2write_T = mul(shiftAmount, UInt<4>("h8")) @[MemoryController.scala 115:59]
    node _data2write_T_1 = dshr(currentReq_dataRequest, _data2write_T) @[MemoryController.scala 115:43]
    node _GEN_12 = mux(currentReq_isWrite, _dataSize_T_5, UInt<3>("h4")) @[MemoryController.scala 105:27 107:14 118:14]
    node _GEN_13 = mux(currentReq_isWrite, _data2write_T_1, UInt<32>("h0")) @[MemoryController.scala 105:27 115:16 61:28]
    node _T_4 = bits(currentReq_addrRequest, 31, 28) @[MemoryController.scala 123:32]
    node _T_5 = eq(_T_4, UInt<4>("hf")) @[MemoryController.scala 123:41]
    node _T_6 = bits(currentReq_addrRequest, 24, 24) @[MemoryController.scala 125:38]
    node _T_7 = bits(currentReq_addrRequest, 24, 24) @[MemoryController.scala 129:39]
    node _T_8 = eq(_T_7, UInt<1>("h0")) @[MemoryController.scala 129:16]
    node _GEN_14 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 129:45 131:24 83:22]
    node _GEN_15 = mux(_T_6, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 125:44 127:24 83:22]
    node _GEN_16 = mux(_T_6, UInt<1>("h0"), _GEN_14) @[MemoryController.scala 125:44 83:22]
    node _GEN_17 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[MemoryController.scala 123:53 83:22]
    node _GEN_18 = mux(_T_5, UInt<1>("h0"), _GEN_16) @[MemoryController.scala 123:53 83:22]
    node _GEN_19 = mux(rspPending, _GEN_17, UInt<1>("h0")) @[MemoryController.scala 122:19 83:22]
    node _GEN_20 = mux(rspPending, _GEN_18, UInt<1>("h0")) @[MemoryController.scala 122:19 83:22]
    node _T_9 = eq(currentReq_isWrite, UInt<1>("h0")) @[MemoryController.scala 142:12]
    node _GEN_21 = mux(_T_9, io_SPIctrl_0_dataOut, UInt<32>("h0")) @[MemoryController.scala 142:33 143:18 62:26]
    node _GEN_22 = mux(io_SPIctrl_0_done, UInt<1>("h0"), _GEN_10) @[MemoryController.scala 140:30 141:18]
    node _GEN_23 = mux(io_SPIctrl_0_done, _GEN_21, UInt<32>("h0")) @[MemoryController.scala 140:30 62:26]
    node _GEN_24 = mux(io_SPIctrl_0_done, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 140:30 145:16 64:26]
    node _T_10 = eq(currentReq_isWrite, UInt<1>("h0")) @[MemoryController.scala 142:12]
    node _GEN_25 = mux(_T_10, io_SPIctrl_1_dataOut, _GEN_23) @[MemoryController.scala 142:33 143:18]
    node _GEN_26 = mux(io_SPIctrl_1_done, UInt<1>("h0"), _GEN_22) @[MemoryController.scala 140:30 141:18]
    node _GEN_27 = mux(io_SPIctrl_1_done, _GEN_25, _GEN_23) @[MemoryController.scala 140:30]
    node _GEN_28 = mux(io_SPIctrl_1_done, UInt<1>("h1"), _GEN_24) @[MemoryController.scala 140:30 145:16]
    node _GEN_29 = mux(masterID, UInt<1>("h1"), UInt<1>("h0")) @[MemoryController.scala 151:19 152:28 78:24]
    node _GEN_30 = mux(masterID, UInt<1>("h0"), UInt<1>("h1")) @[MemoryController.scala 151:19 77:24 154:28]
    node rspValid = _GEN_28 @[MemoryController.scala 64:26]
    node _GEN_31 = mux(rspValid, _GEN_29, UInt<1>("h0")) @[MemoryController.scala 150:17 78:24]
    node _GEN_32 = mux(rspValid, _GEN_30, UInt<1>("h0")) @[MemoryController.scala 150:17 77:24]
    node dataSize = _GEN_12 @[MemoryController.scala 59:26]
    node data2write = _GEN_13 @[MemoryController.scala 61:28]
    node readData = _GEN_27 @[MemoryController.scala 62:26]
    io_memIO_rdData <= memory.io_rdData @[MemoryController.scala 39:12]
    io_stall <= _io_stall_T @[MemoryController.scala 51:12]
    io_dCacheReqOut_ready <= _io_dCacheReqOut_ready_T @[MemoryController.scala 69:25]
    io_dCacheRspIn_valid <= _GEN_32
    io_dCacheRspIn_bits_dataResponse <= readData @[MemoryController.scala 73:36]
    io_dCacheRspIn_bits_error <= UInt<1>("h0") @[MemoryController.scala 75:29]
    io_iCacheReqOut_ready <= _io_iCacheReqOut_ready_T_2 @[MemoryController.scala 70:25]
    io_iCacheRspIn_valid <= _GEN_31
    io_iCacheRspIn_bits_dataResponse <= readData @[MemoryController.scala 74:36]
    io_iCacheRspIn_bits_error <= UInt<1>("h0") @[MemoryController.scala 76:29]
    io_SPIctrl_0_rst <= UInt<1>("h0") @[MemoryController.scala 85:23]
    io_SPIctrl_0_rw <= currentReq_isWrite @[MemoryController.scala 84:22]
    io_SPIctrl_0_en <= _GEN_20
    io_SPIctrl_0_addr <= _io_SPIctrl_0_addr_T @[MemoryController.scala 86:24]
    io_SPIctrl_0_dataIn <= data2write @[MemoryController.scala 87:26]
    io_SPIctrl_0_size <= dataSize @[MemoryController.scala 88:24]
    io_SPIctrl_1_rst <= UInt<1>("h0") @[MemoryController.scala 85:23]
    io_SPIctrl_1_rw <= currentReq_isWrite @[MemoryController.scala 84:22]
    io_SPIctrl_1_en <= _GEN_19
    io_SPIctrl_1_addr <= _io_SPIctrl_1_addr_T @[MemoryController.scala 86:24]
    io_SPIctrl_1_dataIn <= data2write @[MemoryController.scala 87:26]
    io_SPIctrl_1_size <= dataSize @[MemoryController.scala 88:24]
    memory.clock <= clock
    memory.reset <= reset
    memory.io_rdAddress <= io_memIO_rdAddress @[MemoryController.scala 39:12]
    memory.io_rdEnable <= io_memIO_rdEnable @[MemoryController.scala 39:12]
    memory.io_wrAddress <= io_memIO_wrAddress @[MemoryController.scala 39:12]
    memory.io_wrData <= io_memIO_wrData @[MemoryController.scala 39:12]
    memory.io_wrEnable_0 <= io_memIO_wrEnable_0 @[MemoryController.scala 39:12]
    memory.io_wrEnable_1 <= io_memIO_wrEnable_1 @[MemoryController.scala 39:12]
    memory.io_wrEnable_2 <= io_memIO_wrEnable_2 @[MemoryController.scala 39:12]
    memory.io_wrEnable_3 <= io_memIO_wrEnable_3 @[MemoryController.scala 39:12]
    currentReq_addrRequest <= _GEN_6
    currentReq_dataRequest <= _GEN_7
    currentReq_activeByteLane <= _GEN_8
    currentReq_isWrite <= _GEN_9
    rspPending <= mux(reset, UInt<1>("h0"), _GEN_26) @[MemoryController.scala 60:{27,27}]
    masterID <= mux(reset, UInt<1>("h0"), _GEN_11) @[MemoryController.scala 63:{25,25}]

  module SpiMemController :
    input clock : Clock
    input reset : UInt<1>
    input io_rst : UInt<1>
    input io_rw : UInt<1>
    input io_en : UInt<1>
    input io_addr : UInt<24>
    input io_dataIn : UInt<32>
    output io_dataOut : UInt<32>
    output io_done : UInt<1>
    output io_ce : UInt<1>
    output io_sclk : UInt<1>
    output io_si : UInt<1>
    input io_so : UInt<1>
    output io_sioIn : UInt<4>
    input io_sioOut : UInt<4>

    reg stateReg : UInt<4>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[SpiMemController.scala 47:27]
    reg shiftRegIn : UInt<32>, clock with :
      reset => (UInt<1>("h0"), shiftRegIn) @[SpiMemController.scala 49:29]
    reg shiftRegOut : UInt<32>, clock with :
      reset => (UInt<1>("h0"), shiftRegOut) @[SpiMemController.scala 50:30]
    reg bitCounter : UInt<6>, clock with :
      reset => (UInt<1>("h0"), bitCounter) @[SpiMemController.scala 51:29]
    reg sclkReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sclkReg) @[SpiMemController.scala 52:26]
    reg ceReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), ceReg) @[SpiMemController.scala 53:24]
    reg dataInReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), dataInReg) @[SpiMemController.scala 54:28]
    reg quadReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), quadReg) @[SpiMemController.scala 55:26]
    reg rstCnt : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rstCnt) @[SpiMemController.scala 58:25]
    node _T = eq(stateReg, UInt<3>("h6")) @[SpiMemController.scala 59:20]
    node _T_1 = and(_T, ceReg) @[SpiMemController.scala 59:28]
    node _rstCnt_T = add(rstCnt, UInt<1>("h1")) @[SpiMemController.scala 60:26]
    node _rstCnt_T_1 = tail(_rstCnt_T, 1) @[SpiMemController.scala 60:26]
    node _T_2 = eq(rstCnt, UInt<1>("h1")) @[SpiMemController.scala 61:22]
    node _GEN_0 = mux(_T_2, UInt<1>("h0"), _rstCnt_T_1) @[SpiMemController.scala 60:16 61:39 62:20]
    node _GEN_1 = mux(_T_1, _GEN_0, rstCnt) @[SpiMemController.scala 58:25 59:38]
    node _io_si_T = bits(shiftRegOut, 31, 31) @[SpiMemController.scala 69:25]
    node _io_sioIn_T = bits(shiftRegOut, 31, 28) @[SpiMemController.scala 70:28]
    node _shiftRegIn_T = cat(UInt<1>("h0"), io_sioOut) @[Cat.scala 33:92]
    node _shiftRegIn_T_1 = and(shiftRegIn, _shiftRegIn_T) @[SpiMemController.scala 71:30]
    node _io_done_T = eq(stateReg, UInt<3>("h4")) @[SpiMemController.scala 74:26]
    reg shiftRstReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), shiftRstReg) @[SpiMemController.scala 76:30]
    node _T_3 = asUInt(UInt<1>("h0")) @[SpiMemController.scala 80:23]
    node _T_4 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_5 = eq(_T_3, _T_4) @[SpiMemController.scala 80:23]
    node _T_6 = eq(quadReg, UInt<1>("h0")) @[SpiMemController.scala 82:19]
    node _io_sioIn_T_1 = bits(shiftRegOut, 31, 31) @[SpiMemController.scala 90:40]
    node _shiftRegOut_T = cat(UInt<2>("h2"), io_addr) @[Cat.scala 33:92]
    node _shiftRegOut_T_1 = cat(UInt<8>("heb"), io_addr) @[Cat.scala 33:92]
    node _GEN_2 = mux(io_rw, _shiftRegOut_T, _shiftRegOut_T_1) @[SpiMemController.scala 100:30 101:33 105:33]
    node _GEN_3 = mux(io_rw, UInt<4>("hf"), UInt<3>("h7")) @[SpiMemController.scala 100:30 102:32 106:32]
    node _GEN_4 = mux(io_rw, UInt<2>("h3"), UInt<2>("h2")) @[SpiMemController.scala 100:30 103:30 107:30]
    node _GEN_5 = mux(io_en, UInt<1>("h0"), ceReg) @[SpiMemController.scala 98:31 99:23 53:24]
    node _GEN_6 = mux(io_en, _GEN_2, shiftRegOut) @[SpiMemController.scala 50:30 98:31]
    node _GEN_7 = mux(io_en, _GEN_3, bitCounter) @[SpiMemController.scala 51:29 98:31]
    node _GEN_8 = mux(io_en, _GEN_4, stateReg) @[SpiMemController.scala 47:27 98:31]
    node _GEN_9 = mux(io_rst, UInt<1>("h0"), _GEN_5) @[SpiMemController.scala 92:32 93:23]
    node _GEN_10 = mux(io_rst, UInt<31>("h66000000"), _GEN_6) @[SpiMemController.scala 92:32 94:29]
    node _GEN_11 = mux(io_rst, UInt<1>("h1"), _GEN_7) @[SpiMemController.scala 92:32 95:28]
    node _GEN_12 = mux(io_rst, UInt<3>("h5"), _GEN_8) @[SpiMemController.scala 92:32 96:26]
    node _GEN_13 = mux(_T_6, UInt<1>("h1"), quadReg) @[SpiMemController.scala 82:29 85:25 55:26]
    node _GEN_14 = mux(_T_6, UInt<1>("h0"), _GEN_9) @[SpiMemController.scala 82:29 86:23]
    node _GEN_15 = mux(_T_6, UInt<30>("h35000000"), _GEN_10) @[SpiMemController.scala 82:29 87:29]
    node _GEN_16 = mux(_T_6, UInt<3>("h7"), _GEN_11) @[SpiMemController.scala 82:29 88:28]
    node _GEN_17 = mux(_T_6, UInt<1>("h1"), _GEN_12) @[SpiMemController.scala 82:29 89:26]
    node _GEN_18 = mux(_T_6, _io_sioIn_T_1, _io_sioIn_T) @[SpiMemController.scala 70:14 82:29 90:26]
    node _T_7 = asUInt(UInt<1>("h1")) @[SpiMemController.scala 80:23]
    node _T_8 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_9 = eq(_T_7, _T_8) @[SpiMemController.scala 80:23]
    node _io_sioIn_T_2 = bits(shiftRegOut, 31, 31) @[SpiMemController.scala 112:36]
    node _shiftRegOut_T_2 = shl(shiftRegOut, 1) @[SpiMemController.scala 113:40]
    node _bitCounter_T = sub(bitCounter, UInt<1>("h1")) @[SpiMemController.scala 114:38]
    node _bitCounter_T_1 = tail(_bitCounter_T, 1) @[SpiMemController.scala 114:38]
    node _T_10 = eq(bitCounter, UInt<1>("h0")) @[SpiMemController.scala 115:30]
    node _GEN_19 = mux(_T_10, UInt<1>("h0"), _shiftRegOut_T_2) @[SpiMemController.scala 113:25 115:39 116:29]
    node _GEN_20 = mux(_T_10, UInt<1>("h1"), ceReg) @[SpiMemController.scala 115:39 117:23 53:24]
    node _GEN_21 = mux(_T_10, UInt<3>("h4"), stateReg) @[SpiMemController.scala 115:39 118:26 47:27]
    node _T_11 = asUInt(UInt<2>("h2")) @[SpiMemController.scala 80:23]
    node _T_12 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_13 = eq(_T_11, _T_12) @[SpiMemController.scala 80:23]
    node _shiftRegOut_T_3 = shl(shiftRegOut, 4) @[SpiMemController.scala 127:40]
    node _bitCounter_T_2 = sub(bitCounter, UInt<1>("h1")) @[SpiMemController.scala 128:38]
    node _bitCounter_T_3 = tail(_bitCounter_T_2, 1) @[SpiMemController.scala 128:38]
    node _T_14 = eq(bitCounter, UInt<1>("h0")) @[SpiMemController.scala 129:30]
    reg counter : UInt<3>, clock with :
      reset => (UInt<1>("h0"), counter) @[SpiMemController.scala 35:30]
    reg end : UInt<1>, clock with :
      reset => (UInt<1>("h0"), end) @[SpiMemController.scala 36:26]
    node _T_15 = eq(end, UInt<1>("h0")) @[SpiMemController.scala 38:15]
    node _counter_T = add(counter, UInt<1>("h1")) @[SpiMemController.scala 39:36]
    node _counter_T_1 = tail(_counter_T, 1) @[SpiMemController.scala 39:36]
    node _T_16 = eq(counter, UInt<3>("h5")) @[SpiMemController.scala 40:31]
    node _GEN_22 = mux(_T_16, UInt<1>("h1"), end) @[SpiMemController.scala 40:46 41:25 36:26]
    node _GEN_23 = mux(_T_15, _counter_T_1, counter) @[SpiMemController.scala 38:21 39:25 35:30]
    node _GEN_24 = mux(_T_15, _GEN_22, end) @[SpiMemController.scala 38:21 36:26]
    node _GEN_25 = mux(_T_14, UInt<3>("h7"), _bitCounter_T_3) @[SpiMemController.scala 128:24 129:39 131:28]
    node _GEN_26 = mux(_T_14, UInt<4>("h9"), stateReg) @[SpiMemController.scala 129:39 132:26 47:27]
    node _T_17 = asUInt(UInt<4>("h9")) @[SpiMemController.scala 80:23]
    node _T_18 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_19 = eq(_T_17, _T_18) @[SpiMemController.scala 80:23]
    node _shiftRegIn_T_2 = shl(shiftRegIn, 4) @[SpiMemController.scala 138:38]
    node _bitCounter_T_4 = sub(bitCounter, UInt<1>("h1")) @[SpiMemController.scala 139:38]
    node _bitCounter_T_5 = tail(_bitCounter_T_4, 1) @[SpiMemController.scala 139:38]
    node _T_20 = eq(bitCounter, UInt<1>("h0")) @[SpiMemController.scala 140:30]
    node _GEN_27 = mux(_T_20, UInt<3>("h4"), stateReg) @[SpiMemController.scala 140:39 141:26 47:27]
    node _T_21 = asUInt(UInt<2>("h3")) @[SpiMemController.scala 80:23]
    node _T_22 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_23 = eq(_T_21, _T_22) @[SpiMemController.scala 80:23]
    node _shiftRegOut_T_4 = shl(shiftRegOut, 4) @[SpiMemController.scala 147:40]
    node _bitCounter_T_6 = sub(bitCounter, UInt<1>("h1")) @[SpiMemController.scala 148:38]
    node _bitCounter_T_7 = tail(_bitCounter_T_6, 1) @[SpiMemController.scala 148:38]
    node _T_24 = eq(bitCounter, UInt<4>("h8")) @[SpiMemController.scala 149:30]
    node _GEN_28 = mux(_T_24, io_dataIn, _shiftRegOut_T_4) @[SpiMemController.scala 147:25 149:39 151:29]
    node _T_25 = eq(bitCounter, UInt<1>("h0")) @[SpiMemController.scala 153:30]
    node _GEN_29 = mux(_T_25, UInt<1>("h1"), ceReg) @[SpiMemController.scala 153:39 154:23 53:24]
    node _GEN_30 = mux(_T_25, UInt<3>("h4"), stateReg) @[SpiMemController.scala 153:39 155:26 47:27]
    node _T_26 = asUInt(UInt<3>("h4")) @[SpiMemController.scala 80:23]
    node _T_27 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_28 = eq(_T_26, _T_27) @[SpiMemController.scala 80:23]
    node _T_29 = asUInt(UInt<3>("h5")) @[SpiMemController.scala 80:23]
    node _T_30 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_31 = eq(_T_29, _T_30) @[SpiMemController.scala 80:23]
    node _shiftRegOut_T_5 = shl(shiftRegOut, 4) @[SpiMemController.scala 165:40]
    node _bitCounter_T_8 = sub(bitCounter, UInt<1>("h1")) @[SpiMemController.scala 166:38]
    node _bitCounter_T_9 = tail(_bitCounter_T_8, 1) @[SpiMemController.scala 166:38]
    node _T_32 = eq(bitCounter, UInt<1>("h0")) @[SpiMemController.scala 167:30]
    node _GEN_31 = mux(_T_32, UInt<3>("h7"), stateReg) @[SpiMemController.scala 167:39 168:26 47:27]
    node _GEN_32 = mux(_T_32, UInt<1>("h1"), ceReg) @[SpiMemController.scala 167:39 169:23 53:24]
    node _T_33 = asUInt(UInt<3>("h6")) @[SpiMemController.scala 80:23]
    node _T_34 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_35 = eq(_T_33, _T_34) @[SpiMemController.scala 80:23]
    node _io_sioIn_T_3 = bits(shiftRstReg, 7, 4) @[SpiMemController.scala 174:36]
    node _shiftRstReg_T = shl(shiftRstReg, 4) @[SpiMemController.scala 176:40]
    node _bitCounter_T_10 = sub(bitCounter, UInt<1>("h1")) @[SpiMemController.scala 177:38]
    node _bitCounter_T_11 = tail(_bitCounter_T_10, 1) @[SpiMemController.scala 177:38]
    node _T_36 = eq(bitCounter, UInt<1>("h0")) @[SpiMemController.scala 178:30]
    node _GEN_33 = mux(_T_36, UInt<3>("h4"), stateReg) @[SpiMemController.scala 178:39 179:26 47:27]
    node _T_37 = asUInt(UInt<3>("h7")) @[SpiMemController.scala 80:23]
    node _T_38 = asUInt(stateReg) @[SpiMemController.scala 80:23]
    node _T_39 = eq(_T_37, _T_38) @[SpiMemController.scala 80:23]
    node _io_sioIn_T_4 = bits(shiftRstReg, 7, 4) @[SpiMemController.scala 186:36]
    node _GEN_34 = mux(_T_39, UInt<1>("h0"), ceReg) @[SpiMemController.scala 184:19 80:23 53:24]
    node _GEN_35 = mux(_T_39, UInt<8>("h99"), shiftRstReg) @[SpiMemController.scala 80:23 185:25 76:30]
    node _GEN_36 = mux(_T_39, _io_sioIn_T_4, _io_sioIn_T) @[SpiMemController.scala 186:22 70:14 80:23]
    node _GEN_37 = mux(_T_39, UInt<1>("h1"), bitCounter) @[SpiMemController.scala 80:23 187:24 51:29]
    node _GEN_38 = mux(_T_39, UInt<3>("h6"), stateReg) @[SpiMemController.scala 188:22 80:23 47:27]
    node _GEN_39 = mux(_T_35, _io_sioIn_T_3, _GEN_36) @[SpiMemController.scala 174:22 80:23]
    node _GEN_40 = mux(_T_35, _shiftRstReg_T, _GEN_35) @[SpiMemController.scala 80:23 176:25]
    node _GEN_41 = mux(_T_35, _bitCounter_T_11, _GEN_37) @[SpiMemController.scala 80:23 177:24]
    node _GEN_42 = mux(_T_35, _GEN_33, _GEN_38) @[SpiMemController.scala 80:23]
    node _GEN_43 = mux(_T_35, ceReg, _GEN_34) @[SpiMemController.scala 80:23 53:24]
    node _GEN_44 = mux(_T_31, _shiftRegOut_T_5, shiftRegOut) @[SpiMemController.scala 80:23 165:25 50:30]
    node _GEN_45 = mux(_T_31, _bitCounter_T_9, _GEN_41) @[SpiMemController.scala 80:23 166:24]
    node _GEN_46 = mux(_T_31, _GEN_31, _GEN_42) @[SpiMemController.scala 80:23]
    node _GEN_47 = mux(_T_31, _GEN_32, _GEN_43) @[SpiMemController.scala 80:23]
    node _GEN_48 = mux(_T_31, _io_sioIn_T, _GEN_39) @[SpiMemController.scala 70:14 80:23]
    node _GEN_49 = mux(_T_31, shiftRstReg, _GEN_40) @[SpiMemController.scala 80:23 76:30]
    node _GEN_50 = mux(_T_28, UInt<1>("h1"), _GEN_47) @[SpiMemController.scala 160:19 80:23]
    node _GEN_51 = mux(_T_28, UInt<1>("h0"), _GEN_46) @[SpiMemController.scala 161:22 80:23]
    node _GEN_52 = mux(_T_28, shiftRegOut, _GEN_44) @[SpiMemController.scala 80:23 50:30]
    node _GEN_53 = mux(_T_28, bitCounter, _GEN_45) @[SpiMemController.scala 80:23 51:29]
    node _GEN_54 = mux(_T_28, _io_sioIn_T, _GEN_48) @[SpiMemController.scala 70:14 80:23]
    node _GEN_55 = mux(_T_28, shiftRstReg, _GEN_49) @[SpiMemController.scala 80:23 76:30]
    node _GEN_56 = mux(_T_23, _GEN_28, _GEN_52) @[SpiMemController.scala 80:23]
    node _GEN_57 = mux(_T_23, _bitCounter_T_7, _GEN_53) @[SpiMemController.scala 80:23 148:24]
    node _GEN_58 = mux(_T_23, _GEN_29, _GEN_50) @[SpiMemController.scala 80:23]
    node _GEN_59 = mux(_T_23, _GEN_30, _GEN_51) @[SpiMemController.scala 80:23]
    node _GEN_60 = mux(_T_23, _io_sioIn_T, _GEN_54) @[SpiMemController.scala 70:14 80:23]
    node _GEN_61 = mux(_T_23, shiftRstReg, _GEN_55) @[SpiMemController.scala 80:23 76:30]
    node _GEN_62 = mux(_T_19, _shiftRegIn_T_2, _shiftRegIn_T_1) @[SpiMemController.scala 80:23 138:24 71:16]
    node _GEN_63 = mux(_T_19, _bitCounter_T_5, _GEN_57) @[SpiMemController.scala 80:23 139:24]
    node _GEN_64 = mux(_T_19, _GEN_27, _GEN_59) @[SpiMemController.scala 80:23]
    node _GEN_65 = mux(_T_19, shiftRegOut, _GEN_56) @[SpiMemController.scala 80:23 50:30]
    node _GEN_66 = mux(_T_19, ceReg, _GEN_58) @[SpiMemController.scala 80:23 53:24]
    node _GEN_67 = mux(_T_19, _io_sioIn_T, _GEN_60) @[SpiMemController.scala 70:14 80:23]
    node _GEN_68 = mux(_T_19, shiftRstReg, _GEN_61) @[SpiMemController.scala 80:23 76:30]
    node _GEN_69 = mux(_T_13, _shiftRegOut_T_3, _GEN_65) @[SpiMemController.scala 80:23 127:25]
    node _GEN_70 = mux(_T_13, _GEN_25, _GEN_63) @[SpiMemController.scala 80:23]
    node _GEN_71 = mux(_T_13, _GEN_26, _GEN_64) @[SpiMemController.scala 80:23]
    node _GEN_72 = mux(_T_13, _shiftRegIn_T_1, _GEN_62) @[SpiMemController.scala 71:16 80:23]
    node _GEN_73 = mux(_T_13, ceReg, _GEN_66) @[SpiMemController.scala 80:23 53:24]
    node _GEN_74 = mux(_T_13, _io_sioIn_T, _GEN_67) @[SpiMemController.scala 70:14 80:23]
    node _GEN_75 = mux(_T_13, shiftRstReg, _GEN_68) @[SpiMemController.scala 80:23 76:30]
    node _GEN_76 = mux(_T_9, _io_sioIn_T_2, _GEN_74) @[SpiMemController.scala 112:22 80:23]
    node _GEN_77 = mux(_T_9, _GEN_19, _GEN_69) @[SpiMemController.scala 80:23]
    node _GEN_78 = mux(_T_9, _bitCounter_T_1, _GEN_70) @[SpiMemController.scala 80:23 114:24]
    node _GEN_79 = mux(_T_9, _GEN_20, _GEN_73) @[SpiMemController.scala 80:23]
    node _GEN_80 = mux(_T_9, _GEN_21, _GEN_71) @[SpiMemController.scala 80:23]
    node _GEN_81 = mux(_T_9, _shiftRegIn_T_1, _GEN_72) @[SpiMemController.scala 71:16 80:23]
    node _GEN_82 = mux(_T_9, shiftRstReg, _GEN_75) @[SpiMemController.scala 80:23 76:30]
    node _GEN_83 = mux(_T_5, _GEN_13, quadReg) @[SpiMemController.scala 80:23 55:26]
    node _GEN_84 = mux(_T_5, _GEN_14, _GEN_79) @[SpiMemController.scala 80:23]
    node _GEN_85 = mux(_T_5, _GEN_15, _GEN_77) @[SpiMemController.scala 80:23]
    node _GEN_86 = mux(_T_5, _GEN_16, _GEN_78) @[SpiMemController.scala 80:23]
    node _GEN_87 = mux(_T_5, _GEN_17, _GEN_80) @[SpiMemController.scala 80:23]
    node _GEN_88 = mux(_T_5, _GEN_18, _GEN_76) @[SpiMemController.scala 80:23]
    node _GEN_89 = mux(_T_5, _shiftRegIn_T_1, _GEN_81) @[SpiMemController.scala 71:16 80:23]
    node _GEN_90 = mux(_T_5, shiftRstReg, _GEN_82) @[SpiMemController.scala 80:23 76:30]
    io_dataOut <= UInt<32>("h0") @[SpiMemController.scala 78:16]
    io_done <= _io_done_T @[SpiMemController.scala 74:13]
    io_ce <= ceReg @[SpiMemController.scala 67:11]
    io_sclk <= sclkReg @[SpiMemController.scala 66:13]
    io_si <= _io_si_T @[SpiMemController.scala 69:11]
    io_sioIn <= _GEN_88
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_87) @[SpiMemController.scala 47:{27,27}]
    shiftRegIn <= bits(mux(reset, UInt<32>("h0"), _GEN_89), 31, 0) @[SpiMemController.scala 49:{29,29}]
    shiftRegOut <= bits(mux(reset, UInt<32>("h0"), _GEN_85), 31, 0) @[SpiMemController.scala 50:{30,30}]
    bitCounter <= mux(reset, UInt<6>("h0"), _GEN_86) @[SpiMemController.scala 51:{29,29}]
    sclkReg <= mux(reset, UInt<1>("h0"), sclkReg) @[SpiMemController.scala 52:{26,26,26}]
    ceReg <= mux(reset, UInt<1>("h0"), _GEN_84) @[SpiMemController.scala 53:{24,24}]
    dataInReg <= mux(reset, UInt<32>("h0"), io_dataIn) @[SpiMemController.scala 54:{28,28} 73:15]
    quadReg <= mux(reset, UInt<1>("h0"), _GEN_83) @[SpiMemController.scala 55:{26,26}]
    rstCnt <= mux(reset, UInt<1>("h0"), _GEN_1) @[SpiMemController.scala 58:{25,25}]
    shiftRstReg <= bits(mux(reset, UInt<8>("h0"), _GEN_90), 7, 0) @[SpiMemController.scala 76:{30,30}]
    counter <= mux(reset, UInt<3>("h0"), _GEN_23) @[SpiMemController.scala 35:{30,30}]
    end <= mux(reset, UInt<1>("h0"), _GEN_24) @[SpiMemController.scala 36:{26,26}]

  module SPITop :
    input clock : Clock
    input reset : UInt<1>
    input io__memSPIctrl_0_rst : UInt<1>
    input io__memSPIctrl_0_rw : UInt<1>
    input io__memSPIctrl_0_en : UInt<1>
    input io__memSPIctrl_0_addr : UInt<24>
    input io__memSPIctrl_0_dataIn : UInt<32>
    output io__memSPIctrl_0_dataOut : UInt<32>
    output io__memSPIctrl_0_done : UInt<1>
    input io__memSPIctrl_0_size : UInt<3>
    input io__memSPIctrl_1_rst : UInt<1>
    input io__memSPIctrl_1_rw : UInt<1>
    input io__memSPIctrl_1_en : UInt<1>
    input io__memSPIctrl_1_addr : UInt<24>
    input io__memSPIctrl_1_dataIn : UInt<32>
    output io__memSPIctrl_1_dataOut : UInt<32>
    output io__memSPIctrl_1_done : UInt<1>
    input io__memSPIctrl_1_size : UInt<3>
    output io__clk : Clock
    output io__si : UInt<4>
    input io__so : UInt<4>
    output io__dir : UInt<1>
    output io__CS0out : UInt<1>
    output io__CS1out : UInt<1>
    output io_si : UInt<4>

    inst SPICTRL0 of SpiMemController @[SPITop.scala 19:24]
    inst SPICTRL1 of SpiMemController @[SPITop.scala 20:24]
    node _T = eq(SPICTRL0.io_ce, UInt<1>("h0")) @[SPITop.scala 52:8]
    node _T_1 = eq(SPICTRL1.io_ce, UInt<1>("h0")) @[SPITop.scala 54:14]
    node _GEN_0 = mux(_T_1, SPICTRL1.io_si, UInt<1>("h0")) @[SPITop.scala 54:30 55:11 57:11]
    node _GEN_1 = mux(_T, SPICTRL0.io_si, _GEN_0) @[SPITop.scala 52:24 53:11]
    io__memSPIctrl_0_dataOut <= SPICTRL0.io_dataOut @[SPITop.scala 30:28]
    io__memSPIctrl_0_done <= SPICTRL0.io_done @[SPITop.scala 31:25]
    io__memSPIctrl_1_dataOut <= SPICTRL1.io_dataOut @[SPITop.scala 39:28]
    io__memSPIctrl_1_done <= SPICTRL1.io_done @[SPITop.scala 40:25]
    io__clk <= clock @[SPITop.scala 62:10]
    io__si <= pad(_GEN_1, 4)
    io__dir <= UInt<1>("h1") @[SPITop.scala 43:10]
    io__CS0out <= SPICTRL0.io_ce @[SPITop.scala 60:13]
    io__CS1out <= SPICTRL1.io_ce @[SPITop.scala 61:13]
    io_si <= io__si
    SPICTRL0.clock <= clock
    SPICTRL0.reset <= reset
    SPICTRL0.io_rst <= io__memSPIctrl_0_rst @[SPITop.scala 25:19]
    SPICTRL0.io_rw <= io__memSPIctrl_0_rw @[SPITop.scala 26:18]
    SPICTRL0.io_en <= io__memSPIctrl_0_en @[SPITop.scala 27:18]
    SPICTRL0.io_addr <= io__memSPIctrl_0_addr @[SPITop.scala 28:20]
    SPICTRL0.io_dataIn <= io__memSPIctrl_0_dataIn @[SPITop.scala 29:22]
    SPICTRL0.io_so <= bits(io__so, 0, 0) @[SPITop.scala 21:18]
    SPICTRL0.io_sioOut is invalid
    SPICTRL1.clock <= clock
    SPICTRL1.reset <= reset
    SPICTRL1.io_rst <= io__memSPIctrl_1_rst @[SPITop.scala 34:19]
    SPICTRL1.io_rw <= io__memSPIctrl_1_rw @[SPITop.scala 35:18]
    SPICTRL1.io_en <= io__memSPIctrl_1_en @[SPITop.scala 36:18]
    SPICTRL1.io_addr <= io__memSPIctrl_1_addr @[SPITop.scala 37:20]
    SPICTRL1.io_dataIn <= io__memSPIctrl_1_dataIn @[SPITop.scala 38:22]
    SPICTRL1.io_so <= bits(io__so, 0, 0) @[SPITop.scala 22:18]
    SPICTRL1.io_sioOut is invalid

  module PSRAM_Model :
    input clock : Clock
    input reset : UInt<1>
    input io_CS : UInt<1>
    input io_IN : UInt<4>
    output io_OUT : UInt<4>
    output lastCommand_0 : UInt<8>
    output mode_1 : UInt<2>

    mem mem : @[PSRAM_Model.scala 26:24]
      data-type => UInt<8>
      depth => 2048
      read-latency => 1
      write-latency => 1
      reader => readMemVal_MPORT
      writer => MPORT
      read-under-write => undefined
    reg address : UInt<24>, clock with :
      reset => (UInt<1>("h0"), address) @[PSRAM_Model.scala 28:24]
    reg mode : UInt<2>, clock with :
      reset => (UInt<1>("h0"), mode) @[PSRAM_Model.scala 29:21]
    reg idx : UInt<3>, clock with :
      reset => (UInt<1>("h0"), idx) @[PSRAM_Model.scala 30:20]
    reg lastRead : UInt<8>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[PSRAM_Model.scala 31:25]
    reg rw : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rw) @[PSRAM_Model.scala 32:19]
    reg waitDone : UInt<1>, clock with :
      reset => (UInt<1>("h0"), waitDone) @[PSRAM_Model.scala 34:25]
    reg lastCommand : UInt<8>, clock with :
      reset => (UInt<1>("h0"), lastCommand) @[PSRAM_Model.scala 36:28]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[PSRAM_Model.scala 48:25]
    node _T = asUInt(UInt<1>("h0")) @[PSRAM_Model.scala 50:19]
    node _T_1 = asUInt(stateReg) @[PSRAM_Model.scala 50:19]
    node _T_2 = eq(_T, _T_1) @[PSRAM_Model.scala 50:19]
    node _T_3 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 52:12]
    node _T_4 = bits(mode, 0, 0) @[PSRAM_Model.scala 53:19]
    node _T_5 = eq(_T_4, UInt<1>("h0")) @[PSRAM_Model.scala 53:14]
    node _lastRead_T = bits(lastRead, 6, 0) @[PSRAM_Model.scala 54:31]
    node _lastRead_T_1 = bits(io_IN, 0, 0) @[PSRAM_Model.scala 54:45]
    node _lastRead_T_2 = cat(_lastRead_T, _lastRead_T_1) @[PSRAM_Model.scala 54:37]
    node _command_T = bits(lastRead, 6, 0) @[PSRAM_Model.scala 55:30]
    node _command_T_1 = bits(io_IN, 0, 0) @[PSRAM_Model.scala 55:44]
    node _command_T_2 = cat(_command_T, _command_T_1) @[PSRAM_Model.scala 55:36]
    node _lastRead_T_3 = bits(lastRead, 3, 0) @[PSRAM_Model.scala 59:31]
    node _lastRead_T_4 = cat(_lastRead_T_3, io_IN) @[PSRAM_Model.scala 59:37]
    node _command_T_3 = bits(lastRead, 3, 0) @[PSRAM_Model.scala 60:30]
    node _command_T_4 = cat(_command_T_3, io_IN) @[PSRAM_Model.scala 60:36]
    node _GEN_7 = mux(_T_5, _command_T_2, _command_T_4) @[PSRAM_Model.scala 53:24 55:19 60:19]
    node _GEN_15 = mux(_T_3, _GEN_7, UInt<8>("h0")) @[PSRAM_Model.scala 52:19 27:25]
    node _GEN_113 = mux(_T_2, _GEN_15, UInt<8>("h0")) @[PSRAM_Model.scala 50:19 27:25]
    node command = _GEN_113 @[PSRAM_Model.scala 27:25]
    node _T_6 = eq(UInt<8>("h2"), command) @[PSRAM_Model.scala 62:27]
    node _T_7 = eq(UInt<8>("heb"), command) @[PSRAM_Model.scala 62:27]
    node _GEN_0 = mux(_T_7, UInt<1>("h1"), rw) @[PSRAM_Model.scala 62:27 69:18 32:19]
    node _GEN_1 = mux(_T_7, UInt<1>("h0"), address) @[PSRAM_Model.scala 62:27 70:23 28:24]
    node _GEN_2 = mux(_T_7, UInt<1>("h1"), stateReg) @[PSRAM_Model.scala 62:27 71:24 48:25]
    node _GEN_3 = mux(_T_6, UInt<1>("h0"), _GEN_0) @[PSRAM_Model.scala 62:27 64:18]
    node _GEN_4 = mux(_T_6, UInt<1>("h0"), _GEN_1) @[PSRAM_Model.scala 62:27 65:23]
    node _GEN_5 = mux(_T_6, UInt<1>("h1"), _GEN_2) @[PSRAM_Model.scala 62:27 66:24]
    node _GEN_6 = mux(_T_5, _lastRead_T_2, _lastRead_T_4) @[PSRAM_Model.scala 53:24 54:20 59:20]
    node _GEN_8 = mux(_T_5, rw, _GEN_3) @[PSRAM_Model.scala 32:19 53:24]
    node _GEN_9 = mux(_T_5, address, _GEN_4) @[PSRAM_Model.scala 28:24 53:24]
    node _GEN_10 = mux(_T_5, stateReg, _GEN_5) @[PSRAM_Model.scala 53:24 48:25]
    node _T_8 = eq(UInt<8>("h35"), lastCommand) @[PSRAM_Model.scala 78:29]
    node _mode_T = or(mode, UInt<1>("h1")) @[PSRAM_Model.scala 80:27]
    node _T_9 = eq(UInt<8>("hf5"), lastCommand) @[PSRAM_Model.scala 78:29]
    node _mode_T_1 = and(mode, UInt<1>("h0")) @[PSRAM_Model.scala 83:26]
    node _T_10 = eq(UInt<8>("hc0"), lastCommand) @[PSRAM_Model.scala 78:29]
    node _mode_T_2 = xor(mode, UInt<2>("h2")) @[PSRAM_Model.scala 86:26]
    node _GEN_11 = mux(_T_10, _mode_T_2, mode) @[PSRAM_Model.scala 78:29 86:18 29:21]
    node _GEN_12 = mux(_T_9, _mode_T_1, _GEN_11) @[PSRAM_Model.scala 78:29 83:18]
    node _GEN_13 = mux(_T_8, _mode_T, _GEN_12) @[PSRAM_Model.scala 78:29 80:18]
    node _GEN_14 = mux(_T_3, _GEN_6, io_IN) @[PSRAM_Model.scala 40:12 52:19]
    node _GEN_16 = mux(_T_3, _GEN_8, rw) @[PSRAM_Model.scala 32:19 52:19]
    node _GEN_17 = mux(_T_3, _GEN_9, address) @[PSRAM_Model.scala 52:19 28:24]
    node _GEN_18 = mux(_T_3, _GEN_10, stateReg) @[PSRAM_Model.scala 52:19 48:25]
    node _GEN_19 = mux(_T_3, command, lastCommand) @[PSRAM_Model.scala 52:19 75:21 36:28]
    node _GEN_20 = mux(_T_3, mode, _GEN_13) @[PSRAM_Model.scala 52:19 29:21]
    node _T_11 = asUInt(UInt<1>("h1")) @[PSRAM_Model.scala 50:19]
    node _T_12 = asUInt(stateReg) @[PSRAM_Model.scala 50:19]
    node _T_13 = eq(_T_11, _T_12) @[PSRAM_Model.scala 50:19]
    node _T_14 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 94:12]
    node _address_T = cat(address, io_IN) @[PSRAM_Model.scala 95:28]
    node _T_15 = eq(idx, UInt<3>("h5")) @[PSRAM_Model.scala 97:18]
    node _GEN_21 = mux(rw, UInt<2>("h2"), UInt<2>("h3")) @[PSRAM_Model.scala 99:19 100:22 103:22]
    node _GEN_22 = mux(rw, UInt<1>("h0"), waitDone) @[PSRAM_Model.scala 99:19 101:22 34:25]
    node _idx_T = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 106:22]
    node _idx_T_1 = tail(_idx_T, 1) @[PSRAM_Model.scala 106:22]
    node _GEN_23 = mux(_T_15, UInt<1>("h0"), _idx_T_1) @[PSRAM_Model.scala 106:15 97:27 98:15]
    node _GEN_24 = mux(_T_15, _GEN_21, stateReg) @[PSRAM_Model.scala 48:25 97:27]
    node _GEN_25 = mux(_T_15, _GEN_22, waitDone) @[PSRAM_Model.scala 34:25 97:27]
    node _GEN_26 = mux(_T_14, _address_T, address) @[PSRAM_Model.scala 94:20 95:17 28:24]
    node _GEN_27 = mux(_T_14, _GEN_23, idx) @[PSRAM_Model.scala 30:20 94:20]
    node _GEN_28 = mux(_T_14, _GEN_24, UInt<1>("h0")) @[PSRAM_Model.scala 109:18 94:20]
    node _GEN_29 = mux(_T_14, _GEN_25, waitDone) @[PSRAM_Model.scala 94:20 34:25]
    node _T_16 = asUInt(UInt<2>("h2")) @[PSRAM_Model.scala 50:19]
    node _T_17 = asUInt(stateReg) @[PSRAM_Model.scala 50:19]
    node _T_18 = eq(_T_16, _T_17) @[PSRAM_Model.scala 50:19]
    node _T_19 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 113:12]
    node _GEN_30 = validif(UInt<1>("h1"), address) @[PSRAM_Model.scala 114:{31,31}]
    node _readMemVal_WIRE = _GEN_30 @[PSRAM_Model.scala 114:31]
    node _readMemVal_T = or(_readMemVal_WIRE, UInt<11>("h0")) @[PSRAM_Model.scala 114:31]
    node _readMemVal_T_1 = bits(_readMemVal_T, 10, 0) @[PSRAM_Model.scala 114:31]
    node _GEN_31 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[PSRAM_Model.scala 114:{31,31} 26:24]
    node _GEN_32 = validif(UInt<1>("h1"), _readMemVal_T_1) @[PSRAM_Model.scala 114:{31,31}]
    node _GEN_33 = validif(UInt<1>("h1"), clock) @[PSRAM_Model.scala 114:{31,31}]
    node _T_20 = eq(waitDone, UInt<1>("h0")) @[PSRAM_Model.scala 115:14]
    node _T_21 = eq(idx, UInt<3>("h7")) @[PSRAM_Model.scala 116:20]
    node _idx_T_2 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 121:24]
    node _idx_T_3 = tail(_idx_T_2, 1) @[PSRAM_Model.scala 121:24]
    node _GEN_34 = mux(_T_21, UInt<1>("h1"), waitDone) @[PSRAM_Model.scala 116:29 117:22 34:25]
    node _GEN_35 = mux(_T_21, UInt<1>("h0"), _idx_T_3) @[PSRAM_Model.scala 116:29 119:17 121:17]
    node _T_22 = eq(idx, UInt<1>("h1")) @[PSRAM_Model.scala 124:20]
    node _GEN_46 = mux(_T_19, mem.readMemVal_MPORT.data, UInt<8>("h0")) @[PSRAM_Model.scala 113:20 114:20 33:28]
    node _GEN_83 = mux(_T_18, _GEN_46, UInt<8>("h0")) @[PSRAM_Model.scala 50:19 33:28]
    node _GEN_103 = mux(_T_13, UInt<8>("h0"), _GEN_83) @[PSRAM_Model.scala 50:19 33:28]
    node _GEN_124 = mux(_T_2, UInt<8>("h0"), _GEN_103) @[PSRAM_Model.scala 50:19 33:28]
    node readMemVal = _GEN_124 @[PSRAM_Model.scala 33:28]
    node _io_OUT_T = bits(readMemVal, 3, 0) @[PSRAM_Model.scala 125:33]
    node _io_OUT_T_1 = bits(readMemVal, 7, 4) @[PSRAM_Model.scala 128:33]
    node _idx_T_4 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 129:24]
    node _idx_T_5 = tail(_idx_T_4, 1) @[PSRAM_Model.scala 129:24]
    node _address_T_1 = add(address, UInt<1>("h1")) @[PSRAM_Model.scala 130:32]
    node _address_T_2 = tail(_address_T_1, 1) @[PSRAM_Model.scala 130:32]
    node _GEN_36 = mux(_T_22, _io_OUT_T, _io_OUT_T_1) @[PSRAM_Model.scala 124:28 125:20 128:20]
    node _GEN_37 = mux(_T_22, UInt<1>("h0"), _idx_T_5) @[PSRAM_Model.scala 124:28 126:17 129:17]
    node _GEN_38 = mux(_T_22, address, _address_T_2) @[PSRAM_Model.scala 124:28 130:21 28:24]
    node _GEN_39 = mux(_T_20, _GEN_34, waitDone) @[PSRAM_Model.scala 115:25 34:25]
    node _GEN_40 = mux(_T_20, _GEN_35, _GEN_37) @[PSRAM_Model.scala 115:25]
    node _GEN_41 = mux(_T_20, UInt<1>("h0"), _GEN_36) @[PSRAM_Model.scala 115:25 41:10]
    node _GEN_42 = mux(_T_20, address, _GEN_38) @[PSRAM_Model.scala 115:25 28:24]
    node _GEN_43 = mux(_T_19, _GEN_31, UInt<1>("h0")) @[PSRAM_Model.scala 113:20 26:24]
    node _GEN_44 = validif(_T_19, _GEN_32) @[PSRAM_Model.scala 113:20]
    node _GEN_45 = validif(_T_19, _GEN_33) @[PSRAM_Model.scala 113:20]
    node _GEN_47 = mux(_T_19, _GEN_39, waitDone) @[PSRAM_Model.scala 113:20 34:25]
    node _GEN_48 = mux(_T_19, _GEN_40, idx) @[PSRAM_Model.scala 113:20 30:20]
    node _GEN_49 = mux(_T_19, _GEN_41, UInt<1>("h0")) @[PSRAM_Model.scala 113:20 41:10]
    node _GEN_50 = mux(_T_19, _GEN_42, address) @[PSRAM_Model.scala 113:20 28:24]
    node _GEN_51 = mux(_T_19, stateReg, UInt<1>("h0")) @[PSRAM_Model.scala 113:20 136:18 48:25]
    node _T_23 = asUInt(UInt<2>("h3")) @[PSRAM_Model.scala 50:19]
    node _T_24 = asUInt(stateReg) @[PSRAM_Model.scala 50:19]
    node _T_25 = eq(_T_23, _T_24) @[PSRAM_Model.scala 50:19]
    node _T_26 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 140:12]
    node _lastRead_T_5 = bits(lastRead, 3, 0) @[PSRAM_Model.scala 141:29]
    node _lastRead_T_6 = cat(_lastRead_T_5, io_IN) @[PSRAM_Model.scala 141:35]
    node _val2Write_T = bits(lastRead, 3, 0) @[PSRAM_Model.scala 142:30]
    node _val2Write_T_1 = cat(_val2Write_T, io_IN) @[PSRAM_Model.scala 142:36]
    node _T_27 = eq(idx, UInt<1>("h1")) @[PSRAM_Model.scala 143:18]
    node _T_28 = bits(address, 10, 0)
    node _address_T_3 = add(address, UInt<1>("h1")) @[PSRAM_Model.scala 146:30]
    node _address_T_4 = tail(_address_T_3, 1) @[PSRAM_Model.scala 146:30]
    node _idx_T_6 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 149:22]
    node _idx_T_7 = tail(_idx_T_6, 1) @[PSRAM_Model.scala 149:22]
    node _GEN_52 = validif(_T_27, _T_28) @[PSRAM_Model.scala 143:27]
    node _GEN_53 = validif(_T_27, clock) @[PSRAM_Model.scala 143:27]
    node _GEN_54 = mux(_T_27, UInt<1>("h1"), UInt<1>("h0")) @[PSRAM_Model.scala 143:27 26:24]
    node _GEN_55 = validif(_T_27, UInt<1>("h1")) @[PSRAM_Model.scala 143:27]
    node _GEN_61 = mux(_T_26, _val2Write_T_1, UInt<8>("h0")) @[PSRAM_Model.scala 140:20 142:19 35:27]
    node _GEN_71 = mux(_T_25, _GEN_61, UInt<8>("h0")) @[PSRAM_Model.scala 50:19 35:27]
    node _GEN_90 = mux(_T_18, UInt<8>("h0"), _GEN_71) @[PSRAM_Model.scala 50:19 35:27]
    node _GEN_106 = mux(_T_13, UInt<8>("h0"), _GEN_90) @[PSRAM_Model.scala 50:19 35:27]
    node _GEN_126 = mux(_T_2, UInt<8>("h0"), _GEN_106) @[PSRAM_Model.scala 50:19 35:27]
    node val2Write = _GEN_126 @[PSRAM_Model.scala 35:27]
    node _GEN_56 = validif(_T_27, val2Write) @[PSRAM_Model.scala 143:27]
    node _GEN_57 = mux(_T_27, UInt<1>("h0"), _idx_T_7) @[PSRAM_Model.scala 143:27 145:15 149:15]
    node _GEN_58 = mux(_T_27, _address_T_4, address) @[PSRAM_Model.scala 143:27 146:19 28:24]
    node _GEN_59 = mux(_T_27, UInt<1>("h0"), _lastRead_T_6) @[PSRAM_Model.scala 141:18 143:27 147:20]
    node _GEN_60 = mux(_T_26, _GEN_59, io_IN) @[PSRAM_Model.scala 140:20 40:12]
    node _GEN_62 = validif(_T_26, _GEN_52) @[PSRAM_Model.scala 140:20]
    node _GEN_63 = validif(_T_26, _GEN_53) @[PSRAM_Model.scala 140:20]
    node _GEN_64 = mux(_T_26, _GEN_54, UInt<1>("h0")) @[PSRAM_Model.scala 140:20 26:24]
    node _GEN_65 = validif(_T_26, _GEN_55) @[PSRAM_Model.scala 140:20]
    node _GEN_66 = validif(_T_26, _GEN_56) @[PSRAM_Model.scala 140:20]
    node _GEN_67 = mux(_T_26, _GEN_57, idx) @[PSRAM_Model.scala 140:20 30:20]
    node _GEN_68 = mux(_T_26, _GEN_58, address) @[PSRAM_Model.scala 140:20 28:24]
    node _GEN_69 = mux(_T_26, stateReg, UInt<1>("h0")) @[PSRAM_Model.scala 140:20 153:18 48:25]
    node _GEN_70 = mux(_T_25, _GEN_60, io_IN) @[PSRAM_Model.scala 40:12 50:19]
    node _GEN_72 = validif(_T_25, _GEN_62) @[PSRAM_Model.scala 50:19]
    node _GEN_73 = validif(_T_25, _GEN_63) @[PSRAM_Model.scala 50:19]
    node _GEN_74 = mux(_T_25, _GEN_64, UInt<1>("h0")) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_75 = validif(_T_25, _GEN_65) @[PSRAM_Model.scala 50:19]
    node _GEN_76 = validif(_T_25, _GEN_66) @[PSRAM_Model.scala 50:19]
    node _GEN_77 = mux(_T_25, _GEN_67, idx) @[PSRAM_Model.scala 50:19 30:20]
    node _GEN_78 = mux(_T_25, _GEN_68, address) @[PSRAM_Model.scala 50:19 28:24]
    node _GEN_79 = mux(_T_25, _GEN_69, stateReg) @[PSRAM_Model.scala 50:19 48:25]
    node _GEN_80 = mux(_T_18, _GEN_43, UInt<1>("h0")) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_81 = validif(_T_18, _GEN_44) @[PSRAM_Model.scala 50:19]
    node _GEN_82 = validif(_T_18, _GEN_45) @[PSRAM_Model.scala 50:19]
    node _GEN_84 = mux(_T_18, _GEN_47, waitDone) @[PSRAM_Model.scala 50:19 34:25]
    node _GEN_85 = mux(_T_18, _GEN_48, _GEN_77) @[PSRAM_Model.scala 50:19]
    node _GEN_86 = mux(_T_18, _GEN_49, UInt<1>("h0")) @[PSRAM_Model.scala 41:10 50:19]
    node _GEN_87 = mux(_T_18, _GEN_50, _GEN_78) @[PSRAM_Model.scala 50:19]
    node _GEN_88 = mux(_T_18, _GEN_51, _GEN_79) @[PSRAM_Model.scala 50:19]
    node _GEN_89 = mux(_T_18, io_IN, _GEN_70) @[PSRAM_Model.scala 40:12 50:19]
    node _GEN_91 = validif(eq(_T_18, UInt<1>("h0")), _GEN_72) @[PSRAM_Model.scala 50:19]
    node _GEN_92 = validif(eq(_T_18, UInt<1>("h0")), _GEN_73) @[PSRAM_Model.scala 50:19]
    node _GEN_93 = mux(_T_18, UInt<1>("h0"), _GEN_74) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_94 = validif(eq(_T_18, UInt<1>("h0")), _GEN_75) @[PSRAM_Model.scala 50:19]
    node _GEN_95 = validif(eq(_T_18, UInt<1>("h0")), _GEN_76) @[PSRAM_Model.scala 50:19]
    node _GEN_96 = mux(_T_13, _GEN_26, _GEN_87) @[PSRAM_Model.scala 50:19]
    node _GEN_97 = mux(_T_13, _GEN_27, _GEN_85) @[PSRAM_Model.scala 50:19]
    node _GEN_98 = mux(_T_13, _GEN_28, _GEN_88) @[PSRAM_Model.scala 50:19]
    node _GEN_99 = mux(_T_13, _GEN_29, _GEN_84) @[PSRAM_Model.scala 50:19]
    node _GEN_100 = mux(_T_13, UInt<1>("h0"), _GEN_80) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_101 = validif(eq(_T_13, UInt<1>("h0")), _GEN_81) @[PSRAM_Model.scala 50:19]
    node _GEN_102 = validif(eq(_T_13, UInt<1>("h0")), _GEN_82) @[PSRAM_Model.scala 50:19]
    node _GEN_104 = mux(_T_13, UInt<1>("h0"), _GEN_86) @[PSRAM_Model.scala 41:10 50:19]
    node _GEN_105 = mux(_T_13, io_IN, _GEN_89) @[PSRAM_Model.scala 40:12 50:19]
    node _GEN_107 = validif(eq(_T_13, UInt<1>("h0")), _GEN_91) @[PSRAM_Model.scala 50:19]
    node _GEN_108 = validif(eq(_T_13, UInt<1>("h0")), _GEN_92) @[PSRAM_Model.scala 50:19]
    node _GEN_109 = mux(_T_13, UInt<1>("h0"), _GEN_93) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_110 = validif(eq(_T_13, UInt<1>("h0")), _GEN_94) @[PSRAM_Model.scala 50:19]
    node _GEN_111 = validif(eq(_T_13, UInt<1>("h0")), _GEN_95) @[PSRAM_Model.scala 50:19]
    node _GEN_112 = mux(_T_2, _GEN_14, _GEN_105) @[PSRAM_Model.scala 50:19]
    node _GEN_114 = mux(_T_2, _GEN_16, rw) @[PSRAM_Model.scala 32:19 50:19]
    node _GEN_115 = mux(_T_2, _GEN_17, _GEN_96) @[PSRAM_Model.scala 50:19]
    node _GEN_116 = mux(_T_2, _GEN_18, _GEN_98) @[PSRAM_Model.scala 50:19]
    node _GEN_117 = mux(_T_2, _GEN_19, lastCommand) @[PSRAM_Model.scala 50:19 36:28]
    node _GEN_118 = mux(_T_2, _GEN_20, mode) @[PSRAM_Model.scala 50:19 29:21]
    node _GEN_119 = mux(_T_2, idx, _GEN_97) @[PSRAM_Model.scala 50:19 30:20]
    node _GEN_120 = mux(_T_2, waitDone, _GEN_99) @[PSRAM_Model.scala 50:19 34:25]
    node _GEN_121 = mux(_T_2, UInt<1>("h0"), _GEN_100) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_122 = validif(eq(_T_2, UInt<1>("h0")), _GEN_101) @[PSRAM_Model.scala 50:19]
    node _GEN_123 = validif(eq(_T_2, UInt<1>("h0")), _GEN_102) @[PSRAM_Model.scala 50:19]
    node _GEN_125 = mux(_T_2, UInt<1>("h0"), _GEN_104) @[PSRAM_Model.scala 41:10 50:19]
    node _GEN_127 = validif(eq(_T_2, UInt<1>("h0")), _GEN_107) @[PSRAM_Model.scala 50:19]
    node _GEN_128 = validif(eq(_T_2, UInt<1>("h0")), _GEN_108) @[PSRAM_Model.scala 50:19]
    node _GEN_129 = mux(_T_2, UInt<1>("h0"), _GEN_109) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_130 = validif(eq(_T_2, UInt<1>("h0")), _GEN_110) @[PSRAM_Model.scala 50:19]
    node _GEN_131 = validif(eq(_T_2, UInt<1>("h0")), _GEN_111) @[PSRAM_Model.scala 50:19]
    io_OUT <= _GEN_125
    lastCommand_0 <= lastCommand
    mode_1 <= mode
    mem.readMemVal_MPORT.addr <= _GEN_122
    mem.readMemVal_MPORT.en <= _GEN_121
    mem.readMemVal_MPORT.clk <= _GEN_123
    mem.MPORT.addr <= _GEN_127
    mem.MPORT.en <= _GEN_129
    mem.MPORT.clk <= _GEN_128
    mem.MPORT.data <= _GEN_131
    mem.MPORT.mask <= _GEN_130
    address <= bits(mux(reset, UInt<24>("h0"), _GEN_115), 23, 0) @[PSRAM_Model.scala 28:{24,24}]
    mode <= mux(reset, UInt<2>("h0"), _GEN_118) @[PSRAM_Model.scala 29:{21,21}]
    idx <= mux(reset, UInt<3>("h0"), _GEN_119) @[PSRAM_Model.scala 30:{20,20}]
    lastRead <= mux(reset, UInt<8>("h0"), _GEN_112) @[PSRAM_Model.scala 31:{25,25}]
    rw <= mux(reset, UInt<1>("h1"), _GEN_114) @[PSRAM_Model.scala 32:{19,19}]
    waitDone <= mux(reset, UInt<1>("h0"), _GEN_120) @[PSRAM_Model.scala 34:{25,25}]
    lastCommand <= mux(reset, UInt<8>("h0"), _GEN_117) @[PSRAM_Model.scala 36:{28,28}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_116) @[PSRAM_Model.scala 48:{25,25}]

  module PSRAM_Model_1 :
    input clock : Clock
    input reset : UInt<1>
    input io_CS : UInt<1>
    input io_IN : UInt<4>
    output io_OUT : UInt<4>
    output mode_0 : UInt<2>

    mem mem : @[PSRAM_Model.scala 26:24]
      data-type => UInt<8>
      depth => 2048
      read-latency => 1
      write-latency => 1
      reader => readMemVal_MPORT
      writer => MPORT
      read-under-write => undefined
    reg address : UInt<24>, clock with :
      reset => (UInt<1>("h0"), address) @[PSRAM_Model.scala 28:24]
    reg mode : UInt<2>, clock with :
      reset => (UInt<1>("h0"), mode) @[PSRAM_Model.scala 29:21]
    reg idx : UInt<3>, clock with :
      reset => (UInt<1>("h0"), idx) @[PSRAM_Model.scala 30:20]
    reg lastRead : UInt<8>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[PSRAM_Model.scala 31:25]
    reg rw : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rw) @[PSRAM_Model.scala 32:19]
    reg waitDone : UInt<1>, clock with :
      reset => (UInt<1>("h0"), waitDone) @[PSRAM_Model.scala 34:25]
    reg lastCommand : UInt<8>, clock with :
      reset => (UInt<1>("h0"), lastCommand) @[PSRAM_Model.scala 36:28]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[PSRAM_Model.scala 48:25]
    node _T = asUInt(UInt<1>("h0")) @[PSRAM_Model.scala 50:19]
    node _T_1 = asUInt(stateReg) @[PSRAM_Model.scala 50:19]
    node _T_2 = eq(_T, _T_1) @[PSRAM_Model.scala 50:19]
    node _T_3 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 52:12]
    node _T_4 = bits(mode, 0, 0) @[PSRAM_Model.scala 53:19]
    node _T_5 = eq(_T_4, UInt<1>("h0")) @[PSRAM_Model.scala 53:14]
    node _lastRead_T = bits(lastRead, 6, 0) @[PSRAM_Model.scala 54:31]
    node _lastRead_T_1 = bits(io_IN, 0, 0) @[PSRAM_Model.scala 54:45]
    node _lastRead_T_2 = cat(_lastRead_T, _lastRead_T_1) @[PSRAM_Model.scala 54:37]
    node _command_T = bits(lastRead, 6, 0) @[PSRAM_Model.scala 55:30]
    node _command_T_1 = bits(io_IN, 0, 0) @[PSRAM_Model.scala 55:44]
    node _command_T_2 = cat(_command_T, _command_T_1) @[PSRAM_Model.scala 55:36]
    node _lastRead_T_3 = bits(lastRead, 3, 0) @[PSRAM_Model.scala 59:31]
    node _lastRead_T_4 = cat(_lastRead_T_3, io_IN) @[PSRAM_Model.scala 59:37]
    node _command_T_3 = bits(lastRead, 3, 0) @[PSRAM_Model.scala 60:30]
    node _command_T_4 = cat(_command_T_3, io_IN) @[PSRAM_Model.scala 60:36]
    node _GEN_7 = mux(_T_5, _command_T_2, _command_T_4) @[PSRAM_Model.scala 53:24 55:19 60:19]
    node _GEN_15 = mux(_T_3, _GEN_7, UInt<8>("h0")) @[PSRAM_Model.scala 52:19 27:25]
    node _GEN_113 = mux(_T_2, _GEN_15, UInt<8>("h0")) @[PSRAM_Model.scala 50:19 27:25]
    node command = _GEN_113 @[PSRAM_Model.scala 27:25]
    node _T_6 = eq(UInt<8>("h2"), command) @[PSRAM_Model.scala 62:27]
    node _T_7 = eq(UInt<8>("heb"), command) @[PSRAM_Model.scala 62:27]
    node _GEN_0 = mux(_T_7, UInt<1>("h1"), rw) @[PSRAM_Model.scala 62:27 69:18 32:19]
    node _GEN_1 = mux(_T_7, UInt<1>("h0"), address) @[PSRAM_Model.scala 62:27 70:23 28:24]
    node _GEN_2 = mux(_T_7, UInt<1>("h1"), stateReg) @[PSRAM_Model.scala 62:27 71:24 48:25]
    node _GEN_3 = mux(_T_6, UInt<1>("h0"), _GEN_0) @[PSRAM_Model.scala 62:27 64:18]
    node _GEN_4 = mux(_T_6, UInt<1>("h0"), _GEN_1) @[PSRAM_Model.scala 62:27 65:23]
    node _GEN_5 = mux(_T_6, UInt<1>("h1"), _GEN_2) @[PSRAM_Model.scala 62:27 66:24]
    node _GEN_6 = mux(_T_5, _lastRead_T_2, _lastRead_T_4) @[PSRAM_Model.scala 53:24 54:20 59:20]
    node _GEN_8 = mux(_T_5, rw, _GEN_3) @[PSRAM_Model.scala 32:19 53:24]
    node _GEN_9 = mux(_T_5, address, _GEN_4) @[PSRAM_Model.scala 28:24 53:24]
    node _GEN_10 = mux(_T_5, stateReg, _GEN_5) @[PSRAM_Model.scala 53:24 48:25]
    node _T_8 = eq(UInt<8>("h35"), lastCommand) @[PSRAM_Model.scala 78:29]
    node _mode_T = or(mode, UInt<1>("h1")) @[PSRAM_Model.scala 80:27]
    node _T_9 = eq(UInt<8>("hf5"), lastCommand) @[PSRAM_Model.scala 78:29]
    node _mode_T_1 = and(mode, UInt<1>("h0")) @[PSRAM_Model.scala 83:26]
    node _T_10 = eq(UInt<8>("hc0"), lastCommand) @[PSRAM_Model.scala 78:29]
    node _mode_T_2 = xor(mode, UInt<2>("h2")) @[PSRAM_Model.scala 86:26]
    node _GEN_11 = mux(_T_10, _mode_T_2, mode) @[PSRAM_Model.scala 78:29 86:18 29:21]
    node _GEN_12 = mux(_T_9, _mode_T_1, _GEN_11) @[PSRAM_Model.scala 78:29 83:18]
    node _GEN_13 = mux(_T_8, _mode_T, _GEN_12) @[PSRAM_Model.scala 78:29 80:18]
    node _GEN_14 = mux(_T_3, _GEN_6, io_IN) @[PSRAM_Model.scala 40:12 52:19]
    node _GEN_16 = mux(_T_3, _GEN_8, rw) @[PSRAM_Model.scala 32:19 52:19]
    node _GEN_17 = mux(_T_3, _GEN_9, address) @[PSRAM_Model.scala 52:19 28:24]
    node _GEN_18 = mux(_T_3, _GEN_10, stateReg) @[PSRAM_Model.scala 52:19 48:25]
    node _GEN_19 = mux(_T_3, command, lastCommand) @[PSRAM_Model.scala 52:19 75:21 36:28]
    node _GEN_20 = mux(_T_3, mode, _GEN_13) @[PSRAM_Model.scala 52:19 29:21]
    node _T_11 = asUInt(UInt<1>("h1")) @[PSRAM_Model.scala 50:19]
    node _T_12 = asUInt(stateReg) @[PSRAM_Model.scala 50:19]
    node _T_13 = eq(_T_11, _T_12) @[PSRAM_Model.scala 50:19]
    node _T_14 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 94:12]
    node _address_T = cat(address, io_IN) @[PSRAM_Model.scala 95:28]
    node _T_15 = eq(idx, UInt<3>("h5")) @[PSRAM_Model.scala 97:18]
    node _GEN_21 = mux(rw, UInt<2>("h2"), UInt<2>("h3")) @[PSRAM_Model.scala 99:19 100:22 103:22]
    node _GEN_22 = mux(rw, UInt<1>("h0"), waitDone) @[PSRAM_Model.scala 99:19 101:22 34:25]
    node _idx_T = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 106:22]
    node _idx_T_1 = tail(_idx_T, 1) @[PSRAM_Model.scala 106:22]
    node _GEN_23 = mux(_T_15, UInt<1>("h0"), _idx_T_1) @[PSRAM_Model.scala 106:15 97:27 98:15]
    node _GEN_24 = mux(_T_15, _GEN_21, stateReg) @[PSRAM_Model.scala 48:25 97:27]
    node _GEN_25 = mux(_T_15, _GEN_22, waitDone) @[PSRAM_Model.scala 34:25 97:27]
    node _GEN_26 = mux(_T_14, _address_T, address) @[PSRAM_Model.scala 94:20 95:17 28:24]
    node _GEN_27 = mux(_T_14, _GEN_23, idx) @[PSRAM_Model.scala 30:20 94:20]
    node _GEN_28 = mux(_T_14, _GEN_24, UInt<1>("h0")) @[PSRAM_Model.scala 109:18 94:20]
    node _GEN_29 = mux(_T_14, _GEN_25, waitDone) @[PSRAM_Model.scala 94:20 34:25]
    node _T_16 = asUInt(UInt<2>("h2")) @[PSRAM_Model.scala 50:19]
    node _T_17 = asUInt(stateReg) @[PSRAM_Model.scala 50:19]
    node _T_18 = eq(_T_16, _T_17) @[PSRAM_Model.scala 50:19]
    node _T_19 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 113:12]
    node _GEN_30 = validif(UInt<1>("h1"), address) @[PSRAM_Model.scala 114:{31,31}]
    node _readMemVal_WIRE = _GEN_30 @[PSRAM_Model.scala 114:31]
    node _readMemVal_T = or(_readMemVal_WIRE, UInt<11>("h0")) @[PSRAM_Model.scala 114:31]
    node _readMemVal_T_1 = bits(_readMemVal_T, 10, 0) @[PSRAM_Model.scala 114:31]
    node _GEN_31 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[PSRAM_Model.scala 114:{31,31} 26:24]
    node _GEN_32 = validif(UInt<1>("h1"), _readMemVal_T_1) @[PSRAM_Model.scala 114:{31,31}]
    node _GEN_33 = validif(UInt<1>("h1"), clock) @[PSRAM_Model.scala 114:{31,31}]
    node _T_20 = eq(waitDone, UInt<1>("h0")) @[PSRAM_Model.scala 115:14]
    node _T_21 = eq(idx, UInt<3>("h7")) @[PSRAM_Model.scala 116:20]
    node _idx_T_2 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 121:24]
    node _idx_T_3 = tail(_idx_T_2, 1) @[PSRAM_Model.scala 121:24]
    node _GEN_34 = mux(_T_21, UInt<1>("h1"), waitDone) @[PSRAM_Model.scala 116:29 117:22 34:25]
    node _GEN_35 = mux(_T_21, UInt<1>("h0"), _idx_T_3) @[PSRAM_Model.scala 116:29 119:17 121:17]
    node _T_22 = eq(idx, UInt<1>("h1")) @[PSRAM_Model.scala 124:20]
    node _GEN_46 = mux(_T_19, mem.readMemVal_MPORT.data, UInt<8>("h0")) @[PSRAM_Model.scala 113:20 114:20 33:28]
    node _GEN_83 = mux(_T_18, _GEN_46, UInt<8>("h0")) @[PSRAM_Model.scala 50:19 33:28]
    node _GEN_103 = mux(_T_13, UInt<8>("h0"), _GEN_83) @[PSRAM_Model.scala 50:19 33:28]
    node _GEN_124 = mux(_T_2, UInt<8>("h0"), _GEN_103) @[PSRAM_Model.scala 50:19 33:28]
    node readMemVal = _GEN_124 @[PSRAM_Model.scala 33:28]
    node _io_OUT_T = bits(readMemVal, 3, 0) @[PSRAM_Model.scala 125:33]
    node _io_OUT_T_1 = bits(readMemVal, 7, 4) @[PSRAM_Model.scala 128:33]
    node _idx_T_4 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 129:24]
    node _idx_T_5 = tail(_idx_T_4, 1) @[PSRAM_Model.scala 129:24]
    node _address_T_1 = add(address, UInt<1>("h1")) @[PSRAM_Model.scala 130:32]
    node _address_T_2 = tail(_address_T_1, 1) @[PSRAM_Model.scala 130:32]
    node _GEN_36 = mux(_T_22, _io_OUT_T, _io_OUT_T_1) @[PSRAM_Model.scala 124:28 125:20 128:20]
    node _GEN_37 = mux(_T_22, UInt<1>("h0"), _idx_T_5) @[PSRAM_Model.scala 124:28 126:17 129:17]
    node _GEN_38 = mux(_T_22, address, _address_T_2) @[PSRAM_Model.scala 124:28 130:21 28:24]
    node _GEN_39 = mux(_T_20, _GEN_34, waitDone) @[PSRAM_Model.scala 115:25 34:25]
    node _GEN_40 = mux(_T_20, _GEN_35, _GEN_37) @[PSRAM_Model.scala 115:25]
    node _GEN_41 = mux(_T_20, UInt<1>("h0"), _GEN_36) @[PSRAM_Model.scala 115:25 41:10]
    node _GEN_42 = mux(_T_20, address, _GEN_38) @[PSRAM_Model.scala 115:25 28:24]
    node _GEN_43 = mux(_T_19, _GEN_31, UInt<1>("h0")) @[PSRAM_Model.scala 113:20 26:24]
    node _GEN_44 = validif(_T_19, _GEN_32) @[PSRAM_Model.scala 113:20]
    node _GEN_45 = validif(_T_19, _GEN_33) @[PSRAM_Model.scala 113:20]
    node _GEN_47 = mux(_T_19, _GEN_39, waitDone) @[PSRAM_Model.scala 113:20 34:25]
    node _GEN_48 = mux(_T_19, _GEN_40, idx) @[PSRAM_Model.scala 113:20 30:20]
    node _GEN_49 = mux(_T_19, _GEN_41, UInt<1>("h0")) @[PSRAM_Model.scala 113:20 41:10]
    node _GEN_50 = mux(_T_19, _GEN_42, address) @[PSRAM_Model.scala 113:20 28:24]
    node _GEN_51 = mux(_T_19, stateReg, UInt<1>("h0")) @[PSRAM_Model.scala 113:20 136:18 48:25]
    node _T_23 = asUInt(UInt<2>("h3")) @[PSRAM_Model.scala 50:19]
    node _T_24 = asUInt(stateReg) @[PSRAM_Model.scala 50:19]
    node _T_25 = eq(_T_23, _T_24) @[PSRAM_Model.scala 50:19]
    node _T_26 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 140:12]
    node _lastRead_T_5 = bits(lastRead, 3, 0) @[PSRAM_Model.scala 141:29]
    node _lastRead_T_6 = cat(_lastRead_T_5, io_IN) @[PSRAM_Model.scala 141:35]
    node _val2Write_T = bits(lastRead, 3, 0) @[PSRAM_Model.scala 142:30]
    node _val2Write_T_1 = cat(_val2Write_T, io_IN) @[PSRAM_Model.scala 142:36]
    node _T_27 = eq(idx, UInt<1>("h1")) @[PSRAM_Model.scala 143:18]
    node _T_28 = bits(address, 10, 0)
    node _address_T_3 = add(address, UInt<1>("h1")) @[PSRAM_Model.scala 146:30]
    node _address_T_4 = tail(_address_T_3, 1) @[PSRAM_Model.scala 146:30]
    node _idx_T_6 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 149:22]
    node _idx_T_7 = tail(_idx_T_6, 1) @[PSRAM_Model.scala 149:22]
    node _GEN_52 = validif(_T_27, _T_28) @[PSRAM_Model.scala 143:27]
    node _GEN_53 = validif(_T_27, clock) @[PSRAM_Model.scala 143:27]
    node _GEN_54 = mux(_T_27, UInt<1>("h1"), UInt<1>("h0")) @[PSRAM_Model.scala 143:27 26:24]
    node _GEN_55 = validif(_T_27, UInt<1>("h1")) @[PSRAM_Model.scala 143:27]
    node _GEN_61 = mux(_T_26, _val2Write_T_1, UInt<8>("h0")) @[PSRAM_Model.scala 140:20 142:19 35:27]
    node _GEN_71 = mux(_T_25, _GEN_61, UInt<8>("h0")) @[PSRAM_Model.scala 50:19 35:27]
    node _GEN_90 = mux(_T_18, UInt<8>("h0"), _GEN_71) @[PSRAM_Model.scala 50:19 35:27]
    node _GEN_106 = mux(_T_13, UInt<8>("h0"), _GEN_90) @[PSRAM_Model.scala 50:19 35:27]
    node _GEN_126 = mux(_T_2, UInt<8>("h0"), _GEN_106) @[PSRAM_Model.scala 50:19 35:27]
    node val2Write = _GEN_126 @[PSRAM_Model.scala 35:27]
    node _GEN_56 = validif(_T_27, val2Write) @[PSRAM_Model.scala 143:27]
    node _GEN_57 = mux(_T_27, UInt<1>("h0"), _idx_T_7) @[PSRAM_Model.scala 143:27 145:15 149:15]
    node _GEN_58 = mux(_T_27, _address_T_4, address) @[PSRAM_Model.scala 143:27 146:19 28:24]
    node _GEN_59 = mux(_T_27, UInt<1>("h0"), _lastRead_T_6) @[PSRAM_Model.scala 141:18 143:27 147:20]
    node _GEN_60 = mux(_T_26, _GEN_59, io_IN) @[PSRAM_Model.scala 140:20 40:12]
    node _GEN_62 = validif(_T_26, _GEN_52) @[PSRAM_Model.scala 140:20]
    node _GEN_63 = validif(_T_26, _GEN_53) @[PSRAM_Model.scala 140:20]
    node _GEN_64 = mux(_T_26, _GEN_54, UInt<1>("h0")) @[PSRAM_Model.scala 140:20 26:24]
    node _GEN_65 = validif(_T_26, _GEN_55) @[PSRAM_Model.scala 140:20]
    node _GEN_66 = validif(_T_26, _GEN_56) @[PSRAM_Model.scala 140:20]
    node _GEN_67 = mux(_T_26, _GEN_57, idx) @[PSRAM_Model.scala 140:20 30:20]
    node _GEN_68 = mux(_T_26, _GEN_58, address) @[PSRAM_Model.scala 140:20 28:24]
    node _GEN_69 = mux(_T_26, stateReg, UInt<1>("h0")) @[PSRAM_Model.scala 140:20 153:18 48:25]
    node _GEN_70 = mux(_T_25, _GEN_60, io_IN) @[PSRAM_Model.scala 40:12 50:19]
    node _GEN_72 = validif(_T_25, _GEN_62) @[PSRAM_Model.scala 50:19]
    node _GEN_73 = validif(_T_25, _GEN_63) @[PSRAM_Model.scala 50:19]
    node _GEN_74 = mux(_T_25, _GEN_64, UInt<1>("h0")) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_75 = validif(_T_25, _GEN_65) @[PSRAM_Model.scala 50:19]
    node _GEN_76 = validif(_T_25, _GEN_66) @[PSRAM_Model.scala 50:19]
    node _GEN_77 = mux(_T_25, _GEN_67, idx) @[PSRAM_Model.scala 50:19 30:20]
    node _GEN_78 = mux(_T_25, _GEN_68, address) @[PSRAM_Model.scala 50:19 28:24]
    node _GEN_79 = mux(_T_25, _GEN_69, stateReg) @[PSRAM_Model.scala 50:19 48:25]
    node _GEN_80 = mux(_T_18, _GEN_43, UInt<1>("h0")) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_81 = validif(_T_18, _GEN_44) @[PSRAM_Model.scala 50:19]
    node _GEN_82 = validif(_T_18, _GEN_45) @[PSRAM_Model.scala 50:19]
    node _GEN_84 = mux(_T_18, _GEN_47, waitDone) @[PSRAM_Model.scala 50:19 34:25]
    node _GEN_85 = mux(_T_18, _GEN_48, _GEN_77) @[PSRAM_Model.scala 50:19]
    node _GEN_86 = mux(_T_18, _GEN_49, UInt<1>("h0")) @[PSRAM_Model.scala 41:10 50:19]
    node _GEN_87 = mux(_T_18, _GEN_50, _GEN_78) @[PSRAM_Model.scala 50:19]
    node _GEN_88 = mux(_T_18, _GEN_51, _GEN_79) @[PSRAM_Model.scala 50:19]
    node _GEN_89 = mux(_T_18, io_IN, _GEN_70) @[PSRAM_Model.scala 40:12 50:19]
    node _GEN_91 = validif(eq(_T_18, UInt<1>("h0")), _GEN_72) @[PSRAM_Model.scala 50:19]
    node _GEN_92 = validif(eq(_T_18, UInt<1>("h0")), _GEN_73) @[PSRAM_Model.scala 50:19]
    node _GEN_93 = mux(_T_18, UInt<1>("h0"), _GEN_74) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_94 = validif(eq(_T_18, UInt<1>("h0")), _GEN_75) @[PSRAM_Model.scala 50:19]
    node _GEN_95 = validif(eq(_T_18, UInt<1>("h0")), _GEN_76) @[PSRAM_Model.scala 50:19]
    node _GEN_96 = mux(_T_13, _GEN_26, _GEN_87) @[PSRAM_Model.scala 50:19]
    node _GEN_97 = mux(_T_13, _GEN_27, _GEN_85) @[PSRAM_Model.scala 50:19]
    node _GEN_98 = mux(_T_13, _GEN_28, _GEN_88) @[PSRAM_Model.scala 50:19]
    node _GEN_99 = mux(_T_13, _GEN_29, _GEN_84) @[PSRAM_Model.scala 50:19]
    node _GEN_100 = mux(_T_13, UInt<1>("h0"), _GEN_80) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_101 = validif(eq(_T_13, UInt<1>("h0")), _GEN_81) @[PSRAM_Model.scala 50:19]
    node _GEN_102 = validif(eq(_T_13, UInt<1>("h0")), _GEN_82) @[PSRAM_Model.scala 50:19]
    node _GEN_104 = mux(_T_13, UInt<1>("h0"), _GEN_86) @[PSRAM_Model.scala 41:10 50:19]
    node _GEN_105 = mux(_T_13, io_IN, _GEN_89) @[PSRAM_Model.scala 40:12 50:19]
    node _GEN_107 = validif(eq(_T_13, UInt<1>("h0")), _GEN_91) @[PSRAM_Model.scala 50:19]
    node _GEN_108 = validif(eq(_T_13, UInt<1>("h0")), _GEN_92) @[PSRAM_Model.scala 50:19]
    node _GEN_109 = mux(_T_13, UInt<1>("h0"), _GEN_93) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_110 = validif(eq(_T_13, UInt<1>("h0")), _GEN_94) @[PSRAM_Model.scala 50:19]
    node _GEN_111 = validif(eq(_T_13, UInt<1>("h0")), _GEN_95) @[PSRAM_Model.scala 50:19]
    node _GEN_112 = mux(_T_2, _GEN_14, _GEN_105) @[PSRAM_Model.scala 50:19]
    node _GEN_114 = mux(_T_2, _GEN_16, rw) @[PSRAM_Model.scala 32:19 50:19]
    node _GEN_115 = mux(_T_2, _GEN_17, _GEN_96) @[PSRAM_Model.scala 50:19]
    node _GEN_116 = mux(_T_2, _GEN_18, _GEN_98) @[PSRAM_Model.scala 50:19]
    node _GEN_117 = mux(_T_2, _GEN_19, lastCommand) @[PSRAM_Model.scala 50:19 36:28]
    node _GEN_118 = mux(_T_2, _GEN_20, mode) @[PSRAM_Model.scala 50:19 29:21]
    node _GEN_119 = mux(_T_2, idx, _GEN_97) @[PSRAM_Model.scala 50:19 30:20]
    node _GEN_120 = mux(_T_2, waitDone, _GEN_99) @[PSRAM_Model.scala 50:19 34:25]
    node _GEN_121 = mux(_T_2, UInt<1>("h0"), _GEN_100) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_122 = validif(eq(_T_2, UInt<1>("h0")), _GEN_101) @[PSRAM_Model.scala 50:19]
    node _GEN_123 = validif(eq(_T_2, UInt<1>("h0")), _GEN_102) @[PSRAM_Model.scala 50:19]
    node _GEN_125 = mux(_T_2, UInt<1>("h0"), _GEN_104) @[PSRAM_Model.scala 41:10 50:19]
    node _GEN_127 = validif(eq(_T_2, UInt<1>("h0")), _GEN_107) @[PSRAM_Model.scala 50:19]
    node _GEN_128 = validif(eq(_T_2, UInt<1>("h0")), _GEN_108) @[PSRAM_Model.scala 50:19]
    node _GEN_129 = mux(_T_2, UInt<1>("h0"), _GEN_109) @[PSRAM_Model.scala 50:19 26:24]
    node _GEN_130 = validif(eq(_T_2, UInt<1>("h0")), _GEN_110) @[PSRAM_Model.scala 50:19]
    node _GEN_131 = validif(eq(_T_2, UInt<1>("h0")), _GEN_111) @[PSRAM_Model.scala 50:19]
    io_OUT <= _GEN_125
    mode_0 <= mode
    mem.readMemVal_MPORT.addr <= _GEN_122
    mem.readMemVal_MPORT.en <= _GEN_121
    mem.readMemVal_MPORT.clk <= _GEN_123
    mem.MPORT.addr <= _GEN_127
    mem.MPORT.en <= _GEN_129
    mem.MPORT.clk <= _GEN_128
    mem.MPORT.data <= _GEN_131
    mem.MPORT.mask <= _GEN_130
    address <= bits(mux(reset, UInt<24>("h0"), _GEN_115), 23, 0) @[PSRAM_Model.scala 28:{24,24}]
    mode <= mux(reset, UInt<2>("h0"), _GEN_118) @[PSRAM_Model.scala 29:{21,21}]
    idx <= mux(reset, UInt<3>("h0"), _GEN_119) @[PSRAM_Model.scala 30:{20,20}]
    lastRead <= mux(reset, UInt<8>("h0"), _GEN_112) @[PSRAM_Model.scala 31:{25,25}]
    rw <= mux(reset, UInt<1>("h1"), _GEN_114) @[PSRAM_Model.scala 32:{19,19}]
    waitDone <= mux(reset, UInt<1>("h0"), _GEN_120) @[PSRAM_Model.scala 34:{25,25}]
    lastCommand <= mux(reset, UInt<8>("h0"), _GEN_117) @[PSRAM_Model.scala 36:{28,28}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_116) @[PSRAM_Model.scala 48:{25,25}]

  module MemoryControllerTop :
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
    output io_CS0 : UInt<1>
    output io_CS1 : UInt<1>
    output io_CS2 : UInt<1>
    output io_si : UInt<4>
    output lastCommand : UInt<8>
    output mode : UInt<2>
    output mode_0 : UInt<2>

    inst MemCtrl of MemoryController @[MemoryControllerTop.scala 38:23]
    inst SpiCtrl of SPITop @[MemoryControllerTop.scala 53:23]
    inst RAM0 of PSRAM_Model @[MemoryControllerTop.scala 63:20]
    inst RAM1 of PSRAM_Model_1 @[MemoryControllerTop.scala 64:20]
    node _T = eq(SpiCtrl.io__CS0out, UInt<1>("h0")) @[MemoryControllerTop.scala 71:8]
    node _T_1 = eq(SpiCtrl.io__CS1out, UInt<1>("h0")) @[MemoryControllerTop.scala 73:14]
    node _GEN_0 = mux(_T_1, RAM1.io_OUT, UInt<1>("h0")) @[MemoryControllerTop.scala 70:17 73:33 74:19]
    node _GEN_1 = mux(_T, RAM0.io_OUT, _GEN_0) @[MemoryControllerTop.scala 71:27 72:19]
    io_dCacheReqOut_ready <= MemCtrl.io_dCacheReqOut_ready @[MemoryControllerTop.scala 48:27]
    io_dCacheRspIn_valid <= MemCtrl.io_dCacheRspIn_valid @[MemoryControllerTop.scala 49:18]
    io_dCacheRspIn_bits_dataResponse <= MemCtrl.io_dCacheRspIn_bits_dataResponse @[MemoryControllerTop.scala 49:18]
    io_dCacheRspIn_bits_error <= MemCtrl.io_dCacheRspIn_bits_error @[MemoryControllerTop.scala 49:18]
    io_iCacheReqOut_ready <= MemCtrl.io_iCacheReqOut_ready @[MemoryControllerTop.scala 50:27]
    io_iCacheRspIn_valid <= MemCtrl.io_iCacheRspIn_valid @[MemoryControllerTop.scala 51:18]
    io_iCacheRspIn_bits_dataResponse <= MemCtrl.io_iCacheRspIn_bits_dataResponse @[MemoryControllerTop.scala 51:18]
    io_iCacheRspIn_bits_error <= MemCtrl.io_iCacheRspIn_bits_error @[MemoryControllerTop.scala 51:18]
    io_CS0 <= SpiCtrl.io__CS0out @[MemoryControllerTop.scala 58:10]
    io_CS1 <= SpiCtrl.io__CS1out @[MemoryControllerTop.scala 59:10]
    io_CS2 <= UInt<1>("h1") @[MemoryControllerTop.scala 60:10]
    io_si <= SpiCtrl.io_si
    lastCommand <= RAM0.lastCommand_0
    mode <= RAM1.mode_0
    mode_0 <= RAM0.mode_1
    MemCtrl.clock <= clock
    MemCtrl.reset <= reset
    MemCtrl.io_memIO_rdAddress is invalid
    MemCtrl.io_memIO_rdEnable is invalid
    MemCtrl.io_memIO_wrAddress is invalid
    MemCtrl.io_memIO_wrData is invalid
    MemCtrl.io_memIO_wrEnable_0 is invalid
    MemCtrl.io_memIO_wrEnable_1 is invalid
    MemCtrl.io_memIO_wrEnable_2 is invalid
    MemCtrl.io_memIO_wrEnable_3 is invalid
    MemCtrl.io_bootloading <= UInt<1>("h0") @[MemoryControllerTop.scala 40:26]
    MemCtrl.io_dCacheReqOut_valid <= io_dCacheReqOut_valid @[MemoryControllerTop.scala 48:27]
    MemCtrl.io_dCacheReqOut_bits_addrRequest <= io_dCacheReqOut_bits_addrRequest @[MemoryControllerTop.scala 48:27]
    MemCtrl.io_dCacheReqOut_bits_dataRequest <= io_dCacheReqOut_bits_dataRequest @[MemoryControllerTop.scala 48:27]
    MemCtrl.io_dCacheReqOut_bits_activeByteLane <= io_dCacheReqOut_bits_activeByteLane @[MemoryControllerTop.scala 48:27]
    MemCtrl.io_dCacheReqOut_bits_isWrite <= io_dCacheReqOut_bits_isWrite @[MemoryControllerTop.scala 48:27]
    MemCtrl.io_dCacheRspIn_ready <= io_dCacheRspIn_ready @[MemoryControllerTop.scala 49:18]
    MemCtrl.io_iCacheReqOut_valid <= io_iCacheReqOut_valid @[MemoryControllerTop.scala 50:27]
    MemCtrl.io_iCacheReqOut_bits_addrRequest <= io_iCacheReqOut_bits_addrRequest @[MemoryControllerTop.scala 50:27]
    MemCtrl.io_iCacheReqOut_bits_dataRequest <= io_iCacheReqOut_bits_dataRequest @[MemoryControllerTop.scala 50:27]
    MemCtrl.io_iCacheReqOut_bits_activeByteLane <= io_iCacheReqOut_bits_activeByteLane @[MemoryControllerTop.scala 50:27]
    MemCtrl.io_iCacheReqOut_bits_isWrite <= io_iCacheReqOut_bits_isWrite @[MemoryControllerTop.scala 50:27]
    MemCtrl.io_iCacheRspIn_ready <= io_iCacheRspIn_ready @[MemoryControllerTop.scala 51:18]
    MemCtrl.io_SPIctrl_0_dataOut <= SpiCtrl.io__memSPIctrl_0_dataOut @[MemoryControllerTop.scala 55:28]
    MemCtrl.io_SPIctrl_0_done <= SpiCtrl.io__memSPIctrl_0_done @[MemoryControllerTop.scala 55:28]
    MemCtrl.io_SPIctrl_1_dataOut <= SpiCtrl.io__memSPIctrl_1_dataOut @[MemoryControllerTop.scala 56:28]
    MemCtrl.io_SPIctrl_1_done <= SpiCtrl.io__memSPIctrl_1_done @[MemoryControllerTop.scala 56:28]
    SpiCtrl.clock <= clock
    SpiCtrl.reset <= reset
    SpiCtrl.io__memSPIctrl_0_rst <= MemCtrl.io_SPIctrl_0_rst @[MemoryControllerTop.scala 55:28]
    SpiCtrl.io__memSPIctrl_0_rw <= MemCtrl.io_SPIctrl_0_rw @[MemoryControllerTop.scala 55:28]
    SpiCtrl.io__memSPIctrl_0_en <= MemCtrl.io_SPIctrl_0_en @[MemoryControllerTop.scala 55:28]
    SpiCtrl.io__memSPIctrl_0_addr <= MemCtrl.io_SPIctrl_0_addr @[MemoryControllerTop.scala 55:28]
    SpiCtrl.io__memSPIctrl_0_dataIn <= MemCtrl.io_SPIctrl_0_dataIn @[MemoryControllerTop.scala 55:28]
    SpiCtrl.io__memSPIctrl_0_size <= MemCtrl.io_SPIctrl_0_size @[MemoryControllerTop.scala 55:28]
    SpiCtrl.io__memSPIctrl_1_rst <= MemCtrl.io_SPIctrl_1_rst @[MemoryControllerTop.scala 56:28]
    SpiCtrl.io__memSPIctrl_1_rw <= MemCtrl.io_SPIctrl_1_rw @[MemoryControllerTop.scala 56:28]
    SpiCtrl.io__memSPIctrl_1_en <= MemCtrl.io_SPIctrl_1_en @[MemoryControllerTop.scala 56:28]
    SpiCtrl.io__memSPIctrl_1_addr <= MemCtrl.io_SPIctrl_1_addr @[MemoryControllerTop.scala 56:28]
    SpiCtrl.io__memSPIctrl_1_dataIn <= MemCtrl.io_SPIctrl_1_dataIn @[MemoryControllerTop.scala 56:28]
    SpiCtrl.io__memSPIctrl_1_size <= MemCtrl.io_SPIctrl_1_size @[MemoryControllerTop.scala 56:28]
    SpiCtrl.io__so <= _GEN_1
    RAM0.clock <= clock
    RAM0.reset <= reset
    RAM0.io_CS <= SpiCtrl.io__CS0out @[MemoryControllerTop.scala 66:14]
    RAM0.io_IN <= SpiCtrl.io__si @[MemoryControllerTop.scala 67:14]
    RAM1.clock <= clock
    RAM1.reset <= reset
    RAM1.io_CS <= SpiCtrl.io__CS1out @[MemoryControllerTop.scala 69:14]
    RAM1.io_IN <= SpiCtrl.io__si @[MemoryControllerTop.scala 68:14]

  module MemoryControllerTopTester :
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
    output io_CS0 : UInt<1>
    output io_CS1 : UInt<1>
    output io_CS2 : UInt<1>
    output io_RAM0Mode : UInt<2>
    output io_RAM1Mode : UInt<2>
    output io_SpiSi : UInt<4>
    output io_LastCommand : UInt<8>

    inst CTRL of MemoryControllerTop @[MemoryControllerTopTest.scala 31:20]
    node mode_4 = CTRL.mode_0
    node mode_5 = CTRL.mode
    node lastCommand_1 = CTRL.lastCommand
    node iosi_1 = CTRL.io_si
    io_dCacheReqOut_ready <= CTRL.io_dCacheReqOut_ready @[MemoryControllerTopTest.scala 32:24]
    io_dCacheRspIn_valid <= CTRL.io_dCacheRspIn_valid @[MemoryControllerTopTest.scala 33:18]
    io_dCacheRspIn_bits_dataResponse <= CTRL.io_dCacheRspIn_bits_dataResponse @[MemoryControllerTopTest.scala 33:18]
    io_dCacheRspIn_bits_error <= CTRL.io_dCacheRspIn_bits_error @[MemoryControllerTopTest.scala 33:18]
    io_iCacheReqOut_ready <= CTRL.io_iCacheReqOut_ready @[MemoryControllerTopTest.scala 34:24]
    io_iCacheRspIn_valid <= CTRL.io_iCacheRspIn_valid @[MemoryControllerTopTest.scala 35:18]
    io_iCacheRspIn_bits_dataResponse <= CTRL.io_iCacheRspIn_bits_dataResponse @[MemoryControllerTopTest.scala 35:18]
    io_iCacheRspIn_bits_error <= CTRL.io_iCacheRspIn_bits_error @[MemoryControllerTopTest.scala 35:18]
    io_CS0 <= CTRL.io_CS0 @[MemoryControllerTopTest.scala 36:10]
    io_CS1 <= CTRL.io_CS1 @[MemoryControllerTopTest.scala 37:10]
    io_CS2 <= CTRL.io_CS2 @[MemoryControllerTopTest.scala 38:10]
    io_RAM0Mode <= mode_4
    io_RAM1Mode <= mode_5
    io_SpiSi <= iosi_1
    io_LastCommand <= lastCommand_1
    CTRL.clock <= clock
    CTRL.reset <= reset
    CTRL.io_dCacheReqOut_valid <= io_dCacheReqOut_valid @[MemoryControllerTopTest.scala 32:24]
    CTRL.io_dCacheReqOut_bits_addrRequest <= io_dCacheReqOut_bits_addrRequest @[MemoryControllerTopTest.scala 32:24]
    CTRL.io_dCacheReqOut_bits_dataRequest <= io_dCacheReqOut_bits_dataRequest @[MemoryControllerTopTest.scala 32:24]
    CTRL.io_dCacheReqOut_bits_activeByteLane <= io_dCacheReqOut_bits_activeByteLane @[MemoryControllerTopTest.scala 32:24]
    CTRL.io_dCacheReqOut_bits_isWrite <= io_dCacheReqOut_bits_isWrite @[MemoryControllerTopTest.scala 32:24]
    CTRL.io_dCacheRspIn_ready <= io_dCacheRspIn_ready @[MemoryControllerTopTest.scala 33:18]
    CTRL.io_iCacheReqOut_valid <= io_iCacheReqOut_valid @[MemoryControllerTopTest.scala 34:24]
    CTRL.io_iCacheReqOut_bits_addrRequest <= io_iCacheReqOut_bits_addrRequest @[MemoryControllerTopTest.scala 34:24]
    CTRL.io_iCacheReqOut_bits_dataRequest <= io_iCacheReqOut_bits_dataRequest @[MemoryControllerTopTest.scala 34:24]
    CTRL.io_iCacheReqOut_bits_activeByteLane <= io_iCacheReqOut_bits_activeByteLane @[MemoryControllerTopTest.scala 34:24]
    CTRL.io_iCacheReqOut_bits_isWrite <= io_iCacheReqOut_bits_isWrite @[MemoryControllerTopTest.scala 34:24]
    CTRL.io_iCacheRspIn_ready <= io_iCacheRspIn_ready @[MemoryControllerTopTest.scala 35:18]
