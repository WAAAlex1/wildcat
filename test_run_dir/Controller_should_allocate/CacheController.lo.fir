FIRRTL version 1.1.0
circuit CacheController :
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

    inst tagStore of SRAM @[CacheController.scala 43:24]
    inst cache of SRAM_1 @[CacheController.scala 44:21]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 42:25]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 48:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 49:24]
    node targetTag = bits(io_memAdd, 31, 12) @[CacheController.scala 50:28]
    node actualTag = bits(tagStore.io_DO, 31, 12) @[CacheController.scala 52:33]
    node cacheValid = bits(tagStore.io_DO, 11, 11) @[CacheController.scala 53:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (UInt<1>("h0"), writeIndex) @[CacheController.scala 54:27]
    reg updatedTag : UInt<32>, clock with :
      reset => (UInt<1>("h0"), updatedTag) @[CacheController.scala 55:27]
    node memWordAdd = bits(io_memAdd, 31, 2) @[CacheController.scala 60:29]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 74:25]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 75:26]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 78:30]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 90:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 94:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 94:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 94:20]
    node _GEN_0 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 97:25 CacheFunctions.scala 10:13 20:13]
    node _GEN_1 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 97:25 CacheFunctions.scala 11:13 21:13]
    node _GEN_2 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 100:18 90:25 97:25]
    node cacheReadAdd = _cacheReadAdd_T @[CacheController.scala 57:30 74:16]
    node _GEN_3 = mux(io_validReq, cacheReadAdd, UInt<10>("h0")) @[CacheController.scala 103:18 97:25 59:26]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 94:20]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 94:20]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 94:20]
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
    node _GEN_4 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 123:21 126:20 42:25]
    node _GEN_5 = mux(io_rw, UInt<1>("h0"), UInt<2>("h3")) @[CacheController.scala 123:21 128:20 134:20]
    node _GEN_6 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 120:21 123:21 CacheFunctions.scala 15:13]
    node _GEN_7 = mux(io_rw, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 123:21 68:15 CacheFunctions.scala 16:13]
    node _GEN_8 = mux(io_rw, UInt<32>("h0"), _modifiedData_T) @[CacheController.scala 123:21 132:24 61:30]
    node _GEN_15 = mux(_T_7, _GEN_8, UInt<32>("h0")) @[CacheController.scala 118:43 61:30]
    node _GEN_24 = mux(_T_6, UInt<32>("h0"), _GEN_15) @[CacheController.scala 113:25 61:30]
    node _GEN_65 = mux(_T_5, _GEN_24, UInt<32>("h0")) @[CacheController.scala 94:20 61:30]
    node _GEN_79 = mux(_T_2, UInt<32>("h0"), _GEN_65) @[CacheController.scala 94:20 61:30]
    node modifiedData = _GEN_79 @[CacheController.scala 61:30]
    node _GEN_9 = mux(io_rw, io_CPUdataIn, modifiedData) @[CacheController.scala 123:21 70:15 133:23]
    node cacheWriteAdd = bits(_cacheWriteAdd_T, 9, 0) @[CacheController.scala 56:31 75:17]
    node _GEN_10 = mux(_T_7, cacheReadAdd, cacheWriteAdd) @[CacheController.scala 118:43 119:18 137:18]
    node _GEN_11 = mux(_T_7, _GEN_6, UInt<1>("h0")) @[CacheController.scala 118:43 69:15]
    node _GEN_12 = mux(_T_7, _GEN_4, lastRead) @[CacheController.scala 118:43 42:25]
    node _GEN_13 = mux(_T_7, _GEN_5, UInt<2>("h2")) @[CacheController.scala 118:43 139:18]
    node _GEN_14 = mux(_T_7, _GEN_7, UInt<1>("h1")) @[CacheController.scala 118:43 68:15]
    node _GEN_16 = mux(_T_7, _GEN_9, io_CPUdataIn) @[CacheController.scala 118:43 70:15]
    node _GEN_17 = mux(_T_7, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 118:43 71:16 138:22]
    node _GEN_18 = mux(_T_6, cacheWriteAdd, _GEN_10) @[CacheController.scala 113:25 114:18]
    node _GEN_19 = mux(_T_6, UInt<1>("h1"), _GEN_17) @[CacheController.scala 113:25 115:22]
    node _GEN_20 = mux(_T_6, UInt<2>("h2"), _GEN_13) @[CacheController.scala 113:25 117:18]
    node _GEN_21 = mux(_T_6, UInt<1>("h0"), _GEN_11) @[CacheController.scala 113:25 69:15]
    node _GEN_22 = mux(_T_6, lastRead, _GEN_12) @[CacheController.scala 113:25 42:25]
    node _GEN_23 = mux(_T_6, UInt<1>("h1"), _GEN_14) @[CacheController.scala 113:25 68:15]
    node _GEN_25 = mux(_T_6, io_CPUdataIn, _GEN_16) @[CacheController.scala 113:25 70:15]
    node _T_8 = asUInt(UInt<2>("h3")) @[CacheController.scala 94:20]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 94:20]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 94:20]
    node _GEN_26 = mux(io_memReady, UInt<1>("h0"), stateReg) @[CacheController.scala 147:25 148:18 90:25]
    node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 94:20]
    node _T_12 = asUInt(stateReg) @[CacheController.scala 94:20]
    node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 94:20]
    node targetTagWord = _targetTagWord_T @[CacheController.scala 51:31 78:17]
    node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 159:35]
    node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 164:25]
    node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 170:36]
    node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 170:36]
    node _GEN_27 = mux(_T_14, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 164:53 CacheFunctions.scala 15:13 CacheController.scala 67:18]
    node _GEN_28 = mux(_T_14, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 164:53 CacheFunctions.scala 16:13 CacheController.scala 66:18]
    node _GEN_29 = mux(_T_14, UInt<1>("h1"), stateReg) @[CacheController.scala 164:53 167:20 90:25]
    node _GEN_30 = mux(_T_14, UInt<1>("h0"), _writeIndex_T_1) @[CacheController.scala 164:53 168:22 170:22]
    node _GEN_31 = mux(io_memReady, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 161:25 CacheFunctions.scala 15:13 CacheController.scala 69:15]
    node _GEN_32 = mux(io_memReady, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 161:25 CacheFunctions.scala 16:13 CacheController.scala 68:15]
    node _GEN_33 = mux(io_memReady, _GEN_27, UInt<1>("h0")) @[CacheController.scala 161:25 67:18]
    node _GEN_34 = mux(io_memReady, _GEN_28, UInt<1>("h1")) @[CacheController.scala 161:25 66:18]
    node _GEN_35 = mux(io_memReady, _GEN_29, stateReg) @[CacheController.scala 161:25 90:25]
    node _GEN_36 = mux(io_memReady, _GEN_30, writeIndex) @[CacheController.scala 161:25 54:27]
    node _GEN_37 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 152:17 72:13 94:20]
    node _GEN_38 = mux(_T_13, cacheWriteAdd, UInt<10>("h0")) @[CacheController.scala 156:16 94:20 59:26]
    node _GEN_39 = mux(_T_13, io_memDataIn, io_CPUdataIn) @[CacheController.scala 157:19 70:15 94:20]
    node _GEN_40 = mux(_T_13, _updatedTag_T, updatedTag) @[CacheController.scala 159:18 94:20 55:27]
    node _GEN_41 = mux(_T_13, _GEN_31, UInt<1>("h0")) @[CacheController.scala 69:15 94:20]
    node _GEN_42 = mux(_T_13, _GEN_32, UInt<1>("h1")) @[CacheController.scala 68:15 94:20]
    node _GEN_43 = mux(_T_13, _GEN_33, UInt<1>("h0")) @[CacheController.scala 67:18 94:20]
    node _GEN_44 = mux(_T_13, _GEN_34, UInt<1>("h1")) @[CacheController.scala 66:18 94:20]
    node _GEN_45 = mux(_T_13, _GEN_35, stateReg) @[CacheController.scala 94:20 90:25]
    node _GEN_46 = mux(_T_13, _GEN_36, writeIndex) @[CacheController.scala 94:20 54:27]
    node _GEN_47 = mux(_T_10, UInt<2>("h2"), _GEN_37) @[CacheController.scala 144:17 94:20]
    node _GEN_48 = mux(_T_10, cacheReadAdd, _GEN_38) @[CacheController.scala 145:16 94:20]
    node _GEN_49 = mux(_T_10, _GEN_26, _GEN_45) @[CacheController.scala 94:20]
    node _GEN_50 = mux(_T_10, UInt<1>("h0"), _GEN_37) @[CacheController.scala 71:16 94:20]
    node _GEN_51 = mux(_T_10, io_CPUdataIn, _GEN_39) @[CacheController.scala 70:15 94:20]
    node _GEN_52 = mux(_T_10, updatedTag, _GEN_40) @[CacheController.scala 94:20 55:27]
    node _GEN_53 = mux(_T_10, UInt<1>("h0"), _GEN_41) @[CacheController.scala 69:15 94:20]
    node _GEN_54 = mux(_T_10, UInt<1>("h1"), _GEN_42) @[CacheController.scala 68:15 94:20]
    node _GEN_55 = mux(_T_10, UInt<1>("h0"), _GEN_43) @[CacheController.scala 67:18 94:20]
    node _GEN_56 = mux(_T_10, UInt<1>("h1"), _GEN_44) @[CacheController.scala 66:18 94:20]
    node _GEN_57 = mux(_T_10, writeIndex, _GEN_46) @[CacheController.scala 94:20 54:27]
    node _GEN_58 = mux(_T_5, UInt<1>("h1"), _GEN_55) @[CacheController.scala 94:20 112:22]
    node _GEN_59 = mux(_T_5, _GEN_18, _GEN_48) @[CacheController.scala 94:20]
    node _GEN_60 = mux(_T_5, _GEN_19, _GEN_50) @[CacheController.scala 94:20]
    node _GEN_61 = mux(_T_5, _GEN_20, _GEN_49) @[CacheController.scala 94:20]
    node _GEN_62 = mux(_T_5, _GEN_21, _GEN_53) @[CacheController.scala 94:20]
    node _GEN_63 = mux(_T_5, _GEN_22, lastRead) @[CacheController.scala 94:20 42:25]
    node _GEN_64 = mux(_T_5, _GEN_23, _GEN_54) @[CacheController.scala 94:20]
    node _GEN_66 = mux(_T_5, _GEN_25, _GEN_51) @[CacheController.scala 94:20]
    node _GEN_67 = mux(_T_5, UInt<1>("h0"), _GEN_47) @[CacheController.scala 72:13 94:20]
    node _GEN_68 = mux(_T_5, updatedTag, _GEN_52) @[CacheController.scala 94:20 55:27]
    node _GEN_69 = mux(_T_5, UInt<1>("h1"), _GEN_56) @[CacheController.scala 66:18 94:20]
    node _GEN_70 = mux(_T_5, writeIndex, _GEN_57) @[CacheController.scala 94:20 54:27]
    node _GEN_71 = mux(_T_2, _GEN_0, _GEN_58) @[CacheController.scala 94:20]
    node _GEN_72 = mux(_T_2, _GEN_1, _GEN_69) @[CacheController.scala 94:20]
    node _GEN_73 = mux(_T_2, _GEN_2, _GEN_61) @[CacheController.scala 94:20]
    node _GEN_74 = mux(_T_2, _GEN_3, _GEN_59) @[CacheController.scala 94:20]
    node _GEN_75 = mux(_T_2, _GEN_0, _GEN_62) @[CacheController.scala 94:20]
    node _GEN_76 = mux(_T_2, _GEN_1, _GEN_64) @[CacheController.scala 94:20]
    node _GEN_77 = mux(_T_2, UInt<1>("h0"), _GEN_60) @[CacheController.scala 71:16 94:20]
    node _GEN_78 = mux(_T_2, lastRead, _GEN_63) @[CacheController.scala 94:20 42:25]
    node _GEN_80 = mux(_T_2, io_CPUdataIn, _GEN_66) @[CacheController.scala 70:15 94:20]
    node _GEN_81 = mux(_T_2, UInt<1>("h0"), _GEN_67) @[CacheController.scala 72:13 94:20]
    node _GEN_82 = mux(_T_2, updatedTag, _GEN_68) @[CacheController.scala 94:20 55:27]
    node _GEN_83 = mux(_T_2, writeIndex, _GEN_70) @[CacheController.scala 94:20 54:27]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 179:24]
    node _io_cacheInvalid_T = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 180:22]
    node _io_alloAddr_T = cat(memWordAdd, UInt<2>("h0")) @[CacheController.scala 183:30]
    node _io_alloAddr_T_1 = mul(writeIndex, UInt<3>("h4")) @[CacheController.scala 183:55]
    node _io_alloAddr_T_2 = add(_io_alloAddr_T, _io_alloAddr_T_1) @[CacheController.scala 183:43]
    node _io_alloAddr_T_3 = tail(_io_alloAddr_T_2, 1) @[CacheController.scala 183:43]
    node cacheAdd = _GEN_74 @[CacheController.scala 59:26]
    io_CPUdataOut <= lastRead @[CacheController.scala 182:17]
    io_cacheMiss <= _GEN_77
    io_cacheInvalid <= _io_cacheInvalid_T @[CacheController.scala 180:19]
    io_ready <= _io_ready_T @[CacheController.scala 179:12]
    io_alloAddr <= _io_alloAddr_T_3 @[CacheController.scala 183:15]
    io_memReq <= _GEN_81
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_78) @[CacheController.scala 42:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_72
    tagStore.io_ad <= index @[CacheController.scala 81:18]
    tagStore.io_DI <= updatedTag @[CacheController.scala 181:18]
    tagStore.io_EN <= _GEN_71
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_76
    cache.io_ad <= cacheAdd @[CacheController.scala 77:15]
    cache.io_DI <= _GEN_80
    cache.io_EN <= _GEN_75
    writeIndex <= mux(reset, UInt<3>("h0"), _GEN_83) @[CacheController.scala 54:{27,27}]
    updatedTag <= mux(reset, UInt<32>("h0"), _GEN_82) @[CacheController.scala 55:{27,27}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_73) @[CacheController.scala 90:{25,25}]
