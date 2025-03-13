FIRRTL version 1.1.0
circuit RAM :
  module RAM :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<6>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 13:24]
      data-type => UInt<32>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      reader => lastRead_MPORT
      writer => MPORT
      read-under-write => undefined
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[RAM.scala 14:25]
    node _T = and(io_rw, io_EN) @[RAM.scala 17:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 18:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 18:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<6>("h0")) @[RAM.scala 18:22]
    node _io_DO_T_1 = bits(_io_DO_T, 5, 0) @[RAM.scala 18:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 18:{22,22} 13:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 18:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 18:{22,22}]
    node _lastRead_WIRE = _GEN_0 @[RAM.scala 19:25]
    node _lastRead_T = or(_lastRead_WIRE, UInt<6>("h0")) @[RAM.scala 19:25]
    node _lastRead_T_1 = bits(_lastRead_T, 5, 0) @[RAM.scala 19:25]
    node _GEN_4 = validif(UInt<1>("h1"), _lastRead_T_1) @[RAM.scala 19:{25,25}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 20:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 20:21]
    node _GEN_5 = validif(_T_2, io_ad) @[RAM.scala 20:30]
    node _GEN_6 = validif(_T_2, clock) @[RAM.scala 20:30]
    node _GEN_7 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 13:24 20:30]
    node _GEN_8 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 20:30]
    node _GEN_9 = validif(_T_2, io_DI) @[RAM.scala 20:30]
    node _GEN_10 = mux(_T_2, lastRead, lastRead) @[RAM.scala 20:30 22:11 24:11]
    node _GEN_11 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 17:23 13:24]
    node _GEN_12 = validif(_T, _GEN_2) @[RAM.scala 17:23]
    node _GEN_13 = validif(_T, _GEN_3) @[RAM.scala 17:23]
    node _GEN_14 = mux(_T, mem.io_DO_MPORT.data, _GEN_10) @[RAM.scala 17:23 18:11]
    node _GEN_15 = validif(_T, _GEN_4) @[RAM.scala 17:23]
    node _GEN_16 = mux(_T, mem.lastRead_MPORT.data, lastRead) @[RAM.scala 17:23 19:14 14:25]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 17:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_6) @[RAM.scala 17:23]
    node _GEN_19 = mux(_T, UInt<1>("h0"), _GEN_7) @[RAM.scala 17:23 13:24]
    node _GEN_20 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 17:23]
    node _GEN_21 = validif(eq(_T, UInt<1>("h0")), _GEN_9) @[RAM.scala 17:23]
    io_DO <= _GEN_14
    mem.io_DO_MPORT.addr <= _GEN_12
    mem.io_DO_MPORT.en <= _GEN_11
    mem.io_DO_MPORT.clk <= _GEN_13
    mem.lastRead_MPORT.addr <= _GEN_15
    mem.lastRead_MPORT.en <= _GEN_11
    mem.lastRead_MPORT.clk <= _GEN_13
    mem.MPORT.addr <= _GEN_17
    mem.MPORT.en <= _GEN_19
    mem.MPORT.clk <= _GEN_18
    mem.MPORT.data <= _GEN_21
    mem.MPORT.mask <= _GEN_20
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_16) @[RAM.scala 14:{25,25}]
