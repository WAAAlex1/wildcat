FIRRTL version 1.1.0
circuit Arbiter :
  module Arbiter :
    input clock : Clock
    input reset : UInt<1>
    output io_ImemReqOut_ready : UInt<1>
    input io_ImemReqOut_valid : UInt<1>
    input io_ImemReqOut_bits_addrRequest : UInt<32>
    input io_ImemReqOut_bits_dataRequest : UInt<32>
    input io_ImemReqOut_bits_activeByteLane : UInt<4>
    input io_ImemReqOut_bits_isWrite : UInt<1>
    input io_ImemRspIn_ready : UInt<1>
    output io_ImemRspIn_valid : UInt<1>
    output io_ImemRspIn_bits_dataResponse : UInt<32>
    output io_ImemRspIn_bits_error : UInt<1>
    output io_DmemReqOut_ready : UInt<1>
    input io_DmemReqOut_valid : UInt<1>
    input io_DmemReqOut_bits_addrRequest : UInt<32>
    input io_DmemReqOut_bits_dataRequest : UInt<32>
    input io_DmemReqOut_bits_activeByteLane : UInt<4>
    input io_DmemReqOut_bits_isWrite : UInt<1>
    input io_DmemRspIn_ready : UInt<1>
    output io_DmemRspIn_valid : UInt<1>
    output io_DmemRspIn_bits_dataResponse : UInt<32>
    output io_DmemRspIn_bits_error : UInt<1>
    input io_reqOut_ready : UInt<1>
    output io_reqOut_valid : UInt<1>
    output io_reqOut_bits_addrRequest : UInt<32>
    output io_reqOut_bits_dataRequest : UInt<32>
    output io_reqOut_bits_activeByteLane : UInt<4>
    output io_reqOut_bits_isWrite : UInt<1>
    output io_rspIn_ready : UInt<1>
    input io_rspIn_valid : UInt<1>
    input io_rspIn_bits_dataResponse : UInt<32>
    input io_rspIn_bits_error : UInt<1>
    output io_source : UInt<1>

    node _T = and(io_DmemReqOut_valid, io_ImemReqOut_valid) @[Arbiter.scala 29:28]
    node _T_1 = eq(io_ImemReqOut_valid, UInt<1>("h0")) @[Arbiter.scala 33:37]
    node _T_2 = and(io_DmemReqOut_valid, _T_1) @[Arbiter.scala 33:34]
    node _T_3 = eq(io_DmemReqOut_valid, UInt<1>("h0")) @[Arbiter.scala 37:14]
    node _T_4 = and(_T_3, io_ImemReqOut_valid) @[Arbiter.scala 37:35]
    node _T_5 = eq(io_DmemReqOut_valid, UInt<1>("h0")) @[Arbiter.scala 41:14]
    node _T_6 = eq(io_ImemReqOut_valid, UInt<1>("h0")) @[Arbiter.scala 41:38]
    node _T_7 = and(_T_5, _T_6) @[Arbiter.scala 41:35]
    node _GEN_0 = mux(_T_7, io_reqOut_ready, io_reqOut_ready) @[Arbiter.scala 20:13 41:59 42:15]
    node _GEN_1 = mux(_T_7, io_DmemReqOut_valid, io_DmemReqOut_valid) @[Arbiter.scala 20:13 41:59 42:15]
    node _GEN_2 = mux(_T_7, io_DmemReqOut_bits_addrRequest, io_DmemReqOut_bits_addrRequest) @[Arbiter.scala 20:13 41:59 42:15]
    node _GEN_3 = mux(_T_7, io_DmemReqOut_bits_dataRequest, io_DmemReqOut_bits_dataRequest) @[Arbiter.scala 20:13 41:59 42:15]
    node _GEN_4 = mux(_T_7, io_DmemReqOut_bits_activeByteLane, io_DmemReqOut_bits_activeByteLane) @[Arbiter.scala 20:13 41:59 42:15]
    node _GEN_5 = mux(_T_7, io_DmemReqOut_bits_isWrite, io_DmemReqOut_bits_isWrite) @[Arbiter.scala 20:13 41:59 42:15]
    node _GEN_6 = mux(_T_7, io_DmemRspIn_ready, io_DmemRspIn_ready) @[Arbiter.scala 21:16 41:59 43:18]
    node _GEN_7 = mux(_T_7, io_rspIn_valid, io_rspIn_valid) @[Arbiter.scala 21:16 41:59 43:18]
    node _GEN_8 = mux(_T_7, io_rspIn_bits_dataResponse, io_rspIn_bits_dataResponse) @[Arbiter.scala 21:16 41:59 43:18]
    node _GEN_9 = mux(_T_7, io_rspIn_bits_error, io_rspIn_bits_error) @[Arbiter.scala 21:16 41:59 43:18]
    node _GEN_10 = mux(_T_7, UInt<1>("h0"), UInt<1>("h0")) @[Arbiter.scala 22:13 41:59 44:15]
    node _GEN_11 = mux(_T_4, io_reqOut_ready, UInt<1>("h0")) @[Arbiter.scala 37:58 38:15 27:23]
    node _GEN_12 = mux(_T_4, io_ImemReqOut_valid, _GEN_1) @[Arbiter.scala 37:58 38:15]
    node _GEN_13 = mux(_T_4, io_ImemReqOut_bits_addrRequest, _GEN_2) @[Arbiter.scala 37:58 38:15]
    node _GEN_14 = mux(_T_4, io_ImemReqOut_bits_dataRequest, _GEN_3) @[Arbiter.scala 37:58 38:15]
    node _GEN_15 = mux(_T_4, io_ImemReqOut_bits_activeByteLane, _GEN_4) @[Arbiter.scala 37:58 38:15]
    node _GEN_16 = mux(_T_4, io_ImemReqOut_bits_isWrite, _GEN_5) @[Arbiter.scala 37:58 38:15]
    node _GEN_17 = mux(_T_4, io_ImemRspIn_ready, _GEN_6) @[Arbiter.scala 37:58 39:18]
    node _GEN_18 = mux(_T_4, io_rspIn_valid, UInt<1>("h0")) @[Arbiter.scala 37:58 39:18 24:22]
    node _GEN_19 = mux(_T_4, io_rspIn_bits_dataResponse, UInt<1>("h0")) @[Arbiter.scala 37:58 39:18 26:34]
    node _GEN_20 = mux(_T_4, io_rspIn_bits_error, UInt<1>("h0")) @[Arbiter.scala 37:58 39:18 25:27]
    node _GEN_21 = mux(_T_4, UInt<1>("h1"), _GEN_10) @[Arbiter.scala 37:58 40:15]
    node _GEN_22 = mux(_T_4, io_reqOut_ready, _GEN_0) @[Arbiter.scala 20:13 37:58]
    node _GEN_23 = mux(_T_4, io_rspIn_valid, _GEN_7) @[Arbiter.scala 21:16 37:58]
    node _GEN_24 = mux(_T_4, io_rspIn_bits_dataResponse, _GEN_8) @[Arbiter.scala 21:16 37:58]
    node _GEN_25 = mux(_T_4, io_rspIn_bits_error, _GEN_9) @[Arbiter.scala 21:16 37:58]
    node _GEN_26 = mux(_T_2, io_reqOut_ready, _GEN_22) @[Arbiter.scala 33:58 34:15]
    node _GEN_27 = mux(_T_2, io_DmemReqOut_valid, _GEN_12) @[Arbiter.scala 33:58 34:15]
    node _GEN_28 = mux(_T_2, io_DmemReqOut_bits_addrRequest, _GEN_13) @[Arbiter.scala 33:58 34:15]
    node _GEN_29 = mux(_T_2, io_DmemReqOut_bits_dataRequest, _GEN_14) @[Arbiter.scala 33:58 34:15]
    node _GEN_30 = mux(_T_2, io_DmemReqOut_bits_activeByteLane, _GEN_15) @[Arbiter.scala 33:58 34:15]
    node _GEN_31 = mux(_T_2, io_DmemReqOut_bits_isWrite, _GEN_16) @[Arbiter.scala 33:58 34:15]
    node _GEN_32 = mux(_T_2, io_DmemRspIn_ready, _GEN_17) @[Arbiter.scala 33:58 35:18]
    node _GEN_33 = mux(_T_2, io_rspIn_valid, _GEN_23) @[Arbiter.scala 33:58 35:18]
    node _GEN_34 = mux(_T_2, io_rspIn_bits_dataResponse, _GEN_24) @[Arbiter.scala 33:58 35:18]
    node _GEN_35 = mux(_T_2, io_rspIn_bits_error, _GEN_25) @[Arbiter.scala 33:58 35:18]
    node _GEN_36 = mux(_T_2, UInt<1>("h0"), _GEN_21) @[Arbiter.scala 33:58 36:15]
    node _GEN_37 = mux(_T_2, UInt<1>("h0"), _GEN_11) @[Arbiter.scala 27:23 33:58]
    node _GEN_38 = mux(_T_2, UInt<1>("h0"), _GEN_18) @[Arbiter.scala 24:22 33:58]
    node _GEN_39 = mux(_T_2, UInt<1>("h0"), _GEN_19) @[Arbiter.scala 26:34 33:58]
    node _GEN_40 = mux(_T_2, UInt<1>("h0"), _GEN_20) @[Arbiter.scala 25:27 33:58]
    node _GEN_41 = mux(_T, io_reqOut_ready, _GEN_26) @[Arbiter.scala 29:51 30:15]
    node _GEN_42 = mux(_T, io_DmemReqOut_valid, _GEN_27) @[Arbiter.scala 29:51 30:15]
    node _GEN_43 = mux(_T, io_DmemReqOut_bits_addrRequest, _GEN_28) @[Arbiter.scala 29:51 30:15]
    node _GEN_44 = mux(_T, io_DmemReqOut_bits_dataRequest, _GEN_29) @[Arbiter.scala 29:51 30:15]
    node _GEN_45 = mux(_T, io_DmemReqOut_bits_activeByteLane, _GEN_30) @[Arbiter.scala 29:51 30:15]
    node _GEN_46 = mux(_T, io_DmemReqOut_bits_isWrite, _GEN_31) @[Arbiter.scala 29:51 30:15]
    node _GEN_47 = mux(_T, io_DmemRspIn_ready, _GEN_32) @[Arbiter.scala 29:51 31:18]
    node _GEN_48 = mux(_T, io_rspIn_valid, _GEN_33) @[Arbiter.scala 29:51 31:18]
    node _GEN_49 = mux(_T, io_rspIn_bits_dataResponse, _GEN_34) @[Arbiter.scala 29:51 31:18]
    node _GEN_50 = mux(_T, io_rspIn_bits_error, _GEN_35) @[Arbiter.scala 29:51 31:18]
    node _GEN_51 = mux(_T, UInt<1>("h0"), _GEN_36) @[Arbiter.scala 29:51 32:15]
    node _GEN_52 = mux(_T, UInt<1>("h0"), _GEN_37) @[Arbiter.scala 27:23 29:51]
    node _GEN_53 = mux(_T, UInt<1>("h0"), _GEN_38) @[Arbiter.scala 24:22 29:51]
    node _GEN_54 = mux(_T, UInt<1>("h0"), _GEN_39) @[Arbiter.scala 26:34 29:51]
    node _GEN_55 = mux(_T, UInt<1>("h0"), _GEN_40) @[Arbiter.scala 25:27 29:51]
    io_ImemReqOut_ready <= _GEN_52
    io_ImemRspIn_valid <= _GEN_53
    io_ImemRspIn_bits_dataResponse <= _GEN_54
    io_ImemRspIn_bits_error <= _GEN_55
    io_DmemReqOut_ready <= _GEN_41
    io_DmemRspIn_valid <= _GEN_48
    io_DmemRspIn_bits_dataResponse <= _GEN_49
    io_DmemRspIn_bits_error <= _GEN_50
    io_reqOut_valid <= _GEN_42
    io_reqOut_bits_addrRequest <= _GEN_43
    io_reqOut_bits_dataRequest <= _GEN_44
    io_reqOut_bits_activeByteLane <= _GEN_45
    io_reqOut_bits_isWrite <= _GEN_46
    io_rspIn_ready <= _GEN_47
    io_source <= _GEN_51
