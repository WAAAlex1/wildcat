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
    node _T = and(io_rw, io_EN) @[RAM.scala 15:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 16:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 16:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<9>("h0")) @[RAM.scala 16:22]
    node _io_DO_T_1 = bits(_io_DO_T, 8, 0) @[RAM.scala 16:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 16:{22,22} 13:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 16:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 16:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 17:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 17:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 17:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 17:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 13:24 17:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 17:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 17:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 17:30 19:11 21:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 15:23 13:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 15:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 15:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 15:23 16:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 15:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 15:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 15:23 13:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 15:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 15:23]
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
    node _T = and(io_rw, io_EN) @[RAM.scala 15:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 16:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 16:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<10>("h0")) @[RAM.scala 16:22]
    node _io_DO_T_1 = bits(_io_DO_T, 9, 0) @[RAM.scala 16:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 16:{22,22} 13:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 16:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 16:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 17:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 17:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 17:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 17:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 13:24 17:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 17:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 17:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 17:30 19:11 21:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 15:23 13:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 15:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 15:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 15:23 16:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 15:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 15:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 15:23 13:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 15:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 15:23]
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

    mem mem : @[RAM.scala 13:24]
      data-type => UInt<32>
      depth => 4096
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 15:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 16:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 16:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<12>("h0")) @[RAM.scala 16:22]
    node _io_DO_T_1 = bits(_io_DO_T, 11, 0) @[RAM.scala 16:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 16:{22,22} 13:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 16:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 16:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 17:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 17:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 17:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 17:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 13:24 17:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 17:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 17:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 17:30 19:11 21:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 15:23 13:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 15:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 15:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 15:23 16:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 15:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 15:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 15:23 13:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 15:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 15:23]
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
    output io_tagOut : UInt<32>
    input io_tagIn : UInt<32>
    output io_cacheHit : UInt<1>
    output io_cacheValid : UInt<1>
    output io_writeIdx : UInt<3>
    output io_stateAllocate : UInt<1>
    output io_stateCompare : UInt<1>
    output io_stateWait : UInt<1>
    output io_stateWriteT : UInt<1>
    output io_readTag : UInt<32>
    output io_cacheAdd : UInt<10>
    output io_memDI : UInt<32>
    output io_memDO : UInt<32>
    output io_cacheDI : UInt<32>
    output io_cacheDO : UInt<32>
    output io_cacheEN : UInt<1>
    output io_extMemAdd : UInt<13>

    inst tagStore of RAM @[CacheController.scala 37:24]
    inst cache of RAM_1 @[CacheController.scala 38:21]
    inst extMem of RAM_2 @[CacheController.scala 39:22]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 36:25]
    node byteOffset = bits(io_memAdd, 1, 0) @[CacheController.scala 44:29]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 45:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 46:24]
    node targetTag = bits(io_memAdd, 31, 12) @[CacheController.scala 47:28]
    node actualTag = bits(tagStore.io_DO, 31, 12) @[CacheController.scala 49:33]
    node cacheValid = bits(tagStore.io_DO, 11, 11) @[CacheController.scala 50:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (UInt<1>("h0"), writeIndex) @[CacheController.scala 51:27]
    reg writeDone : UInt<1>, clock with :
      reset => (UInt<1>("h0"), writeDone) @[CacheController.scala 52:26]
    reg allocateDone : UInt<1>, clock with :
      reset => (UInt<1>("h0"), allocateDone) @[CacheController.scala 53:29]
    reg updatedTag : UInt<32>, clock with :
      reset => (UInt<1>("h0"), updatedTag) @[CacheController.scala 54:27]
    reg cacheHit : UInt<1>, clock with :
      reset => (UInt<1>("h0"), cacheHit) @[CacheController.scala 55:25]
    node memWordAdd = bits(io_memAdd, 31, 2) @[CacheController.scala 60:29]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 83:25]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 84:26]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 87:30]
    reg stateReg : UInt<3>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 101:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 253:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 253:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 253:20]
    node _GEN_0 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 241:13 245:13 262:21]
    node _GEN_1 = mux(io_rw, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 242:13 246:13 262:21]
    node _GEN_2 = mux(io_rw, io_DI, io_DI) @[CacheController.scala 262:21 68:15 270:23]
    node cacheReadAdd = _cacheReadAdd_T @[CacheController.scala 57:30 83:16]
    node _GEN_3 = mux(io_validReq, cacheReadAdd, UInt<10>("h0")) @[CacheController.scala 256:25 258:18 59:26]
    node _GEN_4 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 241:13 249:13 256:25]
    node _GEN_5 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 242:13 250:13 256:25]
    node _GEN_6 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 256:25 260:18 101:25]
    node _GEN_7 = mux(io_validReq, _GEN_0, UInt<1>("h0")) @[CacheController.scala 249:13 256:25]
    node _GEN_8 = mux(io_validReq, _GEN_1, UInt<1>("h1")) @[CacheController.scala 250:13 256:25]
    node _GEN_9 = mux(io_validReq, _GEN_2, io_DI) @[CacheController.scala 256:25 68:15]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 253:20]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 253:20]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 253:20]
    node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 280:12]
    node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 285:28]
    node _GEN_10 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 289:21 292:20 36:25]
    node _GEN_11 = mux(io_rw, UInt<1>("h0"), UInt<3>("h4")) @[CacheController.scala 289:21 293:20 298:20]
    node cacheWriteAdd = bits(_cacheWriteAdd_T, 9, 0) @[CacheController.scala 56:31 84:17]
    node _GEN_12 = mux(_T_7, cacheReadAdd, cacheWriteAdd) @[CacheController.scala 285:43 286:18 301:18]
    node _GEN_13 = mux(_T_7, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 285:43 287:21 302:21]
    node _GEN_14 = mux(_T_7, _GEN_0, UInt<1>("h0")) @[CacheController.scala 285:43 67:15]
    node _GEN_15 = mux(_T_7, _GEN_10, lastRead) @[CacheController.scala 285:43 36:25]
    node _GEN_16 = mux(_T_7, _GEN_11, UInt<2>("h2")) @[CacheController.scala 285:43 304:18]
    node _GEN_17 = mux(_T_7, _GEN_1, UInt<1>("h1")) @[CacheController.scala 285:43 66:15]
    node _GEN_18 = mux(_T_7, _GEN_2, io_DI) @[CacheController.scala 285:43 68:15]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 241:13 285:43 70:16]
    node _GEN_20 = mux(_T_7, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 242:13 285:43 69:15]
    node _GEN_21 = mux(_T_6, cacheWriteAdd, _GEN_12) @[CacheController.scala 280:25 281:18]
    node _GEN_22 = mux(_T_6, UInt<1>("h1"), _GEN_19) @[CacheController.scala 241:13 280:25]
    node _GEN_23 = mux(_T_6, UInt<1>("h1"), _GEN_20) @[CacheController.scala 242:13 280:25]
    node _GEN_24 = mux(_T_6, UInt<2>("h2"), _GEN_16) @[CacheController.scala 280:25 284:18]
    node _GEN_25 = mux(_T_6, UInt<1>("h0"), _GEN_13) @[CacheController.scala 280:25 73:15]
    node _GEN_26 = mux(_T_6, UInt<1>("h0"), _GEN_14) @[CacheController.scala 280:25 67:15]
    node _GEN_27 = mux(_T_6, lastRead, _GEN_15) @[CacheController.scala 280:25 36:25]
    node _GEN_28 = mux(_T_6, UInt<1>("h1"), _GEN_17) @[CacheController.scala 280:25 66:15]
    node _GEN_29 = mux(_T_6, io_DI, _GEN_18) @[CacheController.scala 280:25 68:15]
    node _T_8 = asUInt(UInt<3>("h4")) @[CacheController.scala 253:20]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 253:20]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 253:20]
    node _GEN_30 = mux(io_memReady, UInt<1>("h0"), stateReg) @[CacheController.scala 316:25 317:18 101:25]
    node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 253:20]
    node _T_12 = asUInt(stateReg) @[CacheController.scala 253:20]
    node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 253:20]
    node _extMem_io_ad_T = add(memWordAdd, writeIndex) @[CacheController.scala 325:34]
    node _extMem_io_ad_T_1 = tail(_extMem_io_ad_T, 1) @[CacheController.scala 325:34]
    node _extMem_io_ad_T_2 = add(_extMem_io_ad_T_1, UInt<1>("h1")) @[CacheController.scala 325:47]
    node _extMem_io_ad_T_3 = tail(_extMem_io_ad_T_2, 1) @[CacheController.scala 325:47]
    node targetTagWord = _targetTagWord_T @[CacheController.scala 48:31 87:17]
    node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 328:35]
    node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 330:38]
    node _T_15 = and(io_memReady, _T_14) @[CacheController.scala 330:24]
    node _T_16 = eq(io_memReady, UInt<1>("h0")) @[CacheController.scala 335:18]
    node _T_17 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 335:45]
    node _T_18 = and(_T_16, _T_17) @[CacheController.scala 335:31]
    node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 338:34]
    node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 338:34]
    node _GEN_31 = mux(_T_18, UInt<2>("h3"), _writeIndex_T_1) @[CacheController.scala 335:54 336:20 338:20]
    node _GEN_32 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 245:13 330:47 65:18]
    node _GEN_33 = mux(_T_15, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 246:13 330:47 64:18]
    node _GEN_34 = mux(_T_15, UInt<1>("h1"), stateReg) @[CacheController.scala 330:47 333:18 101:25]
    node _GEN_35 = mux(_T_15, UInt<1>("h0"), _GEN_31) @[CacheController.scala 330:47 334:20]
    node _GEN_36 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 245:13 253:20 67:15]
    node _GEN_37 = mux(_T_13, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 246:13 253:20 66:15]
    node _GEN_38 = mux(_T_13, cacheWriteAdd, UInt<10>("h0")) @[CacheController.scala 253:20 323:16 59:26]
    node _GEN_39 = mux(_T_13, _extMem_io_ad_T_3, memWordAdd) @[CacheController.scala 253:20 325:20 71:16]
    node _GEN_40 = mux(_T_13, extMem.io_DO, io_DI) @[CacheController.scala 253:20 326:19 68:15]
    node _GEN_41 = mux(_T_13, _updatedTag_T, updatedTag) @[CacheController.scala 253:20 328:18 54:27]
    node _GEN_42 = mux(_T_13, _GEN_32, UInt<1>("h0")) @[CacheController.scala 253:20 65:18]
    node _GEN_43 = mux(_T_13, _GEN_33, UInt<1>("h1")) @[CacheController.scala 253:20 64:18]
    node _GEN_44 = mux(_T_13, _GEN_34, stateReg) @[CacheController.scala 253:20 101:25]
    node _GEN_45 = mux(_T_13, _GEN_35, writeIndex) @[CacheController.scala 253:20 51:27]
    node _GEN_46 = mux(_T_10, cacheReadAdd, _GEN_38) @[CacheController.scala 253:20 311:16]
    node _GEN_47 = mux(_T_10, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 253:20 312:20 69:15]
    node _GEN_48 = mux(_T_10, UInt<1>("h1"), _GEN_36) @[CacheController.scala 253:20 313:20]
    node _GEN_49 = mux(_T_10, io_DI, UInt<32>("h0")) @[CacheController.scala 253:20 314:17 58:27]
    node _GEN_50 = mux(_T_10, _GEN_30, _GEN_44) @[CacheController.scala 253:20]
    node _GEN_51 = mux(_T_10, UInt<1>("h0"), _GEN_36) @[CacheController.scala 253:20 67:15]
    node _GEN_52 = mux(_T_10, UInt<1>("h1"), _GEN_37) @[CacheController.scala 253:20 66:15]
    node _GEN_53 = mux(_T_10, memWordAdd, _GEN_39) @[CacheController.scala 253:20 71:16]
    node _GEN_54 = mux(_T_10, io_DI, _GEN_40) @[CacheController.scala 253:20 68:15]
    node _GEN_55 = mux(_T_10, updatedTag, _GEN_41) @[CacheController.scala 253:20 54:27]
    node _GEN_56 = mux(_T_10, UInt<1>("h0"), _GEN_42) @[CacheController.scala 253:20 65:18]
    node _GEN_57 = mux(_T_10, UInt<1>("h1"), _GEN_43) @[CacheController.scala 253:20 64:18]
    node _GEN_58 = mux(_T_10, writeIndex, _GEN_45) @[CacheController.scala 253:20 51:27]
    node _GEN_59 = mux(_T_5, UInt<1>("h1"), _GEN_56) @[CacheController.scala 253:20 279:22]
    node _GEN_60 = mux(_T_5, _GEN_21, _GEN_46) @[CacheController.scala 253:20]
    node _GEN_61 = mux(_T_5, _GEN_22, _GEN_48) @[CacheController.scala 253:20]
    node _GEN_62 = mux(_T_5, _GEN_23, _GEN_47) @[CacheController.scala 253:20]
    node _GEN_63 = mux(_T_5, _GEN_24, _GEN_50) @[CacheController.scala 253:20]
    node _GEN_64 = mux(_T_5, _GEN_25, UInt<1>("h0")) @[CacheController.scala 253:20 73:15]
    node _GEN_65 = mux(_T_5, _GEN_26, _GEN_51) @[CacheController.scala 253:20]
    node _GEN_66 = mux(_T_5, _GEN_27, lastRead) @[CacheController.scala 253:20 36:25]
    node _GEN_67 = mux(_T_5, _GEN_28, _GEN_52) @[CacheController.scala 253:20]
    node _GEN_68 = mux(_T_5, _GEN_29, _GEN_54) @[CacheController.scala 253:20]
    node _GEN_69 = mux(_T_5, UInt<32>("h0"), _GEN_49) @[CacheController.scala 253:20 58:27]
    node _GEN_70 = mux(_T_5, memWordAdd, _GEN_53) @[CacheController.scala 253:20 71:16]
    node _GEN_71 = mux(_T_5, updatedTag, _GEN_55) @[CacheController.scala 253:20 54:27]
    node _GEN_72 = mux(_T_5, UInt<1>("h1"), _GEN_57) @[CacheController.scala 253:20 64:18]
    node _GEN_73 = mux(_T_5, writeIndex, _GEN_58) @[CacheController.scala 253:20 51:27]
    node _GEN_74 = mux(_T_2, UInt<1>("h0"), _GEN_61) @[CacheController.scala 249:13 253:20]
    node _GEN_75 = mux(_T_2, UInt<1>("h1"), _GEN_62) @[CacheController.scala 250:13 253:20]
    node _GEN_76 = mux(_T_2, _GEN_3, _GEN_60) @[CacheController.scala 253:20]
    node _GEN_77 = mux(_T_2, _GEN_4, _GEN_59) @[CacheController.scala 253:20]
    node _GEN_78 = mux(_T_2, _GEN_5, _GEN_72) @[CacheController.scala 253:20]
    node _GEN_79 = mux(_T_2, _GEN_6, _GEN_63) @[CacheController.scala 253:20]
    node _GEN_80 = mux(_T_2, _GEN_7, _GEN_65) @[CacheController.scala 253:20]
    node _GEN_81 = mux(_T_2, _GEN_8, _GEN_67) @[CacheController.scala 253:20]
    node _GEN_82 = mux(_T_2, _GEN_9, _GEN_68) @[CacheController.scala 253:20]
    node _GEN_83 = mux(_T_2, UInt<1>("h0"), _GEN_64) @[CacheController.scala 253:20 73:15]
    node _GEN_84 = mux(_T_2, lastRead, _GEN_66) @[CacheController.scala 253:20 36:25]
    node _GEN_85 = mux(_T_2, UInt<32>("h0"), _GEN_69) @[CacheController.scala 253:20 58:27]
    node _GEN_86 = mux(_T_2, memWordAdd, _GEN_70) @[CacheController.scala 253:20 71:16]
    node _GEN_87 = mux(_T_2, updatedTag, _GEN_71) @[CacheController.scala 253:20 54:27]
    node _GEN_88 = mux(_T_2, writeIndex, _GEN_73) @[CacheController.scala 253:20 51:27]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 346:24]
    node _io_stateWait_T = eq(stateReg, UInt<2>("h3")) @[CacheController.scala 352:28]
    node _io_stateCompare_T = eq(stateReg, UInt<1>("h1")) @[CacheController.scala 353:31]
    node _io_stateAllocate_T = eq(stateReg, UInt<2>("h2")) @[CacheController.scala 354:32]
    node _io_stateWriteT_T = eq(stateReg, UInt<3>("h4")) @[CacheController.scala 355:30]
    node _io_readTag_T = shl(cacheValid, 11) @[CacheController.scala 356:42]
    node _io_readTag_T_1 = cat(actualTag, _io_readTag_T) @[CacheController.scala 356:27]
    node memDataIn = _GEN_85 @[CacheController.scala 58:27]
    node cacheAdd = _GEN_76 @[CacheController.scala 59:26]
    io_DO <= lastRead @[CacheController.scala 360:9]
    io_ready <= _io_ready_T @[CacheController.scala 346:12]
    io_tagOut <= updatedTag @[CacheController.scala 349:13]
    io_cacheHit <= _GEN_83
    io_cacheValid <= cacheValid @[CacheController.scala 347:17]
    io_writeIdx <= writeIndex @[CacheController.scala 348:15]
    io_stateAllocate <= _io_stateAllocate_T @[CacheController.scala 354:20]
    io_stateCompare <= _io_stateCompare_T @[CacheController.scala 353:19]
    io_stateWait <= _io_stateWait_T @[CacheController.scala 352:16]
    io_stateWriteT <= _io_stateWriteT_T @[CacheController.scala 355:18]
    io_readTag <= _io_readTag_T_1 @[CacheController.scala 356:14]
    io_cacheAdd <= cache.io_ad @[CacheController.scala 358:15]
    io_memDI <= extMem.io_DI @[CacheController.scala 76:12]
    io_memDO <= extMem.io_DO @[CacheController.scala 77:12]
    io_cacheDI <= cache.io_DI @[CacheController.scala 74:14]
    io_cacheDO <= cache.io_DO @[CacheController.scala 75:14]
    io_cacheEN <= cache.io_EN @[CacheController.scala 357:14]
    io_extMemAdd <= pad(extMem.io_ad, 13) @[CacheController.scala 363:16]
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_84) @[CacheController.scala 36:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_78
    tagStore.io_ad <= pad(index, 9) @[CacheController.scala 90:18]
    tagStore.io_DI <= io_tagOut @[CacheController.scala 350:18]
    tagStore.io_EN <= _GEN_77
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_81
    cache.io_ad <= cacheAdd @[CacheController.scala 86:15]
    cache.io_DI <= _GEN_82
    cache.io_EN <= _GEN_80
    extMem.clock <= clock
    extMem.reset <= reset
    extMem.io_rw <= _GEN_75
    extMem.io_ad <= bits(_GEN_86, 11, 0)
    extMem.io_DI <= memDataIn @[CacheController.scala 82:16]
    extMem.io_EN <= _GEN_74
    writeIndex <= mux(reset, UInt<3>("h0"), _GEN_88) @[CacheController.scala 51:{27,27}]
    writeDone <= mux(reset, UInt<1>("h1"), writeDone) @[CacheController.scala 52:{26,26,26}]
    allocateDone <= mux(reset, UInt<1>("h1"), allocateDone) @[CacheController.scala 53:{29,29,29}]
    updatedTag <= mux(reset, UInt<32>("h0"), _GEN_87) @[CacheController.scala 54:{27,27}]
    cacheHit <= mux(reset, UInt<1>("h0"), cacheHit) @[CacheController.scala 55:{25,25,25}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_79) @[CacheController.scala 101:{25,25}]
