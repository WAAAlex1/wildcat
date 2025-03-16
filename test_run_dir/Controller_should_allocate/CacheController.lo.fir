FIRRTL version 1.1.0
circuit CacheController :
  module RAM :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<9>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 24:24]
      data-type => UInt<32>
      depth => 512
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 26:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 27:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 27:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<9>("h0")) @[RAM.scala 27:22]
    node _io_DO_T_1 = bits(_io_DO_T, 8, 0) @[RAM.scala 27:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 27:{22,22} 24:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 27:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 27:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 28:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 28:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 28:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 28:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 24:24 28:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 28:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 28:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 28:30 30:11 32:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 26:23 24:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 26:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 26:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 26:23 27:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 26:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 26:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 26:23 24:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 26:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 26:23]
    io_DO <= _GEN_13
    mem.io_DO_MPORT.addr <= _GEN_11
    mem.io_DO_MPORT.en <= _GEN_10
    mem.io_DO_MPORT.clk <= _GEN_12
    mem.MPORT.addr <= _GEN_14
    mem.MPORT.en <= _GEN_16
    mem.MPORT.clk <= _GEN_15
    mem.MPORT.data <= _GEN_18
    mem.MPORT.mask <= _GEN_17

  module RAM_1 :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<10>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 24:24]
      data-type => UInt<32>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 26:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 27:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 27:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<10>("h0")) @[RAM.scala 27:22]
    node _io_DO_T_1 = bits(_io_DO_T, 9, 0) @[RAM.scala 27:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 27:{22,22} 24:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 27:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 27:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 28:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 28:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 28:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 28:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 24:24 28:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 28:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 28:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 28:30 30:11 32:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 26:23 24:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 26:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 26:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 26:23 27:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 26:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 26:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 26:23 24:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 26:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 26:23]
    io_DO <= _GEN_13
    mem.io_DO_MPORT.addr <= _GEN_11
    mem.io_DO_MPORT.en <= _GEN_10
    mem.io_DO_MPORT.clk <= _GEN_12
    mem.MPORT.addr <= _GEN_14
    mem.MPORT.en <= _GEN_16
    mem.MPORT.clk <= _GEN_15
    mem.MPORT.data <= _GEN_18
    mem.MPORT.mask <= _GEN_17

  module RAM_2 :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<12>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 24:24]
      data-type => UInt<32>
      depth => 4096
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 26:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 27:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 27:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<12>("h0")) @[RAM.scala 27:22]
    node _io_DO_T_1 = bits(_io_DO_T, 11, 0) @[RAM.scala 27:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 27:{22,22} 24:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 27:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 27:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 28:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 28:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 28:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 28:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 24:24 28:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 28:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 28:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 28:30 30:11 32:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 26:23 24:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 26:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 26:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 26:23 27:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 26:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 26:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 26:23 24:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 26:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 26:23]
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
    input io_DI : UInt<32>
    output io_DO : UInt<32>
    output io_ready : UInt<1>
    input io_memReady : UInt<1>
    output io_cacheMiss : UInt<1>
    output io_cacheInvalid : UInt<1>

    inst tagStore of RAM @[CacheController.scala 34:24]
    inst cache of RAM_1 @[CacheController.scala 35:21]
    inst extMem of RAM_2 @[CacheController.scala 36:22]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 33:25]
    node byteOffset = bits(io_memAdd, 1, 0) @[CacheController.scala 41:29]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 42:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 43:24]
    node targetTag = bits(io_memAdd, 31, 12) @[CacheController.scala 44:28]
    node actualTag = bits(tagStore.io_DO, 31, 12) @[CacheController.scala 46:33]
    node cacheValid = bits(tagStore.io_DO, 11, 11) @[CacheController.scala 47:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (UInt<1>("h0"), writeIndex) @[CacheController.scala 48:27]
    reg updatedTag : UInt<32>, clock with :
      reset => (UInt<1>("h0"), updatedTag) @[CacheController.scala 49:27]
    reg cacheHit : UInt<1>, clock with :
      reset => (UInt<1>("h0"), cacheHit) @[CacheController.scala 50:25]
    node memWordAdd = bits(io_memAdd, 31, 2) @[CacheController.scala 55:29]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 71:25]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 72:26]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 75:30]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 87:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 103:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 103:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 103:20]
    node _GEN_0 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 112:21 91:13 95:13]
    node _GEN_1 = mux(io_rw, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 112:21 92:13 96:13]
    node _GEN_2 = mux(io_rw, io_DI, io_DI) @[CacheController.scala 112:21 63:15 119:23]
    node cacheReadAdd = _cacheReadAdd_T @[CacheController.scala 52:30 71:16]
    node _GEN_3 = mux(io_validReq, cacheReadAdd, UInt<10>("h0")) @[CacheController.scala 106:25 108:18 54:26]
    node _GEN_4 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 106:25 91:13 99:13]
    node _GEN_5 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 100:13 106:25 92:13]
    node _GEN_6 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 106:25 110:18 87:25]
    node _GEN_7 = mux(io_validReq, _GEN_0, UInt<1>("h0")) @[CacheController.scala 106:25 99:13]
    node _GEN_8 = mux(io_validReq, _GEN_1, UInt<1>("h1")) @[CacheController.scala 100:13 106:25]
    node _GEN_9 = mux(io_validReq, _GEN_2, io_DI) @[CacheController.scala 106:25 63:15]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 103:20]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 103:20]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 103:20]
    node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 129:12]
    node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 134:28]
    node _GEN_10 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 137:21 140:20 33:25]
    node _GEN_11 = mux(io_rw, UInt<1>("h0"), UInt<2>("h3")) @[CacheController.scala 137:21 141:20 146:20]
    node cacheWriteAdd = bits(_cacheWriteAdd_T, 9, 0) @[CacheController.scala 51:31 72:17]
    node _GEN_12 = mux(_T_7, cacheReadAdd, cacheWriteAdd) @[CacheController.scala 134:43 135:18 149:18]
    node _GEN_13 = mux(_T_7, _GEN_0, UInt<1>("h0")) @[CacheController.scala 134:43 62:15]
    node _GEN_14 = mux(_T_7, _GEN_10, lastRead) @[CacheController.scala 134:43 33:25]
    node _GEN_15 = mux(_T_7, _GEN_11, UInt<2>("h2")) @[CacheController.scala 134:43 152:18]
    node _GEN_16 = mux(_T_7, _GEN_1, UInt<1>("h1")) @[CacheController.scala 134:43 61:15]
    node _GEN_17 = mux(_T_7, _GEN_2, io_DI) @[CacheController.scala 134:43 63:15]
    node _GEN_18 = mux(_T_7, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 134:43 67:16 150:22]
    node _GEN_19 = mux(_T_7, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 134:43 64:15 92:13]
    node _GEN_20 = mux(_T_6, cacheWriteAdd, _GEN_12) @[CacheController.scala 129:25 130:18]
    node _GEN_21 = mux(_T_6, UInt<1>("h1"), _GEN_18) @[CacheController.scala 129:25 91:13]
    node _GEN_22 = mux(_T_6, UInt<1>("h1"), _GEN_19) @[CacheController.scala 129:25 92:13]
    node _GEN_23 = mux(_T_6, UInt<2>("h2"), _GEN_15) @[CacheController.scala 129:25 133:18]
    node _GEN_24 = mux(_T_6, UInt<1>("h0"), _GEN_13) @[CacheController.scala 129:25 62:15]
    node _GEN_25 = mux(_T_6, lastRead, _GEN_14) @[CacheController.scala 129:25 33:25]
    node _GEN_26 = mux(_T_6, UInt<1>("h1"), _GEN_16) @[CacheController.scala 129:25 61:15]
    node _GEN_27 = mux(_T_6, io_DI, _GEN_17) @[CacheController.scala 129:25 63:15]
    node _GEN_28 = mux(_T_6, UInt<1>("h0"), _GEN_18) @[CacheController.scala 129:25 67:16]
    node _T_8 = asUInt(UInt<2>("h3")) @[CacheController.scala 103:20]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 103:20]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 103:20]
    node _GEN_29 = mux(io_memReady, UInt<1>("h0"), stateReg) @[CacheController.scala 164:25 165:18 87:25]
    node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 103:20]
    node _T_12 = asUInt(stateReg) @[CacheController.scala 103:20]
    node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 103:20]
    node _extMem_io_ad_T = add(memWordAdd, writeIndex) @[CacheController.scala 173:34]
    node _extMem_io_ad_T_1 = tail(_extMem_io_ad_T, 1) @[CacheController.scala 173:34]
    node _extMem_io_ad_T_2 = add(_extMem_io_ad_T_1, UInt<1>("h1")) @[CacheController.scala 173:47]
    node _extMem_io_ad_T_3 = tail(_extMem_io_ad_T_2, 1) @[CacheController.scala 173:47]
    node targetTagWord = _targetTagWord_T @[CacheController.scala 45:31 75:17]
    node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 176:35]
    node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 178:38]
    node _T_15 = and(io_memReady, _T_14) @[CacheController.scala 178:24]
    node _T_16 = eq(io_memReady, UInt<1>("h0")) @[CacheController.scala 183:18]
    node _T_17 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 183:45]
    node _T_18 = and(_T_16, _T_17) @[CacheController.scala 183:31]
    node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 186:34]
    node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 186:34]
    node _GEN_30 = mux(_T_18, UInt<2>("h3"), _writeIndex_T_1) @[CacheController.scala 183:54 184:20 186:20]
    node _GEN_31 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 178:47 95:13 60:18]
    node _GEN_32 = mux(_T_15, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 178:47 96:13 59:18]
    node _GEN_33 = mux(_T_15, UInt<1>("h1"), stateReg) @[CacheController.scala 178:47 181:18 87:25]
    node _GEN_34 = mux(_T_15, UInt<1>("h0"), _GEN_30) @[CacheController.scala 178:47 182:20]
    node _GEN_35 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 103:20 95:13 62:15]
    node _GEN_36 = mux(_T_13, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 103:20 96:13 61:15]
    node _GEN_37 = mux(_T_13, cacheWriteAdd, UInt<10>("h0")) @[CacheController.scala 103:20 171:16 54:26]
    node _GEN_38 = mux(_T_13, _extMem_io_ad_T_3, memWordAdd) @[CacheController.scala 103:20 173:20 66:16]
    node _GEN_39 = mux(_T_13, extMem.io_DO, io_DI) @[CacheController.scala 103:20 174:19 63:15]
    node _GEN_40 = mux(_T_13, _updatedTag_T, updatedTag) @[CacheController.scala 103:20 176:18 49:27]
    node _GEN_41 = mux(_T_13, _GEN_31, UInt<1>("h0")) @[CacheController.scala 103:20 60:18]
    node _GEN_42 = mux(_T_13, _GEN_32, UInt<1>("h1")) @[CacheController.scala 103:20 59:18]
    node _GEN_43 = mux(_T_13, _GEN_33, stateReg) @[CacheController.scala 103:20 87:25]
    node _GEN_44 = mux(_T_13, _GEN_34, writeIndex) @[CacheController.scala 103:20 48:27]
    node _GEN_45 = mux(_T_10, cacheReadAdd, _GEN_37) @[CacheController.scala 103:20 159:16]
    node _GEN_46 = mux(_T_10, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 103:20 160:20 64:15]
    node _GEN_47 = mux(_T_10, UInt<1>("h1"), _GEN_35) @[CacheController.scala 103:20 161:20]
    node _GEN_48 = mux(_T_10, io_DI, UInt<32>("h0")) @[CacheController.scala 103:20 162:17 53:27]
    node _GEN_49 = mux(_T_10, _GEN_29, _GEN_43) @[CacheController.scala 103:20]
    node _GEN_50 = mux(_T_10, UInt<1>("h0"), _GEN_35) @[CacheController.scala 103:20 62:15]
    node _GEN_51 = mux(_T_10, UInt<1>("h1"), _GEN_36) @[CacheController.scala 103:20 61:15]
    node _GEN_52 = mux(_T_10, memWordAdd, _GEN_38) @[CacheController.scala 103:20 66:16]
    node _GEN_53 = mux(_T_10, io_DI, _GEN_39) @[CacheController.scala 103:20 63:15]
    node _GEN_54 = mux(_T_10, updatedTag, _GEN_40) @[CacheController.scala 103:20 49:27]
    node _GEN_55 = mux(_T_10, UInt<1>("h0"), _GEN_41) @[CacheController.scala 103:20 60:18]
    node _GEN_56 = mux(_T_10, UInt<1>("h1"), _GEN_42) @[CacheController.scala 103:20 59:18]
    node _GEN_57 = mux(_T_10, writeIndex, _GEN_44) @[CacheController.scala 103:20 48:27]
    node _GEN_58 = mux(_T_5, UInt<1>("h1"), _GEN_55) @[CacheController.scala 103:20 128:22]
    node _GEN_59 = mux(_T_5, _GEN_20, _GEN_45) @[CacheController.scala 103:20]
    node _GEN_60 = mux(_T_5, _GEN_21, _GEN_47) @[CacheController.scala 103:20]
    node _GEN_61 = mux(_T_5, _GEN_22, _GEN_46) @[CacheController.scala 103:20]
    node _GEN_62 = mux(_T_5, _GEN_23, _GEN_49) @[CacheController.scala 103:20]
    node _GEN_63 = mux(_T_5, _GEN_24, _GEN_50) @[CacheController.scala 103:20]
    node _GEN_64 = mux(_T_5, _GEN_25, lastRead) @[CacheController.scala 103:20 33:25]
    node _GEN_65 = mux(_T_5, _GEN_26, _GEN_51) @[CacheController.scala 103:20]
    node _GEN_66 = mux(_T_5, _GEN_27, _GEN_53) @[CacheController.scala 103:20]
    node _GEN_67 = mux(_T_5, _GEN_28, UInt<1>("h0")) @[CacheController.scala 103:20 67:16]
    node _GEN_68 = mux(_T_5, UInt<32>("h0"), _GEN_48) @[CacheController.scala 103:20 53:27]
    node _GEN_69 = mux(_T_5, memWordAdd, _GEN_52) @[CacheController.scala 103:20 66:16]
    node _GEN_70 = mux(_T_5, updatedTag, _GEN_54) @[CacheController.scala 103:20 49:27]
    node _GEN_71 = mux(_T_5, UInt<1>("h1"), _GEN_56) @[CacheController.scala 103:20 59:18]
    node _GEN_72 = mux(_T_5, writeIndex, _GEN_57) @[CacheController.scala 103:20 48:27]
    node _GEN_73 = mux(_T_2, UInt<1>("h0"), _GEN_60) @[CacheController.scala 103:20 99:13]
    node _GEN_74 = mux(_T_2, UInt<1>("h1"), _GEN_61) @[CacheController.scala 100:13 103:20]
    node _GEN_75 = mux(_T_2, _GEN_3, _GEN_59) @[CacheController.scala 103:20]
    node _GEN_76 = mux(_T_2, _GEN_4, _GEN_58) @[CacheController.scala 103:20]
    node _GEN_77 = mux(_T_2, _GEN_5, _GEN_71) @[CacheController.scala 103:20]
    node _GEN_78 = mux(_T_2, _GEN_6, _GEN_62) @[CacheController.scala 103:20]
    node _GEN_79 = mux(_T_2, _GEN_7, _GEN_63) @[CacheController.scala 103:20]
    node _GEN_80 = mux(_T_2, _GEN_8, _GEN_65) @[CacheController.scala 103:20]
    node _GEN_81 = mux(_T_2, _GEN_9, _GEN_66) @[CacheController.scala 103:20]
    node _GEN_82 = mux(_T_2, lastRead, _GEN_64) @[CacheController.scala 103:20 33:25]
    node _GEN_83 = mux(_T_2, UInt<1>("h0"), _GEN_67) @[CacheController.scala 103:20 67:16]
    node _GEN_84 = mux(_T_2, UInt<32>("h0"), _GEN_68) @[CacheController.scala 103:20 53:27]
    node _GEN_85 = mux(_T_2, memWordAdd, _GEN_69) @[CacheController.scala 103:20 66:16]
    node _GEN_86 = mux(_T_2, updatedTag, _GEN_70) @[CacheController.scala 103:20 49:27]
    node _GEN_87 = mux(_T_2, writeIndex, _GEN_72) @[CacheController.scala 103:20 48:27]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 194:24]
    node _io_cacheInvalid_T = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 195:22]
    node memDataIn = _GEN_84 @[CacheController.scala 53:27]
    node cacheAdd = _GEN_75 @[CacheController.scala 54:26]
    io_DO <= lastRead @[CacheController.scala 197:9]
    io_ready <= _io_ready_T @[CacheController.scala 194:12]
    io_cacheMiss <= _GEN_83
    io_cacheInvalid <= _io_cacheInvalid_T @[CacheController.scala 195:19]
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_82) @[CacheController.scala 33:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_77
    tagStore.io_ad <= pad(index, 9) @[CacheController.scala 78:18]
    tagStore.io_DI <= updatedTag @[CacheController.scala 196:18]
    tagStore.io_EN <= _GEN_76
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_80
    cache.io_ad <= cacheAdd @[CacheController.scala 74:15]
    cache.io_DI <= _GEN_81
    cache.io_EN <= _GEN_79
    extMem.clock <= clock
    extMem.reset <= reset
    extMem.io_rw <= _GEN_74
    extMem.io_ad <= bits(_GEN_85, 11, 0)
    extMem.io_DI <= memDataIn @[CacheController.scala 70:16]
    extMem.io_EN <= _GEN_73
    writeIndex <= mux(reset, UInt<3>("h0"), _GEN_87) @[CacheController.scala 48:{27,27}]
    updatedTag <= mux(reset, UInt<32>("h0"), _GEN_86) @[CacheController.scala 49:{27,27}]
    cacheHit <= mux(reset, UInt<1>("h0"), cacheHit) @[CacheController.scala 50:{25,25,25}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_78) @[CacheController.scala 87:{25,25}]
