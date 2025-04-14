FIRRTL version 1.1.0
circuit CacheTop :
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

    inst tagStore of RAM @[CacheController.scala 36:24]
    inst cache of RAM_1 @[CacheController.scala 37:21]
    inst extMem of RAM_2 @[CacheController.scala 38:22]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 35:25]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 44:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 45:24]
    node targetTag = bits(io_memAdd, 31, 12) @[CacheController.scala 46:28]
    node actualTag = bits(tagStore.io_DO, 31, 12) @[CacheController.scala 48:33]
    node cacheValid = bits(tagStore.io_DO, 11, 11) @[CacheController.scala 49:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (UInt<1>("h0"), writeIndex) @[CacheController.scala 50:27]
    reg updatedTag : UInt<32>, clock with :
      reset => (UInt<1>("h0"), updatedTag) @[CacheController.scala 51:27]
    node memWordAdd = bits(io_memAdd, 31, 2) @[CacheController.scala 56:29]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 72:25]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 73:26]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 76:30]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 88:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 92:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 92:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 92:20]
    node _GEN_0 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 101:21 CacheFunctions.scala 13:13 8:13]
    node _GEN_1 = mux(io_rw, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 101:21 CacheFunctions.scala 14:13 9:13]
    node _GEN_2 = mux(io_rw, io_DI, io_DI) @[CacheController.scala 101:21 64:15 108:23]
    node cacheReadAdd = _cacheReadAdd_T @[CacheController.scala 53:30 72:16]
    node _GEN_3 = mux(io_validReq, cacheReadAdd, UInt<10>("h0")) @[CacheController.scala 95:25 97:18 55:26]
    node _GEN_4 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 95:25 CacheFunctions.scala 18:13 8:13]
    node _GEN_5 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 95:25 CacheFunctions.scala 19:13 9:13]
    node _GEN_6 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 95:25 99:18 88:25]
    node _GEN_7 = mux(io_validReq, _GEN_0, UInt<1>("h0")) @[CacheController.scala 95:25 CacheFunctions.scala 18:13]
    node _GEN_8 = mux(io_validReq, _GEN_1, UInt<1>("h1")) @[CacheController.scala 95:25 CacheFunctions.scala 19:13]
    node _GEN_9 = mux(io_validReq, _GEN_2, io_DI) @[CacheController.scala 64:15 95:25]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 92:20]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 92:20]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 92:20]
    node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 118:12]
    node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 123:28]
    node _GEN_10 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 126:21 129:20 35:25]
    node _GEN_11 = mux(io_rw, UInt<1>("h0"), UInt<2>("h3")) @[CacheController.scala 126:21 130:20 135:20]
    node cacheWriteAdd = bits(_cacheWriteAdd_T, 9, 0) @[CacheController.scala 52:31 73:17]
    node _GEN_12 = mux(_T_7, cacheReadAdd, cacheWriteAdd) @[CacheController.scala 123:43 124:18 138:18]
    node _GEN_13 = mux(_T_7, _GEN_0, UInt<1>("h0")) @[CacheController.scala 123:43 63:15]
    node _GEN_14 = mux(_T_7, _GEN_10, lastRead) @[CacheController.scala 123:43 35:25]
    node _GEN_15 = mux(_T_7, _GEN_11, UInt<2>("h2")) @[CacheController.scala 123:43 141:18]
    node _GEN_16 = mux(_T_7, _GEN_1, UInt<1>("h1")) @[CacheController.scala 123:43 62:15]
    node _GEN_17 = mux(_T_7, _GEN_2, io_DI) @[CacheController.scala 123:43 64:15]
    node _GEN_18 = mux(_T_7, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 123:43 68:16 139:22]
    node _GEN_19 = mux(_T_7, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 123:43 65:15 CacheFunctions.scala 9:13]
    node _GEN_20 = mux(_T_6, cacheWriteAdd, _GEN_12) @[CacheController.scala 118:25 119:18]
    node _GEN_21 = mux(_T_6, UInt<1>("h1"), _GEN_18) @[CacheController.scala 118:25 120:22]
    node _GEN_22 = mux(_T_6, UInt<1>("h1"), _GEN_19) @[CacheController.scala 118:25 CacheFunctions.scala 9:13]
    node _GEN_23 = mux(_T_6, UInt<2>("h2"), _GEN_15) @[CacheController.scala 118:25 122:18]
    node _GEN_24 = mux(_T_6, UInt<1>("h0"), _GEN_13) @[CacheController.scala 118:25 63:15]
    node _GEN_25 = mux(_T_6, lastRead, _GEN_14) @[CacheController.scala 118:25 35:25]
    node _GEN_26 = mux(_T_6, UInt<1>("h1"), _GEN_16) @[CacheController.scala 118:25 62:15]
    node _GEN_27 = mux(_T_6, io_DI, _GEN_17) @[CacheController.scala 118:25 64:15]
    node _T_8 = asUInt(UInt<2>("h3")) @[CacheController.scala 92:20]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 92:20]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 92:20]
    node _GEN_28 = mux(io_memReady, UInt<1>("h0"), stateReg) @[CacheController.scala 153:25 154:18 88:25]
    node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 92:20]
    node _T_12 = asUInt(stateReg) @[CacheController.scala 92:20]
    node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 92:20]
    node _extMem_io_ad_T = add(memWordAdd, writeIndex) @[CacheController.scala 163:34]
    node _extMem_io_ad_T_1 = tail(_extMem_io_ad_T, 1) @[CacheController.scala 163:34]
    node _extMem_io_ad_T_2 = add(_extMem_io_ad_T_1, UInt<1>("h1")) @[CacheController.scala 163:47]
    node _extMem_io_ad_T_3 = tail(_extMem_io_ad_T_2, 1) @[CacheController.scala 163:47]
    node targetTagWord = _targetTagWord_T @[CacheController.scala 47:31 76:17]
    node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 166:35]
    node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 168:38]
    node _T_15 = and(io_memReady, _T_14) @[CacheController.scala 168:24]
    node _T_16 = eq(io_memReady, UInt<1>("h0")) @[CacheController.scala 173:18]
    node _T_17 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 173:45]
    node _T_18 = and(_T_16, _T_17) @[CacheController.scala 173:31]
    node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 176:34]
    node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 176:34]
    node _GEN_29 = mux(_T_18, UInt<2>("h3"), _writeIndex_T_1) @[CacheController.scala 173:73 174:20 176:20]
    node _GEN_30 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 168:66 CacheFunctions.scala 13:13 CacheController.scala 61:18]
    node _GEN_31 = mux(_T_15, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 168:66 CacheFunctions.scala 14:13 CacheController.scala 60:18]
    node _GEN_32 = mux(_T_15, UInt<1>("h1"), stateReg) @[CacheController.scala 168:66 171:18 88:25]
    node _GEN_33 = mux(_T_15, UInt<1>("h0"), _GEN_29) @[CacheController.scala 168:66 172:20]
    node _GEN_34 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 158:20 68:16 92:20]
    node _GEN_35 = mux(_T_13, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 92:20 CacheFunctions.scala 14:13 CacheController.scala 62:15]
    node _GEN_36 = mux(_T_13, cacheWriteAdd, UInt<10>("h0")) @[CacheController.scala 161:16 92:20 55:26]
    node _GEN_37 = mux(_T_13, _extMem_io_ad_T_3, memWordAdd) @[CacheController.scala 163:20 67:16 92:20]
    node _GEN_38 = mux(_T_13, extMem.io_DO, io_DI) @[CacheController.scala 164:19 64:15 92:20]
    node _GEN_39 = mux(_T_13, _updatedTag_T, updatedTag) @[CacheController.scala 166:18 92:20 51:27]
    node _GEN_40 = mux(_T_13, _GEN_30, UInt<1>("h0")) @[CacheController.scala 61:18 92:20]
    node _GEN_41 = mux(_T_13, _GEN_31, UInt<1>("h1")) @[CacheController.scala 60:18 92:20]
    node _GEN_42 = mux(_T_13, _GEN_32, stateReg) @[CacheController.scala 92:20 88:25]
    node _GEN_43 = mux(_T_13, _GEN_33, writeIndex) @[CacheController.scala 92:20 50:27]
    node _GEN_44 = mux(_T_10, cacheReadAdd, _GEN_36) @[CacheController.scala 148:16 92:20]
    node _GEN_45 = mux(_T_10, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 149:20 65:15 92:20]
    node _GEN_46 = mux(_T_10, UInt<1>("h1"), _GEN_34) @[CacheController.scala 150:20 92:20]
    node _GEN_47 = mux(_T_10, io_DI, UInt<32>("h0")) @[CacheController.scala 151:17 92:20 54:27]
    node _GEN_48 = mux(_T_10, _GEN_28, _GEN_42) @[CacheController.scala 92:20]
    node _GEN_49 = mux(_T_10, UInt<1>("h0"), _GEN_34) @[CacheController.scala 68:16 92:20]
    node _GEN_50 = mux(_T_10, UInt<1>("h1"), _GEN_35) @[CacheController.scala 62:15 92:20]
    node _GEN_51 = mux(_T_10, memWordAdd, _GEN_37) @[CacheController.scala 67:16 92:20]
    node _GEN_52 = mux(_T_10, io_DI, _GEN_38) @[CacheController.scala 64:15 92:20]
    node _GEN_53 = mux(_T_10, updatedTag, _GEN_39) @[CacheController.scala 92:20 51:27]
    node _GEN_54 = mux(_T_10, UInt<1>("h0"), _GEN_40) @[CacheController.scala 61:18 92:20]
    node _GEN_55 = mux(_T_10, UInt<1>("h1"), _GEN_41) @[CacheController.scala 60:18 92:20]
    node _GEN_56 = mux(_T_10, writeIndex, _GEN_43) @[CacheController.scala 92:20 50:27]
    node _GEN_57 = mux(_T_5, UInt<1>("h1"), _GEN_54) @[CacheController.scala 92:20 117:22]
    node _GEN_58 = mux(_T_5, _GEN_20, _GEN_44) @[CacheController.scala 92:20]
    node _GEN_59 = mux(_T_5, _GEN_21, _GEN_49) @[CacheController.scala 92:20]
    node _GEN_60 = mux(_T_5, _GEN_21, _GEN_46) @[CacheController.scala 92:20]
    node _GEN_61 = mux(_T_5, _GEN_22, _GEN_45) @[CacheController.scala 92:20]
    node _GEN_62 = mux(_T_5, _GEN_23, _GEN_48) @[CacheController.scala 92:20]
    node _GEN_63 = mux(_T_5, _GEN_24, _GEN_49) @[CacheController.scala 92:20]
    node _GEN_64 = mux(_T_5, _GEN_25, lastRead) @[CacheController.scala 92:20 35:25]
    node _GEN_65 = mux(_T_5, _GEN_26, _GEN_50) @[CacheController.scala 92:20]
    node _GEN_66 = mux(_T_5, _GEN_27, _GEN_52) @[CacheController.scala 92:20]
    node _GEN_67 = mux(_T_5, UInt<32>("h0"), _GEN_47) @[CacheController.scala 92:20 54:27]
    node _GEN_68 = mux(_T_5, memWordAdd, _GEN_51) @[CacheController.scala 67:16 92:20]
    node _GEN_69 = mux(_T_5, updatedTag, _GEN_53) @[CacheController.scala 92:20 51:27]
    node _GEN_70 = mux(_T_5, UInt<1>("h1"), _GEN_55) @[CacheController.scala 60:18 92:20]
    node _GEN_71 = mux(_T_5, writeIndex, _GEN_56) @[CacheController.scala 92:20 50:27]
    node _GEN_72 = mux(_T_2, UInt<1>("h0"), _GEN_60) @[CacheController.scala 92:20 CacheFunctions.scala 18:13]
    node _GEN_73 = mux(_T_2, UInt<1>("h1"), _GEN_61) @[CacheController.scala 92:20 CacheFunctions.scala 19:13]
    node _GEN_74 = mux(_T_2, _GEN_3, _GEN_58) @[CacheController.scala 92:20]
    node _GEN_75 = mux(_T_2, _GEN_4, _GEN_57) @[CacheController.scala 92:20]
    node _GEN_76 = mux(_T_2, _GEN_5, _GEN_70) @[CacheController.scala 92:20]
    node _GEN_77 = mux(_T_2, _GEN_6, _GEN_62) @[CacheController.scala 92:20]
    node _GEN_78 = mux(_T_2, _GEN_7, _GEN_63) @[CacheController.scala 92:20]
    node _GEN_79 = mux(_T_2, _GEN_8, _GEN_65) @[CacheController.scala 92:20]
    node _GEN_80 = mux(_T_2, _GEN_9, _GEN_66) @[CacheController.scala 92:20]
    node _GEN_81 = mux(_T_2, UInt<1>("h0"), _GEN_59) @[CacheController.scala 68:16 92:20]
    node _GEN_82 = mux(_T_2, lastRead, _GEN_64) @[CacheController.scala 92:20 35:25]
    node _GEN_83 = mux(_T_2, UInt<32>("h0"), _GEN_67) @[CacheController.scala 92:20 54:27]
    node _GEN_84 = mux(_T_2, memWordAdd, _GEN_68) @[CacheController.scala 67:16 92:20]
    node _GEN_85 = mux(_T_2, updatedTag, _GEN_69) @[CacheController.scala 92:20 51:27]
    node _GEN_86 = mux(_T_2, writeIndex, _GEN_71) @[CacheController.scala 92:20 50:27]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 184:24]
    node _io_cacheInvalid_T = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 185:22]
    node memDataIn = _GEN_83 @[CacheController.scala 54:27]
    node cacheAdd = _GEN_74 @[CacheController.scala 55:26]
    io_DO <= lastRead @[CacheController.scala 187:9]
    io_ready <= _io_ready_T @[CacheController.scala 184:12]
    io_cacheMiss <= _GEN_81
    io_cacheInvalid <= _io_cacheInvalid_T @[CacheController.scala 185:19]
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_82) @[CacheController.scala 35:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_76
    tagStore.io_ad <= pad(index, 9) @[CacheController.scala 79:18]
    tagStore.io_DI <= updatedTag @[CacheController.scala 186:18]
    tagStore.io_EN <= _GEN_75
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_79
    cache.io_ad <= cacheAdd @[CacheController.scala 75:15]
    cache.io_DI <= _GEN_80
    cache.io_EN <= _GEN_78
    extMem.clock <= clock
    extMem.reset <= reset
    extMem.io_rw <= _GEN_73
    extMem.io_ad <= bits(_GEN_84, 11, 0)
    extMem.io_DI <= memDataIn @[CacheController.scala 71:16]
    extMem.io_EN <= _GEN_72
    writeIndex <= mux(reset, UInt<3>("h0"), _GEN_86) @[CacheController.scala 50:{27,27}]
    updatedTag <= mux(reset, UInt<32>("h0"), _GEN_85) @[CacheController.scala 51:{27,27}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_77) @[CacheController.scala 88:{25,25}]

  module CacheTop :
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
    output io_stall : UInt<1>

    inst Controller of CacheController @[CacheTop.scala 21:26]
    node _GEN_0 = mux(Controller.io_cacheMiss, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 29:12 32:33 33:14]
    reg modifiedData : UInt<32>, clock with :
      reset => (UInt<1>("h0"), modifiedData) @[CacheTop.scala 40:29]
    node byteOffset = bits(io_wrAddress, 1, 0) @[CacheTop.scala 41:32]
    node weBits_lo = cat(io_wrEnable_1, io_wrEnable_0) @[CacheTop.scala 46:22]
    node weBits_hi = cat(io_wrEnable_3, io_wrEnable_2) @[CacheTop.scala 46:22]
    node weBits = cat(weBits_hi, weBits_lo) @[CacheTop.scala 46:22]
    node _T = eq(UInt<1>("h1"), weBits) @[CacheTop.scala 51:18]
    node _T_1 = eq(UInt<2>("h2"), weBits) @[CacheTop.scala 51:18]
    node _T_2 = eq(UInt<3>("h4"), weBits) @[CacheTop.scala 51:18]
    node _T_3 = eq(UInt<4>("h8"), weBits) @[CacheTop.scala 51:18]
    node _T_4 = eq(UInt<2>("h3"), weBits) @[CacheTop.scala 51:18]
    node _T_5 = eq(UInt<4>("hc"), weBits) @[CacheTop.scala 51:18]
    node _T_6 = eq(UInt<4>("hf"), weBits) @[CacheTop.scala 51:18]
    node _GEN_1 = mux(_T_6, UInt<2>("h2"), UInt<2>("h3")) @[CacheTop.scala 49:13 51:18 60:31]
    node _GEN_2 = mux(_T_5, UInt<1>("h1"), _GEN_1) @[CacheTop.scala 51:18 58:31]
    node _GEN_3 = mux(_T_4, UInt<1>("h1"), _GEN_2) @[CacheTop.scala 51:18 57:31]
    node _GEN_4 = mux(_T_3, UInt<1>("h0"), _GEN_3) @[CacheTop.scala 51:18 55:31]
    node _GEN_5 = mux(_T_2, UInt<1>("h0"), _GEN_4) @[CacheTop.scala 51:18 54:31]
    node _GEN_6 = mux(_T_1, UInt<1>("h0"), _GEN_5) @[CacheTop.scala 51:18 53:31]
    node _GEN_7 = mux(_T, UInt<1>("h0"), _GEN_6) @[CacheTop.scala 51:18 52:31]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheTop.scala 70:25]
    node _T_7 = asUInt(UInt<1>("h0")) @[CacheTop.scala 72:19]
    node _T_8 = asUInt(stateReg) @[CacheTop.scala 72:19]
    node _T_9 = eq(_T_7, _T_8) @[CacheTop.scala 72:19]
    node storeType = _GEN_7 @[CacheTop.scala 48:23]
    node _T_10 = neq(storeType, UInt<2>("h3")) @[CacheTop.scala 74:38]
    node _T_11 = or(io_rdEnable, _T_10) @[CacheTop.scala 74:24]
    node _GEN_8 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 74:47 75:18 77:18]
    node _T_12 = asUInt(UInt<1>("h1")) @[CacheTop.scala 72:19]
    node _T_13 = asUInt(stateReg) @[CacheTop.scala 72:19]
    node _T_14 = eq(_T_12, _T_13) @[CacheTop.scala 72:19]
    node _GEN_9 = mux(io_rdEnable, io_rdAddress, io_wrAddress) @[CacheTop.scala 83:25 84:30 86:30]
    node _T_15 = eq(storeType, UInt<2>("h3")) @[CacheTop.scala 89:24]
    node _modifiedData_readBytes_0_T = bits(Controller.io_DO, 7, 0) @[CacheFunctions.scala 29:31]
    node _modifiedData_writeBytes_0_T = bits(io_wrData, 7, 0) @[CacheFunctions.scala 30:33]
    node _modifiedData_readBytes_1_T = bits(Controller.io_DO, 15, 8) @[CacheFunctions.scala 29:31]
    node _modifiedData_writeBytes_1_T = bits(io_wrData, 15, 8) @[CacheFunctions.scala 30:33]
    node _modifiedData_readBytes_2_T = bits(Controller.io_DO, 23, 16) @[CacheFunctions.scala 29:31]
    node _modifiedData_writeBytes_2_T = bits(io_wrData, 23, 16) @[CacheFunctions.scala 30:33]
    node _modifiedData_readBytes_3_T = bits(Controller.io_DO, 31, 24) @[CacheFunctions.scala 29:31]
    node _modifiedData_writeBytes_3_T = bits(io_wrData, 31, 24) @[CacheFunctions.scala 30:33]
    node modifiedData_writeBytes_0 = _modifiedData_writeBytes_0_T @[CacheFunctions.scala 24:26 30:21]
    node modifiedData_readBytes_0 = _modifiedData_readBytes_0_T @[CacheFunctions.scala 25:25 29:20]
    node _modifiedData_resultBytes_0_T = mux(io_wrEnable_0, modifiedData_writeBytes_0, modifiedData_readBytes_0) @[CacheFunctions.scala 36:28]
    node modifiedData_writeBytes_1 = _modifiedData_writeBytes_1_T @[CacheFunctions.scala 24:26 30:21]
    node modifiedData_readBytes_1 = _modifiedData_readBytes_1_T @[CacheFunctions.scala 25:25 29:20]
    node _modifiedData_resultBytes_1_T = mux(io_wrEnable_1, modifiedData_writeBytes_1, modifiedData_readBytes_1) @[CacheFunctions.scala 36:28]
    node modifiedData_writeBytes_2 = _modifiedData_writeBytes_2_T @[CacheFunctions.scala 24:26 30:21]
    node modifiedData_readBytes_2 = _modifiedData_readBytes_2_T @[CacheFunctions.scala 25:25 29:20]
    node _modifiedData_resultBytes_2_T = mux(io_wrEnable_2, modifiedData_writeBytes_2, modifiedData_readBytes_2) @[CacheFunctions.scala 36:28]
    node modifiedData_writeBytes_3 = _modifiedData_writeBytes_3_T @[CacheFunctions.scala 24:26 30:21]
    node modifiedData_readBytes_3 = _modifiedData_readBytes_3_T @[CacheFunctions.scala 25:25 29:20]
    node _modifiedData_resultBytes_3_T = mux(io_wrEnable_3, modifiedData_writeBytes_3, modifiedData_readBytes_3) @[CacheFunctions.scala 36:28]
    node modifiedData_resultBytes_1 = _modifiedData_resultBytes_1_T @[CacheFunctions.scala 34:27 36:22]
    node modifiedData_resultBytes_0 = _modifiedData_resultBytes_0_T @[CacheFunctions.scala 34:27 36:22]
    node modifiedData_lo = cat(modifiedData_resultBytes_1, modifiedData_resultBytes_0) @[Cat.scala 33:92]
    node modifiedData_resultBytes_3 = _modifiedData_resultBytes_3_T @[CacheFunctions.scala 34:27 36:22]
    node modifiedData_resultBytes_2 = _modifiedData_resultBytes_2_T @[CacheFunctions.scala 34:27 36:22]
    node modifiedData_hi = cat(modifiedData_resultBytes_3, modifiedData_resultBytes_2) @[Cat.scala 33:92]
    node _modifiedData_T = cat(modifiedData_hi, modifiedData_lo) @[Cat.scala 33:92]
    node _GEN_10 = mux(_T_15, UInt<1>("h0"), UInt<2>("h2")) @[CacheTop.scala 89:33 90:20 93:20]
    node _GEN_11 = mux(_T_15, modifiedData, _modifiedData_T) @[CacheTop.scala 40:29 89:33 92:24]
    node _GEN_12 = mux(Controller.io_ready, _GEN_10, stateReg) @[CacheTop.scala 70:25 88:33]
    node _GEN_13 = mux(Controller.io_ready, _GEN_11, modifiedData) @[CacheTop.scala 40:29 88:33]
    node _T_16 = asUInt(UInt<2>("h2")) @[CacheTop.scala 72:19]
    node _T_17 = asUInt(stateReg) @[CacheTop.scala 72:19]
    node _T_18 = eq(_T_16, _T_17) @[CacheTop.scala 72:19]
    node _GEN_14 = mux(Controller.io_ready, UInt<1>("h0"), stateReg) @[CacheTop.scala 102:32 103:18 70:25]
    node _GEN_15 = mux(_T_18, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 72:19 25:26 99:30]
    node _GEN_16 = mux(_T_18, UInt<1>("h0"), UInt<1>("h1")) @[CacheTop.scala 72:19 100:24 26:20]
    node _GEN_17 = mux(_T_18, io_wrAddress, io_rdAddress) @[CacheTop.scala 72:19 101:28 27:24]
    node _GEN_18 = mux(_T_18, _GEN_14, stateReg) @[CacheTop.scala 72:19 70:25]
    node _GEN_19 = mux(_T_14, UInt<1>("h1"), _GEN_15) @[CacheTop.scala 72:19 81:30]
    node _GEN_20 = mux(_T_14, UInt<1>("h1"), _GEN_16) @[CacheTop.scala 72:19 82:24]
    node _GEN_21 = mux(_T_14, _GEN_9, _GEN_17) @[CacheTop.scala 72:19]
    node _GEN_22 = mux(_T_14, _GEN_12, _GEN_18) @[CacheTop.scala 72:19]
    node _GEN_23 = mux(_T_14, _GEN_13, modifiedData) @[CacheTop.scala 72:19 40:29]
    node _GEN_24 = mux(_T_9, _GEN_8, _GEN_22) @[CacheTop.scala 72:19]
    node _GEN_25 = mux(_T_9, UInt<1>("h0"), _GEN_19) @[CacheTop.scala 72:19 25:26]
    node _GEN_26 = mux(_T_9, UInt<1>("h1"), _GEN_20) @[CacheTop.scala 72:19 26:20]
    node _GEN_27 = mux(_T_9, io_rdAddress, _GEN_21) @[CacheTop.scala 72:19 27:24]
    node _GEN_28 = mux(_T_9, modifiedData, _GEN_23) @[CacheTop.scala 72:19 40:29]
    io_rdData <= Controller.io_DO @[CacheTop.scala 28:13]
    io_stall <= _GEN_0
    Controller.clock <= clock
    Controller.reset <= reset
    Controller.io_validReq <= _GEN_25
    Controller.io_rw <= _GEN_26
    Controller.io_memAdd <= _GEN_27
    Controller.io_DI <= modifiedData @[CacheTop.scala 43:20]
    Controller.io_memReady <= UInt<1>("h1") @[CacheTop.scala 23:26]
    modifiedData <= mux(reset, UInt<32>("h0"), _GEN_28) @[CacheTop.scala 40:{29,29}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_24) @[CacheTop.scala 70:{25,25}]
