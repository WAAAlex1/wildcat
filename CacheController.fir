circuit CacheController :
  module RAM :
    input clock : Clock
    input reset : Reset
    output io : { flip rw : UInt<1>, flip ad : UInt<9>, flip DI : UInt<32>, flip EN : UInt<1>, DO : UInt<32>}

    smem mem : UInt<32> [512] @[RAM.scala 24:24]
    node _T = and(io.rw, io.EN) @[RAM.scala 26:14]
    when _T : @[RAM.scala 26:23]
      wire _io_DO_WIRE : UInt @[RAM.scala 27:22]
      _io_DO_WIRE is invalid @[RAM.scala 27:22]
      when UInt<1>("h1") : @[RAM.scala 27:22]
        _io_DO_WIRE <= io.ad @[RAM.scala 27:22]
        node _io_DO_T = or(_io_DO_WIRE, UInt<9>("h0")) @[RAM.scala 27:22]
        node _io_DO_T_1 = bits(_io_DO_T, 8, 0) @[RAM.scala 27:22]
        read mport io_DO_MPORT = mem[_io_DO_T_1], clock @[RAM.scala 27:22]
      io.DO <= io_DO_MPORT @[RAM.scala 27:11]
    else :
      node _T_1 = eq(io.rw, UInt<1>("h0")) @[RAM.scala 28:14]
      node _T_2 = and(_T_1, io.EN) @[RAM.scala 28:21]
      when _T_2 : @[RAM.scala 28:30]
        write mport MPORT = mem[io.ad], clock
        MPORT <= io.DI
        io.DO <= UInt<1>("h0") @[RAM.scala 30:11]
      else :
        io.DO <= UInt<1>("h0") @[RAM.scala 32:11]


  module RAM_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip rw : UInt<1>, flip ad : UInt<10>, flip DI : UInt<32>, flip EN : UInt<1>, DO : UInt<32>}

    smem mem : UInt<32> [1024] @[RAM.scala 24:24]
    node _T = and(io.rw, io.EN) @[RAM.scala 26:14]
    when _T : @[RAM.scala 26:23]
      wire _io_DO_WIRE : UInt @[RAM.scala 27:22]
      _io_DO_WIRE is invalid @[RAM.scala 27:22]
      when UInt<1>("h1") : @[RAM.scala 27:22]
        _io_DO_WIRE <= io.ad @[RAM.scala 27:22]
        node _io_DO_T = or(_io_DO_WIRE, UInt<10>("h0")) @[RAM.scala 27:22]
        node _io_DO_T_1 = bits(_io_DO_T, 9, 0) @[RAM.scala 27:22]
        read mport io_DO_MPORT = mem[_io_DO_T_1], clock @[RAM.scala 27:22]
      io.DO <= io_DO_MPORT @[RAM.scala 27:11]
    else :
      node _T_1 = eq(io.rw, UInt<1>("h0")) @[RAM.scala 28:14]
      node _T_2 = and(_T_1, io.EN) @[RAM.scala 28:21]
      when _T_2 : @[RAM.scala 28:30]
        write mport MPORT = mem[io.ad], clock
        MPORT <= io.DI
        io.DO <= UInt<1>("h0") @[RAM.scala 30:11]
      else :
        io.DO <= UInt<1>("h0") @[RAM.scala 32:11]


  module RAM_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip rw : UInt<1>, flip ad : UInt<12>, flip DI : UInt<32>, flip EN : UInt<1>, DO : UInt<32>}

    smem mem : UInt<32> [4096] @[RAM.scala 24:24]
    node _T = and(io.rw, io.EN) @[RAM.scala 26:14]
    when _T : @[RAM.scala 26:23]
      wire _io_DO_WIRE : UInt @[RAM.scala 27:22]
      _io_DO_WIRE is invalid @[RAM.scala 27:22]
      when UInt<1>("h1") : @[RAM.scala 27:22]
        _io_DO_WIRE <= io.ad @[RAM.scala 27:22]
        node _io_DO_T = or(_io_DO_WIRE, UInt<12>("h0")) @[RAM.scala 27:22]
        node _io_DO_T_1 = bits(_io_DO_T, 11, 0) @[RAM.scala 27:22]
        read mport io_DO_MPORT = mem[_io_DO_T_1], clock @[RAM.scala 27:22]
      io.DO <= io_DO_MPORT @[RAM.scala 27:11]
    else :
      node _T_1 = eq(io.rw, UInt<1>("h0")) @[RAM.scala 28:14]
      node _T_2 = and(_T_1, io.EN) @[RAM.scala 28:21]
      when _T_2 : @[RAM.scala 28:30]
        write mport MPORT = mem[io.ad], clock
        MPORT <= io.DI
        io.DO <= UInt<1>("h0") @[RAM.scala 30:11]
      else :
        io.DO <= UInt<1>("h0") @[RAM.scala 32:11]


  module CacheController :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip validReq : UInt<1>, flip rw : UInt<1>, flip memAdd : UInt<32>, flip DI : UInt<32>, DO : UInt<32>, ready : UInt<1>, flip memReady : UInt<1>, cacheMiss : UInt<1>, cacheValid : UInt<1>}

    reg lastRead : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[CacheController.scala 33:25]
    inst tagStore of RAM @[CacheController.scala 34:24]
    tagStore.clock <= clock
    tagStore.reset <= reset
    inst cache of RAM_1 @[CacheController.scala 35:21]
    cache.clock <= clock
    cache.reset <= reset
    inst extMem of RAM_2 @[CacheController.scala 36:22]
    extMem.clock <= clock
    extMem.reset <= reset
    node byteOffset = bits(io.memAdd, 1, 0) @[CacheController.scala 41:29]
    node blockOffset = bits(io.memAdd, 3, 2) @[CacheController.scala 42:30]
    node index = bits(io.memAdd, 11, 4) @[CacheController.scala 43:24]
    node targetTag = bits(io.memAdd, 31, 12) @[CacheController.scala 44:28]
    wire targetTagWord : UInt<32> @[CacheController.scala 45:31]
    targetTagWord <= UInt<32>("h0") @[CacheController.scala 45:31]
    node actualTag = bits(tagStore.io.DO, 31, 12) @[CacheController.scala 46:33]
    node cacheValid = bits(tagStore.io.DO, 11, 11) @[CacheController.scala 47:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[CacheController.scala 48:27]
    reg updatedTag : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[CacheController.scala 49:27]
    reg cacheHit : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[CacheController.scala 50:25]
    wire cacheWriteAdd : UInt<10> @[CacheController.scala 51:31]
    cacheWriteAdd <= UInt<10>("h0") @[CacheController.scala 51:31]
    wire cacheReadAdd : UInt<10> @[CacheController.scala 52:30]
    cacheReadAdd <= UInt<10>("h0") @[CacheController.scala 52:30]
    wire memDataIn : UInt<32> @[CacheController.scala 53:27]
    memDataIn <= UInt<32>("h0") @[CacheController.scala 53:27]
    wire cacheAdd : UInt<10> @[CacheController.scala 54:26]
    cacheAdd <= UInt<10>("h0") @[CacheController.scala 54:26]
    node memWordAdd = bits(io.memAdd, 31, 2) @[CacheController.scala 55:29]
    tagStore.io.rw <= UInt<1>("h1") @[CacheController.scala 59:18]
    tagStore.io.EN <= UInt<1>("h0") @[CacheController.scala 60:18]
    cache.io.rw <= UInt<1>("h1") @[CacheController.scala 61:15]
    cache.io.EN <= UInt<1>("h0") @[CacheController.scala 62:15]
    cache.io.DI <= io.DI @[CacheController.scala 63:15]
    extMem.io.rw <= UInt<1>("h1") @[CacheController.scala 64:15]
    extMem.io.EN <= UInt<1>("h0") @[CacheController.scala 65:16]
    extMem.io.ad <= memWordAdd @[CacheController.scala 66:16]
    io.cacheMiss <= UInt<1>("h0") @[CacheController.scala 67:16]
    extMem.io.DI <= memDataIn @[CacheController.scala 70:16]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 71:25]
    cacheReadAdd <= _cacheReadAdd_T @[CacheController.scala 71:16]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 72:26]
    cacheWriteAdd <= _cacheWriteAdd_T @[CacheController.scala 72:17]
    cache.io.ad <= cacheAdd @[CacheController.scala 74:15]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 75:30]
    targetTagWord <= _targetTagWord_T @[CacheController.scala 75:17]
    tagStore.io.ad <= index @[CacheController.scala 78:18]
    reg stateReg : UInt<3>, clock with :
      reset => (reset, UInt<1>("h0")) @[CacheController.scala 87:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 103:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 103:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 103:20]
    when _T_2 : @[CacheController.scala 103:20]
      extMem.io.EN <= UInt<1>("h0") @[CacheController.scala 99:13]
      extMem.io.rw <= UInt<1>("h1") @[CacheController.scala 100:13]
      when io.validReq : @[CacheController.scala 106:25]
        cacheAdd <= cacheReadAdd @[CacheController.scala 108:18]
        tagStore.io.EN <= UInt<1>("h1") @[CacheController.scala 91:13]
        tagStore.io.rw <= UInt<1>("h1") @[CacheController.scala 92:13]
        stateReg <= UInt<1>("h1") @[CacheController.scala 110:18]
        when io.rw : @[CacheController.scala 112:21]
          cache.io.EN <= UInt<1>("h1") @[CacheController.scala 91:13]
          cache.io.rw <= UInt<1>("h1") @[CacheController.scala 92:13]
        else :
          cache.io.EN <= UInt<1>("h1") @[CacheController.scala 95:13]
          cache.io.rw <= UInt<1>("h0") @[CacheController.scala 96:13]
          cache.io.DI <= io.DI @[CacheController.scala 119:23]
      else :
        tagStore.io.EN <= UInt<1>("h0") @[CacheController.scala 99:13]
        tagStore.io.rw <= UInt<1>("h1") @[CacheController.scala 100:13]
        cache.io.EN <= UInt<1>("h0") @[CacheController.scala 99:13]
        cache.io.rw <= UInt<1>("h1") @[CacheController.scala 100:13]
    else :
      node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 103:20]
      node _T_4 = asUInt(stateReg) @[CacheController.scala 103:20]
      node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 103:20]
      when _T_5 : @[CacheController.scala 103:20]
        tagStore.io.EN <= UInt<1>("h1") @[CacheController.scala 128:22]
        node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 129:12]
        when _T_6 : @[CacheController.scala 129:25]
          cacheAdd <= cacheWriteAdd @[CacheController.scala 130:18]
          extMem.io.EN <= UInt<1>("h1") @[CacheController.scala 91:13]
          extMem.io.rw <= UInt<1>("h1") @[CacheController.scala 92:13]
          stateReg <= UInt<2>("h2") @[CacheController.scala 133:18]
        else :
          node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 134:28]
          when _T_7 : @[CacheController.scala 134:43]
            cacheAdd <= cacheReadAdd @[CacheController.scala 135:18]
            when io.rw : @[CacheController.scala 137:21]
              cache.io.EN <= UInt<1>("h1") @[CacheController.scala 139:23]
              lastRead <= cache.io.DO @[CacheController.scala 140:20]
              stateReg <= UInt<1>("h0") @[CacheController.scala 141:20]
            else :
              cache.io.EN <= UInt<1>("h1") @[CacheController.scala 95:13]
              cache.io.rw <= UInt<1>("h0") @[CacheController.scala 96:13]
              cache.io.DI <= io.DI @[CacheController.scala 145:23]
              stateReg <= UInt<3>("h4") @[CacheController.scala 146:20]
          else :
            cacheAdd <= cacheWriteAdd @[CacheController.scala 149:18]
            io.cacheMiss <= UInt<1>("h1") @[CacheController.scala 150:22]
            stateReg <= UInt<2>("h2") @[CacheController.scala 152:18]
            extMem.io.EN <= UInt<1>("h1") @[CacheController.scala 91:13]
            extMem.io.rw <= UInt<1>("h1") @[CacheController.scala 92:13]
      else :
        node _T_8 = asUInt(UInt<3>("h4")) @[CacheController.scala 103:20]
        node _T_9 = asUInt(stateReg) @[CacheController.scala 103:20]
        node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 103:20]
        when _T_10 : @[CacheController.scala 103:20]
          cacheAdd <= cacheReadAdd @[CacheController.scala 159:16]
          extMem.io.rw <= UInt<1>("h0") @[CacheController.scala 160:20]
          extMem.io.EN <= UInt<1>("h1") @[CacheController.scala 161:20]
          memDataIn <= io.DI @[CacheController.scala 162:17]
          when io.memReady : @[CacheController.scala 164:25]
            stateReg <= UInt<1>("h0") @[CacheController.scala 165:18]
        else :
          node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 103:20]
          node _T_12 = asUInt(stateReg) @[CacheController.scala 103:20]
          node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 103:20]
          when _T_13 : @[CacheController.scala 103:20]
            cache.io.EN <= UInt<1>("h1") @[CacheController.scala 95:13]
            cache.io.rw <= UInt<1>("h0") @[CacheController.scala 96:13]
            cacheAdd <= cacheWriteAdd @[CacheController.scala 171:16]
            extMem.io.EN <= UInt<1>("h1") @[CacheController.scala 172:20]
            node _extMem_io_ad_T = add(memWordAdd, writeIndex) @[CacheController.scala 173:34]
            node _extMem_io_ad_T_1 = tail(_extMem_io_ad_T, 1) @[CacheController.scala 173:34]
            node _extMem_io_ad_T_2 = add(_extMem_io_ad_T_1, UInt<1>("h1")) @[CacheController.scala 173:47]
            node _extMem_io_ad_T_3 = tail(_extMem_io_ad_T_2, 1) @[CacheController.scala 173:47]
            extMem.io.ad <= _extMem_io_ad_T_3 @[CacheController.scala 173:20]
            cache.io.DI <= extMem.io.DO @[CacheController.scala 174:19]
            node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 176:35]
            updatedTag <= _updatedTag_T @[CacheController.scala 176:18]
            node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 178:38]
            node _T_15 = and(io.memReady, _T_14) @[CacheController.scala 178:24]
            when _T_15 : @[CacheController.scala 178:47]
              tagStore.io.EN <= UInt<1>("h1") @[CacheController.scala 95:13]
              tagStore.io.rw <= UInt<1>("h0") @[CacheController.scala 96:13]
              stateReg <= UInt<1>("h1") @[CacheController.scala 181:18]
              writeIndex <= UInt<1>("h0") @[CacheController.scala 182:20]
            else :
              node _T_16 = eq(io.memReady, UInt<1>("h0")) @[CacheController.scala 183:18]
              node _T_17 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 183:45]
              node _T_18 = and(_T_16, _T_17) @[CacheController.scala 183:31]
              when _T_18 : @[CacheController.scala 183:54]
                writeIndex <= UInt<2>("h3") @[CacheController.scala 184:20]
              else :
                node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 186:34]
                node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 186:34]
                writeIndex <= _writeIndex_T_1 @[CacheController.scala 186:20]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 194:24]
    io.ready <= _io_ready_T @[CacheController.scala 194:12]
    io.cacheValid <= cacheValid @[CacheController.scala 195:17]
    tagStore.io.DI <= updatedTag @[CacheController.scala 196:18]
    io.DO <= lastRead @[CacheController.scala 197:9]

