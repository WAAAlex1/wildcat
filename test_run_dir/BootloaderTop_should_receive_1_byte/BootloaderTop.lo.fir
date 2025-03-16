FIRRTL version 1.1.0
circuit BootloaderTop :
  module Rx :
    input clock : Clock
    input reset : UInt<1>
    input io_rxd : UInt<1>
    input io_channel_ready : UInt<1>
    output io_channel_valid : UInt<1>
    output io_channel_bits : UInt<8>

    reg rxReg_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rxReg_REG) @[Uart.scala 76:30]
    reg rxReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rxReg) @[Uart.scala 76:22]
    node _falling_T = eq(rxReg, UInt<1>("h0")) @[Uart.scala 77:17]
    reg falling_REG : UInt<1>, clock with :
      reset => (UInt<1>("h0"), falling_REG) @[Uart.scala 77:35]
    node _falling_T_1 = eq(falling_REG, UInt<1>("h1")) @[Uart.scala 77:43]
    node falling = and(_falling_T, _falling_T_1) @[Uart.scala 77:24]
    reg shiftReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), shiftReg) @[Uart.scala 79:25]
    reg cntReg : UInt<20>, clock with :
      reset => (UInt<1>("h0"), cntReg) @[Uart.scala 80:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (UInt<1>("h0"), bitsReg) @[Uart.scala 81:24]
    reg valReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), valReg) @[Uart.scala 82:23]
    node _T = neq(cntReg, UInt<1>("h0")) @[Uart.scala 84:15]
    node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Uart.scala 85:22]
    node _cntReg_T_1 = tail(_cntReg_T, 1) @[Uart.scala 85:22]
    node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Uart.scala 86:22]
    node _shiftReg_T = shr(shiftReg, 1) @[Uart.scala 88:37]
    node _shiftReg_T_1 = cat(rxReg, _shiftReg_T) @[Cat.scala 33:92]
    node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Uart.scala 89:24]
    node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Uart.scala 89:24]
    node _T_2 = eq(bitsReg, UInt<1>("h1")) @[Uart.scala 91:18]
    node _GEN_0 = mux(_T_2, UInt<1>("h1"), valReg) @[Uart.scala 91:27 92:14 82:23]
    node _GEN_1 = mux(falling, UInt<8>("h80"), cntReg) @[Uart.scala 94:23 95:12 80:23]
    node _GEN_2 = mux(falling, UInt<4>("h8"), bitsReg) @[Uart.scala 94:23 96:13 81:24]
    node _GEN_3 = mux(_T_1, UInt<7>("h56"), _GEN_1) @[Uart.scala 86:31 87:12]
    node _GEN_4 = mux(_T_1, _shiftReg_T_1, shiftReg) @[Uart.scala 86:31 88:14 79:25]
    node _GEN_5 = mux(_T_1, _bitsReg_T_1, _GEN_2) @[Uart.scala 86:31 89:13]
    node _GEN_6 = mux(_T_1, _GEN_0, valReg) @[Uart.scala 82:23 86:31]
    node _GEN_7 = mux(_T, _cntReg_T_1, _GEN_3) @[Uart.scala 84:24 85:12]
    node _GEN_8 = mux(_T, shiftReg, _GEN_4) @[Uart.scala 84:24 79:25]
    node _GEN_9 = mux(_T, bitsReg, _GEN_5) @[Uart.scala 81:24 84:24]
    node _GEN_10 = mux(_T, valReg, _GEN_6) @[Uart.scala 82:23 84:24]
    node _T_3 = and(valReg, io_channel_ready) @[Uart.scala 99:15]
    node _GEN_11 = mux(_T_3, UInt<1>("h0"), _GEN_10) @[Uart.scala 100:12 99:36]
    io_channel_valid <= valReg @[Uart.scala 104:20]
    io_channel_bits <= shiftReg @[Uart.scala 103:19]
    rxReg_REG <= mux(reset, UInt<1>("h0"), io_rxd) @[Uart.scala 76:{30,30,30}]
    rxReg <= mux(reset, UInt<1>("h0"), rxReg_REG) @[Uart.scala 76:{22,22,22}]
    falling_REG <= rxReg @[Uart.scala 77:35]
    shiftReg <= mux(reset, UInt<8>("h0"), _GEN_8) @[Uart.scala 79:{25,25}]
    cntReg <= mux(reset, UInt<20>("h56"), _GEN_7) @[Uart.scala 80:{23,23}]
    bitsReg <= mux(reset, UInt<4>("h0"), _GEN_9) @[Uart.scala 81:{24,24}]
    valReg <= mux(reset, UInt<1>("h0"), _GEN_11) @[Uart.scala 82:{23,23}]

  module BootBuffer :
    input clock : Clock
    input reset : UInt<1>
    input io_saveCtrl : UInt<1>
    input io_dataIn : UInt<8>
    output io_dataOut : UInt<64>

    reg buffer : UInt<64>, clock with :
      reset => (UInt<1>("h0"), buffer) @[BootBuffer.scala 21:23]
    node _T = eq(io_saveCtrl, UInt<1>("h1")) @[BootBuffer.scala 23:20]
    node _buffer_T = bits(buffer, 63, 8) @[BootBuffer.scala 24:34]
    node _buffer_T_1 = cat(io_dataIn, _buffer_T) @[BootBuffer.scala 24:25]
    node _GEN_0 = mux(_T, _buffer_T_1, buffer) @[BootBuffer.scala 23:28 24:12 21:23]
    io_dataOut <= buffer @[BootBuffer.scala 27:14]
    buffer <= mux(reset, UInt<64>("h0"), _GEN_0) @[BootBuffer.scala 21:{23,23}]

  module BootloaderTop :
    input clock : Clock
    input reset : UInt<1>
    output io_instrData : UInt<32>
    output io_instrAddr : UInt<32>
    output io_wrEnabled : UInt<1>
    input io_rx : UInt<1>

    inst rx of Rx @[BootloaderTop.scala 30:18]
    inst buffer of BootBuffer @[BootloaderTop.scala 31:22]
    reg stateReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[BootloaderTop.scala 38:25]
    reg incr : UInt<1>, clock with :
      reset => (UInt<1>("h0"), incr) @[BootloaderTop.scala 40:21]
    reg save : UInt<1>, clock with :
      reset => (UInt<1>("h0"), save) @[BootloaderTop.scala 41:21]
    reg wrEnabled : UInt<1>, clock with :
      reset => (UInt<1>("h0"), wrEnabled) @[BootloaderTop.scala 42:26]
    reg byteCount : UInt<4>, clock with :
      reset => (UInt<1>("h0"), byteCount) @[BootloaderTop.scala 43:26]
    node _T = eq(incr, UInt<1>("h1")) @[BootloaderTop.scala 45:13]
    node _byteCount_T = add(byteCount, UInt<1>("h1")) @[BootloaderTop.scala 46:28]
    node _byteCount_T_1 = tail(_byteCount_T, 1) @[BootloaderTop.scala 46:28]
    node _GEN_0 = mux(_T, _byteCount_T_1, byteCount) @[BootloaderTop.scala 45:21 46:15 43:26]
    node _T_1 = asUInt(UInt<1>("h1")) @[BootloaderTop.scala 58:19]
    node _T_2 = asUInt(stateReg) @[BootloaderTop.scala 58:19]
    node _T_3 = eq(_T_1, _T_2) @[BootloaderTop.scala 58:19]
    node _T_4 = eq(io_instrData, UInt<32>("hb00710ad")) @[BootloaderTop.scala 60:25]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), stateReg) @[BootloaderTop.scala 66:26 67:18 38:25]
    node _GEN_2 = mux(rx.io_channel_valid, UInt<1>("h1"), UInt<1>("h0")) @[BootloaderTop.scala 52:23 62:39 63:29]
    node _GEN_3 = mux(rx.io_channel_valid, UInt<1>("h1"), _GEN_1) @[BootloaderTop.scala 62:39 65:18]
    node _GEN_4 = mux(_T_4, UInt<1>("h0"), _GEN_3) @[BootloaderTop.scala 60:43 61:18]
    node _GEN_5 = mux(_T_4, UInt<1>("h0"), _GEN_2) @[BootloaderTop.scala 52:23 60:43]
    node _T_5 = asUInt(UInt<1>("h0")) @[BootloaderTop.scala 58:19]
    node _T_6 = asUInt(stateReg) @[BootloaderTop.scala 58:19]
    node _T_7 = eq(_T_5, _T_6) @[BootloaderTop.scala 58:19]
    node _T_8 = eq(byteCount, UInt<4>("h8")) @[BootloaderTop.scala 71:21]
    node _GEN_6 = mux(UInt<1>("h1"), UInt<1>("h0"), stateReg) @[BootloaderTop.scala 80:26 81:17 38:25]
    node _GEN_7 = mux(rx.io_channel_valid, UInt<1>("h0"), _GEN_6) @[BootloaderTop.scala 75:39 79:17]
    node _GEN_8 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[BootloaderTop.scala 55:13 71:30 72:18]
    node _GEN_9 = mux(_T_8, UInt<1>("h0"), _GEN_0) @[BootloaderTop.scala 71:30 73:18]
    node _GEN_10 = mux(_T_8, UInt<1>("h0"), _GEN_7) @[BootloaderTop.scala 71:30 74:17]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), _GEN_2) @[BootloaderTop.scala 71:30 53:8]
    node _GEN_12 = mux(_T_7, _GEN_8, UInt<1>("h0")) @[BootloaderTop.scala 55:13 58:19]
    node _GEN_13 = mux(_T_7, _GEN_9, _GEN_0) @[BootloaderTop.scala 58:19]
    node _GEN_14 = mux(_T_7, _GEN_10, stateReg) @[BootloaderTop.scala 58:19 38:25]
    node _GEN_15 = mux(_T_7, _GEN_11, UInt<1>("h0")) @[BootloaderTop.scala 58:19 53:8]
    node _GEN_16 = mux(_T_3, _GEN_4, _GEN_14) @[BootloaderTop.scala 58:19]
    node _GEN_17 = mux(_T_3, _GEN_5, _GEN_15) @[BootloaderTop.scala 58:19]
    node _GEN_18 = mux(_T_3, UInt<1>("h0"), _GEN_12) @[BootloaderTop.scala 55:13 58:19]
    node _GEN_19 = mux(_T_3, _GEN_0, _GEN_13) @[BootloaderTop.scala 58:19]
    node _GEN_20 = mux(_T_3, UInt<1>("h0"), _GEN_15) @[BootloaderTop.scala 58:19 53:8]
    node _io_instrData_T = bits(buffer.io_dataOut, 63, 32) @[BootloaderTop.scala 87:36]
    node _io_instrAddr_T = bits(buffer.io_dataOut, 31, 0) @[BootloaderTop.scala 88:36]
    io_instrData <= _io_instrData_T @[BootloaderTop.scala 87:16]
    io_instrAddr <= _io_instrAddr_T @[BootloaderTop.scala 88:16]
    io_wrEnabled <= wrEnabled @[BootloaderTop.scala 86:16]
    rx.clock <= clock
    rx.reset <= reset
    rx.io_rxd <= io_rx @[BootloaderTop.scala 89:13]
    rx.io_channel_ready <= _GEN_17
    buffer.clock <= clock
    buffer.reset <= reset
    buffer.io_saveCtrl <= save @[BootloaderTop.scala 49:22]
    buffer.io_dataIn <= rx.io_channel_bits @[BootloaderTop.scala 50:20]
    stateReg <= mux(reset, UInt<1>("h1"), _GEN_16) @[BootloaderTop.scala 38:{25,25}]
    incr <= mux(reset, UInt<1>("h0"), _GEN_20) @[BootloaderTop.scala 40:{21,21}]
    save <= mux(reset, UInt<1>("h0"), _GEN_17) @[BootloaderTop.scala 41:{21,21}]
    wrEnabled <= mux(reset, UInt<1>("h0"), _GEN_18) @[BootloaderTop.scala 42:{26,26}]
    byteCount <= mux(reset, UInt<4>("h0"), _GEN_19) @[BootloaderTop.scala 43:{26,26}]
