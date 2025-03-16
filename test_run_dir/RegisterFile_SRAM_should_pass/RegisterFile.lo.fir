FIRRTL version 1.1.0
circuit RegisterFile :
  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input io_wrAddr : UInt<5>
    input io_wrData : UInt<32>
    input io_wrEna : UInt<1>
    input io_rdAddr1 : UInt<5>
    input io_rdAddr2 : UInt<5>
    output io_rdData1 : UInt<32>
    output io_rdData2 : UInt<32>

    mem regs : @[Functions.scala 193:29]
      data-type => UInt<32>
      depth => 32
      read-latency => 1
      write-latency => 1
      reader => rs1Val_MPORT
      reader => rs2Val_MPORT
      writer => MPORT
      read-under-write => new
    reg debugRegs_0 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_0) @[Functions.scala 194:30]
    reg debugRegs_1 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_1) @[Functions.scala 194:30]
    reg debugRegs_2 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_2) @[Functions.scala 194:30]
    reg debugRegs_3 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_3) @[Functions.scala 194:30]
    reg debugRegs_4 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_4) @[Functions.scala 194:30]
    reg debugRegs_5 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_5) @[Functions.scala 194:30]
    reg debugRegs_6 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_6) @[Functions.scala 194:30]
    reg debugRegs_7 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_7) @[Functions.scala 194:30]
    reg debugRegs_8 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_8) @[Functions.scala 194:30]
    reg debugRegs_9 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_9) @[Functions.scala 194:30]
    reg debugRegs_10 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_10) @[Functions.scala 194:30]
    reg debugRegs_11 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_11) @[Functions.scala 194:30]
    reg debugRegs_12 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_12) @[Functions.scala 194:30]
    reg debugRegs_13 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_13) @[Functions.scala 194:30]
    reg debugRegs_14 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_14) @[Functions.scala 194:30]
    reg debugRegs_15 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_15) @[Functions.scala 194:30]
    reg debugRegs_16 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_16) @[Functions.scala 194:30]
    reg debugRegs_17 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_17) @[Functions.scala 194:30]
    reg debugRegs_18 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_18) @[Functions.scala 194:30]
    reg debugRegs_19 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_19) @[Functions.scala 194:30]
    reg debugRegs_20 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_20) @[Functions.scala 194:30]
    reg debugRegs_21 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_21) @[Functions.scala 194:30]
    reg debugRegs_22 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_22) @[Functions.scala 194:30]
    reg debugRegs_23 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_23) @[Functions.scala 194:30]
    reg debugRegs_24 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_24) @[Functions.scala 194:30]
    reg debugRegs_25 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_25) @[Functions.scala 194:30]
    reg debugRegs_26 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_26) @[Functions.scala 194:30]
    reg debugRegs_27 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_27) @[Functions.scala 194:30]
    reg debugRegs_28 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_28) @[Functions.scala 194:30]
    reg debugRegs_29 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_29) @[Functions.scala 194:30]
    reg debugRegs_30 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_30) @[Functions.scala 194:30]
    reg debugRegs_31 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), debugRegs_31) @[Functions.scala 194:30]
    reg rs1Val_REG : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rs1Val_REG) @[Functions.scala 195:31]
    node _rs1Val_T = eq(rs1Val_REG, UInt<1>("h0")) @[Functions.scala 195:37]
    node _GEN_0 = validif(UInt<1>("h1"), io_rdAddr1) @[Functions.scala 195:{60,60}]
    node _rs1Val_WIRE = _GEN_0 @[Functions.scala 195:60]
    node _rs1Val_T_1 = or(_rs1Val_WIRE, UInt<5>("h0")) @[Functions.scala 195:60]
    node _rs1Val_T_2 = bits(_rs1Val_T_1, 4, 0) @[Functions.scala 195:60]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 193:29 195:{60,60}]
    node _GEN_2 = validif(UInt<1>("h1"), _rs1Val_T_2) @[Functions.scala 195:{60,60}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[Functions.scala 195:{60,60}]
    node rs1Val = mux(_rs1Val_T, UInt<1>("h0"), regs.rs1Val_MPORT.data) @[Functions.scala 195:23]
    reg rs2Val_REG : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rs2Val_REG) @[Functions.scala 196:31]
    node _rs2Val_T = eq(rs2Val_REG, UInt<1>("h0")) @[Functions.scala 196:37]
    node _GEN_4 = validif(UInt<1>("h1"), io_rdAddr2) @[Functions.scala 196:{60,60}]
    node _rs2Val_WIRE = _GEN_4 @[Functions.scala 196:60]
    node _rs2Val_T_1 = or(_rs2Val_WIRE, UInt<5>("h0")) @[Functions.scala 196:60]
    node _rs2Val_T_2 = bits(_rs2Val_T_1, 4, 0) @[Functions.scala 196:60]
    node _GEN_5 = validif(UInt<1>("h1"), _rs2Val_T_2) @[Functions.scala 196:{60,60}]
    node rs2Val = mux(_rs2Val_T, UInt<1>("h0"), regs.rs2Val_MPORT.data) @[Functions.scala 196:23]
    node _T = neq(io_wrAddr, UInt<1>("h0")) @[Functions.scala 197:24]
    node _T_1 = and(io_wrEna, _T) @[Functions.scala 197:18]
    node _debugRegs_io_wrAddr = io_wrData @[Functions.scala 199:{23,23}]
    node _GEN_6 = mux(eq(UInt<1>("h0"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_0) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_7 = mux(eq(UInt<1>("h1"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_1) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_8 = mux(eq(UInt<2>("h2"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_2) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_9 = mux(eq(UInt<2>("h3"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_3) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_10 = mux(eq(UInt<3>("h4"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_4) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_11 = mux(eq(UInt<3>("h5"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_5) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_12 = mux(eq(UInt<3>("h6"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_6) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_13 = mux(eq(UInt<3>("h7"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_7) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_14 = mux(eq(UInt<4>("h8"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_8) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_15 = mux(eq(UInt<4>("h9"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_9) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_16 = mux(eq(UInt<4>("ha"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_10) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_17 = mux(eq(UInt<4>("hb"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_11) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_18 = mux(eq(UInt<4>("hc"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_12) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_19 = mux(eq(UInt<4>("hd"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_13) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_20 = mux(eq(UInt<4>("he"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_14) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_21 = mux(eq(UInt<4>("hf"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_15) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_22 = mux(eq(UInt<5>("h10"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_16) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_23 = mux(eq(UInt<5>("h11"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_17) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_24 = mux(eq(UInt<5>("h12"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_18) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_25 = mux(eq(UInt<5>("h13"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_19) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_26 = mux(eq(UInt<5>("h14"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_20) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_27 = mux(eq(UInt<5>("h15"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_21) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_28 = mux(eq(UInt<5>("h16"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_22) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_29 = mux(eq(UInt<5>("h17"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_23) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_30 = mux(eq(UInt<5>("h18"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_24) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_31 = mux(eq(UInt<5>("h19"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_25) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_32 = mux(eq(UInt<5>("h1a"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_26) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_33 = mux(eq(UInt<5>("h1b"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_27) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_34 = mux(eq(UInt<5>("h1c"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_28) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_35 = mux(eq(UInt<5>("h1d"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_29) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_36 = mux(eq(UInt<5>("h1e"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_30) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_37 = mux(eq(UInt<5>("h1f"), io_wrAddr), _debugRegs_io_wrAddr, debugRegs_31) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_38 = validif(_T_1, io_wrAddr) @[Functions.scala 197:33]
    node _GEN_39 = validif(_T_1, clock) @[Functions.scala 197:33]
    node _GEN_40 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 193:29 197:33]
    node _GEN_41 = validif(_T_1, UInt<1>("h1")) @[Functions.scala 197:33]
    node _GEN_42 = validif(_T_1, io_wrData) @[Functions.scala 197:33]
    node _GEN_43 = mux(_T_1, _GEN_6, debugRegs_0) @[Functions.scala 194:30 197:33]
    node _GEN_44 = mux(_T_1, _GEN_7, debugRegs_1) @[Functions.scala 194:30 197:33]
    node _GEN_45 = mux(_T_1, _GEN_8, debugRegs_2) @[Functions.scala 194:30 197:33]
    node _GEN_46 = mux(_T_1, _GEN_9, debugRegs_3) @[Functions.scala 194:30 197:33]
    node _GEN_47 = mux(_T_1, _GEN_10, debugRegs_4) @[Functions.scala 194:30 197:33]
    node _GEN_48 = mux(_T_1, _GEN_11, debugRegs_5) @[Functions.scala 194:30 197:33]
    node _GEN_49 = mux(_T_1, _GEN_12, debugRegs_6) @[Functions.scala 194:30 197:33]
    node _GEN_50 = mux(_T_1, _GEN_13, debugRegs_7) @[Functions.scala 194:30 197:33]
    node _GEN_51 = mux(_T_1, _GEN_14, debugRegs_8) @[Functions.scala 194:30 197:33]
    node _GEN_52 = mux(_T_1, _GEN_15, debugRegs_9) @[Functions.scala 194:30 197:33]
    node _GEN_53 = mux(_T_1, _GEN_16, debugRegs_10) @[Functions.scala 194:30 197:33]
    node _GEN_54 = mux(_T_1, _GEN_17, debugRegs_11) @[Functions.scala 194:30 197:33]
    node _GEN_55 = mux(_T_1, _GEN_18, debugRegs_12) @[Functions.scala 194:30 197:33]
    node _GEN_56 = mux(_T_1, _GEN_19, debugRegs_13) @[Functions.scala 194:30 197:33]
    node _GEN_57 = mux(_T_1, _GEN_20, debugRegs_14) @[Functions.scala 194:30 197:33]
    node _GEN_58 = mux(_T_1, _GEN_21, debugRegs_15) @[Functions.scala 194:30 197:33]
    node _GEN_59 = mux(_T_1, _GEN_22, debugRegs_16) @[Functions.scala 194:30 197:33]
    node _GEN_60 = mux(_T_1, _GEN_23, debugRegs_17) @[Functions.scala 194:30 197:33]
    node _GEN_61 = mux(_T_1, _GEN_24, debugRegs_18) @[Functions.scala 194:30 197:33]
    node _GEN_62 = mux(_T_1, _GEN_25, debugRegs_19) @[Functions.scala 194:30 197:33]
    node _GEN_63 = mux(_T_1, _GEN_26, debugRegs_20) @[Functions.scala 194:30 197:33]
    node _GEN_64 = mux(_T_1, _GEN_27, debugRegs_21) @[Functions.scala 194:30 197:33]
    node _GEN_65 = mux(_T_1, _GEN_28, debugRegs_22) @[Functions.scala 194:30 197:33]
    node _GEN_66 = mux(_T_1, _GEN_29, debugRegs_23) @[Functions.scala 194:30 197:33]
    node _GEN_67 = mux(_T_1, _GEN_30, debugRegs_24) @[Functions.scala 194:30 197:33]
    node _GEN_68 = mux(_T_1, _GEN_31, debugRegs_25) @[Functions.scala 194:30 197:33]
    node _GEN_69 = mux(_T_1, _GEN_32, debugRegs_26) @[Functions.scala 194:30 197:33]
    node _GEN_70 = mux(_T_1, _GEN_33, debugRegs_27) @[Functions.scala 194:30 197:33]
    node _GEN_71 = mux(_T_1, _GEN_34, debugRegs_28) @[Functions.scala 194:30 197:33]
    node _GEN_72 = mux(_T_1, _GEN_35, debugRegs_29) @[Functions.scala 194:30 197:33]
    node _GEN_73 = mux(_T_1, _GEN_36, debugRegs_30) @[Functions.scala 194:30 197:33]
    node _GEN_74 = mux(_T_1, _GEN_37, debugRegs_31) @[Functions.scala 194:30 197:33]
    node _debugRegs_WIRE_0 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_1 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_2 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_3 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_4 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_5 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_6 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_7 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_8 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_9 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_10 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_11 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_12 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_13 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_14 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_15 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_16 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_17 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_18 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_19 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_20 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_21 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_22 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_23 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_24 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_25 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_26 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_27 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_28 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_29 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_30 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    node _debugRegs_WIRE_31 = UInt<32>("h0") @[Functions.scala 194:{38,38}]
    io_rdData1 <= rs1Val @[RegisterFileTest.scala 36:18]
    io_rdData2 <= rs2Val @[RegisterFileTest.scala 37:18]
    regs.rs1Val_MPORT.addr <= _GEN_2
    regs.rs1Val_MPORT.en <= _GEN_1
    regs.rs1Val_MPORT.clk <= _GEN_3
    regs.rs2Val_MPORT.addr <= _GEN_5
    regs.rs2Val_MPORT.en <= _GEN_1
    regs.rs2Val_MPORT.clk <= _GEN_3
    regs.MPORT.addr <= _GEN_38
    regs.MPORT.en <= _GEN_40
    regs.MPORT.clk <= _GEN_39
    regs.MPORT.data <= _GEN_42
    regs.MPORT.mask <= _GEN_41
    debugRegs_0 <= mux(reset, _debugRegs_WIRE_0, _GEN_43) @[Functions.scala 194:{30,30}]
    debugRegs_1 <= mux(reset, _debugRegs_WIRE_1, _GEN_44) @[Functions.scala 194:{30,30}]
    debugRegs_2 <= mux(reset, _debugRegs_WIRE_2, _GEN_45) @[Functions.scala 194:{30,30}]
    debugRegs_3 <= mux(reset, _debugRegs_WIRE_3, _GEN_46) @[Functions.scala 194:{30,30}]
    debugRegs_4 <= mux(reset, _debugRegs_WIRE_4, _GEN_47) @[Functions.scala 194:{30,30}]
    debugRegs_5 <= mux(reset, _debugRegs_WIRE_5, _GEN_48) @[Functions.scala 194:{30,30}]
    debugRegs_6 <= mux(reset, _debugRegs_WIRE_6, _GEN_49) @[Functions.scala 194:{30,30}]
    debugRegs_7 <= mux(reset, _debugRegs_WIRE_7, _GEN_50) @[Functions.scala 194:{30,30}]
    debugRegs_8 <= mux(reset, _debugRegs_WIRE_8, _GEN_51) @[Functions.scala 194:{30,30}]
    debugRegs_9 <= mux(reset, _debugRegs_WIRE_9, _GEN_52) @[Functions.scala 194:{30,30}]
    debugRegs_10 <= mux(reset, _debugRegs_WIRE_10, _GEN_53) @[Functions.scala 194:{30,30}]
    debugRegs_11 <= mux(reset, _debugRegs_WIRE_11, _GEN_54) @[Functions.scala 194:{30,30}]
    debugRegs_12 <= mux(reset, _debugRegs_WIRE_12, _GEN_55) @[Functions.scala 194:{30,30}]
    debugRegs_13 <= mux(reset, _debugRegs_WIRE_13, _GEN_56) @[Functions.scala 194:{30,30}]
    debugRegs_14 <= mux(reset, _debugRegs_WIRE_14, _GEN_57) @[Functions.scala 194:{30,30}]
    debugRegs_15 <= mux(reset, _debugRegs_WIRE_15, _GEN_58) @[Functions.scala 194:{30,30}]
    debugRegs_16 <= mux(reset, _debugRegs_WIRE_16, _GEN_59) @[Functions.scala 194:{30,30}]
    debugRegs_17 <= mux(reset, _debugRegs_WIRE_17, _GEN_60) @[Functions.scala 194:{30,30}]
    debugRegs_18 <= mux(reset, _debugRegs_WIRE_18, _GEN_61) @[Functions.scala 194:{30,30}]
    debugRegs_19 <= mux(reset, _debugRegs_WIRE_19, _GEN_62) @[Functions.scala 194:{30,30}]
    debugRegs_20 <= mux(reset, _debugRegs_WIRE_20, _GEN_63) @[Functions.scala 194:{30,30}]
    debugRegs_21 <= mux(reset, _debugRegs_WIRE_21, _GEN_64) @[Functions.scala 194:{30,30}]
    debugRegs_22 <= mux(reset, _debugRegs_WIRE_22, _GEN_65) @[Functions.scala 194:{30,30}]
    debugRegs_23 <= mux(reset, _debugRegs_WIRE_23, _GEN_66) @[Functions.scala 194:{30,30}]
    debugRegs_24 <= mux(reset, _debugRegs_WIRE_24, _GEN_67) @[Functions.scala 194:{30,30}]
    debugRegs_25 <= mux(reset, _debugRegs_WIRE_25, _GEN_68) @[Functions.scala 194:{30,30}]
    debugRegs_26 <= mux(reset, _debugRegs_WIRE_26, _GEN_69) @[Functions.scala 194:{30,30}]
    debugRegs_27 <= mux(reset, _debugRegs_WIRE_27, _GEN_70) @[Functions.scala 194:{30,30}]
    debugRegs_28 <= mux(reset, _debugRegs_WIRE_28, _GEN_71) @[Functions.scala 194:{30,30}]
    debugRegs_29 <= mux(reset, _debugRegs_WIRE_29, _GEN_72) @[Functions.scala 194:{30,30}]
    debugRegs_30 <= mux(reset, _debugRegs_WIRE_30, _GEN_73) @[Functions.scala 194:{30,30}]
    debugRegs_31 <= mux(reset, _debugRegs_WIRE_31, _GEN_74) @[Functions.scala 194:{30,30}]
    rs1Val_REG <= io_rdAddr1 @[Functions.scala 195:31]
    rs2Val_REG <= io_rdAddr2 @[Functions.scala 196:31]
