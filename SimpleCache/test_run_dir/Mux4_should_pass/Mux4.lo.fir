FIRRTL version 1.1.0
circuit Mux4 :
  module Mux2 :
    input clock : Clock
    input reset : UInt<1>
    input io_a : UInt<1>
    input io_b : UInt<1>
    input io_sel : UInt<1>
    output io_y : UInt<1>

    node _T = eq(io_sel, UInt<1>("h0")) @[Hello.scala 10:16]
    node _GEN_0 = mux(_T, io_a, io_b) @[Hello.scala 10:25 11:10 13:10]
    io_y <= _GEN_0

  module Mux4 :
    input clock : Clock
    input reset : UInt<1>
    input io_a : UInt<1>
    input io_b : UInt<1>
    input io_c : UInt<1>
    input io_d : UInt<1>
    input io_sel : UInt<2>
    output io_y : UInt<1>

    inst m1 of Mux2 @[Hello.scala 26:18]
    inst m2 of Mux2 @[Hello.scala 27:18]
    inst m3 of Mux2 @[Hello.scala 28:18]
    node _m1_io_sel_T = bits(io_sel, 0, 0) @[Hello.scala 30:22]
    node _m2_io_sel_T = bits(io_sel, 1, 1) @[Hello.scala 34:22]
    node _m3_io_sel_T = bits(io_sel, 1, 1) @[Hello.scala 38:22]
    io_y <= m1.io_y @[Hello.scala 42:8]
    m1.clock <= clock
    m1.reset <= reset
    m1.io_a <= m2.io_y @[Hello.scala 31:11]
    m1.io_b <= m3.io_y @[Hello.scala 32:11]
    m1.io_sel <= _m1_io_sel_T @[Hello.scala 30:13]
    m2.clock <= clock
    m2.reset <= reset
    m2.io_a <= io_a @[Hello.scala 35:11]
    m2.io_b <= io_b @[Hello.scala 36:11]
    m2.io_sel <= _m2_io_sel_T @[Hello.scala 34:13]
    m3.clock <= clock
    m3.reset <= reset
    m3.io_a <= io_c @[Hello.scala 39:11]
    m3.io_b <= io_d @[Hello.scala 40:11]
    m3.io_sel <= _m3_io_sel_T @[Hello.scala 38:13]
