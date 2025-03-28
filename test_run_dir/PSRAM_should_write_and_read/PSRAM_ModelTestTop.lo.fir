FIRRTL version 1.1.0
circuit PSRAM_ModelTestTop :
  module PSRAM_Model :
    input clock : Clock
    input reset : UInt<1>
    input io_CS : UInt<1>
    input io_IN : UInt<4>
    output io_OUT : UInt<4>
    output io_dir : UInt<1>
    output stateReg_0 : UInt<3>
    output command_0 : UInt<8>
    output address_0 : UInt<24>
    output readMemVal_0 : UInt<8>
    output val2Write_0 : UInt<8>
    output mode_0 : UInt<1>

    mem mem : @[PSRAM_Model.scala 19:24]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => readMemVal_MPORT
      writer => MPORT
      read-under-write => undefined
    reg address : UInt<24>, clock with :
      reset => (UInt<1>("h0"), address) @[PSRAM_Model.scala 21:24]
    reg mode : UInt<1>, clock with :
      reset => (UInt<1>("h0"), mode) @[PSRAM_Model.scala 22:21]
    reg idx : UInt<3>, clock with :
      reset => (UInt<1>("h0"), idx) @[PSRAM_Model.scala 23:20]
    reg lastRead : UInt<24>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[PSRAM_Model.scala 24:25]
    reg rw : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rw) @[PSRAM_Model.scala 25:19]
    reg waitDone : UInt<1>, clock with :
      reset => (UInt<1>("h0"), waitDone) @[PSRAM_Model.scala 27:25]
    reg lastCommand : UInt<8>, clock with :
      reset => (UInt<1>("h0"), lastCommand) @[PSRAM_Model.scala 29:28]
    reg stateReg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[PSRAM_Model.scala 40:25]
    node _T = asUInt(UInt<1>("h0")) @[PSRAM_Model.scala 42:19]
    node _T_1 = asUInt(stateReg) @[PSRAM_Model.scala 42:19]
    node _T_2 = eq(_T, _T_1) @[PSRAM_Model.scala 42:19]
    node _T_3 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 44:12]
    node _T_4 = eq(mode, UInt<1>("h0")) @[PSRAM_Model.scala 45:14]
    node _lastRead_T = bits(io_IN, 0, 0) @[PSRAM_Model.scala 46:40]
    node _lastRead_T_1 = cat(lastRead, _lastRead_T) @[PSRAM_Model.scala 46:32]
    node _command_T = bits(io_IN, 0, 0) @[PSRAM_Model.scala 47:39]
    node _command_T_1 = cat(lastRead, _command_T) @[PSRAM_Model.scala 47:31]
    node _T_5 = eq(idx, UInt<3>("h7")) @[PSRAM_Model.scala 49:20]
    node _idx_T = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 53:24]
    node _idx_T_1 = tail(_idx_T, 1) @[PSRAM_Model.scala 53:24]
    node _GEN_0 = mux(_T_5, UInt<1>("h0"), _lastRead_T_1) @[PSRAM_Model.scala 46:20 49:29 50:22]
    node _GEN_1 = mux(_T_5, UInt<1>("h0"), _idx_T_1) @[PSRAM_Model.scala 49:29 51:17 53:17]
    node _lastRead_T_2 = cat(lastRead, io_IN) @[PSRAM_Model.scala 57:32]
    node _command_T_2 = cat(lastRead, io_IN) @[PSRAM_Model.scala 58:31]
    node _T_6 = eq(idx, UInt<1>("h1")) @[PSRAM_Model.scala 60:20]
    node _GEN_14 = mux(_T_4, _command_T_1, _command_T_2) @[PSRAM_Model.scala 45:21 47:19 58:19]
    node _GEN_22 = mux(_T_3, _GEN_14, UInt<8>("h0")) @[PSRAM_Model.scala 44:19 20:25]
    node _GEN_121 = mux(_T_2, _GEN_22, UInt<8>("h0")) @[PSRAM_Model.scala 42:19 20:25]
    node command = bits(_GEN_121, 7, 0) @[PSRAM_Model.scala 20:25]
    node _T_7 = eq(UInt<8>("h2"), command) @[PSRAM_Model.scala 64:29]
    node _T_8 = eq(UInt<8>("heb"), command) @[PSRAM_Model.scala 64:29]
    node _GEN_2 = mux(_T_8, UInt<1>("h1"), rw) @[PSRAM_Model.scala 25:19 64:29 71:20]
    node _GEN_3 = mux(_T_8, UInt<1>("h0"), address) @[PSRAM_Model.scala 21:24 64:29 72:25]
    node _GEN_4 = mux(_T_8, UInt<2>("h2"), stateReg) @[PSRAM_Model.scala 40:25 64:29 73:26]
    node _GEN_5 = mux(_T_7, UInt<1>("h0"), _GEN_2) @[PSRAM_Model.scala 64:29 66:20]
    node _GEN_6 = mux(_T_7, UInt<1>("h0"), _GEN_3) @[PSRAM_Model.scala 64:29 67:25]
    node _GEN_7 = mux(_T_7, UInt<2>("h2"), _GEN_4) @[PSRAM_Model.scala 64:29 68:26]
    node _idx_T_2 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 78:24]
    node _idx_T_3 = tail(_idx_T_2, 1) @[PSRAM_Model.scala 78:24]
    node _GEN_8 = mux(_T_6, UInt<1>("h0"), _idx_T_3) @[PSRAM_Model.scala 60:29 61:17 78:17]
    node _GEN_9 = mux(_T_6, UInt<1>("h0"), _lastRead_T_2) @[PSRAM_Model.scala 57:20 60:29 62:22]
    node _GEN_10 = mux(_T_6, _GEN_5, rw) @[PSRAM_Model.scala 25:19 60:29]
    node _GEN_11 = mux(_T_6, _GEN_6, address) @[PSRAM_Model.scala 21:24 60:29]
    node _GEN_12 = mux(_T_6, _GEN_7, stateReg) @[PSRAM_Model.scala 40:25 60:29]
    node _GEN_13 = mux(_T_4, _GEN_0, _GEN_9) @[PSRAM_Model.scala 45:21]
    node _GEN_15 = mux(_T_4, _GEN_1, _GEN_8) @[PSRAM_Model.scala 45:21]
    node _GEN_16 = mux(_T_4, rw, _GEN_10) @[PSRAM_Model.scala 25:19 45:21]
    node _GEN_17 = mux(_T_4, address, _GEN_11) @[PSRAM_Model.scala 45:21 21:24]
    node _GEN_18 = mux(_T_4, stateReg, _GEN_12) @[PSRAM_Model.scala 45:21 40:25]
    node _T_9 = eq(lastCommand, UInt<8>("h35")) @[PSRAM_Model.scala 83:39]
    node _T_10 = and(io_CS, _T_9) @[PSRAM_Model.scala 83:24]
    node _T_11 = eq(lastCommand, UInt<8>("hf5")) @[PSRAM_Model.scala 85:39]
    node _T_12 = and(io_CS, _T_11) @[PSRAM_Model.scala 85:24]
    node _GEN_19 = mux(_T_12, UInt<1>("h0"), mode) @[PSRAM_Model.scala 85:59 86:14 22:21]
    node _GEN_20 = mux(_T_10, UInt<1>("h1"), _GEN_19) @[PSRAM_Model.scala 83:60 84:14]
    node _GEN_21 = mux(_T_3, _GEN_13, io_IN) @[PSRAM_Model.scala 31:12 44:19]
    node _GEN_23 = mux(_T_3, _GEN_15, idx) @[PSRAM_Model.scala 44:19 23:20]
    node _GEN_24 = mux(_T_3, _GEN_16, rw) @[PSRAM_Model.scala 25:19 44:19]
    node _GEN_25 = mux(_T_3, _GEN_17, address) @[PSRAM_Model.scala 44:19 21:24]
    node _GEN_26 = mux(_T_3, _GEN_18, stateReg) @[PSRAM_Model.scala 44:19 40:25]
    node _GEN_27 = mux(_T_3, command, lastCommand) @[PSRAM_Model.scala 44:19 81:21 29:28]
    node _GEN_28 = mux(_T_3, mode, _GEN_20) @[PSRAM_Model.scala 44:19 22:21]
    node _T_13 = asUInt(UInt<2>("h2")) @[PSRAM_Model.scala 42:19]
    node _T_14 = asUInt(stateReg) @[PSRAM_Model.scala 42:19]
    node _T_15 = eq(_T_13, _T_14) @[PSRAM_Model.scala 42:19]
    node _T_16 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 90:12]
    node _address_T = cat(address, io_IN) @[PSRAM_Model.scala 91:28]
    node _T_17 = eq(idx, UInt<3>("h5")) @[PSRAM_Model.scala 93:18]
    node _GEN_29 = mux(rw, UInt<2>("h3"), UInt<3>("h4")) @[PSRAM_Model.scala 95:19 96:22 99:22]
    node _GEN_30 = mux(rw, UInt<1>("h0"), waitDone) @[PSRAM_Model.scala 95:19 97:22 27:25]
    node _idx_T_4 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 102:22]
    node _idx_T_5 = tail(_idx_T_4, 1) @[PSRAM_Model.scala 102:22]
    node _GEN_31 = mux(_T_17, UInt<1>("h0"), _idx_T_5) @[PSRAM_Model.scala 102:15 93:27 94:15]
    node _GEN_32 = mux(_T_17, _GEN_29, stateReg) @[PSRAM_Model.scala 40:25 93:27]
    node _GEN_33 = mux(_T_17, _GEN_30, waitDone) @[PSRAM_Model.scala 27:25 93:27]
    node _GEN_34 = mux(_T_16, _address_T, address) @[PSRAM_Model.scala 90:20 91:17 21:24]
    node _GEN_35 = mux(_T_16, _GEN_31, idx) @[PSRAM_Model.scala 23:20 90:20]
    node _GEN_36 = mux(_T_16, _GEN_32, UInt<1>("h0")) @[PSRAM_Model.scala 105:18 90:20]
    node _GEN_37 = mux(_T_16, _GEN_33, waitDone) @[PSRAM_Model.scala 90:20 27:25]
    node _T_18 = asUInt(UInt<2>("h3")) @[PSRAM_Model.scala 42:19]
    node _T_19 = asUInt(stateReg) @[PSRAM_Model.scala 42:19]
    node _T_20 = eq(_T_18, _T_19) @[PSRAM_Model.scala 42:19]
    node _T_21 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 109:12]
    node _GEN_38 = validif(UInt<1>("h1"), address) @[PSRAM_Model.scala 110:{31,31}]
    node _readMemVal_WIRE = _GEN_38 @[PSRAM_Model.scala 110:31]
    node _readMemVal_T = or(_readMemVal_WIRE, UInt<10>("h0")) @[PSRAM_Model.scala 110:31]
    node _readMemVal_T_1 = bits(_readMemVal_T, 9, 0) @[PSRAM_Model.scala 110:31]
    node _GEN_39 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[PSRAM_Model.scala 110:{31,31} 19:24]
    node _GEN_40 = validif(UInt<1>("h1"), _readMemVal_T_1) @[PSRAM_Model.scala 110:{31,31}]
    node _GEN_41 = validif(UInt<1>("h1"), clock) @[PSRAM_Model.scala 110:{31,31}]
    node _T_22 = eq(waitDone, UInt<1>("h0")) @[PSRAM_Model.scala 111:14]
    node _T_23 = eq(idx, UInt<3>("h7")) @[PSRAM_Model.scala 112:20]
    node _idx_T_6 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 117:24]
    node _idx_T_7 = tail(_idx_T_6, 1) @[PSRAM_Model.scala 117:24]
    node _GEN_42 = mux(_T_23, UInt<1>("h1"), waitDone) @[PSRAM_Model.scala 112:29 113:22 27:25]
    node _GEN_43 = mux(_T_23, UInt<1>("h0"), _idx_T_7) @[PSRAM_Model.scala 112:29 115:17 117:17]
    node _T_24 = eq(idx, UInt<1>("h1")) @[PSRAM_Model.scala 120:20]
    node _GEN_54 = mux(_T_21, mem.readMemVal_MPORT.data, UInt<8>("h0")) @[PSRAM_Model.scala 109:20 110:20 26:28]
    node _GEN_91 = mux(_T_20, _GEN_54, UInt<8>("h0")) @[PSRAM_Model.scala 42:19 26:28]
    node _GEN_111 = mux(_T_15, UInt<8>("h0"), _GEN_91) @[PSRAM_Model.scala 42:19 26:28]
    node _GEN_132 = mux(_T_2, UInt<8>("h0"), _GEN_111) @[PSRAM_Model.scala 42:19 26:28]
    node readMemVal = _GEN_132 @[PSRAM_Model.scala 26:28]
    node _io_OUT_T = bits(readMemVal, 3, 0) @[PSRAM_Model.scala 121:33]
    node _io_OUT_T_1 = bits(readMemVal, 7, 4) @[PSRAM_Model.scala 124:33]
    node _idx_T_8 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 125:24]
    node _idx_T_9 = tail(_idx_T_8, 1) @[PSRAM_Model.scala 125:24]
    node _address_T_1 = add(address, UInt<1>("h1")) @[PSRAM_Model.scala 126:32]
    node _address_T_2 = tail(_address_T_1, 1) @[PSRAM_Model.scala 126:32]
    node _GEN_44 = mux(_T_24, _io_OUT_T, _io_OUT_T_1) @[PSRAM_Model.scala 120:28 121:20 124:20]
    node _GEN_45 = mux(_T_24, UInt<1>("h0"), _idx_T_9) @[PSRAM_Model.scala 120:28 122:17 125:17]
    node _GEN_46 = mux(_T_24, address, _address_T_2) @[PSRAM_Model.scala 120:28 126:21 21:24]
    node _GEN_47 = mux(_T_22, _GEN_42, waitDone) @[PSRAM_Model.scala 111:25 27:25]
    node _GEN_48 = mux(_T_22, _GEN_43, _GEN_45) @[PSRAM_Model.scala 111:25]
    node _GEN_49 = mux(_T_22, UInt<1>("h0"), _GEN_44) @[PSRAM_Model.scala 111:25 33:10]
    node _GEN_50 = mux(_T_22, address, _GEN_46) @[PSRAM_Model.scala 111:25 21:24]
    node _GEN_51 = mux(_T_21, _GEN_39, UInt<1>("h0")) @[PSRAM_Model.scala 109:20 19:24]
    node _GEN_52 = validif(_T_21, _GEN_40) @[PSRAM_Model.scala 109:20]
    node _GEN_53 = validif(_T_21, _GEN_41) @[PSRAM_Model.scala 109:20]
    node _GEN_55 = mux(_T_21, _GEN_47, waitDone) @[PSRAM_Model.scala 109:20 27:25]
    node _GEN_56 = mux(_T_21, _GEN_48, idx) @[PSRAM_Model.scala 109:20 23:20]
    node _GEN_57 = mux(_T_21, _GEN_49, UInt<1>("h0")) @[PSRAM_Model.scala 109:20 33:10]
    node _GEN_58 = mux(_T_21, _GEN_50, address) @[PSRAM_Model.scala 109:20 21:24]
    node _GEN_59 = mux(_T_21, stateReg, UInt<1>("h0")) @[PSRAM_Model.scala 109:20 132:18 40:25]
    node _T_25 = asUInt(UInt<3>("h4")) @[PSRAM_Model.scala 42:19]
    node _T_26 = asUInt(stateReg) @[PSRAM_Model.scala 42:19]
    node _T_27 = eq(_T_25, _T_26) @[PSRAM_Model.scala 42:19]
    node _T_28 = eq(io_CS, UInt<1>("h0")) @[PSRAM_Model.scala 136:12]
    node _lastRead_T_3 = cat(lastRead, io_IN) @[PSRAM_Model.scala 137:30]
    node _val2Write_T = cat(lastRead, io_IN) @[PSRAM_Model.scala 138:31]
    node _T_29 = eq(idx, UInt<1>("h1")) @[PSRAM_Model.scala 139:18]
    node _T_30 = bits(address, 9, 0)
    node _address_T_3 = add(address, UInt<1>("h1")) @[PSRAM_Model.scala 142:30]
    node _address_T_4 = tail(_address_T_3, 1) @[PSRAM_Model.scala 142:30]
    node _idx_T_10 = add(idx, UInt<1>("h1")) @[PSRAM_Model.scala 145:22]
    node _idx_T_11 = tail(_idx_T_10, 1) @[PSRAM_Model.scala 145:22]
    node _GEN_60 = validif(_T_29, _T_30) @[PSRAM_Model.scala 139:27]
    node _GEN_61 = validif(_T_29, clock) @[PSRAM_Model.scala 139:27]
    node _GEN_62 = mux(_T_29, UInt<1>("h1"), UInt<1>("h0")) @[PSRAM_Model.scala 139:27 19:24]
    node _GEN_63 = validif(_T_29, UInt<1>("h1")) @[PSRAM_Model.scala 139:27]
    node _GEN_69 = mux(_T_28, _val2Write_T, UInt<8>("h0")) @[PSRAM_Model.scala 136:20 138:19 28:27]
    node _GEN_79 = mux(_T_27, _GEN_69, UInt<8>("h0")) @[PSRAM_Model.scala 42:19 28:27]
    node _GEN_98 = mux(_T_20, UInt<8>("h0"), _GEN_79) @[PSRAM_Model.scala 42:19 28:27]
    node _GEN_114 = mux(_T_15, UInt<8>("h0"), _GEN_98) @[PSRAM_Model.scala 42:19 28:27]
    node _GEN_134 = mux(_T_2, UInt<8>("h0"), _GEN_114) @[PSRAM_Model.scala 42:19 28:27]
    node val2Write = bits(_GEN_134, 7, 0) @[PSRAM_Model.scala 28:27]
    node _GEN_64 = validif(_T_29, val2Write) @[PSRAM_Model.scala 139:27]
    node _GEN_65 = mux(_T_29, UInt<1>("h0"), _idx_T_11) @[PSRAM_Model.scala 139:27 141:15 145:15]
    node _GEN_66 = mux(_T_29, _address_T_4, address) @[PSRAM_Model.scala 139:27 142:19 21:24]
    node _GEN_67 = mux(_T_29, UInt<1>("h0"), _lastRead_T_3) @[PSRAM_Model.scala 137:18 139:27 143:20]
    node _GEN_68 = mux(_T_28, _GEN_67, io_IN) @[PSRAM_Model.scala 136:20 31:12]
    node _GEN_70 = validif(_T_28, _GEN_60) @[PSRAM_Model.scala 136:20]
    node _GEN_71 = validif(_T_28, _GEN_61) @[PSRAM_Model.scala 136:20]
    node _GEN_72 = mux(_T_28, _GEN_62, UInt<1>("h0")) @[PSRAM_Model.scala 136:20 19:24]
    node _GEN_73 = validif(_T_28, _GEN_63) @[PSRAM_Model.scala 136:20]
    node _GEN_74 = validif(_T_28, _GEN_64) @[PSRAM_Model.scala 136:20]
    node _GEN_75 = mux(_T_28, _GEN_65, idx) @[PSRAM_Model.scala 136:20 23:20]
    node _GEN_76 = mux(_T_28, _GEN_66, address) @[PSRAM_Model.scala 136:20 21:24]
    node _GEN_77 = mux(_T_28, stateReg, UInt<1>("h0")) @[PSRAM_Model.scala 136:20 149:18 40:25]
    node _GEN_78 = mux(_T_27, _GEN_68, io_IN) @[PSRAM_Model.scala 31:12 42:19]
    node _GEN_80 = validif(_T_27, _GEN_70) @[PSRAM_Model.scala 42:19]
    node _GEN_81 = validif(_T_27, _GEN_71) @[PSRAM_Model.scala 42:19]
    node _GEN_82 = mux(_T_27, _GEN_72, UInt<1>("h0")) @[PSRAM_Model.scala 42:19 19:24]
    node _GEN_83 = validif(_T_27, _GEN_73) @[PSRAM_Model.scala 42:19]
    node _GEN_84 = validif(_T_27, _GEN_74) @[PSRAM_Model.scala 42:19]
    node _GEN_85 = mux(_T_27, _GEN_75, idx) @[PSRAM_Model.scala 42:19 23:20]
    node _GEN_86 = mux(_T_27, _GEN_76, address) @[PSRAM_Model.scala 42:19 21:24]
    node _GEN_87 = mux(_T_27, _GEN_77, stateReg) @[PSRAM_Model.scala 42:19 40:25]
    node _GEN_88 = mux(_T_20, _GEN_51, UInt<1>("h0")) @[PSRAM_Model.scala 42:19 19:24]
    node _GEN_89 = validif(_T_20, _GEN_52) @[PSRAM_Model.scala 42:19]
    node _GEN_90 = validif(_T_20, _GEN_53) @[PSRAM_Model.scala 42:19]
    node _GEN_92 = mux(_T_20, _GEN_55, waitDone) @[PSRAM_Model.scala 42:19 27:25]
    node _GEN_93 = mux(_T_20, _GEN_56, _GEN_85) @[PSRAM_Model.scala 42:19]
    node _GEN_94 = mux(_T_20, _GEN_57, UInt<1>("h0")) @[PSRAM_Model.scala 33:10 42:19]
    node _GEN_95 = mux(_T_20, _GEN_58, _GEN_86) @[PSRAM_Model.scala 42:19]
    node _GEN_96 = mux(_T_20, _GEN_59, _GEN_87) @[PSRAM_Model.scala 42:19]
    node _GEN_97 = mux(_T_20, io_IN, _GEN_78) @[PSRAM_Model.scala 31:12 42:19]
    node _GEN_99 = validif(eq(_T_20, UInt<1>("h0")), _GEN_80) @[PSRAM_Model.scala 42:19]
    node _GEN_100 = validif(eq(_T_20, UInt<1>("h0")), _GEN_81) @[PSRAM_Model.scala 42:19]
    node _GEN_101 = mux(_T_20, UInt<1>("h0"), _GEN_82) @[PSRAM_Model.scala 42:19 19:24]
    node _GEN_102 = validif(eq(_T_20, UInt<1>("h0")), _GEN_83) @[PSRAM_Model.scala 42:19]
    node _GEN_103 = validif(eq(_T_20, UInt<1>("h0")), _GEN_84) @[PSRAM_Model.scala 42:19]
    node _GEN_104 = mux(_T_15, _GEN_34, _GEN_95) @[PSRAM_Model.scala 42:19]
    node _GEN_105 = mux(_T_15, _GEN_35, _GEN_93) @[PSRAM_Model.scala 42:19]
    node _GEN_106 = mux(_T_15, _GEN_36, _GEN_96) @[PSRAM_Model.scala 42:19]
    node _GEN_107 = mux(_T_15, _GEN_37, _GEN_92) @[PSRAM_Model.scala 42:19]
    node _GEN_108 = mux(_T_15, UInt<1>("h0"), _GEN_88) @[PSRAM_Model.scala 42:19 19:24]
    node _GEN_109 = validif(eq(_T_15, UInt<1>("h0")), _GEN_89) @[PSRAM_Model.scala 42:19]
    node _GEN_110 = validif(eq(_T_15, UInt<1>("h0")), _GEN_90) @[PSRAM_Model.scala 42:19]
    node _GEN_112 = mux(_T_15, UInt<1>("h0"), _GEN_94) @[PSRAM_Model.scala 33:10 42:19]
    node _GEN_113 = mux(_T_15, io_IN, _GEN_97) @[PSRAM_Model.scala 31:12 42:19]
    node _GEN_115 = validif(eq(_T_15, UInt<1>("h0")), _GEN_99) @[PSRAM_Model.scala 42:19]
    node _GEN_116 = validif(eq(_T_15, UInt<1>("h0")), _GEN_100) @[PSRAM_Model.scala 42:19]
    node _GEN_117 = mux(_T_15, UInt<1>("h0"), _GEN_101) @[PSRAM_Model.scala 42:19 19:24]
    node _GEN_118 = validif(eq(_T_15, UInt<1>("h0")), _GEN_102) @[PSRAM_Model.scala 42:19]
    node _GEN_119 = validif(eq(_T_15, UInt<1>("h0")), _GEN_103) @[PSRAM_Model.scala 42:19]
    node _GEN_120 = mux(_T_2, _GEN_21, _GEN_113) @[PSRAM_Model.scala 42:19]
    node _GEN_122 = mux(_T_2, _GEN_23, _GEN_105) @[PSRAM_Model.scala 42:19]
    node _GEN_123 = mux(_T_2, _GEN_24, rw) @[PSRAM_Model.scala 25:19 42:19]
    node _GEN_124 = mux(_T_2, _GEN_25, _GEN_104) @[PSRAM_Model.scala 42:19]
    node _GEN_125 = mux(_T_2, _GEN_26, _GEN_106) @[PSRAM_Model.scala 42:19]
    node _GEN_126 = mux(_T_2, _GEN_27, lastCommand) @[PSRAM_Model.scala 42:19 29:28]
    node _GEN_127 = mux(_T_2, _GEN_28, mode) @[PSRAM_Model.scala 42:19 22:21]
    node _GEN_128 = mux(_T_2, waitDone, _GEN_107) @[PSRAM_Model.scala 42:19 27:25]
    node _GEN_129 = mux(_T_2, UInt<1>("h0"), _GEN_108) @[PSRAM_Model.scala 42:19 19:24]
    node _GEN_130 = validif(eq(_T_2, UInt<1>("h0")), _GEN_109) @[PSRAM_Model.scala 42:19]
    node _GEN_131 = validif(eq(_T_2, UInt<1>("h0")), _GEN_110) @[PSRAM_Model.scala 42:19]
    node _GEN_133 = mux(_T_2, UInt<1>("h0"), _GEN_112) @[PSRAM_Model.scala 33:10 42:19]
    node _GEN_135 = validif(eq(_T_2, UInt<1>("h0")), _GEN_115) @[PSRAM_Model.scala 42:19]
    node _GEN_136 = validif(eq(_T_2, UInt<1>("h0")), _GEN_116) @[PSRAM_Model.scala 42:19]
    node _GEN_137 = mux(_T_2, UInt<1>("h0"), _GEN_117) @[PSRAM_Model.scala 42:19 19:24]
    node _GEN_138 = validif(eq(_T_2, UInt<1>("h0")), _GEN_118) @[PSRAM_Model.scala 42:19]
    node _GEN_139 = validif(eq(_T_2, UInt<1>("h0")), _GEN_119) @[PSRAM_Model.scala 42:19]
    io_OUT <= _GEN_133
    io_dir is invalid
    stateReg_0 <= stateReg
    command_0 <= command
    address_0 <= address
    readMemVal_0 <= readMemVal
    val2Write_0 <= val2Write
    mode_0 <= mode
    mem.readMemVal_MPORT.addr <= _GEN_130
    mem.readMemVal_MPORT.en <= _GEN_129
    mem.readMemVal_MPORT.clk <= _GEN_131
    mem.MPORT.addr <= _GEN_135
    mem.MPORT.en <= _GEN_137
    mem.MPORT.clk <= _GEN_136
    mem.MPORT.data <= _GEN_139
    mem.MPORT.mask <= _GEN_138
    address <= bits(mux(reset, UInt<24>("h0"), _GEN_124), 23, 0) @[PSRAM_Model.scala 21:{24,24}]
    mode <= mux(reset, UInt<1>("h0"), _GEN_127) @[PSRAM_Model.scala 22:{21,21}]
    idx <= mux(reset, UInt<3>("h0"), _GEN_122) @[PSRAM_Model.scala 23:{20,20}]
    lastRead <= bits(mux(reset, UInt<24>("h0"), _GEN_120), 23, 0) @[PSRAM_Model.scala 24:{25,25}]
    rw <= mux(reset, UInt<1>("h1"), _GEN_123) @[PSRAM_Model.scala 25:{19,19}]
    waitDone <= mux(reset, UInt<1>("h0"), _GEN_128) @[PSRAM_Model.scala 27:{25,25}]
    lastCommand <= mux(reset, UInt<8>("h0"), _GEN_126) @[PSRAM_Model.scala 29:{28,28}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_125) @[PSRAM_Model.scala 40:{25,25}]

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
    output io_readMemVal : UInt<8>
    output io_val2Write : UInt<8>

    inst model of PSRAM_Model @[PSRAM_ModelTest.scala 25:21]
    node mode_1 = model.mode_0
    node val2Write_1 = model.val2Write_0
    node readMemVal_1 = model.readMemVal_0
    node address_1 = model.address_0
    node command_1 = model.command_0
    node stateReg_1 = model.stateReg_0
    io_OUT <= model.io_OUT @[PSRAM_ModelTest.scala 26:10]
    io_dir <= pad(model.io_dir, 4) @[PSRAM_ModelTest.scala 27:10]
    io_command <= command_1
    io_address <= address_1
    io_mode <= mode_1
    io_idle is invalid
    io_state <= pad(stateReg_1, 8)
    io_readMemVal <= readMemVal_1
    io_val2Write <= val2Write_1
    model.clock <= clock
    model.reset <= reset
    model.io_CS <= io_CS @[PSRAM_ModelTest.scala 29:15]
    model.io_IN <= io_IN @[PSRAM_ModelTest.scala 28:15]
