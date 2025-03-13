FIRRTL version 1.1.0
circuit Cache :
  module Cache :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<10>
    input io_DI : UInt<32>
    output io_DO : UInt<32>

    mem mem : @[Cache.scala 12:24]
      data-type => UInt<32>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => memVal
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[Cache.scala 14:{24,24}]
    node _memVal_WIRE = _GEN_0 @[Cache.scala 14:24]
    node _memVal_T = or(_memVal_WIRE, UInt<10>("h0")) @[Cache.scala 14:24]
    node _memVal_T_1 = bits(_memVal_T, 9, 0) @[Cache.scala 14:24]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[Cache.scala 12:24 14:{24,24}]
    node _GEN_2 = validif(UInt<1>("h1"), _memVal_T_1) @[Cache.scala 14:{24,24}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[Cache.scala 14:{24,24}]
    node _io_DO_T = mux(io_rw, mem.memVal.data, UInt<1>("h0")) @[Cache.scala 16:15]
    node _T = eq(io_rw, UInt<1>("h0")) @[Cache.scala 18:8]
    node _GEN_4 = validif(_T, io_ad) @[Cache.scala 18:15]
    node _GEN_5 = validif(_T, clock) @[Cache.scala 18:15]
    node _GEN_6 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Cache.scala 18:15 12:24]
    node _GEN_7 = validif(_T, UInt<1>("h1")) @[Cache.scala 18:15]
    node _GEN_8 = validif(_T, io_DI) @[Cache.scala 18:15]
    io_DO <= _io_DO_T @[Cache.scala 16:9]
    mem.memVal.addr <= _GEN_2
    mem.memVal.en <= _GEN_1
    mem.memVal.clk <= _GEN_3
    mem.MPORT.addr <= _GEN_4
    mem.MPORT.en <= _GEN_6
    mem.MPORT.clk <= _GEN_5
    mem.MPORT.data <= _GEN_8
    mem.MPORT.mask <= _GEN_7
