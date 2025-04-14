FIRRTL version 1.1.0
circuit PSRAM_ModelTestTop :
  module PSRAM_Model :
    input clock : Clock
    input reset : UInt<1>
    input io_CS : UInt<1>
    input io_IN : UInt<4>
    output io_OUT : UInt<4>
    output io_dir : UInt<1>
    output mode_0 : UInt<1>
    output stateReg_0 : UInt<3>
    output address_0 : UInt<24>
    output idle_0 : UInt<1>
    output command_0 : UInt<8>

    mem mem : @[PSRAM_Model.scala 20:24]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      read-under-write => undefined
    reg address : UInt<24>, clock with :
      reset => (UInt<1>("h0"), address) @[PSRAM_Model.scala 22:24]
    reg mode : UInt<1>, clock with :
      reset => (UInt<1>("h0"), mode) @[PSRAM_Model.scala 23:21]
    reg idx : UInt<64>, clock with :
      reset => (UInt<1>("h0"), idx) @[PSRAM_Model.scala 24:20]
    reg lastRead : UInt<24>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[PSRAM_Model.scala 25:25]
    reg stateReg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[PSRAM_Model.scala 36:25]
    node _T = asUInt(UInt<1>("h0")) @[PSRAM_Model.scala 38:19]
    node _T_1 = asUInt(stateReg) @[PSRAM_Model.scala 38:19]
    node _T_2 = eq(_T, _T_1) @[PSRAM_Model.scala 38:19]
    node _T_3 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 41:12]
    node _GEN_0 = mux(_T_3, UInt<2>("h2"), stateReg) @[PSRAM_Model.scala 41:19 42:18 36:25]
    node _T_4 = asUInt(UInt<2>("h2")) @[PSRAM_Model.scala 38:19]
    node _T_5 = asUInt(stateReg) @[PSRAM_Model.scala 38:19]
    node _T_6 = eq(_T_4, _T_5) @[PSRAM_Model.scala 38:19]
    node _T_7 = eq(mode, UInt<1>("h0")) @[PSRAM_Model.scala 46:12]
    node _lastRead_T = bits(io_IN, 0, 0) @[PSRAM_Model.scala 47:38]
    node _lastRead_T_1 = cat(lastRead, _lastRead_T) @[PSRAM_Model.scala 47:30]
    node _command_T = bits(io_IN, 0, 0) @[PSRAM_Model.scala 48:37]
    node _command_T_1 = cat(lastRead, _command_T) @[PSRAM_Model.scala 48:29]
    node _T_8 = eq(idx, UInt<3>("h7")) @[PSRAM_Model.scala 50:18]
    node _command_T_2 = cat(lastRead, io_IN) @[PSRAM_Model.scala 66:29]
    node _GEN_23 = mux(_T_7, _command_T_1, _command_T_2) @[PSRAM_Model.scala 46:18 48:17 66:17]
    node _GEN_37 = mux(_T_6, _GEN_23, UInt<8>("h0")) @[PSRAM_Model.scala 38:19 21:25]
    node _GEN_44 = mux(_T_2, UInt<8>("h0"), _GEN_37) @[PSRAM_Model.scala 38:19 21:25]
    node command = bits(_GEN_44, 7, 0) @[PSRAM_Model.scala 21:25]
    node _T_9 = eq(command, UInt<8>("h35")) @[PSRAM_Model.scala 53:24]
    node _T_10 = and(_T_9, io_CS) @[PSRAM_Model.scala 53:45]
    node _GEN_1 = mux(_T_10, UInt<1>("h1"), mode) @[PSRAM_Model.scala 53:55 55:18 23:21]
    node _GEN_2 = mux(_T_10, UInt<1>("h1"), stateReg) @[PSRAM_Model.scala 53:55 56:22 36:25]
    node _idx_T = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 61:22]
    node _idx_T_1 = tail(_idx_T, 1) @[PSRAM_Model.scala 61:22]
    node _GEN_3 = mux(io_CS, UInt<1>("h0"), stateReg) @[PSRAM_Model.scala 58:26 59:20 36:25]
    node _GEN_4 = mux(io_CS, idx, _idx_T_1) @[PSRAM_Model.scala 24:20 58:26 61:15]
    node _GEN_5 = mux(_T_8, UInt<1>("h0"), _lastRead_T_1) @[PSRAM_Model.scala 47:18 50:27 51:20]
    node _GEN_6 = mux(_T_8, UInt<1>("h0"), _GEN_4) @[PSRAM_Model.scala 50:27 52:15]
    node _GEN_7 = mux(_T_8, _GEN_1, mode) @[PSRAM_Model.scala 23:21 50:27]
    node _GEN_8 = mux(_T_8, _GEN_2, _GEN_3) @[PSRAM_Model.scala 50:27]
    node _lastRead_T_2 = cat(lastRead, io_IN) @[PSRAM_Model.scala 65:30]
    node _T_11 = eq(idx, UInt<1>("h1")) @[PSRAM_Model.scala 68:18]
    node _T_12 = eq(UInt<8>("hf5"), command) @[PSRAM_Model.scala 71:26]
    node _GEN_9 = mux(io_CS, UInt<1>("h0"), mode) @[PSRAM_Model.scala 23:21 73:26 74:22]
    node _T_13 = eq(UInt<8>("heb"), command) @[PSRAM_Model.scala 71:26]
    node _T_14 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 81:20]
    node _GEN_10 = mux(_T_14, UInt<3>("h4"), UInt<1>("h1")) @[PSRAM_Model.scala 81:28 82:26 84:26]
    node _T_15 = eq(UInt<8>("h2"), command) @[PSRAM_Model.scala 71:26]
    node _T_16 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 88:20]
    node _GEN_11 = mux(_T_16, UInt<3>("h5"), UInt<1>("h1")) @[PSRAM_Model.scala 88:28 89:26 91:26]
    node _GEN_12 = mux(_T_15, _GEN_11, stateReg) @[PSRAM_Model.scala 36:25 71:26]
    node _GEN_13 = mux(_T_13, _GEN_10, _GEN_12) @[PSRAM_Model.scala 71:26]
    node _GEN_14 = mux(_T_12, _GEN_9, mode) @[PSRAM_Model.scala 23:21 71:26]
    node _GEN_15 = mux(_T_12, _GEN_3, _GEN_13) @[PSRAM_Model.scala 71:26]
    node _idx_T_2 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 98:22]
    node _idx_T_3 = tail(_idx_T_2, 1) @[PSRAM_Model.scala 98:22]
    node _GEN_16 = mux(io_CS, UInt<1>("h1"), stateReg) @[PSRAM_Model.scala 95:26 96:20 36:25]
    node _GEN_17 = mux(io_CS, idx, _idx_T_3) @[PSRAM_Model.scala 24:20 95:26 98:15]
    node _GEN_18 = mux(_T_11, UInt<1>("h0"), _GEN_17) @[PSRAM_Model.scala 68:27 69:15]
    node _GEN_19 = mux(_T_11, UInt<1>("h0"), _lastRead_T_2) @[PSRAM_Model.scala 65:18 68:27 70:20]
    node _GEN_20 = mux(_T_11, _GEN_14, mode) @[PSRAM_Model.scala 23:21 68:27]
    node _GEN_21 = mux(_T_11, _GEN_15, _GEN_16) @[PSRAM_Model.scala 68:27]
    node _GEN_22 = mux(_T_7, _GEN_5, _GEN_19) @[PSRAM_Model.scala 46:18]
    node _GEN_24 = mux(_T_7, _GEN_6, _GEN_18) @[PSRAM_Model.scala 46:18]
    node _GEN_25 = mux(_T_7, _GEN_7, _GEN_20) @[PSRAM_Model.scala 46:18]
    node _GEN_26 = mux(_T_7, _GEN_8, _GEN_21) @[PSRAM_Model.scala 46:18]
    node _T_17 = asUInt(UInt<1>("h1")) @[PSRAM_Model.scala 38:19]
    node _T_18 = asUInt(stateReg) @[PSRAM_Model.scala 38:19]
    node _T_19 = eq(_T_17, _T_18) @[PSRAM_Model.scala 38:19]
    node _T_20 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 105:12]
    node _GEN_27 = mux(_T_20, UInt<2>("h2"), stateReg) @[PSRAM_Model.scala 105:20 106:18 36:25]
    node _T_21 = asUInt(UInt<2>("h3")) @[PSRAM_Model.scala 38:19]
    node _T_22 = asUInt(stateReg) @[PSRAM_Model.scala 38:19]
    node _T_23 = eq(_T_21, _T_22) @[PSRAM_Model.scala 38:19]
    node _T_24 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 110:12]
    node _GEN_28 = mux(_T_24, stateReg, UInt<1>("h1")) @[PSRAM_Model.scala 110:20 113:18 36:25]
    node _T_25 = asUInt(UInt<3>("h4")) @[PSRAM_Model.scala 38:19]
    node _T_26 = asUInt(stateReg) @[PSRAM_Model.scala 38:19]
    node _T_27 = eq(_T_25, _T_26) @[PSRAM_Model.scala 38:19]
    node _T_28 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 117:12]
    node _GEN_29 = mux(_T_28, stateReg, UInt<1>("h1")) @[PSRAM_Model.scala 117:20 120:18 36:25]
    node _T_29 = asUInt(UInt<3>("h5")) @[PSRAM_Model.scala 38:19]
    node _T_30 = asUInt(stateReg) @[PSRAM_Model.scala 38:19]
    node _T_31 = eq(_T_29, _T_30) @[PSRAM_Model.scala 38:19]
    node _T_32 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 124:12]
    node _GEN_30 = mux(_T_32, stateReg, UInt<1>("h1")) @[PSRAM_Model.scala 124:20 127:18 36:25]
    node _GEN_31 = mux(_T_31, _GEN_30, stateReg) @[PSRAM_Model.scala 38:19 36:25]
    node _GEN_32 = mux(_T_27, _GEN_29, _GEN_31) @[PSRAM_Model.scala 38:19]
    node _GEN_33 = mux(_T_23, _GEN_28, _GEN_32) @[PSRAM_Model.scala 38:19]
    node _GEN_34 = mux(_T_19, UInt<1>("h0"), idx) @[PSRAM_Model.scala 104:11 38:19 24:20]
    node _GEN_35 = mux(_T_19, _GEN_27, _GEN_33) @[PSRAM_Model.scala 38:19]
    node _GEN_36 = mux(_T_6, _GEN_22, io_IN) @[PSRAM_Model.scala 27:12 38:19]
    node _GEN_38 = mux(_T_6, _GEN_24, _GEN_34) @[PSRAM_Model.scala 38:19]
    node _GEN_39 = mux(_T_6, _GEN_25, mode) @[PSRAM_Model.scala 38:19 23:21]
    node _GEN_40 = mux(_T_6, _GEN_26, _GEN_35) @[PSRAM_Model.scala 38:19]
    node _GEN_41 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[PSRAM_Model.scala 38:19 40:11]
    node _GEN_42 = mux(_T_2, _GEN_0, _GEN_40) @[PSRAM_Model.scala 38:19]
    node _GEN_43 = mux(_T_2, io_IN, _GEN_36) @[PSRAM_Model.scala 27:12 38:19]
    node _GEN_45 = mux(_T_2, mode, _GEN_39) @[PSRAM_Model.scala 38:19 23:21]
    node _idle_T = eq(stateReg, UInt<1>("h0")) @[PSRAM_Model.scala 132:24]
    node _idle_T_1 = eq(stateReg, UInt<1>("h1")) @[PSRAM_Model.scala 132:48]
    node idle = or(_idle_T, _idle_T_1) @[PSRAM_Model.scala 132:35]
    io_OUT <= UInt<4>("h0") @[PSRAM_Model.scala 29:10]
    io_dir <= UInt<1>("h0") @[PSRAM_Model.scala 28:10]
    mode_0 <= mode
    stateReg_0 <= stateReg
    address_0 <= address
    idle_0 <= idle
    command_0 <= command
    address <= mux(reset, UInt<24>("h0"), address) @[PSRAM_Model.scala 22:{24,24,24}]
    mode <= mux(reset, UInt<1>("h0"), _GEN_45) @[PSRAM_Model.scala 23:{21,21}]
    idx <= mux(reset, UInt<64>("h0"), _GEN_41) @[PSRAM_Model.scala 24:{20,20}]
    lastRead <= bits(mux(reset, UInt<24>("h0"), _GEN_43), 23, 0) @[PSRAM_Model.scala 25:{25,25}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_42) @[PSRAM_Model.scala 36:{25,25}]

  module PSRAM_ModelTestTop :
    input clock : Clock
    input reset : UInt<1>
    input io_CS : UInt<1>
    input io_IN : UInt<4>
    output io_OUT : UInt<4>
    output io_dir : UInt<4>
    output io_command : UInt<8>
    output io_address : UInt<24>
    output io_mode : UInt<1>
    output io_idle : UInt<1>
    output io_state : UInt<8>

    inst model of PSRAM_Model @[PSRAM_ModelTest.scala 23:21]
    node command = model.command_0
    node idle = model.idle_0
    node address = model.address_0
    node stateReg = model.stateReg_0
    node mode = model.mode_0
    io_OUT <= model.io_OUT @[PSRAM_ModelTest.scala 24:10]
    io_dir <= pad(model.io_dir, 4) @[PSRAM_ModelTest.scala 25:10]
    io_command <= command
    io_address <= address
    io_mode <= mode
    io_idle <= idle
    io_state <= pad(stateReg, 8)
    model.clock <= clock
    model.reset <= reset
    model.io_CS <= io_CS @[PSRAM_ModelTest.scala 27:15]
    model.io_IN <= io_IN @[PSRAM_ModelTest.scala 26:15]
