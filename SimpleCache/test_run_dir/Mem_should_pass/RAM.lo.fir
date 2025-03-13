FIRRTL version 1.1.0
circuit RAM :
  module RAM :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<6>
    input io_DI : UInt<32>
    input io_WE : UInt<1>
    output io_DO : UInt<32>
    output io_memReady : UInt<1>

    mem mem : @[RAM.scala 15:24]
      data-type => UInt<32>
      depth => 64
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    reg ready : UInt<1>, clock with :
      reset => (UInt<1>("h0"), ready) @[RAM.scala 16:22]
    node _T = eq(io_rw, UInt<1>("h0")) @[RAM.scala 18:8]
    node _T_1 = and(_T, io_WE) @[RAM.scala 18:15]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 24:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 24:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<6>("h0")) @[RAM.scala 24:22]
    node _io_DO_T_1 = bits(_io_DO_T, 5, 0) @[RAM.scala 24:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 24:{22,22} 15:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 24:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 24:{22,22}]
    node _GEN_4 = mux(io_rw, UInt<1>("h1"), ready) @[RAM.scala 22:20 25:11 16:22]
    node _GEN_5 = mux(io_rw, _GEN_1, UInt<1>("h0")) @[RAM.scala 22:20 15:24]
    node _GEN_6 = validif(io_rw, _GEN_2) @[RAM.scala 22:20]
    node _GEN_7 = validif(io_rw, _GEN_3) @[RAM.scala 22:20]
    node _GEN_8 = mux(io_rw, mem.io_DO_MPORT.data, UInt<1>("h0")) @[RAM.scala 22:20 24:11 14:9]
    node _GEN_9 = mux(_T_1, UInt<1>("h1"), _GEN_4) @[RAM.scala 18:24 21:11]
    node _GEN_10 = validif(_T_1, io_ad) @[RAM.scala 18:24]
    node _GEN_11 = validif(_T_1, clock) @[RAM.scala 18:24]
    node _GEN_12 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 15:24 18:24]
    node _GEN_13 = validif(_T_1, UInt<1>("h1")) @[RAM.scala 18:24]
    node _GEN_14 = validif(_T_1, io_DI) @[RAM.scala 18:24]
    node _GEN_15 = mux(_T_1, UInt<1>("h0"), _GEN_5) @[RAM.scala 15:24 18:24]
    node _GEN_16 = validif(eq(_T_1, UInt<1>("h0")), _GEN_6) @[RAM.scala 18:24]
    node _GEN_17 = validif(eq(_T_1, UInt<1>("h0")), _GEN_7) @[RAM.scala 18:24]
    node _GEN_18 = mux(_T_1, UInt<1>("h0"), _GEN_8) @[RAM.scala 18:24 14:9]
    io_DO <= _GEN_18
    io_memReady <= ready @[RAM.scala 27:15]
    mem.io_DO_MPORT.addr <= _GEN_16
    mem.io_DO_MPORT.en <= _GEN_15
    mem.io_DO_MPORT.clk <= _GEN_17
    mem.MPORT.addr <= _GEN_10
    mem.MPORT.en <= _GEN_12
    mem.MPORT.clk <= _GEN_11
    mem.MPORT.data <= _GEN_14
    mem.MPORT.mask <= _GEN_13
    ready <= mux(reset, UInt<1>("h1"), _GEN_9) @[RAM.scala 16:{22,22}]
