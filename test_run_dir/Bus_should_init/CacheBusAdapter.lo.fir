FIRRTL version 1.1.0
circuit CacheBusAdapter :
  module TilelinkHost :
    input clock : Clock
    input reset : UInt<1>
    input io_tlMasterTransmitter_ready : UInt<1>
    output io_tlMasterTransmitter_valid : UInt<1>
    output io_tlMasterTransmitter_bits_a_opcode : UInt<3>
    output io_tlMasterTransmitter_bits_a_param : UInt<3>
    output io_tlMasterTransmitter_bits_a_size : UInt<2>
    output io_tlMasterTransmitter_bits_a_source : UInt<8>
    output io_tlMasterTransmitter_bits_a_address : UInt<32>
    output io_tlMasterTransmitter_bits_a_mask : UInt<4>
    output io_tlMasterTransmitter_bits_a_corrupt : UInt<1>
    output io_tlMasterTransmitter_bits_a_data : UInt<32>
    output io_tlSlaveReceiver_ready : UInt<1>
    input io_tlSlaveReceiver_valid : UInt<1>
    input io_tlSlaveReceiver_bits_d_opcode : UInt<3>
    input io_tlSlaveReceiver_bits_d_param : UInt<2>
    input io_tlSlaveReceiver_bits_d_size : UInt<2>
    input io_tlSlaveReceiver_bits_d_source : UInt<8>
    input io_tlSlaveReceiver_bits_d_sink : UInt<1>
    input io_tlSlaveReceiver_bits_d_denied : UInt<1>
    input io_tlSlaveReceiver_bits_d_corrupt : UInt<1>
    input io_tlSlaveReceiver_bits_d_data : UInt<32>
    output io_reqIn_ready : UInt<1>
    input io_reqIn_valid : UInt<1>
    input io_reqIn_bits_addrRequest : UInt<32>
    input io_reqIn_bits_dataRequest : UInt<32>
    input io_reqIn_bits_activeByteLane : UInt<4>
    input io_reqIn_bits_isWrite : UInt<1>
    input io_rspOut_ready : UInt<1>
    output io_rspOut_valid : UInt<1>
    output io_rspOut_bits_dataResponse : UInt<32>
    output io_rspOut_bits_error : UInt<1>

    reg opReg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), opReg) @[TilelinkHost.scala 16:24]
    reg paramReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), paramReg) @[TilelinkHost.scala 17:27]
    reg sizeReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sizeReg) @[TilelinkHost.scala 18:26]
    reg addReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), addReg) @[TilelinkHost.scala 19:25]
    reg sourceReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sourceReg) @[TilelinkHost.scala 20:28]
    reg counterHost : UInt<2>, clock with :
      reset => (UInt<1>("h0"), counterHost) @[TilelinkHost.scala 21:30]
    node _T = not(io_reqIn_valid) @[TilelinkHost.scala 41:10]
    node _T_1 = gt(counterHost, UInt<1>("h0")) @[TilelinkHost.scala 41:43]
    node _T_2 = and(_T, _T_1) @[TilelinkHost.scala 41:28]
    node _GEN_0 = mux(_T_2, UInt<1>("h0"), counterHost) @[TilelinkHost.scala 41:49 42:21 21:30]
    node _T_3 = eq(counterHost, UInt<1>("h0")) @[TilelinkHost.scala 44:22]
    node _GEN_1 = mux(_T_3, UInt<3>("h6"), opReg) @[TilelinkHost.scala 44:30 45:15 16:24]
    node _GEN_2 = mux(_T_3, UInt<1>("h0"), paramReg) @[TilelinkHost.scala 44:30 46:18 17:27]
    node _GEN_3 = mux(_T_3, UInt<1>("h0"), sizeReg) @[TilelinkHost.scala 44:30 47:17 18:26]
    node _GEN_4 = mux(_T_3, UInt<1>("h0"), sourceReg) @[TilelinkHost.scala 44:30 48:19 20:28]
    node _GEN_5 = mux(_T_3, UInt<1>("h0"), _GEN_0) @[TilelinkHost.scala 44:30 49:21]
    node _T_4 = gt(counterHost, UInt<1>("h0")) @[TilelinkHost.scala 54:46]
    node _T_5 = and(UInt<1>("h0"), _T_4) @[TilelinkHost.scala 54:31]
    node _T_6 = neq(opReg, UInt<3>("h4")) @[TilelinkHost.scala 55:24]
    node _T_7 = neq(opReg, UInt<2>("h2")) @[TilelinkHost.scala 60:28]
    node _T_8 = neq(opReg, UInt<2>("h3")) @[TilelinkHost.scala 60:54]
    node _T_9 = and(_T_7, _T_8) @[TilelinkHost.scala 60:45]
    node _io_tlMasterTransmitter_bits_a_address_T = add(addReg, UInt<3>("h4")) @[TilelinkHost.scala 61:69]
    node _io_tlMasterTransmitter_bits_a_address_T_1 = tail(_io_tlMasterTransmitter_bits_a_address_T, 1) @[TilelinkHost.scala 61:69]
    node _addReg_T = add(addReg, UInt<3>("h4")) @[TilelinkHost.scala 62:38]
    node _addReg_T_1 = tail(_addReg_T, 1) @[TilelinkHost.scala 62:38]
    node _GEN_6 = mux(_T_9, _io_tlMasterTransmitter_bits_a_address_T_1, addReg) @[TilelinkHost.scala 60:68 61:59 65:59]
    node _GEN_7 = mux(_T_9, _addReg_T_1, addReg) @[TilelinkHost.scala 19:25 60:68 62:28]
    node _counterHost_T = sub(counterHost, UInt<1>("h1")) @[TilelinkHost.scala 72:44]
    node _counterHost_T_1 = tail(_counterHost_T, 1) @[TilelinkHost.scala 72:44]
    node _T_10 = eq(opReg, UInt<3>("h4")) @[TilelinkHost.scala 75:25]
    node _counterHost_T_2 = sub(counterHost, UInt<1>("h1")) @[TilelinkHost.scala 76:40]
    node _counterHost_T_3 = tail(_counterHost_T_2, 1) @[TilelinkHost.scala 76:40]
    node _GEN_8 = mux(_T_10, _counterHost_T_3, _GEN_5) @[TilelinkHost.scala 75:35 76:25]
    node _GEN_9 = mux(_T_10, UInt<1>("h0"), UInt<1>("h1")) @[TilelinkHost.scala 26:33 75:35 77:38]
    node _GEN_10 = mux(_T_10, UInt<1>("h1"), UInt<1>("h0")) @[TilelinkHost.scala 25:33 75:35 78:38]
    node _GEN_11 = mux(_T_6, opReg, UInt<1>("h0")) @[TilelinkHost.scala 55:34 28:45 56:54]
    node _GEN_12 = mux(_T_6, paramReg, UInt<1>("h0")) @[TilelinkHost.scala 55:34 31:45 57:53]
    node _GEN_13 = mux(_T_6, sizeReg, UInt<1>("h0")) @[TilelinkHost.scala 55:34 33:45 58:52]
    node _GEN_14 = mux(_T_6, sourceReg, UInt<1>("h0")) @[TilelinkHost.scala 55:34 32:45 59:54]
    node _GEN_15 = mux(_T_6, _GEN_6, addReg) @[TilelinkHost.scala 55:34 30:45]
    node _GEN_16 = mux(_T_6, _GEN_7, addReg) @[TilelinkHost.scala 19:25 55:34]
    node _GEN_17 = mux(_T_6, io_reqIn_bits_dataRequest, UInt<1>("h0")) @[TilelinkHost.scala 55:34 29:45 67:57]
    node _GEN_18 = mux(_T_6, io_reqIn_bits_activeByteLane, UInt<1>("h0")) @[TilelinkHost.scala 55:34 34:45 68:57]
    node _GEN_19 = mux(_T_6, UInt<1>("h0"), UInt<1>("h0")) @[TilelinkHost.scala 55:34 35:45 69:57]
    node _GEN_20 = mux(_T_6, io_reqIn_valid, UInt<1>("h0")) @[TilelinkHost.scala 55:34 36:45 70:57]
    node _GEN_21 = mux(_T_6, UInt<1>("h0"), _GEN_9) @[TilelinkHost.scala 55:34 71:42]
    node _GEN_22 = mux(_T_6, _counterHost_T_1, _GEN_8) @[TilelinkHost.scala 55:34 72:29]
    node _GEN_23 = mux(_T_6, UInt<1>("h1"), _GEN_10) @[TilelinkHost.scala 55:34 73:42]
    node _io_tlMasterTransmitter_bits_a_opcode_T = eq(io_reqIn_bits_activeByteLane, UInt<4>("hf")) @[TilelinkHost.scala 87:113]
    node _io_tlMasterTransmitter_bits_a_opcode_T_1 = mux(_io_tlMasterTransmitter_bits_a_opcode_T, UInt<1>("h0"), UInt<1>("h1")) @[TilelinkHost.scala 87:83]
    node _io_tlMasterTransmitter_bits_a_opcode_T_2 = mux(io_reqIn_bits_isWrite, _io_tlMasterTransmitter_bits_a_opcode_T_1, UInt<3>("h4")) @[TilelinkHost.scala 87:56]
    node _io_tlMasterTransmitter_bits_a_size_T = eq(UInt<1>("h1"), UInt<3>("h4")) @[Mux.scala 81:61]
    node _io_tlMasterTransmitter_bits_a_size_T_1 = mux(_io_tlMasterTransmitter_bits_a_size_T, UInt<1>("h0"), UInt<2>("h2")) @[Mux.scala 81:58]
    node _io_tlMasterTransmitter_bits_a_size_T_2 = eq(UInt<2>("h2"), UInt<3>("h4")) @[Mux.scala 81:61]
    node _io_tlMasterTransmitter_bits_a_size_T_3 = mux(_io_tlMasterTransmitter_bits_a_size_T_2, UInt<1>("h1"), _io_tlMasterTransmitter_bits_a_size_T_1) @[Mux.scala 81:58]
    node _io_tlMasterTransmitter_bits_a_size_T_4 = eq(UInt<3>("h4"), UInt<3>("h4")) @[Mux.scala 81:61]
    node _io_tlMasterTransmitter_bits_a_size_T_5 = mux(_io_tlMasterTransmitter_bits_a_size_T_4, UInt<2>("h2"), _io_tlMasterTransmitter_bits_a_size_T_3) @[Mux.scala 81:58]
    node _io_tlMasterTransmitter_bits_a_size_T_6 = eq(UInt<4>("h8"), UInt<3>("h4")) @[Mux.scala 81:61]
    node _io_tlMasterTransmitter_bits_a_size_T_7 = mux(_io_tlMasterTransmitter_bits_a_size_T_6, UInt<2>("h3"), _io_tlMasterTransmitter_bits_a_size_T_5) @[Mux.scala 81:58]
    node _GEN_24 = mux(_T_5, _GEN_11, _io_tlMasterTransmitter_bits_a_opcode_T_2) @[TilelinkHost.scala 54:52 87:50]
    node _GEN_25 = mux(_T_5, _GEN_12, UInt<1>("h0")) @[TilelinkHost.scala 54:52 94:49]
    node _GEN_26 = mux(_T_5, _GEN_13, _io_tlMasterTransmitter_bits_a_size_T_7) @[TilelinkHost.scala 54:52 112:53]
    node _GEN_27 = mux(_T_5, _GEN_14, UInt<2>("h2")) @[TilelinkHost.scala 54:52 96:49]
    node _GEN_28 = mux(_T_5, _GEN_15, io_reqIn_bits_addrRequest) @[TilelinkHost.scala 54:52 90:49]
    node _GEN_29 = mux(_T_5, _GEN_16, io_reqIn_bits_addrRequest) @[TilelinkHost.scala 125:16 54:52]
    node _GEN_30 = mux(_T_5, _GEN_17, io_reqIn_bits_dataRequest) @[TilelinkHost.scala 54:52 89:49]
    node _GEN_31 = mux(_T_5, _GEN_18, io_reqIn_bits_activeByteLane) @[TilelinkHost.scala 119:49 54:52]
    node _GEN_32 = mux(_T_5, _GEN_19, UInt<1>("h0")) @[TilelinkHost.scala 120:49 54:52]
    node _GEN_33 = mux(_T_5, _GEN_20, io_reqIn_valid) @[TilelinkHost.scala 121:49 54:52]
    node _GEN_34 = mux(_T_5, _GEN_21, UInt<1>("h0")) @[TilelinkHost.scala 123:34 54:52]
    node _GEN_35 = mux(_T_5, _GEN_22, _GEN_5) @[TilelinkHost.scala 54:52]
    node _GEN_36 = mux(_T_5, _GEN_23, UInt<1>("h1")) @[TilelinkHost.scala 124:34 54:52]
    node _GEN_37 = mux(io_reqIn_valid, _GEN_24, UInt<1>("h0")) @[TilelinkHost.scala 53:25 28:45]
    node _GEN_38 = mux(io_reqIn_valid, _GEN_25, UInt<1>("h0")) @[TilelinkHost.scala 53:25 31:45]
    node _GEN_39 = mux(io_reqIn_valid, _GEN_26, UInt<1>("h0")) @[TilelinkHost.scala 53:25 33:45]
    node _GEN_40 = mux(io_reqIn_valid, _GEN_27, UInt<1>("h0")) @[TilelinkHost.scala 53:25 32:45]
    node _GEN_41 = mux(io_reqIn_valid, _GEN_28, addReg) @[TilelinkHost.scala 53:25 30:45]
    node _GEN_42 = mux(io_reqIn_valid, _GEN_29, addReg) @[TilelinkHost.scala 19:25 53:25]
    node _GEN_43 = mux(io_reqIn_valid, _GEN_30, UInt<1>("h0")) @[TilelinkHost.scala 53:25 29:45]
    node _GEN_44 = mux(io_reqIn_valid, _GEN_31, UInt<1>("h0")) @[TilelinkHost.scala 53:25 34:45]
    node _GEN_45 = mux(io_reqIn_valid, _GEN_32, UInt<1>("h0")) @[TilelinkHost.scala 53:25 35:45]
    node _GEN_46 = mux(io_reqIn_valid, _GEN_33, UInt<1>("h0")) @[TilelinkHost.scala 53:25 36:45]
    node _GEN_47 = mux(io_reqIn_valid, _GEN_34, UInt<1>("h1")) @[TilelinkHost.scala 53:25 26:33]
    node _GEN_48 = mux(io_reqIn_valid, _GEN_35, _GEN_5) @[TilelinkHost.scala 53:25]
    node _GEN_49 = mux(io_reqIn_valid, _GEN_36, UInt<1>("h0")) @[TilelinkHost.scala 53:25 25:33]
    node _T_11 = gt(counterHost, UInt<1>("h0")) @[TilelinkHost.scala 137:26]
    node _GEN_50 = mux(_T_11, UInt<1>("h0"), UInt<1>("h1")) @[TilelinkHost.scala 137:32 138:28 140:38]
    node _GEN_51 = mux(io_tlSlaveReceiver_valid, io_tlSlaveReceiver_bits_d_data, UInt<1>("h0")) @[TilelinkHost.scala 129:35 131:37 37:45]
    node _GEN_52 = mux(io_tlSlaveReceiver_valid, io_tlSlaveReceiver_bits_d_denied, UInt<1>("h0")) @[TilelinkHost.scala 129:35 132:30 38:45]
    node _GEN_53 = mux(io_tlSlaveReceiver_valid, io_tlSlaveReceiver_valid, UInt<1>("h0")) @[TilelinkHost.scala 129:35 134:25 39:45]
    node _GEN_54 = mux(io_tlSlaveReceiver_valid, UInt<1>("h0"), _GEN_49) @[TilelinkHost.scala 129:35 136:34]
    node _GEN_55 = mux(io_tlSlaveReceiver_valid, _GEN_50, _GEN_47) @[TilelinkHost.scala 129:35]
    io_tlMasterTransmitter_valid <= _GEN_46
    io_tlMasterTransmitter_bits_a_opcode <= _GEN_37
    io_tlMasterTransmitter_bits_a_param <= pad(_GEN_38, 3)
    io_tlMasterTransmitter_bits_a_size <= _GEN_39
    io_tlMasterTransmitter_bits_a_source <= pad(_GEN_40, 8)
    io_tlMasterTransmitter_bits_a_address <= _GEN_41
    io_tlMasterTransmitter_bits_a_mask <= _GEN_44
    io_tlMasterTransmitter_bits_a_corrupt <= _GEN_45
    io_tlMasterTransmitter_bits_a_data <= _GEN_43
    io_tlSlaveReceiver_ready <= _GEN_54
    io_reqIn_ready <= _GEN_55
    io_rspOut_valid <= _GEN_53
    io_rspOut_bits_dataResponse <= _GEN_51
    io_rspOut_bits_error <= _GEN_52
    opReg <= mux(reset, UInt<3>("h6"), _GEN_1) @[TilelinkHost.scala 16:{24,24}]
    paramReg <= mux(reset, UInt<1>("h0"), _GEN_2) @[TilelinkHost.scala 17:{27,27}]
    sizeReg <= mux(reset, UInt<1>("h0"), _GEN_3) @[TilelinkHost.scala 18:{26,26}]
    addReg <= mux(reset, UInt<1>("h0"), _GEN_42) @[TilelinkHost.scala 19:{25,25}]
    sourceReg <= mux(reset, UInt<1>("h0"), _GEN_4) @[TilelinkHost.scala 20:{28,28}]
    counterHost <= mux(reset, UInt<1>("h0"), _GEN_48) @[TilelinkHost.scala 21:{30,30}]

  module TilelinkDevice :
    input clock : Clock
    input reset : UInt<1>
    input io_tlSlaveTransmitter_ready : UInt<1>
    output io_tlSlaveTransmitter_valid : UInt<1>
    output io_tlSlaveTransmitter_bits_d_opcode : UInt<3>
    output io_tlSlaveTransmitter_bits_d_param : UInt<2>
    output io_tlSlaveTransmitter_bits_d_size : UInt<2>
    output io_tlSlaveTransmitter_bits_d_source : UInt<8>
    output io_tlSlaveTransmitter_bits_d_sink : UInt<1>
    output io_tlSlaveTransmitter_bits_d_denied : UInt<1>
    output io_tlSlaveTransmitter_bits_d_corrupt : UInt<1>
    output io_tlSlaveTransmitter_bits_d_data : UInt<32>
    output io_tlMasterReceiver_ready : UInt<1>
    input io_tlMasterReceiver_valid : UInt<1>
    input io_tlMasterReceiver_bits_a_opcode : UInt<3>
    input io_tlMasterReceiver_bits_a_param : UInt<3>
    input io_tlMasterReceiver_bits_a_size : UInt<2>
    input io_tlMasterReceiver_bits_a_source : UInt<8>
    input io_tlMasterReceiver_bits_a_address : UInt<32>
    input io_tlMasterReceiver_bits_a_mask : UInt<4>
    input io_tlMasterReceiver_bits_a_corrupt : UInt<1>
    input io_tlMasterReceiver_bits_a_data : UInt<32>
    input io_reqOut_ready : UInt<1>
    output io_reqOut_valid : UInt<1>
    output io_reqOut_bits_addrRequest : UInt<32>
    output io_reqOut_bits_dataRequest : UInt<32>
    output io_reqOut_bits_activeByteLane : UInt<4>
    output io_reqOut_bits_isWrite : UInt<1>
    output io_rspIn_ready : UInt<1>
    input io_rspIn_valid : UInt<1>
    input io_rspIn_bits_dataResponse : UInt<32>
    input io_rspIn_bits_error : UInt<1>

    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[TilelinkDevice.scala 21:27]
    reg rspData : UInt<32>, clock with :
      reset => (UInt<1>("h0"), rspData) @[TilelinkDevice.scala 22:26]
    reg addRegD : UInt<32>, clock with :
      reset => (UInt<1>("h0"), addRegD) @[TilelinkDevice.scala 24:26]
    reg maskRegD : UInt<4>, clock with :
      reset => (UInt<1>("h0"), maskRegD) @[TilelinkDevice.scala 25:27]
    reg counterD : UInt<2>, clock with :
      reset => (UInt<1>("h0"), counterD) @[TilelinkDevice.scala 26:27]
    reg opRegD : UInt<3>, clock with :
      reset => (UInt<1>("h0"), opRegD) @[TilelinkDevice.scala 27:25]
    node _T = eq(counterD, UInt<1>("h0")) @[TilelinkDevice.scala 58:19]
    node _GEN_0 = mux(io_tlMasterReceiver_valid, io_tlMasterReceiver_bits_a_opcode, UInt<3>("h6")) @[TilelinkDevice.scala 59:40 60:20 62:20]
    node _GEN_1 = mux(_T, _GEN_0, opRegD) @[TilelinkDevice.scala 27:25 58:27]
    node _GEN_2 = mux(_T, UInt<1>("h0"), addRegD) @[TilelinkDevice.scala 58:27 64:17 24:26]
    node _GEN_3 = mux(_T, UInt<1>("h0"), maskRegD) @[TilelinkDevice.scala 58:27 65:18 25:27]
    node _T_1 = eq(opRegD, UInt<2>("h2")) @[TilelinkDevice.scala 68:40]
    node _T_2 = eq(opRegD, UInt<2>("h3")) @[TilelinkDevice.scala 68:67]
    node _T_3 = or(_T_1, _T_2) @[TilelinkDevice.scala 68:57]
    node _T_4 = and(UInt<1>("h0"), _T_3) @[TilelinkDevice.scala 68:29]
    node _T_5 = eq(stateReg, UInt<2>("h0")) @[TilelinkDevice.scala 69:22]
    node _T_6 = gt(counterD, UInt<1>("h0")) @[TilelinkDevice.scala 73:27]
    node _T_7 = dshl(UInt<1>("h1"), io_tlMasterReceiver_bits_a_size) @[TilelinkDevice.scala 73:42]
    node _T_8 = gt(_T_7, UInt<3>("h4")) @[TilelinkDevice.scala 73:87]
    node _T_9 = and(_T_6, _T_8) @[TilelinkDevice.scala 73:33]
    node _io_reqOut_bits_addrRequest_T = add(addRegD, UInt<3>("h4")) @[TilelinkDevice.scala 74:55]
    node _io_reqOut_bits_addrRequest_T_1 = tail(_io_reqOut_bits_addrRequest_T, 1) @[TilelinkDevice.scala 74:55]
    node _addRegD_T = add(addRegD, UInt<3>("h4")) @[TilelinkDevice.scala 75:36]
    node _addRegD_T_1 = tail(_addRegD_T, 1) @[TilelinkDevice.scala 75:36]
    node _counterD_T = sub(counterD, UInt<1>("h1")) @[TilelinkDevice.scala 76:38]
    node _counterD_T_1 = tail(_counterD_T, 1) @[TilelinkDevice.scala 76:38]
    node _GEN_4 = mux(_T_9, _io_reqOut_bits_addrRequest_T_1, io_tlMasterReceiver_bits_a_address) @[TilelinkDevice.scala 73:101 74:44 78:44]
    node _GEN_5 = mux(_T_9, _addRegD_T_1, _GEN_2) @[TilelinkDevice.scala 73:101 75:25]
    node _GEN_6 = mux(_T_9, _counterD_T_1, counterD) @[TilelinkDevice.scala 73:101 76:26 26:27]
    node _T_10 = eq(counterD, UInt<1>("h0")) @[TilelinkDevice.scala 86:27]
    node _T_11 = dshl(UInt<1>("h1"), io_tlMasterReceiver_bits_a_size) @[TilelinkDevice.scala 86:44]
    node _T_12 = gt(_T_11, UInt<3>("h4")) @[TilelinkDevice.scala 86:89]
    node _T_13 = and(_T_10, _T_12) @[TilelinkDevice.scala 86:35]
    node _counterD_T_2 = dshl(UInt<1>("h1"), io_tlMasterReceiver_bits_a_size) @[TilelinkDevice.scala 88:35]
    node _counterD_T_3 = div(_counterD_T_2, UInt<3>("h4")) @[TilelinkDevice.scala 88:80]
    node _counterD_T_4 = sub(_counterD_T_3, UInt<1>("h1")) @[TilelinkDevice.scala 88:93]
    node _counterD_T_5 = tail(_counterD_T_4, 1) @[TilelinkDevice.scala 88:93]
    node _GEN_7 = mux(_T_13, io_tlMasterReceiver_bits_a_address, _GEN_5) @[TilelinkDevice.scala 86:103 87:25]
    node _GEN_8 = mux(_T_13, _counterD_T_5, _GEN_6) @[TilelinkDevice.scala 86:103 88:26]
    node _GEN_9 = mux(io_tlMasterReceiver_valid, _GEN_4, UInt<1>("h0")) @[TilelinkDevice.scala 41:37 70:40]
    node _GEN_10 = mux(io_tlMasterReceiver_valid, _GEN_7, _GEN_2) @[TilelinkDevice.scala 70:40]
    node _GEN_11 = mux(io_tlMasterReceiver_valid, _GEN_8, counterD) @[TilelinkDevice.scala 26:27 70:40]
    node _GEN_12 = mux(io_tlMasterReceiver_valid, io_tlMasterReceiver_bits_a_data, UInt<1>("h0")) @[TilelinkDevice.scala 42:37 70:40 80:40]
    node _GEN_13 = mux(io_tlMasterReceiver_valid, io_tlMasterReceiver_bits_a_mask, UInt<1>("h0")) @[TilelinkDevice.scala 43:37 70:40 81:43]
    node _GEN_14 = mux(io_tlMasterReceiver_valid, UInt<1>("h0"), UInt<1>("h0")) @[TilelinkDevice.scala 70:40 82:36 44:37]
    node _GEN_15 = mux(io_tlMasterReceiver_valid, UInt<1>("h1"), UInt<1>("h0")) @[TilelinkDevice.scala 70:40 83:29 45:37]
    node _GEN_16 = mux(io_tlMasterReceiver_valid, UInt<2>("h1"), stateReg) @[TilelinkDevice.scala 70:40 85:22 21:27]
    node _T_14 = eq(stateReg, UInt<2>("h1")) @[TilelinkDevice.scala 92:27]
    node _io_reqOut_bits_dataRequest_T = eq(io_tlMasterReceiver_bits_a_opcode, UInt<2>("h2")) @[TilelinkDevice.scala 98:124]
    node _io_reqOut_bits_dataRequest_T_1 = eq(io_tlMasterReceiver_bits_a_param, UInt<1>("h0")) @[TilelinkDevice.scala 99:187]
    node _io_reqOut_bits_dataRequest_T_2 = lt(io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 99:234]
    node _io_reqOut_bits_dataRequest_T_3 = mux(_io_reqOut_bits_dataRequest_T_2, io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 99:201]
    node _io_reqOut_bits_dataRequest_T_4 = eq(io_tlMasterReceiver_bits_a_param, UInt<1>("h1")) @[TilelinkDevice.scala 102:187]
    node _io_reqOut_bits_dataRequest_T_5 = lt(io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 102:234]
    node _io_reqOut_bits_dataRequest_T_6 = mux(_io_reqOut_bits_dataRequest_T_5, io_rspIn_bits_dataResponse, io_tlMasterReceiver_bits_a_data) @[TilelinkDevice.scala 102:201]
    node _io_reqOut_bits_dataRequest_T_7 = eq(io_tlMasterReceiver_bits_a_param, UInt<2>("h2")) @[TilelinkDevice.scala 105:187]
    node _io_reqOut_bits_dataRequest_T_8 = lt(io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 105:234]
    node _io_reqOut_bits_dataRequest_T_9 = mux(_io_reqOut_bits_dataRequest_T_8, io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 105:201]
    node _io_reqOut_bits_dataRequest_T_10 = eq(io_tlMasterReceiver_bits_a_param, UInt<2>("h3")) @[TilelinkDevice.scala 108:187]
    node _io_reqOut_bits_dataRequest_T_11 = lt(io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 108:234]
    node _io_reqOut_bits_dataRequest_T_12 = mux(_io_reqOut_bits_dataRequest_T_11, io_rspIn_bits_dataResponse, io_tlMasterReceiver_bits_a_data) @[TilelinkDevice.scala 108:201]
    node _io_reqOut_bits_dataRequest_T_13 = eq(io_tlMasterReceiver_bits_a_param, UInt<3>("h4")) @[TilelinkDevice.scala 111:187]
    node _io_reqOut_bits_dataRequest_T_14 = add(io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 111:231]
    node _io_reqOut_bits_dataRequest_T_15 = tail(_io_reqOut_bits_dataRequest_T_14, 1) @[TilelinkDevice.scala 111:231]
    node _io_reqOut_bits_dataRequest_T_16 = mux(_io_reqOut_bits_dataRequest_T_13, _io_reqOut_bits_dataRequest_T_15, io_rspIn_bits_dataResponse) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_17 = mux(_io_reqOut_bits_dataRequest_T_10, _io_reqOut_bits_dataRequest_T_12, _io_reqOut_bits_dataRequest_T_16) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_18 = mux(_io_reqOut_bits_dataRequest_T_7, _io_reqOut_bits_dataRequest_T_9, _io_reqOut_bits_dataRequest_T_17) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_19 = mux(_io_reqOut_bits_dataRequest_T_4, _io_reqOut_bits_dataRequest_T_6, _io_reqOut_bits_dataRequest_T_18) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_20 = mux(_io_reqOut_bits_dataRequest_T_1, _io_reqOut_bits_dataRequest_T_3, _io_reqOut_bits_dataRequest_T_19) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_21 = eq(io_tlMasterReceiver_bits_a_opcode, UInt<2>("h3")) @[TilelinkDevice.scala 113:124]
    node _io_reqOut_bits_dataRequest_T_22 = eq(io_tlMasterReceiver_bits_a_param, UInt<1>("h0")) @[TilelinkDevice.scala 114:187]
    node _io_reqOut_bits_dataRequest_T_23 = xor(io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 114:231]
    node _io_reqOut_bits_dataRequest_T_24 = eq(io_tlMasterReceiver_bits_a_param, UInt<1>("h1")) @[TilelinkDevice.scala 115:187]
    node _io_reqOut_bits_dataRequest_T_25 = or(io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 115:231]
    node _io_reqOut_bits_dataRequest_T_26 = eq(io_tlMasterReceiver_bits_a_param, UInt<2>("h2")) @[TilelinkDevice.scala 116:187]
    node _io_reqOut_bits_dataRequest_T_27 = and(io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[TilelinkDevice.scala 116:231]
    node _io_reqOut_bits_dataRequest_T_28 = eq(io_tlMasterReceiver_bits_a_param, UInt<2>("h3")) @[TilelinkDevice.scala 117:187]
    node _io_reqOut_bits_dataRequest_T_29 = mux(_io_reqOut_bits_dataRequest_T_28, io_tlMasterReceiver_bits_a_data, io_rspIn_bits_dataResponse) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_30 = mux(_io_reqOut_bits_dataRequest_T_26, _io_reqOut_bits_dataRequest_T_27, _io_reqOut_bits_dataRequest_T_29) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_31 = mux(_io_reqOut_bits_dataRequest_T_24, _io_reqOut_bits_dataRequest_T_25, _io_reqOut_bits_dataRequest_T_30) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_32 = mux(_io_reqOut_bits_dataRequest_T_22, _io_reqOut_bits_dataRequest_T_23, _io_reqOut_bits_dataRequest_T_31) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_33 = mux(_io_reqOut_bits_dataRequest_T_21, _io_reqOut_bits_dataRequest_T_32, io_rspIn_bits_dataResponse) @[Mux.scala 101:16]
    node _io_reqOut_bits_dataRequest_T_34 = mux(_io_reqOut_bits_dataRequest_T, _io_reqOut_bits_dataRequest_T_20, _io_reqOut_bits_dataRequest_T_33) @[Mux.scala 101:16]
    node _GEN_17 = mux(io_rspIn_valid, addRegD, UInt<1>("h0")) @[TilelinkDevice.scala 95:33 41:37 96:44]
    node _GEN_18 = mux(io_rspIn_valid, _io_reqOut_bits_dataRequest_T_34, UInt<1>("h0")) @[TilelinkDevice.scala 95:33 42:37 97:44]
    node _GEN_19 = mux(io_rspIn_valid, io_tlMasterReceiver_bits_a_mask, UInt<1>("h0")) @[TilelinkDevice.scala 95:33 121:47 43:37]
    node _GEN_20 = mux(io_rspIn_valid, UInt<1>("h1"), UInt<1>("h0")) @[TilelinkDevice.scala 95:33 122:40 44:37]
    node _GEN_21 = mux(io_rspIn_valid, io_rspIn_bits_dataResponse, rspData) @[TilelinkDevice.scala 124:25 22:26 95:33]
    node _GEN_22 = mux(io_rspIn_valid, UInt<2>("h2"), stateReg) @[TilelinkDevice.scala 125:26 21:27 95:33]
    node _T_15 = eq(stateReg, UInt<2>("h2")) @[TilelinkDevice.scala 130:27]
    node _GEN_23 = mux(io_rspIn_valid, UInt<1>("h0"), UInt<1>("h1")) @[TilelinkDevice.scala 131:28 134:33 135:32]
    node _GEN_24 = mux(io_rspIn_valid, rspData, UInt<1>("h0")) @[TilelinkDevice.scala 134:33 138:51 48:45]
    node _GEN_25 = mux(io_rspIn_valid, UInt<1>("h0"), UInt<1>("h0")) @[TilelinkDevice.scala 134:33 139:52 49:45]
    node _GEN_26 = mux(io_rspIn_valid, io_tlMasterReceiver_bits_a_size, UInt<1>("h0")) @[TilelinkDevice.scala 134:33 140:51 50:45]
    node _GEN_27 = mux(io_rspIn_valid, io_tlMasterReceiver_bits_a_source, UInt<1>("h0")) @[TilelinkDevice.scala 134:33 141:53 51:45]
    node _GEN_28 = mux(io_rspIn_valid, io_rspIn_bits_error, UInt<1>("h0")) @[TilelinkDevice.scala 134:33 143:53 53:45]
    node _GEN_29 = mux(io_rspIn_valid, io_rspIn_valid, UInt<1>("h0")) @[TilelinkDevice.scala 134:33 145:45 55:45]
    node _GEN_30 = mux(io_rspIn_valid, UInt<2>("h0"), stateReg) @[TilelinkDevice.scala 134:33 147:26 21:27]
    node _GEN_31 = mux(_T_15, _GEN_23, UInt<1>("h0")) @[TilelinkDevice.scala 130:44 30:20]
    node _GEN_32 = mux(_T_15, UInt<1>("h0"), UInt<1>("h0")) @[TilelinkDevice.scala 130:44 132:29 45:37]
    node _GEN_33 = mux(_T_15, _GEN_20, UInt<1>("h0")) @[TilelinkDevice.scala 130:44 47:45]
    node _GEN_34 = mux(_T_15, _GEN_24, UInt<1>("h0")) @[TilelinkDevice.scala 130:44 48:45]
    node _GEN_35 = mux(_T_15, _GEN_25, UInt<1>("h0")) @[TilelinkDevice.scala 130:44 49:45]
    node _GEN_36 = mux(_T_15, _GEN_26, UInt<1>("h0")) @[TilelinkDevice.scala 130:44 50:45]
    node _GEN_37 = mux(_T_15, _GEN_27, UInt<1>("h0")) @[TilelinkDevice.scala 130:44 51:45]
    node _GEN_38 = mux(_T_15, _GEN_28, UInt<1>("h0")) @[TilelinkDevice.scala 130:44 53:45]
    node _GEN_39 = mux(_T_15, _GEN_29, UInt<1>("h0")) @[TilelinkDevice.scala 130:44 55:45]
    node _GEN_40 = mux(_T_15, _GEN_30, stateReg) @[TilelinkDevice.scala 130:44 21:27]
    node _GEN_41 = mux(_T_14, _GEN_20, _GEN_32) @[TilelinkDevice.scala 92:34]
    node _GEN_42 = mux(_T_14, UInt<1>("h1"), _GEN_31) @[TilelinkDevice.scala 92:34 94:28]
    node _GEN_43 = mux(_T_14, _GEN_17, UInt<1>("h0")) @[TilelinkDevice.scala 92:34 41:37]
    node _GEN_44 = mux(_T_14, _GEN_18, UInt<1>("h0")) @[TilelinkDevice.scala 92:34 42:37]
    node _GEN_45 = mux(_T_14, _GEN_19, UInt<1>("h0")) @[TilelinkDevice.scala 92:34 43:37]
    node _GEN_46 = mux(_T_14, _GEN_20, UInt<1>("h0")) @[TilelinkDevice.scala 92:34 44:37]
    node _GEN_47 = mux(_T_14, _GEN_21, rspData) @[TilelinkDevice.scala 22:26 92:34]
    node _GEN_48 = mux(_T_14, _GEN_22, _GEN_40) @[TilelinkDevice.scala 92:34]
    node _GEN_49 = mux(_T_14, UInt<1>("h0"), _GEN_33) @[TilelinkDevice.scala 92:34 47:45]
    node _GEN_50 = mux(_T_14, UInt<1>("h0"), _GEN_34) @[TilelinkDevice.scala 92:34 48:45]
    node _GEN_51 = mux(_T_14, UInt<1>("h0"), _GEN_35) @[TilelinkDevice.scala 92:34 49:45]
    node _GEN_52 = mux(_T_14, UInt<1>("h0"), _GEN_36) @[TilelinkDevice.scala 92:34 50:45]
    node _GEN_53 = mux(_T_14, UInt<1>("h0"), _GEN_37) @[TilelinkDevice.scala 92:34 51:45]
    node _GEN_54 = mux(_T_14, UInt<1>("h0"), _GEN_38) @[TilelinkDevice.scala 92:34 53:45]
    node _GEN_55 = mux(_T_14, UInt<1>("h0"), _GEN_39) @[TilelinkDevice.scala 92:34 55:45]
    node _GEN_56 = mux(_T_5, _GEN_9, _GEN_43) @[TilelinkDevice.scala 69:31]
    node _GEN_57 = mux(_T_5, _GEN_10, _GEN_2) @[TilelinkDevice.scala 69:31]
    node _GEN_58 = mux(_T_5, _GEN_11, counterD) @[TilelinkDevice.scala 26:27 69:31]
    node _GEN_59 = mux(_T_5, _GEN_12, _GEN_44) @[TilelinkDevice.scala 69:31]
    node _GEN_60 = mux(_T_5, _GEN_13, _GEN_45) @[TilelinkDevice.scala 69:31]
    node _GEN_61 = mux(_T_5, _GEN_14, _GEN_46) @[TilelinkDevice.scala 69:31]
    node _GEN_62 = mux(_T_5, _GEN_15, _GEN_41) @[TilelinkDevice.scala 69:31]
    node _GEN_63 = mux(_T_5, _GEN_15, _GEN_42) @[TilelinkDevice.scala 69:31]
    node _GEN_64 = mux(_T_5, _GEN_16, _GEN_48) @[TilelinkDevice.scala 69:31]
    node _GEN_65 = mux(_T_5, rspData, _GEN_47) @[TilelinkDevice.scala 22:26 69:31]
    node _GEN_66 = mux(_T_5, UInt<1>("h0"), _GEN_49) @[TilelinkDevice.scala 69:31 47:45]
    node _GEN_67 = mux(_T_5, UInt<1>("h0"), _GEN_50) @[TilelinkDevice.scala 69:31 48:45]
    node _GEN_68 = mux(_T_5, UInt<1>("h0"), _GEN_51) @[TilelinkDevice.scala 69:31 49:45]
    node _GEN_69 = mux(_T_5, UInt<1>("h0"), _GEN_52) @[TilelinkDevice.scala 69:31 50:45]
    node _GEN_70 = mux(_T_5, UInt<1>("h0"), _GEN_53) @[TilelinkDevice.scala 69:31 51:45]
    node _GEN_71 = mux(_T_5, UInt<1>("h0"), _GEN_54) @[TilelinkDevice.scala 69:31 53:45]
    node _GEN_72 = mux(_T_5, UInt<1>("h0"), _GEN_55) @[TilelinkDevice.scala 69:31 55:45]
    node _T_16 = gt(counterD, UInt<1>("h0")) @[TilelinkDevice.scala 153:43]
    node _T_17 = and(UInt<1>("h0"), _T_16) @[TilelinkDevice.scala 153:31]
    node _T_18 = eq(opRegD, UInt<3>("h4")) @[TilelinkDevice.scala 153:59]
    node _T_19 = and(_T_17, _T_18) @[TilelinkDevice.scala 153:49]
    node _io_reqOut_bits_addrRequest_T_2 = add(addRegD, UInt<3>("h4")) @[TilelinkDevice.scala 154:52]
    node _io_reqOut_bits_addrRequest_T_3 = tail(_io_reqOut_bits_addrRequest_T_2, 1) @[TilelinkDevice.scala 154:52]
    node _counterD_T_6 = sub(counterD, UInt<1>("h1")) @[TilelinkDevice.scala 157:34]
    node _counterD_T_7 = tail(_counterD_T_6, 1) @[TilelinkDevice.scala 157:34]
    node _addRegD_T_2 = add(addRegD, UInt<3>("h4")) @[TilelinkDevice.scala 160:32]
    node _addRegD_T_3 = tail(_addRegD_T_2, 1) @[TilelinkDevice.scala 160:32]
    node _io_reqOut_bits_isWrite_T = eq(io_tlMasterReceiver_bits_a_opcode, UInt<1>("h0")) @[TilelinkDevice.scala 169:73]
    node _io_reqOut_bits_isWrite_T_1 = eq(io_tlMasterReceiver_bits_a_opcode, UInt<1>("h1")) @[TilelinkDevice.scala 169:128]
    node _io_reqOut_bits_isWrite_T_2 = or(_io_reqOut_bits_isWrite_T, _io_reqOut_bits_isWrite_T_1) @[TilelinkDevice.scala 169:91]
    node _T_20 = dshl(UInt<1>("h1"), io_tlMasterReceiver_bits_a_size) @[TilelinkDevice.scala 174:24]
    node _T_21 = gt(_T_20, UInt<3>("h4")) @[TilelinkDevice.scala 174:69]
    node _T_22 = eq(io_tlMasterReceiver_bits_a_opcode, UInt<3>("h4")) @[TilelinkDevice.scala 174:120]
    node _T_23 = and(_T_21, _T_22) @[TilelinkDevice.scala 174:83]
    node _counterD_T_8 = dshl(UInt<1>("h1"), io_tlMasterReceiver_bits_a_size) @[TilelinkDevice.scala 178:35]
    node _counterD_T_9 = div(_counterD_T_8, UInt<3>("h4")) @[TilelinkDevice.scala 178:78]
    node _counterD_T_10 = sub(_counterD_T_9, UInt<1>("h1")) @[TilelinkDevice.scala 178:90]
    node _counterD_T_11 = tail(_counterD_T_10, 1) @[TilelinkDevice.scala 178:90]
    node _GEN_73 = mux(_T_23, io_tlMasterReceiver_bits_a_opcode, _GEN_1) @[TilelinkDevice.scala 174:130 175:24]
    node _GEN_74 = mux(_T_23, io_tlMasterReceiver_bits_a_address, _GEN_2) @[TilelinkDevice.scala 174:130 176:25]
    node _GEN_75 = mux(_T_23, io_tlMasterReceiver_bits_a_mask, _GEN_3) @[TilelinkDevice.scala 174:130 177:26]
    node _GEN_76 = mux(_T_23, _counterD_T_11, counterD) @[TilelinkDevice.scala 174:130 178:26 26:27]
    node _GEN_77 = mux(io_tlMasterReceiver_valid, io_tlMasterReceiver_bits_a_address, UInt<1>("h0")) @[TilelinkDevice.scala 164:45 166:40 41:37]
    node _GEN_78 = mux(io_tlMasterReceiver_valid, _io_reqOut_bits_isWrite_T_2, UInt<1>("h0")) @[TilelinkDevice.scala 164:45 169:36 44:37]
    node _GEN_79 = mux(io_tlMasterReceiver_valid, _GEN_73, _GEN_1) @[TilelinkDevice.scala 164:45]
    node _GEN_80 = mux(io_tlMasterReceiver_valid, _GEN_74, _GEN_2) @[TilelinkDevice.scala 164:45]
    node _GEN_81 = mux(io_tlMasterReceiver_valid, _GEN_75, _GEN_3) @[TilelinkDevice.scala 164:45]
    node _GEN_82 = mux(io_tlMasterReceiver_valid, _GEN_76, counterD) @[TilelinkDevice.scala 164:45 26:27]
    node _GEN_83 = mux(_T_19, _io_reqOut_bits_addrRequest_T_3, _GEN_77) @[TilelinkDevice.scala 153:69 154:40]
    node _GEN_84 = mux(_T_19, maskRegD, _GEN_13) @[TilelinkDevice.scala 153:69 155:43]
    node _GEN_85 = mux(_T_19, UInt<1>("h0"), _GEN_78) @[TilelinkDevice.scala 153:69 156:36]
    node _GEN_86 = mux(_T_19, _counterD_T_7, _GEN_82) @[TilelinkDevice.scala 153:69 157:22]
    node _GEN_87 = mux(_T_19, UInt<1>("h1"), _GEN_15) @[TilelinkDevice.scala 153:69 158:29]
    node _GEN_88 = mux(_T_19, _addRegD_T_3, _GEN_80) @[TilelinkDevice.scala 153:69 160:21]
    node _GEN_89 = mux(_T_19, UInt<1>("h0"), _GEN_12) @[TilelinkDevice.scala 153:69 42:37]
    node _GEN_90 = mux(_T_19, _GEN_1, _GEN_79) @[TilelinkDevice.scala 153:69]
    node _GEN_91 = mux(_T_19, _GEN_3, _GEN_81) @[TilelinkDevice.scala 153:69]
    node _T_24 = and(io_rspIn_valid, UInt<1>("h0")) @[TilelinkDevice.scala 185:29]
    node _T_25 = gt(counterD, UInt<1>("h0")) @[TilelinkDevice.scala 185:61]
    node _T_26 = and(_T_24, _T_25) @[TilelinkDevice.scala 185:49]
    node _T_27 = neq(opRegD, UInt<3>("h4")) @[TilelinkDevice.scala 185:77]
    node _T_28 = and(_T_26, _T_27) @[TilelinkDevice.scala 185:67]
    node _counterD_T_12 = sub(counterD, UInt<1>("h1")) @[TilelinkDevice.scala 187:34]
    node _counterD_T_13 = tail(_counterD_T_12, 1) @[TilelinkDevice.scala 187:34]
    node _T_29 = eq(io_tlMasterReceiver_bits_a_opcode, UInt<3>("h4")) @[TilelinkDevice.scala 201:52]
    node _GEN_92 = mux(_T_29, UInt<1>("h0"), UInt<1>("h1")) @[TilelinkDevice.scala 201:62 202:53 204:53]
    node _T_30 = dshl(UInt<1>("h1"), io_tlMasterReceiver_bits_a_size) @[TilelinkDevice.scala 214:24]
    node _T_31 = gt(_T_30, UInt<3>("h4")) @[TilelinkDevice.scala 214:67]
    node _T_32 = neq(io_tlMasterReceiver_bits_a_opcode, UInt<3>("h4")) @[TilelinkDevice.scala 214:118]
    node _T_33 = and(_T_31, _T_32) @[TilelinkDevice.scala 214:81]
    node _counterD_T_14 = dshl(UInt<1>("h1"), io_tlMasterReceiver_bits_a_size) @[TilelinkDevice.scala 215:35]
    node _counterD_T_15 = div(_counterD_T_14, UInt<3>("h4")) @[TilelinkDevice.scala 215:78]
    node _counterD_T_16 = sub(_counterD_T_15, UInt<1>("h1")) @[TilelinkDevice.scala 215:90]
    node _counterD_T_17 = tail(_counterD_T_16, 1) @[TilelinkDevice.scala 215:90]
    node _GEN_93 = mux(_T_33, _counterD_T_17, _GEN_86) @[TilelinkDevice.scala 214:128 215:26]
    node _GEN_94 = mux(_T_33, io_tlMasterReceiver_bits_a_opcode, _GEN_90) @[TilelinkDevice.scala 214:128 216:24]
    node _GEN_95 = mux(io_rspIn_valid, _GEN_92, UInt<1>("h0")) @[TilelinkDevice.scala 199:34 47:45]
    node _GEN_96 = mux(io_rspIn_valid, io_rspIn_bits_dataResponse, UInt<1>("h0")) @[TilelinkDevice.scala 199:34 205:51 48:45]
    node _GEN_97 = mux(io_rspIn_valid, _GEN_93, _GEN_86) @[TilelinkDevice.scala 199:34]
    node _GEN_98 = mux(io_rspIn_valid, _GEN_94, _GEN_90) @[TilelinkDevice.scala 199:34]
    node _GEN_99 = mux(io_rspIn_valid, UInt<1>("h0"), _GEN_87) @[TilelinkDevice.scala 199:34 218:28]
    node _GEN_100 = mux(_T_28, UInt<1>("h0"), _GEN_99) @[TilelinkDevice.scala 185:87 186:28]
    node _GEN_101 = mux(_T_28, _counterD_T_13, _GEN_97) @[TilelinkDevice.scala 185:87 187:22]
    node _GEN_102 = mux(_T_28, UInt<2>("h3"), _GEN_95) @[TilelinkDevice.scala 185:87 189:49]
    node _GEN_103 = mux(_T_28, UInt<1>("h0"), _GEN_96) @[TilelinkDevice.scala 185:87 190:47]
    node _GEN_104 = mux(_T_28, UInt<1>("h0"), _GEN_25) @[TilelinkDevice.scala 185:87 191:48]
    node _GEN_105 = mux(_T_28, UInt<1>("h0"), _GEN_26) @[TilelinkDevice.scala 185:87 192:47]
    node _GEN_106 = mux(_T_28, UInt<1>("h0"), _GEN_27) @[TilelinkDevice.scala 185:87 193:49]
    node _GEN_107 = mux(_T_28, UInt<1>("h0"), _GEN_28) @[TilelinkDevice.scala 185:87 195:49]
    node _GEN_108 = mux(_T_28, UInt<1>("h0"), _GEN_29) @[TilelinkDevice.scala 185:87 197:41]
    node _GEN_109 = mux(_T_28, _GEN_90, _GEN_98) @[TilelinkDevice.scala 185:87]
    node _GEN_110 = mux(_T_4, _GEN_56, _GEN_83) @[TilelinkDevice.scala 68:83]
    node _GEN_111 = mux(_T_4, _GEN_57, _GEN_88) @[TilelinkDevice.scala 68:83]
    node _GEN_112 = mux(_T_4, _GEN_58, _GEN_101) @[TilelinkDevice.scala 68:83]
    node _GEN_113 = mux(_T_4, _GEN_59, _GEN_89) @[TilelinkDevice.scala 68:83]
    node _GEN_114 = mux(_T_4, _GEN_60, _GEN_84) @[TilelinkDevice.scala 68:83]
    node _GEN_115 = mux(_T_4, _GEN_61, _GEN_85) @[TilelinkDevice.scala 68:83]
    node _GEN_116 = mux(_T_4, _GEN_62, _GEN_87) @[TilelinkDevice.scala 68:83]
    node _GEN_117 = mux(_T_4, _GEN_63, _GEN_100) @[TilelinkDevice.scala 68:83]
    node _GEN_118 = mux(_T_4, _GEN_64, stateReg) @[TilelinkDevice.scala 21:27 68:83]
    node _GEN_119 = mux(_T_4, _GEN_65, rspData) @[TilelinkDevice.scala 22:26 68:83]
    node _GEN_120 = mux(_T_4, _GEN_66, _GEN_102) @[TilelinkDevice.scala 68:83]
    node _GEN_121 = mux(_T_4, _GEN_67, _GEN_103) @[TilelinkDevice.scala 68:83]
    node _GEN_122 = mux(_T_4, _GEN_68, _GEN_104) @[TilelinkDevice.scala 68:83]
    node _GEN_123 = mux(_T_4, _GEN_69, _GEN_105) @[TilelinkDevice.scala 68:83]
    node _GEN_124 = mux(_T_4, _GEN_70, _GEN_106) @[TilelinkDevice.scala 68:83]
    node _GEN_125 = mux(_T_4, _GEN_71, _GEN_107) @[TilelinkDevice.scala 68:83]
    node _GEN_126 = mux(_T_4, _GEN_72, _GEN_108) @[TilelinkDevice.scala 68:83]
    node _GEN_127 = mux(_T_4, _GEN_1, _GEN_109) @[TilelinkDevice.scala 68:83]
    node _GEN_128 = mux(_T_4, _GEN_3, _GEN_91) @[TilelinkDevice.scala 68:83]
    io_tlSlaveTransmitter_valid <= _GEN_126
    io_tlSlaveTransmitter_bits_d_opcode <= pad(_GEN_120, 3)
    io_tlSlaveTransmitter_bits_d_param <= pad(_GEN_122, 2)
    io_tlSlaveTransmitter_bits_d_size <= _GEN_123
    io_tlSlaveTransmitter_bits_d_source <= _GEN_124
    io_tlSlaveTransmitter_bits_d_sink <= _GEN_122
    io_tlSlaveTransmitter_bits_d_denied <= _GEN_125
    io_tlSlaveTransmitter_bits_d_corrupt <= _GEN_122
    io_tlSlaveTransmitter_bits_d_data <= _GEN_121
    io_tlMasterReceiver_ready <= UInt<1>("h1") @[TilelinkDevice.scala 29:31]
    io_reqOut_valid <= _GEN_116
    io_reqOut_bits_addrRequest <= _GEN_110
    io_reqOut_bits_dataRequest <= _GEN_113
    io_reqOut_bits_activeByteLane <= _GEN_114
    io_reqOut_bits_isWrite <= _GEN_115
    io_rspIn_ready <= _GEN_117
    stateReg <= mux(reset, UInt<2>("h0"), _GEN_118) @[TilelinkDevice.scala 21:{27,27}]
    rspData <= mux(reset, UInt<1>("h0"), _GEN_119) @[TilelinkDevice.scala 22:{26,26}]
    addRegD <= mux(reset, UInt<1>("h0"), _GEN_111) @[TilelinkDevice.scala 24:{26,26}]
    maskRegD <= mux(reset, UInt<1>("h0"), _GEN_128) @[TilelinkDevice.scala 25:{27,27}]
    counterD <= bits(mux(reset, UInt<1>("h0"), _GEN_112), 1, 0) @[TilelinkDevice.scala 26:{27,27}]
    opRegD <= mux(reset, UInt<3>("h6"), _GEN_127) @[TilelinkDevice.scala 27:{25,25}]

  module TilelinkAdapter :
    input clock : Clock
    input reset : UInt<1>
    output io_reqIn_ready : UInt<1>
    input io_reqIn_valid : UInt<1>
    input io_reqIn_bits_addrRequest : UInt<32>
    input io_reqIn_bits_dataRequest : UInt<32>
    input io_reqIn_bits_activeByteLane : UInt<4>
    input io_reqIn_bits_isWrite : UInt<1>
    input io_rspOut_ready : UInt<1>
    output io_rspOut_valid : UInt<1>
    output io_rspOut_bits_dataResponse : UInt<32>
    output io_rspOut_bits_error : UInt<1>
    input io_reqOut_ready : UInt<1>
    output io_reqOut_valid : UInt<1>
    output io_reqOut_bits_addrRequest : UInt<32>
    output io_reqOut_bits_dataRequest : UInt<32>
    output io_reqOut_bits_activeByteLane : UInt<4>
    output io_reqOut_bits_isWrite : UInt<1>
    output io_rspIn_ready : UInt<1>
    input io_rspIn_valid : UInt<1>
    input io_rspIn_bits_dataResponse : UInt<32>
    input io_rspIn_bits_error : UInt<1>

    inst tlHost of TilelinkHost @[TilelinkAdapter.scala 18:24]
    inst tlSlave of TilelinkDevice @[TilelinkAdapter.scala 19:25]
    io_reqIn_ready <= tlHost.io_reqIn_ready @[TilelinkAdapter.scala 28:21]
    io_rspOut_valid <= tlHost.io_rspOut_valid @[TilelinkAdapter.scala 31:15]
    io_rspOut_bits_dataResponse <= tlHost.io_rspOut_bits_dataResponse @[TilelinkAdapter.scala 31:15]
    io_rspOut_bits_error <= tlHost.io_rspOut_bits_error @[TilelinkAdapter.scala 31:15]
    io_reqOut_valid <= tlSlave.io_reqOut_valid @[TilelinkAdapter.scala 34:15]
    io_reqOut_bits_addrRequest <= tlSlave.io_reqOut_bits_addrRequest @[TilelinkAdapter.scala 34:15]
    io_reqOut_bits_dataRequest <= tlSlave.io_reqOut_bits_dataRequest @[TilelinkAdapter.scala 34:15]
    io_reqOut_bits_activeByteLane <= tlSlave.io_reqOut_bits_activeByteLane @[TilelinkAdapter.scala 34:15]
    io_reqOut_bits_isWrite <= tlSlave.io_reqOut_bits_isWrite @[TilelinkAdapter.scala 34:15]
    io_rspIn_ready <= tlSlave.io_rspIn_ready @[TilelinkAdapter.scala 37:22]
    tlHost.clock <= clock
    tlHost.reset <= reset
    tlHost.io_tlMasterTransmitter_ready <= tlSlave.io_tlMasterReceiver_ready @[TilelinkAdapter.scala 22:35]
    tlHost.io_tlSlaveReceiver_valid <= tlSlave.io_tlSlaveTransmitter_valid @[TilelinkAdapter.scala 25:35]
    tlHost.io_tlSlaveReceiver_bits_d_opcode <= tlSlave.io_tlSlaveTransmitter_bits_d_opcode @[TilelinkAdapter.scala 25:35]
    tlHost.io_tlSlaveReceiver_bits_d_param <= tlSlave.io_tlSlaveTransmitter_bits_d_param @[TilelinkAdapter.scala 25:35]
    tlHost.io_tlSlaveReceiver_bits_d_size <= tlSlave.io_tlSlaveTransmitter_bits_d_size @[TilelinkAdapter.scala 25:35]
    tlHost.io_tlSlaveReceiver_bits_d_source <= tlSlave.io_tlSlaveTransmitter_bits_d_source @[TilelinkAdapter.scala 25:35]
    tlHost.io_tlSlaveReceiver_bits_d_sink <= tlSlave.io_tlSlaveTransmitter_bits_d_sink @[TilelinkAdapter.scala 25:35]
    tlHost.io_tlSlaveReceiver_bits_d_denied <= tlSlave.io_tlSlaveTransmitter_bits_d_denied @[TilelinkAdapter.scala 25:35]
    tlHost.io_tlSlaveReceiver_bits_d_corrupt <= tlSlave.io_tlSlaveTransmitter_bits_d_corrupt @[TilelinkAdapter.scala 25:35]
    tlHost.io_tlSlaveReceiver_bits_d_data <= tlSlave.io_tlSlaveTransmitter_bits_d_data @[TilelinkAdapter.scala 25:35]
    tlHost.io_reqIn_valid <= io_reqIn_valid @[TilelinkAdapter.scala 28:21]
    tlHost.io_reqIn_bits_addrRequest <= io_reqIn_bits_addrRequest @[TilelinkAdapter.scala 28:21]
    tlHost.io_reqIn_bits_dataRequest <= io_reqIn_bits_dataRequest @[TilelinkAdapter.scala 28:21]
    tlHost.io_reqIn_bits_activeByteLane <= io_reqIn_bits_activeByteLane @[TilelinkAdapter.scala 28:21]
    tlHost.io_reqIn_bits_isWrite <= io_reqIn_bits_isWrite @[TilelinkAdapter.scala 28:21]
    tlHost.io_rspOut_ready <= io_rspOut_ready @[TilelinkAdapter.scala 31:15]
    tlSlave.clock <= clock
    tlSlave.reset <= reset
    tlSlave.io_tlSlaveTransmitter_ready <= tlHost.io_tlSlaveReceiver_ready @[TilelinkAdapter.scala 25:35]
    tlSlave.io_tlMasterReceiver_valid <= tlHost.io_tlMasterTransmitter_valid @[TilelinkAdapter.scala 22:35]
    tlSlave.io_tlMasterReceiver_bits_a_opcode <= tlHost.io_tlMasterTransmitter_bits_a_opcode @[TilelinkAdapter.scala 22:35]
    tlSlave.io_tlMasterReceiver_bits_a_param <= tlHost.io_tlMasterTransmitter_bits_a_param @[TilelinkAdapter.scala 22:35]
    tlSlave.io_tlMasterReceiver_bits_a_size <= tlHost.io_tlMasterTransmitter_bits_a_size @[TilelinkAdapter.scala 22:35]
    tlSlave.io_tlMasterReceiver_bits_a_source <= tlHost.io_tlMasterTransmitter_bits_a_source @[TilelinkAdapter.scala 22:35]
    tlSlave.io_tlMasterReceiver_bits_a_address <= tlHost.io_tlMasterTransmitter_bits_a_address @[TilelinkAdapter.scala 22:35]
    tlSlave.io_tlMasterReceiver_bits_a_mask <= tlHost.io_tlMasterTransmitter_bits_a_mask @[TilelinkAdapter.scala 22:35]
    tlSlave.io_tlMasterReceiver_bits_a_corrupt <= tlHost.io_tlMasterTransmitter_bits_a_corrupt @[TilelinkAdapter.scala 22:35]
    tlSlave.io_tlMasterReceiver_bits_a_data <= tlHost.io_tlMasterTransmitter_bits_a_data @[TilelinkAdapter.scala 22:35]
    tlSlave.io_reqOut_ready <= io_reqOut_ready @[TilelinkAdapter.scala 34:15]
    tlSlave.io_rspIn_valid <= io_rspIn_valid @[TilelinkAdapter.scala 37:22]
    tlSlave.io_rspIn_bits_dataResponse <= io_rspIn_bits_dataResponse @[TilelinkAdapter.scala 37:22]
    tlSlave.io_rspIn_bits_error <= io_rspIn_bits_error @[TilelinkAdapter.scala 37:22]

  module SRAM :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<8>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[SRAM.scala 26:24]
      data-type => UInt<32>
      depth => 256
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => new
    node _T = and(io_rw, io_EN) @[SRAM.scala 28:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[SRAM.scala 29:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[SRAM.scala 29:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<8>("h0")) @[SRAM.scala 29:22]
    node _io_DO_T_1 = bits(_io_DO_T, 7, 0) @[SRAM.scala 29:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 29:{22,22} 26:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[SRAM.scala 29:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[SRAM.scala 29:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[SRAM.scala 30:14]
    node _T_2 = and(_T_1, io_EN) @[SRAM.scala 30:21]
    node _GEN_4 = validif(_T_2, io_ad) @[SRAM.scala 30:30]
    node _GEN_5 = validif(_T_2, clock) @[SRAM.scala 30:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 26:24 30:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[SRAM.scala 30:30]
    node _GEN_8 = validif(_T_2, io_DI) @[SRAM.scala 30:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[SRAM.scala 30:30 32:11 34:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[SRAM.scala 28:23 26:24]
    node _GEN_11 = validif(_T, _GEN_2) @[SRAM.scala 28:23]
    node _GEN_12 = validif(_T, _GEN_3) @[SRAM.scala 28:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[SRAM.scala 28:23 29:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[SRAM.scala 28:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[SRAM.scala 28:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[SRAM.scala 28:23 26:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[SRAM.scala 28:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[SRAM.scala 28:23]
    io_DO <= _GEN_13
    mem.io_DO_MPORT.addr <= _GEN_11
    mem.io_DO_MPORT.en <= _GEN_10
    mem.io_DO_MPORT.clk <= _GEN_12
    mem.MPORT.addr <= _GEN_14
    mem.MPORT.en <= _GEN_16
    mem.MPORT.clk <= _GEN_15
    mem.MPORT.data <= _GEN_18
    mem.MPORT.mask <= _GEN_17

  module SRAM_1 :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<10>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[SRAM.scala 26:24]
      data-type => UInt<32>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => new
    node _T = and(io_rw, io_EN) @[SRAM.scala 28:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[SRAM.scala 29:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[SRAM.scala 29:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<10>("h0")) @[SRAM.scala 29:22]
    node _io_DO_T_1 = bits(_io_DO_T, 9, 0) @[SRAM.scala 29:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 29:{22,22} 26:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[SRAM.scala 29:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[SRAM.scala 29:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[SRAM.scala 30:14]
    node _T_2 = and(_T_1, io_EN) @[SRAM.scala 30:21]
    node _GEN_4 = validif(_T_2, io_ad) @[SRAM.scala 30:30]
    node _GEN_5 = validif(_T_2, clock) @[SRAM.scala 30:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 26:24 30:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[SRAM.scala 30:30]
    node _GEN_8 = validif(_T_2, io_DI) @[SRAM.scala 30:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[SRAM.scala 30:30 32:11 34:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[SRAM.scala 28:23 26:24]
    node _GEN_11 = validif(_T, _GEN_2) @[SRAM.scala 28:23]
    node _GEN_12 = validif(_T, _GEN_3) @[SRAM.scala 28:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[SRAM.scala 28:23 29:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[SRAM.scala 28:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[SRAM.scala 28:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[SRAM.scala 28:23 26:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[SRAM.scala 28:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[SRAM.scala 28:23]
    io_DO <= _GEN_13
    mem.io_DO_MPORT.addr <= _GEN_11
    mem.io_DO_MPORT.en <= _GEN_10
    mem.io_DO_MPORT.clk <= _GEN_12
    mem.MPORT.addr <= _GEN_14
    mem.MPORT.en <= _GEN_16
    mem.MPORT.clk <= _GEN_15
    mem.MPORT.data <= _GEN_18
    mem.MPORT.mask <= _GEN_17

  module CacheController :
    input clock : Clock
    input reset : UInt<1>
    input io_validReq : UInt<1>
    input io_rw : UInt<1>
    input io_memAdd : UInt<32>
    input io_CPUdataIn : UInt<32>
    output io_CPUdataOut : UInt<32>
    output io_cacheMiss : UInt<1>
    output io_cacheInvalid : UInt<1>
    output io_ready : UInt<1>
    input io_wrEnable_0 : UInt<1>
    input io_wrEnable_1 : UInt<1>
    input io_wrEnable_2 : UInt<1>
    input io_wrEnable_3 : UInt<1>
    input io_memDataIn : UInt<32>
    input io_memReady : UInt<1>
    output io_alloAddr : UInt<32>
    output io_memReq : UInt<2>

    inst tagStore of SRAM @[CacheController.scala 42:24]
    inst cache of SRAM_1 @[CacheController.scala 43:21]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 41:25]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 47:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 48:24]
    node targetTag = bits(io_memAdd, 31, 12) @[CacheController.scala 49:28]
    node actualTag = bits(tagStore.io_DO, 31, 12) @[CacheController.scala 51:33]
    node cacheValid = bits(tagStore.io_DO, 11, 11) @[CacheController.scala 52:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (UInt<1>("h0"), writeIndex) @[CacheController.scala 53:27]
    reg updatedTag : UInt<32>, clock with :
      reset => (UInt<1>("h0"), updatedTag) @[CacheController.scala 54:27]
    node memWordAdd = bits(io_memAdd, 31, 2) @[CacheController.scala 59:29]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 73:25]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 74:26]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 77:30]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 89:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 93:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 93:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 93:20]
    node _GEN_0 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 96:25 CacheFunctions.scala 10:13 20:13]
    node _GEN_1 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 96:25 CacheFunctions.scala 11:13 21:13]
    node _GEN_2 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 96:25 99:18 89:25]
    node cacheReadAdd = _cacheReadAdd_T @[CacheController.scala 56:30 73:16]
    node _GEN_3 = mux(io_validReq, cacheReadAdd, UInt<10>("h0")) @[CacheController.scala 102:18 96:25 58:26]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 93:20]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 93:20]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 93:20]
    node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 113:12]
    node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 118:28]
    node _modifiedData_readBytes_0_T = bits(cache.io_DO, 7, 0) @[CacheFunctions.scala 31:31]
    node _modifiedData_writeBytes_0_T = bits(io_CPUdataIn, 7, 0) @[CacheFunctions.scala 32:33]
    node _modifiedData_readBytes_1_T = bits(cache.io_DO, 15, 8) @[CacheFunctions.scala 31:31]
    node _modifiedData_writeBytes_1_T = bits(io_CPUdataIn, 15, 8) @[CacheFunctions.scala 32:33]
    node _modifiedData_readBytes_2_T = bits(cache.io_DO, 23, 16) @[CacheFunctions.scala 31:31]
    node _modifiedData_writeBytes_2_T = bits(io_CPUdataIn, 23, 16) @[CacheFunctions.scala 32:33]
    node _modifiedData_readBytes_3_T = bits(cache.io_DO, 31, 24) @[CacheFunctions.scala 31:31]
    node _modifiedData_writeBytes_3_T = bits(io_CPUdataIn, 31, 24) @[CacheFunctions.scala 32:33]
    node modifiedData_writeBytes_0 = _modifiedData_writeBytes_0_T @[CacheFunctions.scala 26:26 32:21]
    node modifiedData_readBytes_0 = _modifiedData_readBytes_0_T @[CacheFunctions.scala 27:25 31:20]
    node _modifiedData_resultBytes_0_T = mux(io_wrEnable_0, modifiedData_writeBytes_0, modifiedData_readBytes_0) @[CacheFunctions.scala 38:28]
    node modifiedData_writeBytes_1 = _modifiedData_writeBytes_1_T @[CacheFunctions.scala 26:26 32:21]
    node modifiedData_readBytes_1 = _modifiedData_readBytes_1_T @[CacheFunctions.scala 27:25 31:20]
    node _modifiedData_resultBytes_1_T = mux(io_wrEnable_1, modifiedData_writeBytes_1, modifiedData_readBytes_1) @[CacheFunctions.scala 38:28]
    node modifiedData_writeBytes_2 = _modifiedData_writeBytes_2_T @[CacheFunctions.scala 26:26 32:21]
    node modifiedData_readBytes_2 = _modifiedData_readBytes_2_T @[CacheFunctions.scala 27:25 31:20]
    node _modifiedData_resultBytes_2_T = mux(io_wrEnable_2, modifiedData_writeBytes_2, modifiedData_readBytes_2) @[CacheFunctions.scala 38:28]
    node modifiedData_writeBytes_3 = _modifiedData_writeBytes_3_T @[CacheFunctions.scala 26:26 32:21]
    node modifiedData_readBytes_3 = _modifiedData_readBytes_3_T @[CacheFunctions.scala 27:25 31:20]
    node _modifiedData_resultBytes_3_T = mux(io_wrEnable_3, modifiedData_writeBytes_3, modifiedData_readBytes_3) @[CacheFunctions.scala 38:28]
    node modifiedData_resultBytes_1 = _modifiedData_resultBytes_1_T @[CacheFunctions.scala 36:27 38:22]
    node modifiedData_resultBytes_0 = _modifiedData_resultBytes_0_T @[CacheFunctions.scala 36:27 38:22]
    node modifiedData_lo = cat(modifiedData_resultBytes_1, modifiedData_resultBytes_0) @[Cat.scala 33:92]
    node modifiedData_resultBytes_3 = _modifiedData_resultBytes_3_T @[CacheFunctions.scala 36:27 38:22]
    node modifiedData_resultBytes_2 = _modifiedData_resultBytes_2_T @[CacheFunctions.scala 36:27 38:22]
    node modifiedData_hi = cat(modifiedData_resultBytes_3, modifiedData_resultBytes_2) @[Cat.scala 33:92]
    node _modifiedData_T = cat(modifiedData_hi, modifiedData_lo) @[Cat.scala 33:92]
    node _GEN_4 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 123:21 126:20 41:25]
    node _GEN_5 = mux(io_rw, UInt<1>("h0"), UInt<2>("h3")) @[CacheController.scala 123:21 128:20 134:20]
    node _GEN_6 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 120:21 123:21 CacheFunctions.scala 15:13]
    node _GEN_7 = mux(io_rw, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 123:21 67:15 CacheFunctions.scala 16:13]
    node _GEN_8 = mux(io_rw, UInt<32>("h0"), _modifiedData_T) @[CacheController.scala 123:21 132:24 60:30]
    node _GEN_15 = mux(_T_7, _GEN_8, UInt<32>("h0")) @[CacheController.scala 118:43 60:30]
    node _GEN_24 = mux(_T_6, UInt<32>("h0"), _GEN_15) @[CacheController.scala 113:25 60:30]
    node _GEN_65 = mux(_T_5, _GEN_24, UInt<32>("h0")) @[CacheController.scala 93:20 60:30]
    node _GEN_79 = mux(_T_2, UInt<32>("h0"), _GEN_65) @[CacheController.scala 93:20 60:30]
    node modifiedData = _GEN_79 @[CacheController.scala 60:30]
    node _GEN_9 = mux(io_rw, io_CPUdataIn, modifiedData) @[CacheController.scala 123:21 69:15 133:23]
    node cacheWriteAdd = bits(_cacheWriteAdd_T, 9, 0) @[CacheController.scala 55:31 74:17]
    node _GEN_10 = mux(_T_7, cacheReadAdd, cacheWriteAdd) @[CacheController.scala 118:43 119:18 137:18]
    node _GEN_11 = mux(_T_7, _GEN_6, UInt<1>("h0")) @[CacheController.scala 118:43 68:15]
    node _GEN_12 = mux(_T_7, _GEN_4, lastRead) @[CacheController.scala 118:43 41:25]
    node _GEN_13 = mux(_T_7, _GEN_5, UInt<2>("h2")) @[CacheController.scala 118:43 139:18]
    node _GEN_14 = mux(_T_7, _GEN_7, UInt<1>("h1")) @[CacheController.scala 118:43 67:15]
    node _GEN_16 = mux(_T_7, _GEN_9, io_CPUdataIn) @[CacheController.scala 118:43 69:15]
    node _GEN_17 = mux(_T_7, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 118:43 70:16 138:22]
    node _GEN_18 = mux(_T_6, cacheWriteAdd, _GEN_10) @[CacheController.scala 113:25 114:18]
    node _GEN_19 = mux(_T_6, UInt<1>("h1"), _GEN_17) @[CacheController.scala 113:25 115:22]
    node _GEN_20 = mux(_T_6, UInt<2>("h2"), _GEN_13) @[CacheController.scala 113:25 117:18]
    node _GEN_21 = mux(_T_6, UInt<1>("h0"), _GEN_11) @[CacheController.scala 113:25 68:15]
    node _GEN_22 = mux(_T_6, lastRead, _GEN_12) @[CacheController.scala 113:25 41:25]
    node _GEN_23 = mux(_T_6, UInt<1>("h1"), _GEN_14) @[CacheController.scala 113:25 67:15]
    node _GEN_25 = mux(_T_6, io_CPUdataIn, _GEN_16) @[CacheController.scala 113:25 69:15]
    node _T_8 = asUInt(UInt<2>("h3")) @[CacheController.scala 93:20]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 93:20]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 93:20]
    node _GEN_26 = mux(io_memReady, UInt<1>("h0"), stateReg) @[CacheController.scala 147:25 148:18 89:25]
    node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 93:20]
    node _T_12 = asUInt(stateReg) @[CacheController.scala 93:20]
    node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 93:20]
    node targetTagWord = _targetTagWord_T @[CacheController.scala 50:31 77:17]
    node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 159:35]
    node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 164:25]
    node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 170:36]
    node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 170:36]
    node _GEN_27 = mux(_T_14, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 164:53 CacheFunctions.scala 15:13 CacheController.scala 66:18]
    node _GEN_28 = mux(_T_14, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 164:53 CacheFunctions.scala 16:13 CacheController.scala 65:18]
    node _GEN_29 = mux(_T_14, UInt<1>("h1"), stateReg) @[CacheController.scala 164:53 167:20 89:25]
    node _GEN_30 = mux(_T_14, UInt<1>("h0"), _writeIndex_T_1) @[CacheController.scala 164:53 168:22 170:22]
    node _GEN_31 = mux(io_memReady, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 161:25 CacheFunctions.scala 15:13 CacheController.scala 68:15]
    node _GEN_32 = mux(io_memReady, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 161:25 CacheFunctions.scala 16:13 CacheController.scala 67:15]
    node _GEN_33 = mux(io_memReady, _GEN_27, UInt<1>("h0")) @[CacheController.scala 161:25 66:18]
    node _GEN_34 = mux(io_memReady, _GEN_28, UInt<1>("h1")) @[CacheController.scala 161:25 65:18]
    node _GEN_35 = mux(io_memReady, _GEN_29, stateReg) @[CacheController.scala 161:25 89:25]
    node _GEN_36 = mux(io_memReady, _GEN_30, writeIndex) @[CacheController.scala 161:25 53:27]
    node _GEN_37 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 152:17 71:13 93:20]
    node _GEN_38 = mux(_T_13, cacheWriteAdd, UInt<10>("h0")) @[CacheController.scala 156:16 93:20 58:26]
    node _GEN_39 = mux(_T_13, io_memDataIn, io_CPUdataIn) @[CacheController.scala 157:19 69:15 93:20]
    node _GEN_40 = mux(_T_13, _updatedTag_T, updatedTag) @[CacheController.scala 159:18 93:20 54:27]
    node _GEN_41 = mux(_T_13, _GEN_31, UInt<1>("h0")) @[CacheController.scala 68:15 93:20]
    node _GEN_42 = mux(_T_13, _GEN_32, UInt<1>("h1")) @[CacheController.scala 67:15 93:20]
    node _GEN_43 = mux(_T_13, _GEN_33, UInt<1>("h0")) @[CacheController.scala 66:18 93:20]
    node _GEN_44 = mux(_T_13, _GEN_34, UInt<1>("h1")) @[CacheController.scala 65:18 93:20]
    node _GEN_45 = mux(_T_13, _GEN_35, stateReg) @[CacheController.scala 93:20 89:25]
    node _GEN_46 = mux(_T_13, _GEN_36, writeIndex) @[CacheController.scala 93:20 53:27]
    node _GEN_47 = mux(_T_10, UInt<2>("h2"), _GEN_37) @[CacheController.scala 144:17 93:20]
    node _GEN_48 = mux(_T_10, cacheReadAdd, _GEN_38) @[CacheController.scala 145:16 93:20]
    node _GEN_49 = mux(_T_10, _GEN_26, _GEN_45) @[CacheController.scala 93:20]
    node _GEN_50 = mux(_T_10, UInt<1>("h0"), _GEN_37) @[CacheController.scala 70:16 93:20]
    node _GEN_51 = mux(_T_10, io_CPUdataIn, _GEN_39) @[CacheController.scala 69:15 93:20]
    node _GEN_52 = mux(_T_10, updatedTag, _GEN_40) @[CacheController.scala 93:20 54:27]
    node _GEN_53 = mux(_T_10, UInt<1>("h0"), _GEN_41) @[CacheController.scala 68:15 93:20]
    node _GEN_54 = mux(_T_10, UInt<1>("h1"), _GEN_42) @[CacheController.scala 67:15 93:20]
    node _GEN_55 = mux(_T_10, UInt<1>("h0"), _GEN_43) @[CacheController.scala 66:18 93:20]
    node _GEN_56 = mux(_T_10, UInt<1>("h1"), _GEN_44) @[CacheController.scala 65:18 93:20]
    node _GEN_57 = mux(_T_10, writeIndex, _GEN_46) @[CacheController.scala 93:20 53:27]
    node _GEN_58 = mux(_T_5, UInt<1>("h1"), _GEN_55) @[CacheController.scala 93:20 112:22]
    node _GEN_59 = mux(_T_5, _GEN_18, _GEN_48) @[CacheController.scala 93:20]
    node _GEN_60 = mux(_T_5, _GEN_19, _GEN_50) @[CacheController.scala 93:20]
    node _GEN_61 = mux(_T_5, _GEN_20, _GEN_49) @[CacheController.scala 93:20]
    node _GEN_62 = mux(_T_5, _GEN_21, _GEN_53) @[CacheController.scala 93:20]
    node _GEN_63 = mux(_T_5, _GEN_22, lastRead) @[CacheController.scala 93:20 41:25]
    node _GEN_64 = mux(_T_5, _GEN_23, _GEN_54) @[CacheController.scala 93:20]
    node _GEN_66 = mux(_T_5, _GEN_25, _GEN_51) @[CacheController.scala 93:20]
    node _GEN_67 = mux(_T_5, UInt<1>("h0"), _GEN_47) @[CacheController.scala 71:13 93:20]
    node _GEN_68 = mux(_T_5, updatedTag, _GEN_52) @[CacheController.scala 93:20 54:27]
    node _GEN_69 = mux(_T_5, UInt<1>("h1"), _GEN_56) @[CacheController.scala 65:18 93:20]
    node _GEN_70 = mux(_T_5, writeIndex, _GEN_57) @[CacheController.scala 93:20 53:27]
    node _GEN_71 = mux(_T_2, _GEN_0, _GEN_58) @[CacheController.scala 93:20]
    node _GEN_72 = mux(_T_2, _GEN_1, _GEN_69) @[CacheController.scala 93:20]
    node _GEN_73 = mux(_T_2, _GEN_2, _GEN_61) @[CacheController.scala 93:20]
    node _GEN_74 = mux(_T_2, _GEN_3, _GEN_59) @[CacheController.scala 93:20]
    node _GEN_75 = mux(_T_2, _GEN_0, _GEN_62) @[CacheController.scala 93:20]
    node _GEN_76 = mux(_T_2, _GEN_1, _GEN_64) @[CacheController.scala 93:20]
    node _GEN_77 = mux(_T_2, UInt<1>("h0"), _GEN_60) @[CacheController.scala 70:16 93:20]
    node _GEN_78 = mux(_T_2, lastRead, _GEN_63) @[CacheController.scala 93:20 41:25]
    node _GEN_80 = mux(_T_2, io_CPUdataIn, _GEN_66) @[CacheController.scala 69:15 93:20]
    node _GEN_81 = mux(_T_2, UInt<1>("h0"), _GEN_67) @[CacheController.scala 71:13 93:20]
    node _GEN_82 = mux(_T_2, updatedTag, _GEN_68) @[CacheController.scala 93:20 54:27]
    node _GEN_83 = mux(_T_2, writeIndex, _GEN_70) @[CacheController.scala 93:20 53:27]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 179:24]
    node _io_cacheInvalid_T = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 180:22]
    node _io_CPUdataOut_T = mux(io_ready, lastRead, cache.io_DO) @[CacheController.scala 182:23]
    node _io_alloAddr_T = shl(memWordAdd, 2) @[CacheController.scala 184:30]
    node _io_alloAddr_T_1 = mul(writeIndex, UInt<3>("h4")) @[CacheController.scala 184:55]
    node _io_alloAddr_T_2 = add(_io_alloAddr_T, _io_alloAddr_T_1) @[CacheController.scala 184:43]
    node _io_alloAddr_T_3 = tail(_io_alloAddr_T_2, 1) @[CacheController.scala 184:43]
    node cacheAdd = _GEN_74 @[CacheController.scala 58:26]
    io_CPUdataOut <= _io_CPUdataOut_T @[CacheController.scala 182:17]
    io_cacheMiss <= _GEN_77
    io_cacheInvalid <= _io_cacheInvalid_T @[CacheController.scala 180:19]
    io_ready <= _io_ready_T @[CacheController.scala 179:12]
    io_alloAddr <= _io_alloAddr_T_3 @[CacheController.scala 184:15]
    io_memReq <= _GEN_81
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_78) @[CacheController.scala 41:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_72
    tagStore.io_ad <= index @[CacheController.scala 80:18]
    tagStore.io_DI <= updatedTag @[CacheController.scala 181:18]
    tagStore.io_EN <= _GEN_71
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_76
    cache.io_ad <= cacheAdd @[CacheController.scala 76:15]
    cache.io_DI <= _GEN_80
    cache.io_EN <= _GEN_75
    writeIndex <= mux(reset, UInt<3>("h0"), _GEN_83) @[CacheController.scala 53:{27,27}]
    updatedTag <= mux(reset, UInt<32>("h0"), _GEN_82) @[CacheController.scala 54:{27,27}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_73) @[CacheController.scala 89:{25,25}]

  module CacheTop :
    input clock : Clock
    input reset : UInt<1>
    input io_CPUmemIO_rdAddress : UInt<32>
    output io_CPUmemIO_rdData : UInt<32>
    input io_CPUmemIO_rdEnable : UInt<1>
    input io_CPUmemIO_wrAddress : UInt<32>
    input io_CPUmemIO_wrData : UInt<32>
    input io_CPUmemIO_wrEnable_0 : UInt<1>
    input io_CPUmemIO_wrEnable_1 : UInt<1>
    input io_CPUmemIO_wrEnable_2 : UInt<1>
    input io_CPUmemIO_wrEnable_3 : UInt<1>
    output io_CPUmemIO_stall : UInt<1>
    input io_CacheReqOut_ready : UInt<1>
    output io_CacheReqOut_valid : UInt<1>
    output io_CacheReqOut_bits_addrRequest : UInt<32>
    output io_CacheReqOut_bits_dataRequest : UInt<32>
    output io_CacheReqOut_bits_activeByteLane : UInt<4>
    output io_CacheReqOut_bits_isWrite : UInt<1>
    output io_CacheRspIn_ready : UInt<1>
    input io_CacheRspIn_valid : UInt<1>
    input io_CacheRspIn_bits_dataResponse : UInt<32>
    input io_CacheRspIn_bits_error : UInt<1>

    inst Controller of CacheController @[CacheTop.scala 34:26]
    node _Controller_io_memReady_T = eq(io_CacheRspIn_bits_error, UInt<1>("h0")) @[CacheTop.scala 36:52]
    node _Controller_io_memReady_T_1 = and(io_CacheRspIn_valid, _Controller_io_memReady_T) @[CacheTop.scala 36:49]
    node _GEN_0 = mux(Controller.io_cacheMiss, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 45:21 58:32 59:23]
    node weBits_lo = cat(io_CPUmemIO_wrEnable_1, io_CPUmemIO_wrEnable_0) @[CacheTop.scala 63:37]
    node weBits_hi = cat(io_CPUmemIO_wrEnable_3, io_CPUmemIO_wrEnable_2) @[CacheTop.scala 63:37]
    node weBits = cat(weBits_hi, weBits_lo) @[CacheTop.scala 63:37]
    node _GEN_1 = mux(io_CPUmemIO_rdEnable, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 38:26 67:29 69:28]
    node _GEN_2 = mux(io_CPUmemIO_rdEnable, UInt<1>("h1"), UInt<1>("h1")) @[CacheTop.scala 39:20 67:29 70:22]
    node _GEN_3 = mux(io_CPUmemIO_rdEnable, io_CPUmemIO_rdAddress, io_CPUmemIO_rdAddress) @[CacheTop.scala 40:24 67:29 71:26]
    node _T = gt(weBits, UInt<1>("h0")) @[CacheTop.scala 76:15]
    node _GEN_4 = mux(_T, UInt<1>("h1"), _GEN_1) @[CacheTop.scala 76:21 78:28]
    node _GEN_5 = mux(_T, UInt<1>("h0"), _GEN_2) @[CacheTop.scala 76:21 79:22]
    node _GEN_6 = mux(_T, io_CPUmemIO_wrAddress, _GEN_3) @[CacheTop.scala 76:21 80:26]
    node _T_1 = eq(Controller.io_memReq, UInt<1>("h1")) @[CacheTop.scala 86:29]
    node _T_2 = eq(Controller.io_memReq, UInt<2>("h2")) @[CacheTop.scala 92:35]
    node io_CacheReqOut_bits_activeByteLane_lo = cat(Controller.io_wrEnable_1, Controller.io_wrEnable_0) @[CacheTop.scala 98:66]
    node io_CacheReqOut_bits_activeByteLane_hi = cat(Controller.io_wrEnable_3, Controller.io_wrEnable_2) @[CacheTop.scala 98:66]
    node _io_CacheReqOut_bits_activeByteLane_T = cat(io_CacheReqOut_bits_activeByteLane_hi, io_CacheReqOut_bits_activeByteLane_lo) @[CacheTop.scala 98:66]
    node _GEN_7 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 49:24 92:43 94:26]
    node _GEN_8 = mux(_T_2, io_CPUmemIO_wrData, UInt<1>("h0")) @[CacheTop.scala 50:35 92:43 95:37]
    node _GEN_9 = mux(_T_2, io_CPUmemIO_wrAddress, UInt<1>("h0")) @[CacheTop.scala 51:35 92:43 96:37]
    node _GEN_10 = mux(_T_2, _io_CacheReqOut_bits_activeByteLane_T, UInt<1>("h0")) @[CacheTop.scala 53:38 92:43 98:40]
    node _GEN_11 = mux(_T_1, UInt<1>("h1"), _GEN_7) @[CacheTop.scala 86:37 88:26]
    node _GEN_12 = mux(_T_1, Controller.io_alloAddr, _GEN_9) @[CacheTop.scala 86:37 89:37]
    node _GEN_13 = mux(_T_1, UInt<4>("hf"), _GEN_10) @[CacheTop.scala 86:37 90:40]
    node _GEN_14 = mux(_T_1, UInt<1>("h0"), _GEN_8) @[CacheTop.scala 50:35 86:37]
    node _GEN_15 = mux(_T_1, UInt<1>("h0"), _GEN_7) @[CacheTop.scala 52:31 86:37]
    io_CPUmemIO_rdData <= Controller.io_CPUdataOut @[CacheTop.scala 44:22]
    io_CPUmemIO_stall <= _GEN_0
    io_CacheReqOut_valid <= _GEN_11
    io_CacheReqOut_bits_addrRequest <= _GEN_12
    io_CacheReqOut_bits_dataRequest <= _GEN_14
    io_CacheReqOut_bits_activeByteLane <= _GEN_13
    io_CacheReqOut_bits_isWrite <= _GEN_15
    io_CacheRspIn_ready <= UInt<1>("h1") @[CacheTop.scala 54:23]
    Controller.clock <= clock
    Controller.reset <= reset
    Controller.io_validReq <= _GEN_4
    Controller.io_rw <= _GEN_5
    Controller.io_memAdd <= _GEN_6
    Controller.io_CPUdataIn <= io_CPUmemIO_wrData @[CacheTop.scala 42:27]
    Controller.io_wrEnable_0 <= io_CPUmemIO_wrEnable_0 @[CacheTop.scala 41:26]
    Controller.io_wrEnable_1 <= io_CPUmemIO_wrEnable_1 @[CacheTop.scala 41:26]
    Controller.io_wrEnable_2 <= io_CPUmemIO_wrEnable_2 @[CacheTop.scala 41:26]
    Controller.io_wrEnable_3 <= io_CPUmemIO_wrEnable_3 @[CacheTop.scala 41:26]
    Controller.io_memDataIn <= io_CacheRspIn_bits_dataResponse @[CacheTop.scala 43:27]
    Controller.io_memReady <= _Controller_io_memReady_T_1 @[CacheTop.scala 36:26]

  module CacheBusAdapter :
    input clock : Clock
    input reset : UInt<1>
    input io_CPUMemIO_rdAddress : UInt<32>
    output io_CPUMemIO_rdData : UInt<32>
    input io_CPUMemIO_rdEnable : UInt<1>
    input io_CPUMemIO_wrAddress : UInt<32>
    input io_CPUMemIO_wrData : UInt<32>
    input io_CPUMemIO_wrEnable_0 : UInt<1>
    input io_CPUMemIO_wrEnable_1 : UInt<1>
    input io_CPUMemIO_wrEnable_2 : UInt<1>
    input io_CPUMemIO_wrEnable_3 : UInt<1>
    output io_CPUMemIO_stall : UInt<1>
    input io_reqOut_ready : UInt<1>
    output io_reqOut_valid : UInt<1>
    output io_reqOut_bits_addrRequest : UInt<32>
    output io_reqOut_bits_dataRequest : UInt<32>
    output io_reqOut_bits_activeByteLane : UInt<4>
    output io_reqOut_bits_isWrite : UInt<1>
    output io_rspIn_ready : UInt<1>
    input io_rspIn_valid : UInt<1>
    input io_rspIn_bits_dataResponse : UInt<32>
    input io_rspIn_bits_error : UInt<1>

    inst TL_Adapter of TilelinkAdapter @[CacheBusAdapter.scala 30:26]
    inst Cache of CacheTop @[CacheBusAdapter.scala 33:21]
    io_CPUMemIO_rdData <= Cache.io_CPUmemIO_rdData @[CacheBusAdapter.scala 34:21]
    io_CPUMemIO_stall <= Cache.io_CPUmemIO_stall @[CacheBusAdapter.scala 34:21]
    io_reqOut_valid <= TL_Adapter.io_reqOut_valid @[CacheBusAdapter.scala 39:13]
    io_reqOut_bits_addrRequest <= TL_Adapter.io_reqOut_bits_addrRequest @[CacheBusAdapter.scala 39:13]
    io_reqOut_bits_dataRequest <= TL_Adapter.io_reqOut_bits_dataRequest @[CacheBusAdapter.scala 39:13]
    io_reqOut_bits_activeByteLane <= TL_Adapter.io_reqOut_bits_activeByteLane @[CacheBusAdapter.scala 39:13]
    io_reqOut_bits_isWrite <= TL_Adapter.io_reqOut_bits_isWrite @[CacheBusAdapter.scala 39:13]
    io_rspIn_ready <= TL_Adapter.io_rspIn_ready @[CacheBusAdapter.scala 40:23]
    TL_Adapter.clock <= clock
    TL_Adapter.reset <= reset
    TL_Adapter.io_reqIn_valid <= Cache.io_CacheReqOut_valid @[CacheBusAdapter.scala 37:23]
    TL_Adapter.io_reqIn_bits_addrRequest <= Cache.io_CacheReqOut_bits_addrRequest @[CacheBusAdapter.scala 37:23]
    TL_Adapter.io_reqIn_bits_dataRequest <= Cache.io_CacheReqOut_bits_dataRequest @[CacheBusAdapter.scala 37:23]
    TL_Adapter.io_reqIn_bits_activeByteLane <= Cache.io_CacheReqOut_bits_activeByteLane @[CacheBusAdapter.scala 37:23]
    TL_Adapter.io_reqIn_bits_isWrite <= Cache.io_CacheReqOut_bits_isWrite @[CacheBusAdapter.scala 37:23]
    TL_Adapter.io_rspOut_ready <= Cache.io_CacheRspIn_ready @[CacheBusAdapter.scala 38:23]
    TL_Adapter.io_reqOut_ready <= io_reqOut_ready @[CacheBusAdapter.scala 39:13]
    TL_Adapter.io_rspIn_valid <= io_rspIn_valid @[CacheBusAdapter.scala 40:23]
    TL_Adapter.io_rspIn_bits_dataResponse <= io_rspIn_bits_dataResponse @[CacheBusAdapter.scala 40:23]
    TL_Adapter.io_rspIn_bits_error <= io_rspIn_bits_error @[CacheBusAdapter.scala 40:23]
    Cache.clock <= clock
    Cache.reset <= reset
    Cache.io_CPUmemIO_rdAddress <= io_CPUMemIO_rdAddress @[CacheBusAdapter.scala 34:21]
    Cache.io_CPUmemIO_rdEnable <= io_CPUMemIO_rdEnable @[CacheBusAdapter.scala 34:21]
    Cache.io_CPUmemIO_wrAddress <= io_CPUMemIO_wrAddress @[CacheBusAdapter.scala 34:21]
    Cache.io_CPUmemIO_wrData <= io_CPUMemIO_wrData @[CacheBusAdapter.scala 34:21]
    Cache.io_CPUmemIO_wrEnable_0 <= io_CPUMemIO_wrEnable_0 @[CacheBusAdapter.scala 34:21]
    Cache.io_CPUmemIO_wrEnable_1 <= io_CPUMemIO_wrEnable_1 @[CacheBusAdapter.scala 34:21]
    Cache.io_CPUmemIO_wrEnable_2 <= io_CPUMemIO_wrEnable_2 @[CacheBusAdapter.scala 34:21]
    Cache.io_CPUmemIO_wrEnable_3 <= io_CPUMemIO_wrEnable_3 @[CacheBusAdapter.scala 34:21]
    Cache.io_CacheReqOut_ready <= TL_Adapter.io_reqIn_ready @[CacheBusAdapter.scala 37:23]
    Cache.io_CacheRspIn_valid <= TL_Adapter.io_rspOut_valid @[CacheBusAdapter.scala 38:23]
    Cache.io_CacheRspIn_bits_dataResponse <= TL_Adapter.io_rspOut_bits_dataResponse @[CacheBusAdapter.scala 38:23]
    Cache.io_CacheRspIn_bits_error <= TL_Adapter.io_rspOut_bits_error @[CacheBusAdapter.scala 38:23]
