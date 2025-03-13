circuit Cache :
  module Cache :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip rw : UInt<1>, flip ad : UInt<10>, flip DI : UInt<32>, DO : UInt<32>}

    smem mem : UInt<8> [1024] @[Cache.scala 12:24]
    wire _memVal_WIRE : UInt @[Cache.scala 14:24]
    _memVal_WIRE is invalid @[Cache.scala 14:24]
    when UInt<1>("h1") : @[Cache.scala 14:24]
      _memVal_WIRE <= io.ad @[Cache.scala 14:24]
      node _memVal_T = or(_memVal_WIRE, UInt<10>("h0")) @[Cache.scala 14:24]
      node _memVal_T_1 = bits(_memVal_T, 9, 0) @[Cache.scala 14:24]
      read mport memVal = mem[_memVal_T_1], clock @[Cache.scala 14:24]
    node _io_DO_T = mux(io.rw, memVal, UInt<1>("h0")) @[Cache.scala 16:15]
    io.DO <= _io_DO_T @[Cache.scala 16:9]
    node _T = eq(io.rw, UInt<1>("h0")) @[Cache.scala 18:8]
    when _T : @[Cache.scala 18:15]
      write mport MPORT = mem[io.ad], clock
      MPORT <= io.DI


