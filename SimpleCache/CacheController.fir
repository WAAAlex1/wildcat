circuit CacheController :
  module RAM :
    input clock : Clock
    input reset : Reset
    output io : { flip rw : UInt<1>, flip ad : UInt<9>, flip DI : UInt<32>, flip EN : UInt<1>, DO : UInt<32>}

    smem mem : UInt<32> [512] @[RAM.scala 13:24]
    node _T = and(io.rw, io.EN) @[RAM.scala 15:14]
    when _T : @[RAM.scala 15:23]
      wire _io_DO_WIRE : UInt @[RAM.scala 16:22]
      _io_DO_WIRE is invalid @[RAM.scala 16:22]
      when UInt<1>("h1") : @[RAM.scala 16:22]
        _io_DO_WIRE <= io.ad @[RAM.scala 16:22]
        node _io_DO_T = or(_io_DO_WIRE, UInt<9>("h0")) @[RAM.scala 16:22]
        node _io_DO_T_1 = bits(_io_DO_T, 8, 0) @[RAM.scala 16:22]
        read mport io_DO_MPORT = mem[_io_DO_T_1], clock @[RAM.scala 16:22]
      io.DO <= io_DO_MPORT @[RAM.scala 16:11]
    else :
      node _T_1 = eq(io.rw, UInt<1>("h0")) @[RAM.scala 17:14]
      node _T_2 = and(_T_1, io.EN) @[RAM.scala 17:21]
      when _T_2 : @[RAM.scala 17:30]
        write mport MPORT = mem[io.ad], clock
        MPORT <= io.DI
        io.DO <= UInt<1>("h0") @[RAM.scala 19:11]
      else :
        io.DO <= UInt<1>("h0") @[RAM.scala 21:11]


  module RAM_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip rw : UInt<1>, flip ad : UInt<10>, flip DI : UInt<32>, flip EN : UInt<1>, DO : UInt<32>}

    smem mem : UInt<32> [1024] @[RAM.scala 13:24]
    node _T = and(io.rw, io.EN) @[RAM.scala 15:14]
    when _T : @[RAM.scala 15:23]
      wire _io_DO_WIRE : UInt @[RAM.scala 16:22]
      _io_DO_WIRE is invalid @[RAM.scala 16:22]
      when UInt<1>("h1") : @[RAM.scala 16:22]
        _io_DO_WIRE <= io.ad @[RAM.scala 16:22]
        node _io_DO_T = or(_io_DO_WIRE, UInt<10>("h0")) @[RAM.scala 16:22]
        node _io_DO_T_1 = bits(_io_DO_T, 9, 0) @[RAM.scala 16:22]
        read mport io_DO_MPORT = mem[_io_DO_T_1], clock @[RAM.scala 16:22]
      io.DO <= io_DO_MPORT @[RAM.scala 16:11]
    else :
      node _T_1 = eq(io.rw, UInt<1>("h0")) @[RAM.scala 17:14]
      node _T_2 = and(_T_1, io.EN) @[RAM.scala 17:21]
      when _T_2 : @[RAM.scala 17:30]
        write mport MPORT = mem[io.ad], clock
        MPORT <= io.DI
        io.DO <= UInt<1>("h0") @[RAM.scala 19:11]
      else :
        io.DO <= UInt<1>("h0") @[RAM.scala 21:11]


  module RAM_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip rw : UInt<1>, flip ad : UInt<12>, flip DI : UInt<32>, flip EN : UInt<1>, DO : UInt<32>}

    smem mem : UInt<32> [4096] @[RAM.scala 13:24]
    node _T = and(io.rw, io.EN) @[RAM.scala 15:14]
    when _T : @[RAM.scala 15:23]
      wire _io_DO_WIRE : UInt @[RAM.scala 16:22]
      _io_DO_WIRE is invalid @[RAM.scala 16:22]
      when UInt<1>("h1") : @[RAM.scala 16:22]
        _io_DO_WIRE <= io.ad @[RAM.scala 16:22]
        node _io_DO_T = or(_io_DO_WIRE, UInt<12>("h0")) @[RAM.scala 16:22]
        node _io_DO_T_1 = bits(_io_DO_T, 11, 0) @[RAM.scala 16:22]
        read mport io_DO_MPORT = mem[_io_DO_T_1], clock @[RAM.scala 16:22]
      io.DO <= io_DO_MPORT @[RAM.scala 16:11]
    else :
      node _T_1 = eq(io.rw, UInt<1>("h0")) @[RAM.scala 17:14]
      node _T_2 = and(_T_1, io.EN) @[RAM.scala 17:21]
      when _T_2 : @[RAM.scala 17:30]
        write mport MPORT = mem[io.ad], clock
        MPORT <= io.DI
        io.DO <= UInt<1>("h0") @[RAM.scala 19:11]
      else :
        io.DO <= UInt<1>("h0") @[RAM.scala 21:11]


  module CacheController :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip validReq : UInt<1>, flip rw : UInt<1>, flip memAdd : UInt<32>, flip DI : UInt<32>, DO : UInt<32>, ready : UInt<1>, flip memReady : UInt<1>, cacheMiss : UInt<1>}

    reg lastRead : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[CacheController.scala 36:25]
    inst tagStore of RAM @[CacheController.scala 37:24]
    tagStore.clock <= clock
    tagStore.reset <= reset
    inst cache of RAM_1 @[CacheController.scala 38:21]
    cache.clock <= clock
    cache.reset <= reset
    inst extMem of RAM_2 @[CacheController.scala 39:22]
    extMem.clock <= clock
    extMem.reset <= reset
    node byteOffset = bits(io.memAdd, 1, 0) @[CacheController.scala 44:29]
    node blockOffset = bits(io.memAdd, 3, 2) @[CacheController.scala 45:30]
    node index = bits(io.memAdd, 11, 4) @[CacheController.scala 46:24]
    node targetTag = bits(io.memAdd, 31, 12) @[CacheController.scala 47:28]
    wire targetTagWord : UInt<32> @[CacheController.scala 48:31]
    targetTagWord <= UInt<32>("h0") @[CacheController.scala 48:31]
    node actualTag = bits(tagStore.io.DO, 31, 12) @[CacheController.scala 49:33]
    node cacheValid = bits(tagStore.io.DO, 11, 11) @[CacheController.scala 50:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[CacheController.scala 51:27]
    reg writeDone : UInt<1>, clock with :
      reset => (reset, UInt<1>("h1")) @[CacheController.scala 52:26]
    reg allocateDone : UInt<1>, clock with :
      reset => (reset, UInt<1>("h1")) @[CacheController.scala 53:29]
    reg updatedTag : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[CacheController.scala 54:27]
    reg cacheHit : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[CacheController.scala 55:25]
    wire cacheWriteAdd : UInt<10> @[CacheController.scala 56:31]
    cacheWriteAdd <= UInt<10>("h0") @[CacheController.scala 56:31]
    wire cacheReadAdd : UInt<10> @[CacheController.scala 57:30]
    cacheReadAdd <= UInt<10>("h0") @[CacheController.scala 57:30]
    wire memDataIn : UInt<32> @[CacheController.scala 58:27]
    memDataIn <= UInt<32>("h0") @[CacheController.scala 58:27]
    wire cacheAdd : UInt<10> @[CacheController.scala 59:26]
    cacheAdd <= UInt<10>("h0") @[CacheController.scala 59:26]
    node memWordAdd = bits(io.memAdd, 31, 2) @[CacheController.scala 60:29]
    tagStore.io.rw <= UInt<1>("h1") @[CacheController.scala 64:18]
    tagStore.io.EN <= UInt<1>("h0") @[CacheController.scala 65:18]
    cache.io.rw <= UInt<1>("h1") @[CacheController.scala 66:15]
    cache.io.EN <= UInt<1>("h0") @[CacheController.scala 67:15]
    cache.io.DI <= io.DI @[CacheController.scala 68:15]
    extMem.io.rw <= UInt<1>("h1") @[CacheController.scala 69:15]
    extMem.io.EN <= UInt<1>("h0") @[CacheController.scala 70:16]
    extMem.io.ad <= memWordAdd @[CacheController.scala 71:16]
    io.cacheMiss <= UInt<1>("h0") @[CacheController.scala 73:16]
    extMem.io.DI <= memDataIn @[CacheController.scala 82:16]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 83:25]
    cacheReadAdd <= _cacheReadAdd_T @[CacheController.scala 83:16]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 84:26]
    cacheWriteAdd <= _cacheWriteAdd_T @[CacheController.scala 84:17]
    cache.io.ad <= cacheAdd @[CacheController.scala 86:15]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 87:30]
    targetTagWord <= _targetTagWord_T @[CacheController.scala 87:17]
    tagStore.io.ad <= index @[CacheController.scala 90:18]
    reg stateReg : UInt<3>, clock with :
      reset => (reset, UInt<1>("h0")) @[CacheController.scala 101:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 253:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 253:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 253:20]
    when _T_2 : @[CacheController.scala 253:20]
      extMem.io.EN <= UInt<1>("h0") @[CacheController.scala 249:13]
      extMem.io.rw <= UInt<1>("h1") @[CacheController.scala 250:13]
      when io.validReq : @[CacheController.scala 256:25]
        cacheAdd <= cacheReadAdd @[CacheController.scala 258:18]
        tagStore.io.EN <= UInt<1>("h1") @[CacheController.scala 241:13]
        tagStore.io.rw <= UInt<1>("h1") @[CacheController.scala 242:13]
        stateReg <= UInt<1>("h1") @[CacheController.scala 260:18]
        when io.rw : @[CacheController.scala 262:21]
          cache.io.EN <= UInt<1>("h1") @[CacheController.scala 241:13]
          cache.io.rw <= UInt<1>("h1") @[CacheController.scala 242:13]
        else :
          cache.io.EN <= UInt<1>("h1") @[CacheController.scala 245:13]
          cache.io.rw <= UInt<1>("h0") @[CacheController.scala 246:13]
          cache.io.DI <= io.DI @[CacheController.scala 270:23]
      else :
        tagStore.io.EN <= UInt<1>("h0") @[CacheController.scala 249:13]
        tagStore.io.rw <= UInt<1>("h1") @[CacheController.scala 250:13]
        cache.io.EN <= UInt<1>("h0") @[CacheController.scala 249:13]
        cache.io.rw <= UInt<1>("h1") @[CacheController.scala 250:13]
    else :
      node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 253:20]
      node _T_4 = asUInt(stateReg) @[CacheController.scala 253:20]
      node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 253:20]
      when _T_5 : @[CacheController.scala 253:20]
        tagStore.io.EN <= UInt<1>("h1") @[CacheController.scala 279:22]
        node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 280:12]
        when _T_6 : @[CacheController.scala 280:25]
          cacheAdd <= cacheWriteAdd @[CacheController.scala 281:18]
          extMem.io.EN <= UInt<1>("h1") @[CacheController.scala 241:13]
          extMem.io.rw <= UInt<1>("h1") @[CacheController.scala 242:13]
          stateReg <= UInt<2>("h2") @[CacheController.scala 284:18]
        else :
          node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 285:28]
          when _T_7 : @[CacheController.scala 285:43]
            cacheAdd <= cacheReadAdd @[CacheController.scala 286:18]
            when io.rw : @[CacheController.scala 289:21]
              cache.io.EN <= UInt<1>("h1") @[CacheController.scala 291:23]
              lastRead <= cache.io.DO @[CacheController.scala 292:20]
              stateReg <= UInt<1>("h0") @[CacheController.scala 293:20]
            else :
              cache.io.EN <= UInt<1>("h1") @[CacheController.scala 245:13]
              cache.io.rw <= UInt<1>("h0") @[CacheController.scala 246:13]
              cache.io.DI <= io.DI @[CacheController.scala 297:23]
              stateReg <= UInt<3>("h4") @[CacheController.scala 298:20]
          else :
            cacheAdd <= cacheWriteAdd @[CacheController.scala 301:18]
            io.cacheMiss <= UInt<1>("h1") @[CacheController.scala 302:22]
            stateReg <= UInt<2>("h2") @[CacheController.scala 304:18]
            extMem.io.EN <= UInt<1>("h1") @[CacheController.scala 241:13]
            extMem.io.rw <= UInt<1>("h1") @[CacheController.scala 242:13]
      else :
        node _T_8 = asUInt(UInt<3>("h4")) @[CacheController.scala 253:20]
        node _T_9 = asUInt(stateReg) @[CacheController.scala 253:20]
        node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 253:20]
        when _T_10 : @[CacheController.scala 253:20]
          cacheAdd <= cacheReadAdd @[CacheController.scala 311:16]
          extMem.io.rw <= UInt<1>("h0") @[CacheController.scala 312:20]
          extMem.io.EN <= UInt<1>("h1") @[CacheController.scala 313:20]
          memDataIn <= io.DI @[CacheController.scala 314:17]
          when io.memReady : @[CacheController.scala 316:25]
            stateReg <= UInt<1>("h0") @[CacheController.scala 317:18]
        else :
          node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 253:20]
          node _T_12 = asUInt(stateReg) @[CacheController.scala 253:20]
          node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 253:20]
          when _T_13 : @[CacheController.scala 253:20]
            cache.io.EN <= UInt<1>("h1") @[CacheController.scala 245:13]
            cache.io.rw <= UInt<1>("h0") @[CacheController.scala 246:13]
            cacheAdd <= cacheWriteAdd @[CacheController.scala 323:16]
            extMem.io.EN <= UInt<1>("h1") @[CacheController.scala 324:20]
            node _extMem_io_ad_T = add(memWordAdd, writeIndex) @[CacheController.scala 325:34]
            node _extMem_io_ad_T_1 = tail(_extMem_io_ad_T, 1) @[CacheController.scala 325:34]
            node _extMem_io_ad_T_2 = add(_extMem_io_ad_T_1, UInt<1>("h1")) @[CacheController.scala 325:47]
            node _extMem_io_ad_T_3 = tail(_extMem_io_ad_T_2, 1) @[CacheController.scala 325:47]
            extMem.io.ad <= _extMem_io_ad_T_3 @[CacheController.scala 325:20]
            cache.io.DI <= extMem.io.DO @[CacheController.scala 326:19]
            node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 328:35]
            updatedTag <= _updatedTag_T @[CacheController.scala 328:18]
            node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 330:38]
            node _T_15 = and(io.memReady, _T_14) @[CacheController.scala 330:24]
            when _T_15 : @[CacheController.scala 330:47]
              tagStore.io.EN <= UInt<1>("h1") @[CacheController.scala 245:13]
              tagStore.io.rw <= UInt<1>("h0") @[CacheController.scala 246:13]
              stateReg <= UInt<1>("h1") @[CacheController.scala 333:18]
              writeIndex <= UInt<1>("h0") @[CacheController.scala 334:20]
            else :
              node _T_16 = eq(io.memReady, UInt<1>("h0")) @[CacheController.scala 335:18]
              node _T_17 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 335:45]
              node _T_18 = and(_T_16, _T_17) @[CacheController.scala 335:31]
              when _T_18 : @[CacheController.scala 335:54]
                writeIndex <= UInt<2>("h3") @[CacheController.scala 336:20]
              else :
                node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 338:34]
                node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 338:34]
                writeIndex <= _writeIndex_T_1 @[CacheController.scala 338:20]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 346:24]
    io.ready <= _io_ready_T @[CacheController.scala 346:12]
    tagStore.io.DI <= updatedTag @[CacheController.scala 351:18]
    io.DO <= lastRead @[CacheController.scala 361:9]

