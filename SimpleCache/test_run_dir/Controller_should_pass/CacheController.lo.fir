FIRRTL version 1.1.0
circuit CacheController :
  module RAM :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<9>
    input io_DI : UInt<32>
    input io_WE : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 14:24]
      data-type => UInt<32>
      depth => 512
      read-latency => 1
      write-latency => 1
      reader => memVal
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 16:{24,24}]
    node _memVal_WIRE = _GEN_0 @[RAM.scala 16:24]
    node _memVal_T = or(_memVal_WIRE, UInt<9>("h0")) @[RAM.scala 16:24]
    node _memVal_T_1 = bits(_memVal_T, 8, 0) @[RAM.scala 16:24]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 14:24 16:{24,24}]
    node _GEN_2 = validif(UInt<1>("h1"), _memVal_T_1) @[RAM.scala 16:{24,24}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 16:{24,24}]
    node _io_DO_T = mux(io_rw, mem.memVal.data, io_DI) @[RAM.scala 18:15]
    node _T = eq(io_rw, UInt<1>("h0")) @[RAM.scala 20:8]
    node _T_1 = and(_T, io_WE) @[RAM.scala 20:15]
    node _GEN_4 = validif(_T_1, io_ad) @[RAM.scala 20:24]
    node _GEN_5 = validif(_T_1, clock) @[RAM.scala 20:24]
    node _GEN_6 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 14:24 20:24]
    node _GEN_7 = validif(_T_1, UInt<1>("h1")) @[RAM.scala 20:24]
    node _GEN_8 = validif(_T_1, io_DI) @[RAM.scala 20:24]
    io_DO <= _io_DO_T @[RAM.scala 18:9]
    mem.memVal.addr <= _GEN_2
    mem.memVal.en <= _GEN_1
    mem.memVal.clk <= _GEN_3
    mem.MPORT.addr <= _GEN_4
    mem.MPORT.en <= _GEN_6
    mem.MPORT.clk <= _GEN_5
    mem.MPORT.data <= _GEN_8
    mem.MPORT.mask <= _GEN_7

  module RAM_1 :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<10>
    input io_DI : UInt<32>
    input io_WE : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 14:24]
      data-type => UInt<32>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => memVal
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 16:{24,24}]
    node _memVal_WIRE = _GEN_0 @[RAM.scala 16:24]
    node _memVal_T = or(_memVal_WIRE, UInt<10>("h0")) @[RAM.scala 16:24]
    node _memVal_T_1 = bits(_memVal_T, 9, 0) @[RAM.scala 16:24]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 14:24 16:{24,24}]
    node _GEN_2 = validif(UInt<1>("h1"), _memVal_T_1) @[RAM.scala 16:{24,24}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 16:{24,24}]
    node _io_DO_T = mux(io_rw, mem.memVal.data, io_DI) @[RAM.scala 18:15]
    node _T = eq(io_rw, UInt<1>("h0")) @[RAM.scala 20:8]
    node _T_1 = and(_T, io_WE) @[RAM.scala 20:15]
    node _GEN_4 = validif(_T_1, io_ad) @[RAM.scala 20:24]
    node _GEN_5 = validif(_T_1, clock) @[RAM.scala 20:24]
    node _GEN_6 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 14:24 20:24]
    node _GEN_7 = validif(_T_1, UInt<1>("h1")) @[RAM.scala 20:24]
    node _GEN_8 = validif(_T_1, io_DI) @[RAM.scala 20:24]
    io_DO <= _io_DO_T @[RAM.scala 18:9]
    mem.memVal.addr <= _GEN_2
    mem.memVal.en <= _GEN_1
    mem.memVal.clk <= _GEN_3
    mem.MPORT.addr <= _GEN_4
    mem.MPORT.en <= _GEN_6
    mem.MPORT.clk <= _GEN_5
    mem.MPORT.data <= _GEN_8
    mem.MPORT.mask <= _GEN_7

  module RAM_2 :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<11>
    input io_DI : UInt<32>
    input io_WE : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 14:24]
      data-type => UInt<32>
      depth => 2048
      read-latency => 1
      write-latency => 1
      reader => memVal
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 16:{24,24}]
    node _memVal_WIRE = _GEN_0 @[RAM.scala 16:24]
    node _memVal_T = or(_memVal_WIRE, UInt<11>("h0")) @[RAM.scala 16:24]
    node _memVal_T_1 = bits(_memVal_T, 10, 0) @[RAM.scala 16:24]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 14:24 16:{24,24}]
    node _GEN_2 = validif(UInt<1>("h1"), _memVal_T_1) @[RAM.scala 16:{24,24}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 16:{24,24}]
    node _io_DO_T = mux(io_rw, mem.memVal.data, io_DI) @[RAM.scala 18:15]
    node _T = eq(io_rw, UInt<1>("h0")) @[RAM.scala 20:8]
    node _T_1 = and(_T, io_WE) @[RAM.scala 20:15]
    node _GEN_4 = validif(_T_1, io_ad) @[RAM.scala 20:24]
    node _GEN_5 = validif(_T_1, clock) @[RAM.scala 20:24]
    node _GEN_6 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 14:24 20:24]
    node _GEN_7 = validif(_T_1, UInt<1>("h1")) @[RAM.scala 20:24]
    node _GEN_8 = validif(_T_1, io_DI) @[RAM.scala 20:24]
    io_DO <= _io_DO_T @[RAM.scala 18:9]
    mem.memVal.addr <= _GEN_2
    mem.memVal.en <= _GEN_1
    mem.memVal.clk <= _GEN_3
    mem.MPORT.addr <= _GEN_4
    mem.MPORT.en <= _GEN_6
    mem.MPORT.clk <= _GEN_5
    mem.MPORT.data <= _GEN_8
    mem.MPORT.mask <= _GEN_7

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

    inst tagStore of RAM @[CacheController.scala 16:24]
    inst cache of RAM_1 @[CacheController.scala 17:21]
    inst extMem of RAM_2 @[CacheController.scala 18:22]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 15:25]
    node byteOffset = bits(io_memAdd, 1, 0) @[CacheController.scala 32:29]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 33:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 34:24]
    node targetTag = bits(io_memAdd, 31, 11) @[CacheController.scala 35:28]
    node actualTag = bits(tagStore.io_DO, 31, 11) @[CacheController.scala 37:26]
    node cacheValid = bits(tagStore.io_DO, 10, 10) @[CacheController.scala 38:27]
    node _cache_io_ad_T = cat(index, blockOffset) @[CacheController.scala 41:24]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 49:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 52:19]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 52:19]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 52:19]
    node _GEN_0 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 54:24 55:18 49:25]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 52:19]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 52:19]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 52:19]
    node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 67:12]
    node _T_7 = eq(targetTag, actualTag) @[CacheController.scala 69:28]
    node _GEN_1 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 24:15 70:20 72:23]
    node _GEN_2 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 70:20 74:20 15:25]
    node _GEN_3 = mux(io_rw, UInt<1>("h0"), UInt<2>("h3")) @[CacheController.scala 70:20 75:20 78:20]
    node _GEN_4 = mux(_T_7, _GEN_1, UInt<1>("h1")) @[CacheController.scala 24:15 69:42]
    node _GEN_5 = mux(_T_7, _GEN_2, lastRead) @[CacheController.scala 15:25 69:42]
    node _GEN_6 = mux(_T_7, _GEN_3, UInt<2>("h2")) @[CacheController.scala 69:42 82:18]
    node _GEN_7 = mux(_T_6, UInt<2>("h2"), _GEN_6) @[CacheController.scala 67:24 68:18]
    node _GEN_8 = mux(_T_6, UInt<1>("h1"), _GEN_4) @[CacheController.scala 24:15 67:24]
    node _GEN_9 = mux(_T_6, lastRead, _GEN_5) @[CacheController.scala 67:24 15:25]
    node _T_8 = asUInt(UInt<2>("h3")) @[CacheController.scala 52:19]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 52:19]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 52:19]
    node _GEN_10 = mux(io_memReady, UInt<1>("h0"), stateReg) @[CacheController.scala 87:24 89:18 49:25]
    node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 52:19]
    node _T_12 = asUInt(stateReg) @[CacheController.scala 52:19]
    node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 52:19]
    node _GEN_11 = mux(io_memReady, UInt<1>("h1"), stateReg) @[CacheController.scala 93:24 95:18 49:25]
    node _GEN_12 = mux(_T_13, _GEN_11, stateReg) @[CacheController.scala 52:19 49:25]
    node _GEN_13 = mux(_T_10, _GEN_10, _GEN_12) @[CacheController.scala 52:19]
    node _GEN_14 = mux(_T_5, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 21:18 52:19 59:22]
    node _GEN_15 = mux(_T_5, _GEN_7, _GEN_13) @[CacheController.scala 52:19]
    node _GEN_16 = mux(_T_5, _GEN_8, UInt<1>("h1")) @[CacheController.scala 24:15 52:19]
    node _GEN_17 = mux(_T_5, _GEN_9, lastRead) @[CacheController.scala 52:19 15:25]
    node _GEN_18 = mux(_T_2, _GEN_0, _GEN_15) @[CacheController.scala 52:19]
    node _GEN_19 = mux(_T_2, UInt<1>("h1"), _GEN_14) @[CacheController.scala 21:18 52:19]
    node _GEN_20 = mux(_T_2, UInt<1>("h1"), _GEN_16) @[CacheController.scala 24:15 52:19]
    node _GEN_21 = mux(_T_2, lastRead, _GEN_17) @[CacheController.scala 52:19 15:25]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 101:24]
    io_DO <= lastRead @[CacheController.scala 102:9]
    io_ready <= _io_ready_T @[CacheController.scala 101:12]
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_21) @[CacheController.scala 15:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_19
    tagStore.io_ad <= pad(index, 9) @[CacheController.scala 40:18]
    tagStore.io_DI <= UInt<32>("h0") @[CacheController.scala 23:18]
    tagStore.io_WE <= UInt<1>("h0") @[CacheController.scala 22:18]
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_20
    cache.io_ad <= _cache_io_ad_T @[CacheController.scala 41:15]
    cache.io_DI <= UInt<32>("h0") @[CacheController.scala 26:15]
    cache.io_WE <= UInt<1>("h0") @[CacheController.scala 25:15]
    extMem.clock <= clock
    extMem.reset <= reset
    extMem.io_rw <= UInt<1>("h1") @[CacheController.scala 27:16]
    extMem.io_ad <= bits(io_memAdd, 10, 0) @[CacheController.scala 29:16]
    extMem.io_DI <= UInt<32>("h0") @[CacheController.scala 30:16]
    extMem.io_WE <= UInt<1>("h0") @[CacheController.scala 28:16]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_18) @[CacheController.scala 49:{25,25}]
