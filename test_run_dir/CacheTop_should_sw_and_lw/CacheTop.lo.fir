FIRRTL version 1.1.0
circuit CacheTop :
  module SRAM :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<9>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[SRAM.scala 26:24]
      data-type => UInt<32>
      depth => 512
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => new
    node _T = and(io_rw, io_EN) @[SRAM.scala 31:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[SRAM.scala 32:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[SRAM.scala 32:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<9>("h0")) @[SRAM.scala 32:22]
    node _io_DO_T_1 = bits(_io_DO_T, 8, 0) @[SRAM.scala 32:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 32:{22,22} 26:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[SRAM.scala 32:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[SRAM.scala 32:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[SRAM.scala 33:14]
    node _T_2 = and(_T_1, io_EN) @[SRAM.scala 33:21]
    node _GEN_4 = validif(_T_2, io_ad) @[SRAM.scala 33:30]
    node _GEN_5 = validif(_T_2, clock) @[SRAM.scala 33:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 26:24 33:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[SRAM.scala 33:30]
    node _GEN_8 = validif(_T_2, io_DI) @[SRAM.scala 33:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[SRAM.scala 33:30 35:11 37:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[SRAM.scala 31:23 26:24]
    node _GEN_11 = validif(_T, _GEN_2) @[SRAM.scala 31:23]
    node _GEN_12 = validif(_T, _GEN_3) @[SRAM.scala 31:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[SRAM.scala 31:23 32:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[SRAM.scala 31:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[SRAM.scala 31:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[SRAM.scala 31:23 26:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[SRAM.scala 31:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[SRAM.scala 31:23]
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
    node _T = and(io_rw, io_EN) @[SRAM.scala 31:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[SRAM.scala 32:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[SRAM.scala 32:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<10>("h0")) @[SRAM.scala 32:22]
    node _io_DO_T_1 = bits(_io_DO_T, 9, 0) @[SRAM.scala 32:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 32:{22,22} 26:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[SRAM.scala 32:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[SRAM.scala 32:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[SRAM.scala 33:14]
    node _T_2 = and(_T_1, io_EN) @[SRAM.scala 33:21]
    node _GEN_4 = validif(_T_2, io_ad) @[SRAM.scala 33:30]
    node _GEN_5 = validif(_T_2, clock) @[SRAM.scala 33:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 26:24 33:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[SRAM.scala 33:30]
    node _GEN_8 = validif(_T_2, io_DI) @[SRAM.scala 33:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[SRAM.scala 33:30 35:11 37:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[SRAM.scala 31:23 26:24]
    node _GEN_11 = validif(_T, _GEN_2) @[SRAM.scala 31:23]
    node _GEN_12 = validif(_T, _GEN_3) @[SRAM.scala 31:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[SRAM.scala 31:23 32:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[SRAM.scala 31:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[SRAM.scala 31:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[SRAM.scala 31:23 26:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[SRAM.scala 31:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[SRAM.scala 31:23]
    io_DO <= _GEN_13
    mem.io_DO_MPORT.addr <= _GEN_11
    mem.io_DO_MPORT.en <= _GEN_10
    mem.io_DO_MPORT.clk <= _GEN_12
    mem.MPORT.addr <= _GEN_14
    mem.MPORT.en <= _GEN_16
    mem.MPORT.clk <= _GEN_15
    mem.MPORT.data <= _GEN_18
    mem.MPORT.mask <= _GEN_17

  module SRAM_2 :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<12>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[SRAM.scala 26:24]
      data-type => UInt<32>
      depth => 4096
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => new
    node _T = and(io_rw, io_EN) @[SRAM.scala 31:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[SRAM.scala 32:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[SRAM.scala 32:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<12>("h0")) @[SRAM.scala 32:22]
    node _io_DO_T_1 = bits(_io_DO_T, 11, 0) @[SRAM.scala 32:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 32:{22,22} 26:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[SRAM.scala 32:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[SRAM.scala 32:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[SRAM.scala 33:14]
    node _T_2 = and(_T_1, io_EN) @[SRAM.scala 33:21]
    node _GEN_4 = validif(_T_2, io_ad) @[SRAM.scala 33:30]
    node _GEN_5 = validif(_T_2, clock) @[SRAM.scala 33:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[SRAM.scala 26:24 33:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[SRAM.scala 33:30]
    node _GEN_8 = validif(_T_2, io_DI) @[SRAM.scala 33:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[SRAM.scala 33:30 35:11 37:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[SRAM.scala 31:23 26:24]
    node _GEN_11 = validif(_T, _GEN_2) @[SRAM.scala 31:23]
    node _GEN_12 = validif(_T, _GEN_3) @[SRAM.scala 31:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[SRAM.scala 31:23 32:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[SRAM.scala 31:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[SRAM.scala 31:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[SRAM.scala 31:23 26:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[SRAM.scala 31:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[SRAM.scala 31:23]
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
    input io_wrEnable_0 : UInt<1>
    input io_wrEnable_1 : UInt<1>
    input io_wrEnable_2 : UInt<1>
    input io_wrEnable_3 : UInt<1>
    output io_modData : UInt<32>

    inst tagStore of SRAM @[CacheController.scala 38:24]
    inst cache of SRAM_1 @[CacheController.scala 39:21]
    inst extMem of SRAM_2 @[CacheController.scala 40:22]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 37:25]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 45:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 46:24]
    node targetTag = bits(io_memAdd, 31, 12) @[CacheController.scala 47:28]
    node actualTag = bits(tagStore.io_DO, 31, 12) @[CacheController.scala 49:33]
    node cacheValid = bits(tagStore.io_DO, 11, 11) @[CacheController.scala 50:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (UInt<1>("h0"), writeIndex) @[CacheController.scala 51:27]
    reg updatedTag : UInt<32>, clock with :
      reset => (UInt<1>("h0"), updatedTag) @[CacheController.scala 52:27]
    node memWordAdd = bits(io_memAdd, 31, 2) @[CacheController.scala 57:29]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 75:25]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 76:26]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 79:30]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 91:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 95:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 95:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 95:20]
    node cacheReadAdd = _cacheReadAdd_T @[CacheController.scala 54:30 75:16]
    node _GEN_0 = mux(io_validReq, cacheReadAdd, UInt<10>("h0")) @[CacheController.scala 101:18 99:25 56:26]
    node _GEN_1 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 99:25 CacheFunctions.scala 10:13 20:13]
    node _GEN_2 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 99:25 CacheFunctions.scala 11:13 21:13]
    node _GEN_3 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 103:18 91:25 99:25]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 95:20]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 95:20]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 95:20]
    node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 124:12]
    node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 129:28]
    node _modifiedData_readBytes_0_T = bits(cache.io_DO, 7, 0) @[CacheFunctions.scala 31:31]
    node _modifiedData_writeBytes_0_T = bits(io_DI, 7, 0) @[CacheFunctions.scala 32:33]
    node _modifiedData_readBytes_1_T = bits(cache.io_DO, 15, 8) @[CacheFunctions.scala 31:31]
    node _modifiedData_writeBytes_1_T = bits(io_DI, 15, 8) @[CacheFunctions.scala 32:33]
    node _modifiedData_readBytes_2_T = bits(cache.io_DO, 23, 16) @[CacheFunctions.scala 31:31]
    node _modifiedData_writeBytes_2_T = bits(io_DI, 23, 16) @[CacheFunctions.scala 32:33]
    node _modifiedData_readBytes_3_T = bits(cache.io_DO, 31, 24) @[CacheFunctions.scala 31:31]
    node _modifiedData_writeBytes_3_T = bits(io_DI, 31, 24) @[CacheFunctions.scala 32:33]
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
    node _GEN_4 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 135:21 137:20 37:25]
    node _GEN_5 = mux(io_rw, UInt<1>("h0"), UInt<2>("h3")) @[CacheController.scala 135:21 139:20 145:20]
    node _GEN_6 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 131:21 135:21 CacheFunctions.scala 15:13]
    node _GEN_7 = mux(io_rw, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 135:21 65:15 CacheFunctions.scala 16:13]
    node _GEN_8 = mux(io_rw, UInt<32>("h0"), _modifiedData_T) @[CacheController.scala 135:21 143:24 58:30]
    node _GEN_15 = mux(_T_7, _GEN_8, UInt<32>("h0")) @[CacheController.scala 129:43 58:30]
    node _GEN_26 = mux(_T_6, UInt<32>("h0"), _GEN_15) @[CacheController.scala 124:25 58:30]
    node _GEN_66 = mux(_T_5, _GEN_26, UInt<32>("h0")) @[CacheController.scala 95:20 58:30]
    node _GEN_83 = mux(_T_2, UInt<32>("h0"), _GEN_66) @[CacheController.scala 95:20 58:30]
    node modifiedData = _GEN_83 @[CacheController.scala 58:30]
    node _GEN_9 = mux(io_rw, io_DI, modifiedData) @[CacheController.scala 135:21 67:15 144:23]
    node cacheWriteAdd = bits(_cacheWriteAdd_T, 9, 0) @[CacheController.scala 53:31 76:17]
    node _GEN_10 = mux(_T_7, cacheReadAdd, cacheWriteAdd) @[CacheController.scala 129:43 130:18 148:18]
    node _GEN_11 = mux(_T_7, _GEN_6, UInt<1>("h0")) @[CacheController.scala 129:43 66:15]
    node _GEN_12 = mux(_T_7, _GEN_4, lastRead) @[CacheController.scala 129:43 37:25]
    node _GEN_13 = mux(_T_7, _GEN_5, UInt<2>("h2")) @[CacheController.scala 129:43 151:18]
    node _GEN_14 = mux(_T_7, _GEN_7, UInt<1>("h1")) @[CacheController.scala 129:43 65:15]
    node _GEN_16 = mux(_T_7, _GEN_9, io_DI) @[CacheController.scala 129:43 67:15]
    node _GEN_17 = mux(_T_7, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 129:43 71:16 149:22]
    node _GEN_18 = mux(_T_7, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 129:43 68:15 CacheFunctions.scala 11:13]
    node _GEN_19 = mux(_T_6, cacheWriteAdd, _GEN_10) @[CacheController.scala 124:25 125:18]
    node _GEN_20 = mux(_T_6, UInt<1>("h1"), _GEN_17) @[CacheController.scala 124:25 126:22]
    node _GEN_21 = mux(_T_6, UInt<1>("h1"), _GEN_18) @[CacheController.scala 124:25 CacheFunctions.scala 11:13]
    node _GEN_22 = mux(_T_6, UInt<2>("h2"), _GEN_13) @[CacheController.scala 124:25 128:18]
    node _GEN_23 = mux(_T_6, UInt<1>("h0"), _GEN_11) @[CacheController.scala 124:25 66:15]
    node _GEN_24 = mux(_T_6, lastRead, _GEN_12) @[CacheController.scala 124:25 37:25]
    node _GEN_25 = mux(_T_6, UInt<1>("h1"), _GEN_14) @[CacheController.scala 124:25 65:15]
    node _GEN_27 = mux(_T_6, io_DI, _GEN_16) @[CacheController.scala 124:25 67:15]
    node _T_8 = asUInt(UInt<2>("h3")) @[CacheController.scala 95:20]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 95:20]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 95:20]
    node _GEN_28 = mux(io_memReady, UInt<1>("h0"), stateReg) @[CacheController.scala 163:25 164:18 91:25]
    node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 95:20]
    node _T_12 = asUInt(stateReg) @[CacheController.scala 95:20]
    node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 95:20]
    node _extMem_io_ad_T = add(memWordAdd, writeIndex) @[CacheController.scala 173:34]
    node _extMem_io_ad_T_1 = tail(_extMem_io_ad_T, 1) @[CacheController.scala 173:34]
    node _extMem_io_ad_T_2 = add(_extMem_io_ad_T_1, UInt<1>("h1")) @[CacheController.scala 173:47]
    node _extMem_io_ad_T_3 = tail(_extMem_io_ad_T_2, 1) @[CacheController.scala 173:47]
    node targetTagWord = _targetTagWord_T @[CacheController.scala 48:31 79:17]
    node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 176:35]
    node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 178:38]
    node _T_15 = and(io_memReady, _T_14) @[CacheController.scala 178:24]
    node _T_16 = eq(io_memReady, UInt<1>("h0")) @[CacheController.scala 183:18]
    node _T_17 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 183:45]
    node _T_18 = and(_T_16, _T_17) @[CacheController.scala 183:31]
    node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 186:34]
    node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 186:34]
    node _GEN_29 = mux(_T_18, UInt<2>("h3"), _writeIndex_T_1) @[CacheController.scala 183:73 184:20 186:20]
    node _GEN_30 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 178:66 CacheFunctions.scala 15:13 CacheController.scala 64:18]
    node _GEN_31 = mux(_T_15, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 178:66 CacheFunctions.scala 16:13 CacheController.scala 63:18]
    node _GEN_32 = mux(_T_15, UInt<1>("h1"), stateReg) @[CacheController.scala 178:66 181:18 91:25]
    node _GEN_33 = mux(_T_15, UInt<1>("h0"), _GEN_29) @[CacheController.scala 178:66 182:20]
    node _GEN_34 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 168:20 71:16 95:20]
    node _GEN_35 = mux(_T_13, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 95:20 CacheFunctions.scala 16:13 CacheController.scala 65:15]
    node _GEN_36 = mux(_T_13, cacheWriteAdd, UInt<10>("h0")) @[CacheController.scala 171:16 95:20 56:26]
    node _GEN_37 = mux(_T_13, _extMem_io_ad_T_3, memWordAdd) @[CacheController.scala 173:20 70:16 95:20]
    node _GEN_38 = mux(_T_13, extMem.io_DO, io_DI) @[CacheController.scala 174:19 67:15 95:20]
    node _GEN_39 = mux(_T_13, _updatedTag_T, updatedTag) @[CacheController.scala 176:18 95:20 52:27]
    node _GEN_40 = mux(_T_13, _GEN_30, UInt<1>("h0")) @[CacheController.scala 64:18 95:20]
    node _GEN_41 = mux(_T_13, _GEN_31, UInt<1>("h1")) @[CacheController.scala 63:18 95:20]
    node _GEN_42 = mux(_T_13, _GEN_32, stateReg) @[CacheController.scala 95:20 91:25]
    node _GEN_43 = mux(_T_13, _GEN_33, writeIndex) @[CacheController.scala 95:20 51:27]
    node _GEN_44 = mux(_T_10, cacheReadAdd, _GEN_36) @[CacheController.scala 158:16 95:20]
    node _GEN_45 = mux(_T_10, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 159:20 68:15 95:20]
    node _GEN_46 = mux(_T_10, UInt<1>("h1"), _GEN_34) @[CacheController.scala 160:20 95:20]
    node _GEN_47 = mux(_T_10, io_DI, UInt<32>("h0")) @[CacheController.scala 161:17 95:20 55:27]
    node _GEN_48 = mux(_T_10, _GEN_28, _GEN_42) @[CacheController.scala 95:20]
    node _GEN_49 = mux(_T_10, UInt<1>("h0"), _GEN_34) @[CacheController.scala 71:16 95:20]
    node _GEN_50 = mux(_T_10, UInt<1>("h1"), _GEN_35) @[CacheController.scala 65:15 95:20]
    node _GEN_51 = mux(_T_10, memWordAdd, _GEN_37) @[CacheController.scala 70:16 95:20]
    node _GEN_52 = mux(_T_10, io_DI, _GEN_38) @[CacheController.scala 67:15 95:20]
    node _GEN_53 = mux(_T_10, updatedTag, _GEN_39) @[CacheController.scala 95:20 52:27]
    node _GEN_54 = mux(_T_10, UInt<1>("h0"), _GEN_40) @[CacheController.scala 64:18 95:20]
    node _GEN_55 = mux(_T_10, UInt<1>("h1"), _GEN_41) @[CacheController.scala 63:18 95:20]
    node _GEN_56 = mux(_T_10, writeIndex, _GEN_43) @[CacheController.scala 95:20 51:27]
    node _GEN_57 = mux(_T_5, UInt<1>("h1"), _GEN_54) @[CacheController.scala 95:20 123:22]
    node _GEN_58 = mux(_T_5, _GEN_19, _GEN_44) @[CacheController.scala 95:20]
    node _GEN_59 = mux(_T_5, _GEN_20, _GEN_49) @[CacheController.scala 95:20]
    node _GEN_60 = mux(_T_5, _GEN_20, _GEN_46) @[CacheController.scala 95:20]
    node _GEN_61 = mux(_T_5, _GEN_21, _GEN_45) @[CacheController.scala 95:20]
    node _GEN_62 = mux(_T_5, _GEN_22, _GEN_48) @[CacheController.scala 95:20]
    node _GEN_63 = mux(_T_5, _GEN_23, _GEN_49) @[CacheController.scala 95:20]
    node _GEN_64 = mux(_T_5, _GEN_24, lastRead) @[CacheController.scala 95:20 37:25]
    node _GEN_65 = mux(_T_5, _GEN_25, _GEN_50) @[CacheController.scala 95:20]
    node _GEN_67 = mux(_T_5, _GEN_27, _GEN_52) @[CacheController.scala 95:20]
    node _GEN_68 = mux(_T_5, UInt<32>("h0"), _GEN_47) @[CacheController.scala 95:20 55:27]
    node _GEN_69 = mux(_T_5, memWordAdd, _GEN_51) @[CacheController.scala 70:16 95:20]
    node _GEN_70 = mux(_T_5, updatedTag, _GEN_53) @[CacheController.scala 95:20 52:27]
    node _GEN_71 = mux(_T_5, UInt<1>("h1"), _GEN_55) @[CacheController.scala 63:18 95:20]
    node _GEN_72 = mux(_T_5, writeIndex, _GEN_56) @[CacheController.scala 95:20 51:27]
    node _GEN_73 = mux(_T_2, UInt<1>("h0"), _GEN_60) @[CacheController.scala 95:20 CacheFunctions.scala 20:13]
    node _GEN_74 = mux(_T_2, UInt<1>("h1"), _GEN_61) @[CacheController.scala 95:20 CacheFunctions.scala 21:13]
    node _GEN_75 = mux(_T_2, _GEN_0, _GEN_58) @[CacheController.scala 95:20]
    node _GEN_76 = mux(_T_2, _GEN_1, _GEN_57) @[CacheController.scala 95:20]
    node _GEN_77 = mux(_T_2, _GEN_2, _GEN_71) @[CacheController.scala 95:20]
    node _GEN_78 = mux(_T_2, _GEN_3, _GEN_62) @[CacheController.scala 95:20]
    node _GEN_79 = mux(_T_2, _GEN_1, _GEN_63) @[CacheController.scala 95:20]
    node _GEN_80 = mux(_T_2, _GEN_2, _GEN_65) @[CacheController.scala 95:20]
    node _GEN_81 = mux(_T_2, UInt<1>("h0"), _GEN_59) @[CacheController.scala 71:16 95:20]
    node _GEN_82 = mux(_T_2, lastRead, _GEN_64) @[CacheController.scala 95:20 37:25]
    node _GEN_84 = mux(_T_2, io_DI, _GEN_67) @[CacheController.scala 67:15 95:20]
    node _GEN_85 = mux(_T_2, UInt<32>("h0"), _GEN_68) @[CacheController.scala 95:20 55:27]
    node _GEN_86 = mux(_T_2, memWordAdd, _GEN_69) @[CacheController.scala 70:16 95:20]
    node _GEN_87 = mux(_T_2, updatedTag, _GEN_70) @[CacheController.scala 95:20 52:27]
    node _GEN_88 = mux(_T_2, writeIndex, _GEN_72) @[CacheController.scala 95:20 51:27]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 194:24]
    node _io_cacheInvalid_T = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 195:22]
    node memDataIn = _GEN_85 @[CacheController.scala 55:27]
    node cacheAdd = _GEN_75 @[CacheController.scala 56:26]
    io_DO <= lastRead @[CacheController.scala 197:9]
    io_ready <= _io_ready_T @[CacheController.scala 194:12]
    io_cacheMiss <= _GEN_81
    io_cacheInvalid <= _io_cacheInvalid_T @[CacheController.scala 195:19]
    io_modData <= modifiedData @[CacheController.scala 60:14]
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_82) @[CacheController.scala 37:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_77
    tagStore.io_ad <= pad(index, 9) @[CacheController.scala 82:18]
    tagStore.io_DI <= updatedTag @[CacheController.scala 196:18]
    tagStore.io_EN <= _GEN_76
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_80
    cache.io_ad <= cacheAdd @[CacheController.scala 78:15]
    cache.io_DI <= _GEN_84
    cache.io_EN <= _GEN_79
    extMem.clock <= clock
    extMem.reset <= reset
    extMem.io_rw <= _GEN_74
    extMem.io_ad <= bits(_GEN_86, 11, 0)
    extMem.io_DI <= memDataIn @[CacheController.scala 74:16]
    extMem.io_EN <= _GEN_73
    writeIndex <= mux(reset, UInt<3>("h0"), _GEN_88) @[CacheController.scala 51:{27,27}]
    updatedTag <= mux(reset, UInt<32>("h0"), _GEN_87) @[CacheController.scala 52:{27,27}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_78) @[CacheController.scala 91:{25,25}]

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
    node _GEN_0 = mux(Controller.io_cacheMiss, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 31:12 34:32 35:14]
    node weBits_lo = cat(io_wrEnable_1, io_wrEnable_0) @[CacheTop.scala 39:28]
    node weBits_hi = cat(io_wrEnable_3, io_wrEnable_2) @[CacheTop.scala 39:28]
    node weBits = cat(weBits_hi, weBits_lo) @[CacheTop.scala 39:28]
    node _GEN_1 = mux(io_rdEnable, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 42:20 25:26 43:28]
    node _GEN_2 = mux(io_rdEnable, UInt<1>("h1"), UInt<1>("h1")) @[CacheTop.scala 26:20 42:20 44:22]
    node _GEN_3 = mux(io_rdEnable, io_rdAddress, io_rdAddress) @[CacheTop.scala 42:20 27:24 45:26]
    node _T = gt(weBits, UInt<1>("h0")) @[CacheTop.scala 48:15]
    node _GEN_4 = mux(_T, UInt<1>("h1"), _GEN_1) @[CacheTop.scala 48:21 49:28]
    node _GEN_5 = mux(_T, UInt<1>("h0"), _GEN_2) @[CacheTop.scala 48:21 50:22]
    node _GEN_6 = mux(_T, io_wrAddress, _GEN_3) @[CacheTop.scala 48:21 51:26]
    io_rdData <= Controller.io_DO @[CacheTop.scala 30:13]
    io_stall <= _GEN_0
    Controller.clock <= clock
    Controller.reset <= reset
    Controller.io_validReq <= _GEN_4
    Controller.io_rw <= _GEN_5
    Controller.io_memAdd <= _GEN_6
    Controller.io_DI <= io_wrData @[CacheTop.scala 29:20]
    Controller.io_memReady <= UInt<1>("h1") @[CacheTop.scala 23:26]
    Controller.io_wrEnable_0 <= io_wrEnable_0 @[CacheTop.scala 28:26]
    Controller.io_wrEnable_1 <= io_wrEnable_1 @[CacheTop.scala 28:26]
    Controller.io_wrEnable_2 <= io_wrEnable_2 @[CacheTop.scala 28:26]
    Controller.io_wrEnable_3 <= io_wrEnable_3 @[CacheTop.scala 28:26]
