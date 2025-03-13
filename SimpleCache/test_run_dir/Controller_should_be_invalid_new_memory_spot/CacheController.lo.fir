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

    mem mem : @[RAM.scala 13:24]
      data-type => UInt<32>
      depth => 512
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 16:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 17:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 17:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<9>("h0")) @[RAM.scala 17:22]
    node _io_DO_T_1 = bits(_io_DO_T, 8, 0) @[RAM.scala 17:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 17:{22,22} 13:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 17:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 17:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 18:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 18:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 18:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 18:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 13:24 18:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 18:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 18:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h1")) @[RAM.scala 18:30 20:11 22:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 16:23 13:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 16:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 16:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 16:23 17:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 16:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 16:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 16:23 13:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 16:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 16:23]
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

    mem mem : @[RAM.scala 13:24]
      data-type => UInt<32>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 16:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 17:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 17:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<10>("h0")) @[RAM.scala 17:22]
    node _io_DO_T_1 = bits(_io_DO_T, 9, 0) @[RAM.scala 17:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 17:{22,22} 13:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 17:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 17:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 18:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 18:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 18:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 18:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 13:24 18:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 18:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 18:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h1")) @[RAM.scala 18:30 20:11 22:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 16:23 13:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 16:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 16:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 16:23 17:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 16:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 16:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 16:23 13:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 16:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 16:23]
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
    input io_ad : UInt<11>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 13:24]
      data-type => UInt<32>
      depth => 2048
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 16:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 17:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 17:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<11>("h0")) @[RAM.scala 17:22]
    node _io_DO_T_1 = bits(_io_DO_T, 10, 0) @[RAM.scala 17:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 17:{22,22} 13:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 17:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 17:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 18:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 18:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 18:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 18:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 13:24 18:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 18:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 18:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h1")) @[RAM.scala 18:30 20:11 22:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 16:23 13:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 16:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 16:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 16:23 17:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 16:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 16:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 16:23 13:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 16:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 16:23]
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
    output io_memDataOut : UInt<32>
    output io_ready : UInt<1>
    input io_memReady : UInt<1>
    output io_tagOut : UInt<32>
    input io_tagIn : UInt<32>
    output io_cacheHit : UInt<1>
    output io_cacheValid : UInt<1>
    output io_writeIdx : UInt<2>
    output io_stateAllocate : UInt<1>
    output io_stateCompare : UInt<1>
    output io_stateWait : UInt<1>
    output io_stateWriteT : UInt<1>
    output io_readTag : UInt<32>

    inst tagStore of RAM @[CacheController.scala 27:24]
    inst cache of RAM_1 @[CacheController.scala 28:21]
    inst extMem of RAM_2 @[CacheController.scala 29:22]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 26:25]
    node byteOffset = bits(io_memAdd, 1, 0) @[CacheController.scala 46:29]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 47:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 48:24]
    node targetTag = bits(io_memAdd, 31, 12) @[CacheController.scala 49:28]
    reg tagWord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), tagWord) @[CacheController.scala 50:24]
    node actualTag = bits(tagStore.io_DO, 31, 12) @[CacheController.scala 51:33]
    node cacheValid = bits(tagStore.io_DO, 11, 11) @[CacheController.scala 52:34]
    reg writeIndex : UInt<2>, clock with :
      reset => (UInt<1>("h0"), writeIndex) @[CacheController.scala 53:27]
    reg writeDone : UInt<1>, clock with :
      reset => (UInt<1>("h0"), writeDone) @[CacheController.scala 54:26]
    reg allocateDone : UInt<1>, clock with :
      reset => (UInt<1>("h0"), allocateDone) @[CacheController.scala 55:29]
    reg updatedTag : UInt<32>, clock with :
      reset => (UInt<1>("h0"), updatedTag) @[CacheController.scala 56:27]
    reg cacheHit : UInt<1>, clock with :
      reset => (UInt<1>("h0"), cacheHit) @[CacheController.scala 57:25]
    reg cacheAdd : UInt<10>, clock with :
      reset => (UInt<1>("h0"), cacheAdd) @[CacheController.scala 58:25]
    reg stateReg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 72:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 75:19]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 75:19]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 75:19]
    node _GEN_0 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 32:18 78:24 80:24]
    node _GEN_1 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 78:24 81:24 84:24]
    node _GEN_2 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 78:24 82:18 72:25]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 75:19]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 75:19]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 75:19]
    node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 91:12]
    node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 94:28]
    node _cacheAdd_T = cat(index, blockOffset) @[CacheController.scala 95:27]
    node _GEN_3 = mux(io_rw, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 98:21 100:23 107:23]
    node _GEN_4 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 98:21 101:23 108:23]
    node _GEN_5 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 102:20 98:21 26:25]
    node _GEN_6 = mux(io_rw, UInt<1>("h0"), UInt<2>("h3")) @[CacheController.scala 103:20 110:20 98:21]
    node _GEN_7 = mux(io_rw, writeDone, UInt<1>("h0")) @[CacheController.scala 106:21 98:21 54:26]
    node _GEN_8 = mux(_T_7, _cacheAdd_T, cacheAdd) @[CacheController.scala 94:43 95:18 58:25]
    node _GEN_9 = mux(_T_7, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 113:21 94:43 96:21]
    node _GEN_10 = mux(_T_7, _GEN_3, UInt<1>("h1")) @[CacheController.scala 34:15 94:43]
    node _GEN_11 = mux(_T_7, _GEN_4, UInt<1>("h1")) @[CacheController.scala 35:15 94:43]
    node _GEN_12 = mux(_T_7, _GEN_5, lastRead) @[CacheController.scala 26:25 94:43]
    node _GEN_13 = mux(_T_7, _GEN_6, UInt<2>("h2")) @[CacheController.scala 115:18 94:43]
    node _GEN_14 = mux(_T_7, _GEN_7, writeDone) @[CacheController.scala 54:26 94:43]
    node _GEN_15 = mux(_T_7, allocateDone, UInt<1>("h0")) @[CacheController.scala 114:22 55:29 94:43]
    node _GEN_16 = mux(_T_6, UInt<1>("h0"), _GEN_15) @[CacheController.scala 91:24 92:22]
    node _GEN_17 = mux(_T_6, UInt<2>("h2"), _GEN_13) @[CacheController.scala 91:24 93:18]
    node _GEN_18 = mux(_T_6, cacheAdd, _GEN_8) @[CacheController.scala 91:24 58:25]
    node _GEN_19 = mux(_T_6, UInt<1>("h0"), _GEN_9) @[CacheController.scala 43:15 91:24]
    node _GEN_20 = mux(_T_6, UInt<1>("h1"), _GEN_10) @[CacheController.scala 34:15 91:24]
    node _GEN_21 = mux(_T_6, UInt<1>("h1"), _GEN_11) @[CacheController.scala 35:15 91:24]
    node _GEN_22 = mux(_T_6, lastRead, _GEN_12) @[CacheController.scala 91:24 26:25]
    node _GEN_23 = mux(_T_6, writeDone, _GEN_14) @[CacheController.scala 91:24 54:26]
    node _T_8 = asUInt(UInt<2>("h3")) @[CacheController.scala 75:19]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 75:19]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 75:19]
    node _T_11 = eq(writeDone, UInt<1>("h0")) @[CacheController.scala 122:12]
    node _T_12 = and(_T_11, allocateDone) @[CacheController.scala 122:23]
    node _T_13 = and(writeDone, allocateDone) @[CacheController.scala 125:28]
    node _T_14 = eq(allocateDone, UInt<1>("h0")) @[CacheController.scala 130:18]
    node _GEN_24 = mux(_T_14, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 130:32 131:22 38:16]
    node _GEN_25 = mux(_T_14, UInt<1>("h0"), writeIndex) @[CacheController.scala 130:32 133:20 53:27]
    node _GEN_26 = mux(_T_14, UInt<1>("h1"), allocateDone) @[CacheController.scala 130:32 134:22 55:29]
    node _GEN_27 = mux(_T_14, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 130:32 136:24 32:18]
    node _GEN_28 = mux(_T_14, UInt<1>("h1"), stateReg) @[CacheController.scala 130:32 137:18 72:25]
    node _GEN_29 = mux(_T_13, UInt<1>("h0"), _GEN_24) @[CacheController.scala 125:45 126:22]
    node _GEN_30 = mux(_T_13, UInt<1>("h0"), _GEN_25) @[CacheController.scala 125:45 128:20]
    node _GEN_31 = mux(_T_13, UInt<1>("h0"), _GEN_28) @[CacheController.scala 125:45 129:18]
    node _GEN_32 = mux(_T_13, allocateDone, _GEN_26) @[CacheController.scala 125:45 55:29]
    node _GEN_33 = mux(_T_13, UInt<1>("h1"), _GEN_27) @[CacheController.scala 125:45 32:18]
    node _GEN_34 = mux(_T_12, UInt<1>("h0"), _GEN_29) @[CacheController.scala 122:40 123:21]
    node _GEN_35 = mux(_T_12, UInt<3>("h4"), _GEN_31) @[CacheController.scala 122:40 124:18]
    node _GEN_36 = mux(_T_12, UInt<1>("h1"), _GEN_29) @[CacheController.scala 122:40 38:16]
    node _GEN_37 = mux(_T_12, writeIndex, _GEN_30) @[CacheController.scala 122:40 53:27]
    node _GEN_38 = mux(_T_12, allocateDone, _GEN_32) @[CacheController.scala 122:40 55:29]
    node _GEN_39 = mux(_T_12, UInt<1>("h1"), _GEN_33) @[CacheController.scala 122:40 32:18]
    node _T_15 = asUInt(UInt<3>("h4")) @[CacheController.scala 75:19]
    node _T_16 = asUInt(stateReg) @[CacheController.scala 75:19]
    node _T_17 = eq(_T_15, _T_16) @[CacheController.scala 75:19]
    node _cacheAdd_T_1 = cat(index, writeIndex) @[CacheController.scala 143:25]
    node _extMem_io_ad_T = mul(writeIndex, UInt<3>("h4")) @[CacheController.scala 146:46]
    node _extMem_io_ad_T_1 = add(io_memAdd, _extMem_io_ad_T) @[CacheController.scala 146:33]
    node _extMem_io_ad_T_2 = tail(_extMem_io_ad_T_1, 1) @[CacheController.scala 146:33]
    node _T_18 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 149:38]
    node _T_19 = and(io_memReady, _T_18) @[CacheController.scala 149:24]
    node _T_20 = eq(io_memReady, UInt<1>("h0")) @[CacheController.scala 152:18]
    node _T_21 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 152:45]
    node _T_22 = and(_T_20, _T_21) @[CacheController.scala 152:31]
    node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 155:34]
    node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 155:34]
    node _GEN_40 = mux(_T_22, UInt<2>("h3"), _writeIndex_T_1) @[CacheController.scala 152:54 153:20 155:20]
    node _GEN_41 = mux(_T_19, UInt<1>("h1"), writeDone) @[CacheController.scala 149:46 150:19 54:26]
    node _GEN_42 = mux(_T_19, UInt<2>("h3"), stateReg) @[CacheController.scala 149:46 151:18 72:25]
    node _GEN_43 = mux(_T_19, writeIndex, _GEN_40) @[CacheController.scala 149:46 53:27]
    node _T_23 = asUInt(UInt<2>("h2")) @[CacheController.scala 75:19]
    node _T_24 = asUInt(stateReg) @[CacheController.scala 75:19]
    node _T_25 = eq(_T_23, _T_24) @[CacheController.scala 75:19]
    node _cacheAdd_T_2 = cat(index, writeIndex) @[CacheController.scala 163:25]
    node _extMem_io_ad_T_3 = mul(writeIndex, UInt<3>("h4")) @[CacheController.scala 166:46]
    node _extMem_io_ad_T_4 = add(io_memAdd, _extMem_io_ad_T_3) @[CacheController.scala 166:33]
    node _extMem_io_ad_T_5 = tail(_extMem_io_ad_T_4, 1) @[CacheController.scala 166:33]
    node _updatedTag_T = shl(targetTag, 12) @[CacheController.scala 169:32]
    node _updatedTag_T_1 = or(updatedTag, UInt<12>("h800")) @[CacheController.scala 170:32]
    node _T_26 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 172:38]
    node _T_27 = and(io_memReady, _T_26) @[CacheController.scala 172:24]
    node _T_28 = eq(io_memReady, UInt<1>("h0")) @[CacheController.scala 177:18]
    node _T_29 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 177:45]
    node _T_30 = and(_T_28, _T_29) @[CacheController.scala 177:31]
    node _writeIndex_T_2 = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 180:34]
    node _writeIndex_T_3 = tail(_writeIndex_T_2, 1) @[CacheController.scala 180:34]
    node _GEN_44 = mux(_T_30, UInt<2>("h3"), _writeIndex_T_3) @[CacheController.scala 177:54 178:20 180:20]
    node _GEN_45 = mux(_T_27, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 172:46 174:24 32:18]
    node _GEN_46 = mux(_T_27, UInt<2>("h3"), stateReg) @[CacheController.scala 172:46 176:18 72:25]
    node _GEN_47 = mux(_T_27, writeIndex, _GEN_44) @[CacheController.scala 172:46 53:27]
    node _GEN_48 = mux(_T_25, UInt<1>("h0"), allocateDone) @[CacheController.scala 75:19 160:20 55:29]
    node _GEN_49 = mux(_T_25, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 161:19 34:15 75:19]
    node _GEN_50 = mux(_T_25, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 162:19 35:15 75:19]
    node _GEN_51 = mux(_T_25, _cacheAdd_T_2, cacheAdd) @[CacheController.scala 163:16 75:19 58:25]
    node _GEN_52 = mux(_T_25, _extMem_io_ad_T_5, io_memAdd) @[CacheController.scala 75:19 166:20 41:16]
    node _GEN_53 = mux(_T_25, extMem.io_DO, io_DI) @[CacheController.scala 167:19 36:15 75:19]
    node _GEN_54 = mux(_T_25, _updatedTag_T_1, updatedTag) @[CacheController.scala 170:18 75:19 56:27]
    node _GEN_55 = mux(_T_25, _GEN_45, UInt<1>("h1")) @[CacheController.scala 32:18 75:19]
    node _GEN_56 = mux(_T_25, _GEN_46, stateReg) @[CacheController.scala 75:19 72:25]
    node _GEN_57 = mux(_T_25, _GEN_47, writeIndex) @[CacheController.scala 75:19 53:27]
    node _GEN_58 = mux(_T_17, UInt<1>("h1"), _GEN_49) @[CacheController.scala 141:19 75:19]
    node _GEN_59 = mux(_T_17, UInt<1>("h1"), _GEN_50) @[CacheController.scala 142:19 75:19]
    node _GEN_60 = mux(_T_17, _cacheAdd_T_1, _GEN_51) @[CacheController.scala 143:16 75:19]
    node _GEN_61 = mux(_T_17, _extMem_io_ad_T_2, _GEN_52) @[CacheController.scala 75:19 146:20]
    node _GEN_62 = mux(_T_17, cache.io_DO, UInt<1>("h0")) @[CacheController.scala 75:19 147:21 40:17]
    node _GEN_63 = mux(_T_17, _GEN_41, writeDone) @[CacheController.scala 75:19 54:26]
    node _GEN_64 = mux(_T_17, _GEN_42, _GEN_56) @[CacheController.scala 75:19]
    node _GEN_65 = mux(_T_17, _GEN_43, _GEN_57) @[CacheController.scala 75:19]
    node _GEN_66 = mux(_T_17, allocateDone, _GEN_48) @[CacheController.scala 75:19 55:29]
    node _GEN_67 = mux(_T_17, io_DI, _GEN_53) @[CacheController.scala 36:15 75:19]
    node _GEN_68 = mux(_T_17, updatedTag, _GEN_54) @[CacheController.scala 75:19 56:27]
    node _GEN_69 = mux(_T_17, UInt<1>("h1"), _GEN_55) @[CacheController.scala 32:18 75:19]
    node _GEN_70 = mux(_T_10, _GEN_34, _GEN_59) @[CacheController.scala 75:19]
    node _GEN_71 = mux(_T_10, _GEN_35, _GEN_64) @[CacheController.scala 75:19]
    node _GEN_72 = mux(_T_10, _GEN_36, _GEN_59) @[CacheController.scala 75:19]
    node _GEN_73 = mux(_T_10, _GEN_37, _GEN_65) @[CacheController.scala 75:19]
    node _GEN_74 = mux(_T_10, _GEN_38, _GEN_66) @[CacheController.scala 75:19]
    node _GEN_75 = mux(_T_10, _GEN_39, _GEN_69) @[CacheController.scala 75:19]
    node _GEN_76 = mux(_T_10, UInt<1>("h1"), _GEN_58) @[CacheController.scala 34:15 75:19]
    node _GEN_77 = mux(_T_10, cacheAdd, _GEN_60) @[CacheController.scala 75:19 58:25]
    node _GEN_78 = mux(_T_10, io_memAdd, _GEN_61) @[CacheController.scala 41:16 75:19]
    node _GEN_79 = mux(_T_10, UInt<1>("h0"), _GEN_62) @[CacheController.scala 40:17 75:19]
    node _GEN_80 = mux(_T_10, writeDone, _GEN_63) @[CacheController.scala 75:19 54:26]
    node _GEN_81 = mux(_T_10, io_DI, _GEN_67) @[CacheController.scala 36:15 75:19]
    node _GEN_82 = mux(_T_10, updatedTag, _GEN_68) @[CacheController.scala 75:19 56:27]
    node _GEN_83 = mux(_T_5, _GEN_16, _GEN_74) @[CacheController.scala 75:19]
    node _GEN_84 = mux(_T_5, _GEN_17, _GEN_71) @[CacheController.scala 75:19]
    node _GEN_85 = mux(_T_5, _GEN_18, _GEN_77) @[CacheController.scala 75:19]
    node _GEN_86 = mux(_T_5, _GEN_19, UInt<1>("h0")) @[CacheController.scala 43:15 75:19]
    node _GEN_87 = mux(_T_5, _GEN_20, _GEN_76) @[CacheController.scala 75:19]
    node _GEN_88 = mux(_T_5, _GEN_21, _GEN_70) @[CacheController.scala 75:19]
    node _GEN_89 = mux(_T_5, _GEN_22, lastRead) @[CacheController.scala 75:19 26:25]
    node _GEN_90 = mux(_T_5, _GEN_23, _GEN_80) @[CacheController.scala 75:19]
    node _GEN_91 = mux(_T_5, UInt<1>("h1"), _GEN_72) @[CacheController.scala 38:16 75:19]
    node _GEN_92 = mux(_T_5, writeIndex, _GEN_73) @[CacheController.scala 75:19 53:27]
    node _GEN_93 = mux(_T_5, UInt<1>("h1"), _GEN_75) @[CacheController.scala 32:18 75:19]
    node _GEN_94 = mux(_T_5, UInt<1>("h1"), _GEN_76) @[CacheController.scala 37:15 75:19]
    node _GEN_95 = mux(_T_5, io_memAdd, _GEN_78) @[CacheController.scala 41:16 75:19]
    node _GEN_96 = mux(_T_5, UInt<1>("h0"), _GEN_79) @[CacheController.scala 40:17 75:19]
    node _GEN_97 = mux(_T_5, io_DI, _GEN_81) @[CacheController.scala 36:15 75:19]
    node _GEN_98 = mux(_T_5, updatedTag, _GEN_82) @[CacheController.scala 75:19 56:27]
    node _GEN_99 = mux(_T_2, _GEN_0, _GEN_93) @[CacheController.scala 75:19]
    node _GEN_100 = mux(_T_2, _GEN_1, UInt<1>("h1")) @[CacheController.scala 33:18 75:19]
    node _GEN_101 = mux(_T_2, _GEN_2, _GEN_84) @[CacheController.scala 75:19]
    node _GEN_102 = mux(_T_2, _GEN_1, _GEN_88) @[CacheController.scala 75:19]
    node _GEN_103 = mux(_T_2, _GEN_1, _GEN_91) @[CacheController.scala 75:19]
    node _GEN_104 = mux(_T_2, allocateDone, _GEN_83) @[CacheController.scala 75:19 55:29]
    node _GEN_105 = mux(_T_2, cacheAdd, _GEN_85) @[CacheController.scala 75:19 58:25]
    node _GEN_106 = mux(_T_2, UInt<1>("h0"), _GEN_86) @[CacheController.scala 43:15 75:19]
    node _GEN_107 = mux(_T_2, UInt<1>("h1"), _GEN_87) @[CacheController.scala 34:15 75:19]
    node _GEN_108 = mux(_T_2, lastRead, _GEN_89) @[CacheController.scala 75:19 26:25]
    node _GEN_109 = mux(_T_2, writeDone, _GEN_90) @[CacheController.scala 75:19 54:26]
    node _GEN_110 = mux(_T_2, writeIndex, _GEN_92) @[CacheController.scala 75:19 53:27]
    node _GEN_111 = mux(_T_2, UInt<1>("h1"), _GEN_94) @[CacheController.scala 37:15 75:19]
    node _GEN_112 = mux(_T_2, io_memAdd, _GEN_95) @[CacheController.scala 41:16 75:19]
    node _GEN_113 = mux(_T_2, UInt<1>("h0"), _GEN_96) @[CacheController.scala 40:17 75:19]
    node _GEN_114 = mux(_T_2, io_DI, _GEN_97) @[CacheController.scala 36:15 75:19]
    node _GEN_115 = mux(_T_2, updatedTag, _GEN_98) @[CacheController.scala 75:19 56:27]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 188:24]
    node _io_stateWait_T = eq(stateReg, UInt<2>("h3")) @[CacheController.scala 194:28]
    node _io_stateCompare_T = eq(stateReg, UInt<1>("h1")) @[CacheController.scala 195:31]
    node _io_stateAllocate_T = eq(stateReg, UInt<2>("h2")) @[CacheController.scala 196:32]
    node _io_stateWriteT_T = eq(stateReg, UInt<3>("h4")) @[CacheController.scala 197:30]
    node _io_readTag_T = shl(cacheValid, 11) @[CacheController.scala 198:42]
    node _io_readTag_T_1 = cat(actualTag, _io_readTag_T) @[CacheController.scala 198:27]
    io_DO <= lastRead @[CacheController.scala 201:9]
    io_memDataOut <= _GEN_113
    io_ready <= _io_ready_T @[CacheController.scala 188:12]
    io_tagOut <= updatedTag @[CacheController.scala 191:13]
    io_cacheHit <= _GEN_106
    io_cacheValid <= cacheValid @[CacheController.scala 189:17]
    io_writeIdx <= writeIndex @[CacheController.scala 190:15]
    io_stateAllocate <= _io_stateAllocate_T @[CacheController.scala 196:20]
    io_stateCompare <= _io_stateCompare_T @[CacheController.scala 195:19]
    io_stateWait <= _io_stateWait_T @[CacheController.scala 194:16]
    io_stateWriteT <= _io_stateWriteT_T @[CacheController.scala 197:18]
    io_readTag <= _io_readTag_T_1 @[CacheController.scala 198:14]
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_108) @[CacheController.scala 26:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_99
    tagStore.io_ad <= pad(index, 9) @[CacheController.scala 61:18]
    tagStore.io_DI <= io_tagOut @[CacheController.scala 192:18]
    tagStore.io_EN <= _GEN_100
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_107
    cache.io_ad <= cacheAdd @[CacheController.scala 199:15]
    cache.io_DI <= _GEN_114
    cache.io_EN <= _GEN_102
    extMem.clock <= clock
    extMem.reset <= reset
    extMem.io_rw <= _GEN_111
    extMem.io_ad <= bits(_GEN_112, 10, 0)
    extMem.io_DI <= io_memDataOut @[CacheController.scala 39:16]
    extMem.io_EN <= _GEN_103
    tagWord <= mux(reset, UInt<32>("h0"), tagWord) @[CacheController.scala 50:{24,24,24}]
    writeIndex <= mux(reset, UInt<2>("h0"), _GEN_110) @[CacheController.scala 53:{27,27}]
    writeDone <= mux(reset, UInt<1>("h1"), _GEN_109) @[CacheController.scala 54:{26,26}]
    allocateDone <= mux(reset, UInt<1>("h1"), _GEN_104) @[CacheController.scala 55:{29,29}]
    updatedTag <= mux(reset, UInt<32>("h0"), _GEN_115) @[CacheController.scala 56:{27,27}]
    cacheHit <= mux(reset, UInt<1>("h0"), cacheHit) @[CacheController.scala 57:{25,25,25}]
    cacheAdd <= mux(reset, UInt<10>("h0"), _GEN_105) @[CacheController.scala 58:{25,25}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_101) @[CacheController.scala 72:{25,25}]
