FIRRTL version 1.1.0
circuit WildcatTestTop :
  module ThreeCats :
    input clock : Clock
    input reset : UInt<1>
    output io_imem_address : UInt<32>
    input io_imem_data : UInt<32>
    input io_imem_stall : UInt<1>
    output io_dmem_rdAddress : UInt<32>
    input io_dmem_rdData : UInt<32>
    output io_dmem_rdEnable : UInt<1>
    output io_dmem_wrAddress : UInt<32>
    output io_dmem_wrData : UInt<32>
    output io_dmem_wrEnable_0 : UInt<1>
    output io_dmem_wrEnable_1 : UInt<1>
    output io_dmem_wrEnable_2 : UInt<1>
    output io_dmem_wrEnable_3 : UInt<1>
    input io_dmem_stall : UInt<1>
    output decExReg_decOut_isECall : UInt<1>
    output debugRegs_0_0 : UInt<32>
    output debugRegs_0_1 : UInt<32>
    output debugRegs_0_2 : UInt<32>
    output debugRegs_0_3 : UInt<32>
    output debugRegs_0_4 : UInt<32>
    output debugRegs_0_5 : UInt<32>
    output debugRegs_0_6 : UInt<32>
    output debugRegs_0_7 : UInt<32>
    output debugRegs_0_8 : UInt<32>
    output debugRegs_0_9 : UInt<32>
    output debugRegs_0_10 : UInt<32>
    output debugRegs_0_11 : UInt<32>
    output debugRegs_0_12 : UInt<32>
    output debugRegs_0_13 : UInt<32>
    output debugRegs_0_14 : UInt<32>
    output debugRegs_0_15 : UInt<32>
    output debugRegs_0_16 : UInt<32>
    output debugRegs_0_17 : UInt<32>
    output debugRegs_0_18 : UInt<32>
    output debugRegs_0_19 : UInt<32>
    output debugRegs_0_20 : UInt<32>
    output debugRegs_0_21 : UInt<32>
    output debugRegs_0_22 : UInt<32>
    output debugRegs_0_23 : UInt<32>
    output debugRegs_0_24 : UInt<32>
    output debugRegs_0_25 : UInt<32>
    output debugRegs_0_26 : UInt<32>
    output debugRegs_0_27 : UInt<32>
    output debugRegs_0_28 : UInt<32>
    output debugRegs_0_29 : UInt<32>
    output debugRegs_0_30 : UInt<32>
    output debugRegs_0_31 : UInt<32>

    mem regs : @[Functions.scala 193:29]
      data-type => UInt<32>
      depth => 32
      read-latency => 1
      write-latency => 1
      reader => rs1Val_MPORT
      reader => rs2Val_MPORT
      writer => MPORT
      read-under-write => new
    reg exFwdReg_valid : UInt<1>, clock with :
      reset => (UInt<1>("h0"), exFwdReg_valid) @[ThreeCats.scala 36:25]
    reg exFwdReg_wbDest : UInt<5>, clock with :
      reset => (UInt<1>("h0"), exFwdReg_wbDest) @[ThreeCats.scala 36:25]
    reg exFwdReg_wbData : UInt<32>, clock with :
      reset => (UInt<1>("h0"), exFwdReg_wbData) @[ThreeCats.scala 36:25]
    node _pcReg_T = asUInt(asSInt(UInt<32>("h0"))) @[ThreeCats.scala 41:33]
    reg pcReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pcReg) @[ThreeCats.scala 41:22]
    node _pcNext_T = add(pcReg, UInt<3>("h4")) @[ThreeCats.scala 42:62]
    node _pcNext_T_1 = tail(_pcNext_T, 1) @[ThreeCats.scala 42:62]
    reg decExReg__func3 : UInt<3>, clock with :
      reset => (UInt<1>("h0"), decExReg__func3) @[ThreeCats.scala 109:25]
    node _doBranch_T = eq(UInt<1>("h0"), decExReg__func3) @[Functions.scala 142:20]
    reg decExReg__rs1 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), decExReg__rs1) @[ThreeCats.scala 109:25]
    node _v1_T = eq(exFwdReg_wbDest, decExReg__rs1) @[ThreeCats.scala 113:50]
    node _v1_T_1 = and(exFwdReg_valid, _v1_T) @[ThreeCats.scala 113:31]
    reg decExReg__rs1Val : UInt<32>, clock with :
      reset => (UInt<1>("h0"), decExReg__rs1Val) @[ThreeCats.scala 109:25]
    node v1 = mux(_v1_T_1, exFwdReg_wbData, decExReg__rs1Val) @[ThreeCats.scala 113:15]
    reg decExReg__rs2 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), decExReg__rs2) @[ThreeCats.scala 109:25]
    node _v2_T = eq(exFwdReg_wbDest, decExReg__rs2) @[ThreeCats.scala 114:50]
    node _v2_T_1 = and(exFwdReg_valid, _v2_T) @[ThreeCats.scala 114:31]
    reg decExReg__rs2Val : UInt<32>, clock with :
      reset => (UInt<1>("h0"), decExReg__rs2Val) @[ThreeCats.scala 109:25]
    node v2 = mux(_v2_T_1, exFwdReg_wbData, decExReg__rs2Val) @[ThreeCats.scala 114:15]
    node _doBranch_res_T = eq(v1, v2) @[Functions.scala 144:20]
    node _doBranch_T_1 = eq(UInt<1>("h1"), decExReg__func3) @[Functions.scala 142:20]
    node _doBranch_res_T_1 = neq(v1, v2) @[Functions.scala 147:20]
    node _doBranch_T_2 = eq(UInt<3>("h4"), decExReg__func3) @[Functions.scala 142:20]
    node _doBranch_res_T_2 = asSInt(v1) @[Functions.scala 150:20]
    node _doBranch_res_T_3 = asSInt(v2) @[Functions.scala 150:33]
    node _doBranch_res_T_4 = lt(_doBranch_res_T_2, _doBranch_res_T_3) @[Functions.scala 150:27]
    node _doBranch_T_3 = eq(UInt<3>("h5"), decExReg__func3) @[Functions.scala 142:20]
    node _doBranch_res_T_5 = asSInt(v1) @[Functions.scala 153:20]
    node _doBranch_res_T_6 = asSInt(v2) @[Functions.scala 153:34]
    node _doBranch_res_T_7 = geq(_doBranch_res_T_5, _doBranch_res_T_6) @[Functions.scala 153:27]
    node _doBranch_T_4 = eq(UInt<3>("h6"), decExReg__func3) @[Functions.scala 142:20]
    node _doBranch_res_T_8 = lt(v1, v2) @[Functions.scala 156:20]
    node _doBranch_T_5 = eq(UInt<3>("h7"), decExReg__func3) @[Functions.scala 142:20]
    node _doBranch_res_T_9 = geq(v1, v2) @[Functions.scala 159:20]
    node _GEN_221 = mux(_doBranch_T_5, _doBranch_res_T_9, UInt<1>("h0")) @[Functions.scala 142:20 159:13 141:9]
    node _GEN_222 = mux(_doBranch_T_4, _doBranch_res_T_8, _GEN_221) @[Functions.scala 142:20 156:13]
    node _GEN_223 = mux(_doBranch_T_3, _doBranch_res_T_7, _GEN_222) @[Functions.scala 142:20 153:13]
    node _GEN_224 = mux(_doBranch_T_2, _doBranch_res_T_4, _GEN_223) @[Functions.scala 142:20 150:13]
    node _GEN_225 = mux(_doBranch_T_1, _doBranch_res_T_1, _GEN_224) @[Functions.scala 142:20 147:13]
    node _GEN_226 = mux(_doBranch_T, _doBranch_res_T, _GEN_225) @[Functions.scala 142:20 144:13]
    node doBranch_res = _GEN_226 @[Functions.scala 140:19]
    reg decExReg__decOut_isBranch : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isBranch) @[ThreeCats.scala 109:25]
    node _doBranch_T_6 = and(doBranch_res, decExReg__decOut_isBranch) @[ThreeCats.scala 136:49]
    reg decExReg__decOut_isJal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isJal) @[ThreeCats.scala 109:25]
    node _doBranch_T_7 = or(_doBranch_T_6, decExReg__decOut_isJal) @[ThreeCats.scala 136:78]
    reg decExReg__decOut_isJalr : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isJalr) @[ThreeCats.scala 109:25]
    node _doBranch_T_8 = or(_doBranch_T_7, decExReg__decOut_isJalr) @[ThreeCats.scala 136:103]
    reg decExReg__valid : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__valid) @[ThreeCats.scala 109:25]
    node _doBranch_T_9 = and(_doBranch_T_8, decExReg__valid) @[ThreeCats.scala 136:130]
    node doBranch = _doBranch_T_9 @[ThreeCats.scala 136:12 27:29]
    reg decExReg__decOut_isLoad : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isLoad) @[ThreeCats.scala 109:25]
    node _T_13 = eq(doBranch, UInt<1>("h0")) @[ThreeCats.scala 140:34]
    node _T_14 = and(decExReg__decOut_isLoad, _T_13) @[ThreeCats.scala 140:31]
    node _res_T_16 = eq(UInt<1>("h0"), decExReg__func3) @[Functions.scala 256:19]
    reg decExReg__memLow : UInt<2>, clock with :
      reset => (UInt<1>("h0"), decExReg__memLow) @[ThreeCats.scala 109:25]
    node _res_T_17 = eq(UInt<1>("h0"), decExReg__memLow) @[Functions.scala 258:24]
    node _res_res_T_19 = bits(io_dmem_rdData, 7, 7) @[Functions.scala 260:33]
    node _res_res_T_20 = bits(_res_res_T_19, 0, 0) @[Bitwise.scala 77:15]
    node _res_res_T_21 = mux(_res_res_T_20, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 77:12]
    node _res_res_T_22 = bits(io_dmem_rdData, 7, 0) @[Functions.scala 260:45]
    node _res_res_T_23 = cat(_res_res_T_21, _res_res_T_22) @[Functions.scala 260:38]
    node _res_T_18 = eq(UInt<1>("h1"), decExReg__memLow) @[Functions.scala 258:24]
    node _res_res_T_24 = bits(io_dmem_rdData, 15, 15) @[Functions.scala 263:33]
    node _res_res_T_25 = bits(_res_res_T_24, 0, 0) @[Bitwise.scala 77:15]
    node _res_res_T_26 = mux(_res_res_T_25, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 77:12]
    node _res_res_T_27 = bits(io_dmem_rdData, 15, 8) @[Functions.scala 263:46]
    node _res_res_T_28 = cat(_res_res_T_26, _res_res_T_27) @[Functions.scala 263:39]
    node _res_T_19 = eq(UInt<2>("h2"), decExReg__memLow) @[Functions.scala 258:24]
    node _res_res_T_29 = bits(io_dmem_rdData, 23, 23) @[Functions.scala 266:33]
    node _res_res_T_30 = bits(_res_res_T_29, 0, 0) @[Bitwise.scala 77:15]
    node _res_res_T_31 = mux(_res_res_T_30, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 77:12]
    node _res_res_T_32 = bits(io_dmem_rdData, 23, 16) @[Functions.scala 266:46]
    node _res_res_T_33 = cat(_res_res_T_31, _res_res_T_32) @[Functions.scala 266:39]
    node _res_T_20 = eq(UInt<2>("h3"), decExReg__memLow) @[Functions.scala 258:24]
    node _res_res_T_34 = bits(io_dmem_rdData, 31, 31) @[Functions.scala 270:33]
    node _res_res_T_35 = bits(_res_res_T_34, 0, 0) @[Bitwise.scala 77:15]
    node _res_res_T_36 = mux(_res_res_T_35, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 77:12]
    node _res_res_T_37 = bits(io_dmem_rdData, 31, 24) @[Functions.scala 270:46]
    node _res_res_T_38 = cat(_res_res_T_36, _res_res_T_37) @[Functions.scala 270:39]
    node _GEN_227 = mux(_res_T_20, _res_res_T_38, io_dmem_rdData) @[Functions.scala 258:24 270:17 255:9]
    node _GEN_228 = mux(_res_T_19, _res_res_T_33, _GEN_227) @[Functions.scala 258:24 266:17]
    node _GEN_229 = mux(_res_T_18, _res_res_T_28, _GEN_228) @[Functions.scala 258:24 263:17]
    node _GEN_230 = mux(_res_T_17, _res_res_T_23, _GEN_229) @[Functions.scala 258:24 260:17]
    node _res_T_21 = eq(UInt<1>("h1"), decExReg__func3) @[Functions.scala 256:19]
    node _res_T_22 = eq(UInt<1>("h0"), decExReg__memLow) @[Functions.scala 275:24]
    node _res_res_T_39 = bits(io_dmem_rdData, 15, 15) @[Functions.scala 277:33]
    node _res_res_T_40 = bits(_res_res_T_39, 0, 0) @[Bitwise.scala 77:15]
    node _res_res_T_41 = mux(_res_res_T_40, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 77:12]
    node _res_res_T_42 = bits(io_dmem_rdData, 15, 0) @[Functions.scala 277:46]
    node _res_res_T_43 = cat(_res_res_T_41, _res_res_T_42) @[Functions.scala 277:39]
    node _res_T_23 = eq(UInt<2>("h2"), decExReg__memLow) @[Functions.scala 275:24]
    node _res_res_T_44 = bits(io_dmem_rdData, 31, 31) @[Functions.scala 280:33]
    node _res_res_T_45 = bits(_res_res_T_44, 0, 0) @[Bitwise.scala 77:15]
    node _res_res_T_46 = mux(_res_res_T_45, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 77:12]
    node _res_res_T_47 = bits(io_dmem_rdData, 31, 16) @[Functions.scala 280:46]
    node _res_res_T_48 = cat(_res_res_T_46, _res_res_T_47) @[Functions.scala 280:39]
    node _GEN_231 = mux(_res_T_23, _res_res_T_48, io_dmem_rdData) @[Functions.scala 275:24 280:17 255:9]
    node _GEN_232 = mux(_res_T_22, _res_res_T_43, _GEN_231) @[Functions.scala 275:24 277:17]
    node _res_T_24 = eq(UInt<3>("h4"), decExReg__func3) @[Functions.scala 256:19]
    node _res_T_25 = eq(UInt<1>("h0"), decExReg__memLow) @[Functions.scala 285:24]
    node _res_res_T_49 = bits(io_dmem_rdData, 7, 0) @[Functions.scala 287:24]
    node _res_T_26 = eq(UInt<1>("h1"), decExReg__memLow) @[Functions.scala 285:24]
    node _res_res_T_50 = bits(io_dmem_rdData, 15, 8) @[Functions.scala 290:24]
    node _res_T_27 = eq(UInt<2>("h2"), decExReg__memLow) @[Functions.scala 285:24]
    node _res_res_T_51 = bits(io_dmem_rdData, 23, 16) @[Functions.scala 293:24]
    node _res_T_28 = eq(UInt<2>("h3"), decExReg__memLow) @[Functions.scala 285:24]
    node _res_res_T_52 = bits(io_dmem_rdData, 31, 24) @[Functions.scala 296:24]
    node _GEN_233 = mux(_res_T_28, _res_res_T_52, io_dmem_rdData) @[Functions.scala 285:24 296:17 255:9]
    node _GEN_234 = mux(_res_T_27, _res_res_T_51, _GEN_233) @[Functions.scala 285:24 293:17]
    node _GEN_235 = mux(_res_T_26, _res_res_T_50, _GEN_234) @[Functions.scala 285:24 290:17]
    node _GEN_236 = mux(_res_T_25, _res_res_T_49, _GEN_235) @[Functions.scala 285:24 287:17]
    node _res_T_29 = eq(UInt<3>("h5"), decExReg__func3) @[Functions.scala 256:19]
    node _res_T_30 = eq(UInt<1>("h0"), decExReg__memLow) @[Functions.scala 301:24]
    node _res_res_T_53 = bits(io_dmem_rdData, 15, 0) @[Functions.scala 303:24]
    node _res_T_31 = eq(UInt<2>("h2"), decExReg__memLow) @[Functions.scala 301:24]
    node _res_res_T_54 = bits(io_dmem_rdData, 31, 16) @[Functions.scala 306:24]
    node _GEN_237 = mux(_res_T_31, _res_res_T_54, io_dmem_rdData) @[Functions.scala 301:24 306:17 255:9]
    node _GEN_238 = mux(_res_T_30, _res_res_T_53, _GEN_237) @[Functions.scala 301:24 303:17]
    node _GEN_239 = mux(_res_T_29, _GEN_238, io_dmem_rdData) @[Functions.scala 256:19 255:9]
    node _GEN_240 = mux(_res_T_24, _GEN_236, _GEN_239) @[Functions.scala 256:19]
    node _GEN_241 = mux(_res_T_21, _GEN_232, _GEN_240) @[Functions.scala 256:19]
    node _GEN_242 = mux(_res_T_16, _GEN_230, _GEN_241) @[Functions.scala 256:19]
    node res_res_1 = _GEN_242 @[Functions.scala 254:19]
    reg decExReg__decOut_isAuiPc : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isAuiPc) @[ThreeCats.scala 109:25]
    reg decExReg__pc : UInt<32>, clock with :
      reset => (UInt<1>("h0"), decExReg__pc) @[ThreeCats.scala 109:25]
    node _res_T_11 = asSInt(decExReg__pc) @[ThreeCats.scala 123:25]
    reg decExReg__decOut_imm : SInt<32>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_imm) @[ThreeCats.scala 109:25]
    node _res_T_12 = add(_res_T_11, decExReg__decOut_imm) @[ThreeCats.scala 123:32]
    node _res_T_13 = tail(_res_T_12, 1) @[ThreeCats.scala 123:32]
    node _res_T_14 = asSInt(_res_T_13) @[ThreeCats.scala 123:32]
    node _res_T_15 = asUInt(_res_T_14) @[ThreeCats.scala 123:55]
    reg decExReg__decOut_isLui : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isLui) @[ThreeCats.scala 109:25]
    node _res_T_10 = asUInt(decExReg__decOut_imm) @[ThreeCats.scala 120:32]
    reg decExReg__decOut_aluOp : UInt<4>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_aluOp) @[ThreeCats.scala 109:25]
    node _res_T = eq(UInt<1>("h0"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    reg decExReg__decOut_isImm : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isImm) @[ThreeCats.scala 109:25]
    node _val2_T = asUInt(decExReg__decOut_imm) @[ThreeCats.scala 117:61]
    node val2 = mux(decExReg__decOut_isImm, _val2_T, v2) @[ThreeCats.scala 117:17]
    node _res_res_T = add(v1, val2) @[Functions.scala 220:18]
    node _res_res_T_1 = tail(_res_res_T, 1) @[Functions.scala 220:18]
    node _res_T_1 = eq(UInt<1>("h1"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_2 = sub(v1, val2) @[Functions.scala 223:18]
    node _res_res_T_3 = tail(_res_res_T_2, 1) @[Functions.scala 223:18]
    node _res_T_2 = eq(UInt<4>("h9"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_4 = and(v1, val2) @[Functions.scala 226:18]
    node _res_T_3 = eq(UInt<4>("h8"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_5 = or(v1, val2) @[Functions.scala 229:18]
    node _res_T_4 = eq(UInt<3>("h5"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_6 = xor(v1, val2) @[Functions.scala 232:18]
    node _res_T_5 = eq(UInt<2>("h2"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_7 = bits(val2, 4, 0) @[Functions.scala 235:22]
    node _res_res_T_8 = dshl(v1, _res_res_T_7) @[Functions.scala 235:18]
    node _res_T_6 = eq(UInt<3>("h6"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_9 = bits(val2, 4, 0) @[Functions.scala 238:22]
    node _res_res_T_10 = dshr(v1, _res_res_T_9) @[Functions.scala 238:18]
    node _res_T_7 = eq(UInt<3>("h7"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_11 = asSInt(v1) @[Functions.scala 241:19]
    node _res_res_T_12 = bits(val2, 4, 0) @[Functions.scala 241:30]
    node _res_res_T_13 = dshr(_res_res_T_11, _res_res_T_12) @[Functions.scala 241:26]
    node _res_res_T_14 = asUInt(_res_res_T_13) @[Functions.scala 241:38]
    node _res_T_8 = eq(UInt<2>("h3"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_15 = asSInt(v1) @[Functions.scala 244:19]
    node _res_res_T_16 = asSInt(val2) @[Functions.scala 244:30]
    node _res_res_T_17 = lt(_res_res_T_15, _res_res_T_16) @[Functions.scala 244:26]
    node _res_T_9 = eq(UInt<3>("h4"), decExReg__decOut_aluOp) @[Functions.scala 218:16]
    node _res_res_T_18 = lt(v1, val2) @[Functions.scala 247:19]
    node _GEN_207 = validif(_res_T_9, _res_res_T_18) @[Functions.scala 218:16 247:13]
    node _GEN_208 = mux(_res_T_8, _res_res_T_17, _GEN_207) @[Functions.scala 218:16 244:13]
    node _GEN_209 = mux(_res_T_7, _res_res_T_14, _GEN_208) @[Functions.scala 218:16 241:13]
    node _GEN_210 = mux(_res_T_6, _res_res_T_10, _GEN_209) @[Functions.scala 218:16 238:13]
    node _GEN_211 = mux(_res_T_5, _res_res_T_8, _GEN_210) @[Functions.scala 218:16 235:13]
    node _GEN_212 = mux(_res_T_4, _res_res_T_6, _GEN_211) @[Functions.scala 218:16 232:13]
    node _GEN_213 = mux(_res_T_3, _res_res_T_5, _GEN_212) @[Functions.scala 218:16 229:13]
    node _GEN_214 = mux(_res_T_2, _res_res_T_4, _GEN_213) @[Functions.scala 218:16 226:13]
    node _GEN_215 = mux(_res_T_1, _res_res_T_3, _GEN_214) @[Functions.scala 218:16 223:13]
    node _GEN_216 = mux(_res_T, _res_res_T_1, _GEN_215) @[Functions.scala 218:16 220:13]
    node res_res = bits(_GEN_216, 31, 0) @[Functions.scala 216:19]
    node _GEN_217 = mux(decExReg__decOut_isLui, _res_T_10, res_res) @[ThreeCats.scala 119:31 118:7 120:9]
    node _GEN_218 = mux(decExReg__decOut_isAuiPc, _res_T_15, _GEN_217) @[ThreeCats.scala 122:33 123:9]
    node _GEN_243 = mux(_T_14, res_res_1, _GEN_218) @[ThreeCats.scala 140:45 141:9]
    node res = _GEN_243 @[ThreeCats.scala 116:17]
    node _branchTarget_T = asSInt(decExReg__pc) @[ThreeCats.scala 132:32]
    node _branchTarget_T_1 = add(_branchTarget_T, decExReg__decOut_imm) @[ThreeCats.scala 132:39]
    node _branchTarget_T_2 = tail(_branchTarget_T_1, 1) @[ThreeCats.scala 132:39]
    node _branchTarget_T_3 = asSInt(_branchTarget_T_2) @[ThreeCats.scala 132:39]
    node _branchTarget_T_4 = asUInt(_branchTarget_T_3) @[ThreeCats.scala 132:62]
    node _GEN_220 = mux(decExReg__decOut_isJalr, res, _branchTarget_T_4) @[ThreeCats.scala 132:16 133:32 134:18]
    node branchTarget = _GEN_220 @[ThreeCats.scala 28:33]
    node _pcNext_T_2 = mux(doBranch, branchTarget, _pcNext_T_1) @[ThreeCats.scala 42:31]
    node _GEN_0 = mux(io_imem_stall, UInt<5>("h13"), io_imem_data) @[ThreeCats.scala 48:24 49:11 47:26]
    node _GEN_1 = mux(io_imem_stall, pcReg, _pcNext_T_2) @[ThreeCats.scala 48:24 50:12 42:27]
    reg pcRegReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pcRegReg) @[ThreeCats.scala 54:25]
    reg instrReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), instrReg) @[ThreeCats.scala 55:25]
    node instr = _GEN_0 @[ThreeCats.scala 47:26]
    node _instrReg_T = mux(doBranch, UInt<6>("h33"), instr) @[ThreeCats.scala 56:18]
    node rs1 = bits(instr, 19, 15) @[ThreeCats.scala 57:18]
    node rs2 = bits(instr, 24, 20) @[ThreeCats.scala 58:18]
    node rd = bits(instr, 11, 7) @[ThreeCats.scala 59:17]
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
    node _GEN_2 = validif(UInt<1>("h1"), rs1) @[Functions.scala 195:{60,60}]
    node _rs1Val_WIRE = _GEN_2 @[Functions.scala 195:60]
    node _rs1Val_T_1 = or(_rs1Val_WIRE, UInt<5>("h0")) @[Functions.scala 195:60]
    node _rs1Val_T_2 = bits(_rs1Val_T_1, 4, 0) @[Functions.scala 195:60]
    node _GEN_3 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 193:29 195:{60,60}]
    node _GEN_4 = validif(UInt<1>("h1"), _rs1Val_T_2) @[Functions.scala 195:{60,60}]
    node _GEN_5 = validif(UInt<1>("h1"), clock) @[Functions.scala 195:{60,60}]
    node rs1Val = mux(_rs1Val_T, UInt<1>("h0"), regs.rs1Val_MPORT.data) @[Functions.scala 195:23]
    reg rs2Val_REG : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rs2Val_REG) @[Functions.scala 196:31]
    node _rs2Val_T = eq(rs2Val_REG, UInt<1>("h0")) @[Functions.scala 196:37]
    node _GEN_6 = validif(UInt<1>("h1"), rs2) @[Functions.scala 196:{60,60}]
    node _rs2Val_WIRE = _GEN_6 @[Functions.scala 196:60]
    node _rs2Val_T_1 = or(_rs2Val_WIRE, UInt<5>("h0")) @[Functions.scala 196:60]
    node _rs2Val_T_2 = bits(_rs2Val_T_1, 4, 0) @[Functions.scala 196:60]
    node _GEN_7 = validif(UInt<1>("h1"), _rs2Val_T_2) @[Functions.scala 196:{60,60}]
    node rs2Val = mux(_rs2Val_T, UInt<1>("h0"), regs.rs2Val_MPORT.data) @[Functions.scala 196:23]
    reg decExReg__rd : UInt<5>, clock with :
      reset => (UInt<1>("h0"), decExReg__rd) @[ThreeCats.scala 109:25]
    node wbDest = decExReg__rd @[ThreeCats.scala 126:10 24:20]
    node _T = neq(wbDest, UInt<1>("h0")) @[Functions.scala 197:24]
    reg decExReg__decOut_rfWrite : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_rfWrite) @[ThreeCats.scala 109:25]
    node _wrEna_T = and(decExReg__valid, decExReg__decOut_rfWrite) @[ThreeCats.scala 137:27]
    node wrEna = _wrEna_T @[ThreeCats.scala 25:26 137:9]
    node _T_1 = and(wrEna, _T) @[Functions.scala 197:18]
    node _T_12 = or(decExReg__decOut_isJal, decExReg__decOut_isJalr) @[ThreeCats.scala 128:30]
    node _wbData_T = add(decExReg__pc, UInt<3>("h4")) @[ThreeCats.scala 129:27]
    node _wbData_T_1 = tail(_wbData_T, 1) @[ThreeCats.scala 129:27]
    node _GEN_219 = mux(_T_12, _wbData_T_1, res) @[ThreeCats.scala 127:10 128:57 129:12]
    node wbData = _GEN_219 @[ThreeCats.scala 23:20]
    node _debugRegs_wbDest = wbData @[Functions.scala 199:{23,23}]
    node _GEN_8 = mux(eq(UInt<1>("h0"), wbDest), _debugRegs_wbDest, debugRegs_0) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_9 = mux(eq(UInt<1>("h1"), wbDest), _debugRegs_wbDest, debugRegs_1) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_10 = mux(eq(UInt<2>("h2"), wbDest), _debugRegs_wbDest, debugRegs_2) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_11 = mux(eq(UInt<2>("h3"), wbDest), _debugRegs_wbDest, debugRegs_3) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_12 = mux(eq(UInt<3>("h4"), wbDest), _debugRegs_wbDest, debugRegs_4) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_13 = mux(eq(UInt<3>("h5"), wbDest), _debugRegs_wbDest, debugRegs_5) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_14 = mux(eq(UInt<3>("h6"), wbDest), _debugRegs_wbDest, debugRegs_6) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_15 = mux(eq(UInt<3>("h7"), wbDest), _debugRegs_wbDest, debugRegs_7) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_16 = mux(eq(UInt<4>("h8"), wbDest), _debugRegs_wbDest, debugRegs_8) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_17 = mux(eq(UInt<4>("h9"), wbDest), _debugRegs_wbDest, debugRegs_9) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_18 = mux(eq(UInt<4>("ha"), wbDest), _debugRegs_wbDest, debugRegs_10) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_19 = mux(eq(UInt<4>("hb"), wbDest), _debugRegs_wbDest, debugRegs_11) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_20 = mux(eq(UInt<4>("hc"), wbDest), _debugRegs_wbDest, debugRegs_12) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_21 = mux(eq(UInt<4>("hd"), wbDest), _debugRegs_wbDest, debugRegs_13) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_22 = mux(eq(UInt<4>("he"), wbDest), _debugRegs_wbDest, debugRegs_14) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_23 = mux(eq(UInt<4>("hf"), wbDest), _debugRegs_wbDest, debugRegs_15) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_24 = mux(eq(UInt<5>("h10"), wbDest), _debugRegs_wbDest, debugRegs_16) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_25 = mux(eq(UInt<5>("h11"), wbDest), _debugRegs_wbDest, debugRegs_17) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_26 = mux(eq(UInt<5>("h12"), wbDest), _debugRegs_wbDest, debugRegs_18) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_27 = mux(eq(UInt<5>("h13"), wbDest), _debugRegs_wbDest, debugRegs_19) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_28 = mux(eq(UInt<5>("h14"), wbDest), _debugRegs_wbDest, debugRegs_20) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_29 = mux(eq(UInt<5>("h15"), wbDest), _debugRegs_wbDest, debugRegs_21) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_30 = mux(eq(UInt<5>("h16"), wbDest), _debugRegs_wbDest, debugRegs_22) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_31 = mux(eq(UInt<5>("h17"), wbDest), _debugRegs_wbDest, debugRegs_23) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_32 = mux(eq(UInt<5>("h18"), wbDest), _debugRegs_wbDest, debugRegs_24) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_33 = mux(eq(UInt<5>("h19"), wbDest), _debugRegs_wbDest, debugRegs_25) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_34 = mux(eq(UInt<5>("h1a"), wbDest), _debugRegs_wbDest, debugRegs_26) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_35 = mux(eq(UInt<5>("h1b"), wbDest), _debugRegs_wbDest, debugRegs_27) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_36 = mux(eq(UInt<5>("h1c"), wbDest), _debugRegs_wbDest, debugRegs_28) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_37 = mux(eq(UInt<5>("h1d"), wbDest), _debugRegs_wbDest, debugRegs_29) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_38 = mux(eq(UInt<5>("h1e"), wbDest), _debugRegs_wbDest, debugRegs_30) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_39 = mux(eq(UInt<5>("h1f"), wbDest), _debugRegs_wbDest, debugRegs_31) @[Functions.scala 199:{23,23} 194:30]
    node _GEN_40 = validif(_T_1, wbDest) @[Functions.scala 197:33]
    node _GEN_41 = validif(_T_1, clock) @[Functions.scala 197:33]
    node _GEN_42 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 193:29 197:33]
    node _GEN_43 = validif(_T_1, UInt<1>("h1")) @[Functions.scala 197:33]
    node _GEN_44 = validif(_T_1, wbData) @[Functions.scala 197:33]
    node _GEN_45 = mux(_T_1, _GEN_8, debugRegs_0) @[Functions.scala 194:30 197:33]
    node _GEN_46 = mux(_T_1, _GEN_9, debugRegs_1) @[Functions.scala 194:30 197:33]
    node _GEN_47 = mux(_T_1, _GEN_10, debugRegs_2) @[Functions.scala 194:30 197:33]
    node _GEN_48 = mux(_T_1, _GEN_11, debugRegs_3) @[Functions.scala 194:30 197:33]
    node _GEN_49 = mux(_T_1, _GEN_12, debugRegs_4) @[Functions.scala 194:30 197:33]
    node _GEN_50 = mux(_T_1, _GEN_13, debugRegs_5) @[Functions.scala 194:30 197:33]
    node _GEN_51 = mux(_T_1, _GEN_14, debugRegs_6) @[Functions.scala 194:30 197:33]
    node _GEN_52 = mux(_T_1, _GEN_15, debugRegs_7) @[Functions.scala 194:30 197:33]
    node _GEN_53 = mux(_T_1, _GEN_16, debugRegs_8) @[Functions.scala 194:30 197:33]
    node _GEN_54 = mux(_T_1, _GEN_17, debugRegs_9) @[Functions.scala 194:30 197:33]
    node _GEN_55 = mux(_T_1, _GEN_18, debugRegs_10) @[Functions.scala 194:30 197:33]
    node _GEN_56 = mux(_T_1, _GEN_19, debugRegs_11) @[Functions.scala 194:30 197:33]
    node _GEN_57 = mux(_T_1, _GEN_20, debugRegs_12) @[Functions.scala 194:30 197:33]
    node _GEN_58 = mux(_T_1, _GEN_21, debugRegs_13) @[Functions.scala 194:30 197:33]
    node _GEN_59 = mux(_T_1, _GEN_22, debugRegs_14) @[Functions.scala 194:30 197:33]
    node _GEN_60 = mux(_T_1, _GEN_23, debugRegs_15) @[Functions.scala 194:30 197:33]
    node _GEN_61 = mux(_T_1, _GEN_24, debugRegs_16) @[Functions.scala 194:30 197:33]
    node _GEN_62 = mux(_T_1, _GEN_25, debugRegs_17) @[Functions.scala 194:30 197:33]
    node _GEN_63 = mux(_T_1, _GEN_26, debugRegs_18) @[Functions.scala 194:30 197:33]
    node _GEN_64 = mux(_T_1, _GEN_27, debugRegs_19) @[Functions.scala 194:30 197:33]
    node _GEN_65 = mux(_T_1, _GEN_28, debugRegs_20) @[Functions.scala 194:30 197:33]
    node _GEN_66 = mux(_T_1, _GEN_29, debugRegs_21) @[Functions.scala 194:30 197:33]
    node _GEN_67 = mux(_T_1, _GEN_30, debugRegs_22) @[Functions.scala 194:30 197:33]
    node _GEN_68 = mux(_T_1, _GEN_31, debugRegs_23) @[Functions.scala 194:30 197:33]
    node _GEN_69 = mux(_T_1, _GEN_32, debugRegs_24) @[Functions.scala 194:30 197:33]
    node _GEN_70 = mux(_T_1, _GEN_33, debugRegs_25) @[Functions.scala 194:30 197:33]
    node _GEN_71 = mux(_T_1, _GEN_34, debugRegs_26) @[Functions.scala 194:30 197:33]
    node _GEN_72 = mux(_T_1, _GEN_35, debugRegs_27) @[Functions.scala 194:30 197:33]
    node _GEN_73 = mux(_T_1, _GEN_36, debugRegs_28) @[Functions.scala 194:30 197:33]
    node _GEN_74 = mux(_T_1, _GEN_37, debugRegs_29) @[Functions.scala 194:30 197:33]
    node _GEN_75 = mux(_T_1, _GEN_38, debugRegs_30) @[Functions.scala 194:30 197:33]
    node _GEN_76 = mux(_T_1, _GEN_39, debugRegs_31) @[Functions.scala 194:30 197:33]
    node decOut_opcode = bits(instrReg, 6, 0) @[Functions.scala 17:29]
    node decOut_func3 = bits(instrReg, 14, 12) @[Functions.scala 18:28]
    node _decOut_T = eq(UInt<5>("h13"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_1 = eq(UInt<6>("h33"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_2 = eq(UInt<7>("h63"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_3 = eq(UInt<2>("h3"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_4 = eq(UInt<6>("h23"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_5 = eq(UInt<6>("h37"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_6 = eq(UInt<5>("h17"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_7 = eq(UInt<7>("h6f"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_8 = eq(UInt<7>("h67"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_9 = eq(UInt<7>("h73"), decOut_opcode) @[Functions.scala 34:20]
    node _decOut_T_10 = eq(decOut_func3, UInt<1>("h0")) @[Functions.scala 84:21]
    node _GEN_77 = mux(_decOut_T_10, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 30:20 84:30 85:26]
    node _GEN_78 = mux(_decOut_T_10, UInt<1>("h0"), UInt<1>("h1")) @[Functions.scala 31:20 84:30 87:26]
    node _GEN_79 = mux(_decOut_T_9, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 34:20 20:22 83:26]
    node _GEN_80 = mux(_decOut_T_9, _GEN_77, UInt<1>("h0")) @[Functions.scala 30:20 34:20]
    node _GEN_81 = mux(_decOut_T_9, _GEN_78, UInt<1>("h0")) @[Functions.scala 31:20 34:20]
    node _GEN_82 = mux(_decOut_T_8, UInt<1>("h1"), _GEN_79) @[Functions.scala 34:20 77:26]
    node _GEN_83 = mux(_decOut_T_8, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 21:18 34:20 78:22]
    node _GEN_84 = mux(_decOut_T_8, UInt<1>("h0"), _GEN_80) @[Functions.scala 30:20 34:20]
    node _GEN_85 = mux(_decOut_T_8, UInt<1>("h0"), _GEN_81) @[Functions.scala 31:20 34:20]
    node _GEN_86 = mux(_decOut_T_7, UInt<3>("h5"), _GEN_82) @[Functions.scala 34:20 72:26]
    node _GEN_87 = mux(_decOut_T_7, UInt<1>("h1"), _GEN_83) @[Functions.scala 34:20 73:24]
    node _GEN_88 = mux(_decOut_T_7, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 27:18 34:20 74:22]
    node _GEN_89 = mux(_decOut_T_7, UInt<1>("h0"), _GEN_83) @[Functions.scala 21:18 34:20]
    node _GEN_90 = mux(_decOut_T_7, UInt<1>("h0"), _GEN_84) @[Functions.scala 30:20 34:20]
    node _GEN_91 = mux(_decOut_T_7, UInt<1>("h0"), _GEN_85) @[Functions.scala 31:20 34:20]
    node _GEN_92 = mux(_decOut_T_6, UInt<3>("h4"), _GEN_86) @[Functions.scala 34:20 67:26]
    node _GEN_93 = mux(_decOut_T_6, UInt<1>("h1"), _GEN_87) @[Functions.scala 34:20 68:24]
    node _GEN_94 = mux(_decOut_T_6, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 23:20 34:20 69:24]
    node _GEN_95 = mux(_decOut_T_6, UInt<1>("h0"), _GEN_88) @[Functions.scala 27:18 34:20]
    node _GEN_96 = mux(_decOut_T_6, UInt<1>("h0"), _GEN_89) @[Functions.scala 21:18 34:20]
    node _GEN_97 = mux(_decOut_T_6, UInt<1>("h0"), _GEN_90) @[Functions.scala 30:20 34:20]
    node _GEN_98 = mux(_decOut_T_6, UInt<1>("h0"), _GEN_91) @[Functions.scala 31:20 34:20]
    node _GEN_99 = mux(_decOut_T_5, UInt<3>("h4"), _GEN_92) @[Functions.scala 34:20 62:26]
    node _GEN_100 = mux(_decOut_T_5, UInt<1>("h1"), _GEN_93) @[Functions.scala 34:20 63:24]
    node _GEN_101 = mux(_decOut_T_5, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 22:18 34:20 64:22]
    node _GEN_102 = mux(_decOut_T_5, UInt<1>("h0"), _GEN_94) @[Functions.scala 23:20 34:20]
    node _GEN_103 = mux(_decOut_T_5, UInt<1>("h0"), _GEN_95) @[Functions.scala 27:18 34:20]
    node _GEN_104 = mux(_decOut_T_5, UInt<1>("h0"), _GEN_96) @[Functions.scala 21:18 34:20]
    node _GEN_105 = mux(_decOut_T_5, UInt<1>("h0"), _GEN_97) @[Functions.scala 30:20 34:20]
    node _GEN_106 = mux(_decOut_T_5, UInt<1>("h0"), _GEN_98) @[Functions.scala 31:20 34:20]
    node _GEN_107 = mux(_decOut_T_4, UInt<2>("h2"), _GEN_99) @[Functions.scala 34:20 58:26]
    node _GEN_108 = mux(_decOut_T_4, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 25:20 34:20 59:24]
    node _GEN_109 = mux(_decOut_T_4, UInt<1>("h0"), _GEN_100) @[Functions.scala 29:20 34:20]
    node _GEN_110 = mux(_decOut_T_4, UInt<1>("h0"), _GEN_101) @[Functions.scala 22:18 34:20]
    node _GEN_111 = mux(_decOut_T_4, UInt<1>("h0"), _GEN_102) @[Functions.scala 23:20 34:20]
    node _GEN_112 = mux(_decOut_T_4, UInt<1>("h0"), _GEN_103) @[Functions.scala 27:18 34:20]
    node _GEN_113 = mux(_decOut_T_4, UInt<1>("h0"), _GEN_104) @[Functions.scala 21:18 34:20]
    node _GEN_114 = mux(_decOut_T_4, UInt<1>("h0"), _GEN_105) @[Functions.scala 30:20 34:20]
    node _GEN_115 = mux(_decOut_T_4, UInt<1>("h0"), _GEN_106) @[Functions.scala 31:20 34:20]
    node _GEN_116 = mux(_decOut_T_3, UInt<1>("h1"), _GEN_107) @[Functions.scala 34:20 53:26]
    node _GEN_117 = mux(_decOut_T_3, UInt<1>("h1"), _GEN_109) @[Functions.scala 34:20 54:24]
    node _GEN_118 = mux(_decOut_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 24:19 34:20 55:23]
    node _GEN_119 = mux(_decOut_T_3, UInt<1>("h0"), _GEN_108) @[Functions.scala 25:20 34:20]
    node _GEN_120 = mux(_decOut_T_3, UInt<1>("h0"), _GEN_110) @[Functions.scala 22:18 34:20]
    node _GEN_121 = mux(_decOut_T_3, UInt<1>("h0"), _GEN_111) @[Functions.scala 23:20 34:20]
    node _GEN_122 = mux(_decOut_T_3, UInt<1>("h0"), _GEN_112) @[Functions.scala 27:18 34:20]
    node _GEN_123 = mux(_decOut_T_3, UInt<1>("h0"), _GEN_113) @[Functions.scala 21:18 34:20]
    node _GEN_124 = mux(_decOut_T_3, UInt<1>("h0"), _GEN_114) @[Functions.scala 30:20 34:20]
    node _GEN_125 = mux(_decOut_T_3, UInt<1>("h0"), _GEN_115) @[Functions.scala 31:20 34:20]
    node _GEN_126 = mux(_decOut_T_2, UInt<2>("h3"), _GEN_116) @[Functions.scala 34:20 48:26]
    node _GEN_127 = mux(_decOut_T_2, UInt<1>("h1"), _GEN_123) @[Functions.scala 34:20 49:22]
    node _GEN_128 = mux(_decOut_T_2, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 34:20 26:21 50:25]
    node _GEN_129 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_117) @[Functions.scala 29:20 34:20]
    node _GEN_130 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_118) @[Functions.scala 24:19 34:20]
    node _GEN_131 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_119) @[Functions.scala 25:20 34:20]
    node _GEN_132 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_120) @[Functions.scala 22:18 34:20]
    node _GEN_133 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_121) @[Functions.scala 23:20 34:20]
    node _GEN_134 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_122) @[Functions.scala 27:18 34:20]
    node _GEN_135 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_123) @[Functions.scala 28:19 34:20]
    node _GEN_136 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_124) @[Functions.scala 30:20 34:20]
    node _GEN_137 = mux(_decOut_T_2, UInt<1>("h0"), _GEN_125) @[Functions.scala 31:20 34:20]
    node _GEN_138 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_126) @[Functions.scala 34:20 42:26]
    node _GEN_139 = mux(_decOut_T_1, UInt<1>("h1"), _GEN_129) @[Functions.scala 34:20 43:24]
    node _GEN_140 = mux(_decOut_T_1, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 34:20 32:21 44:25]
    node _GEN_141 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_127) @[Functions.scala 21:18 34:20]
    node _GEN_142 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_128) @[Functions.scala 34:20 26:21]
    node _GEN_143 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_130) @[Functions.scala 24:19 34:20]
    node _GEN_144 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_131) @[Functions.scala 25:20 34:20]
    node _GEN_145 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_132) @[Functions.scala 22:18 34:20]
    node _GEN_146 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_133) @[Functions.scala 23:20 34:20]
    node _GEN_147 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_134) @[Functions.scala 27:18 34:20]
    node _GEN_148 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_135) @[Functions.scala 28:19 34:20]
    node _GEN_149 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_136) @[Functions.scala 30:20 34:20]
    node _GEN_150 = mux(_decOut_T_1, UInt<1>("h0"), _GEN_137) @[Functions.scala 31:20 34:20]
    node _GEN_151 = mux(_decOut_T, UInt<1>("h1"), _GEN_138) @[Functions.scala 34:20 36:26]
    node _GEN_152 = mux(_decOut_T, UInt<1>("h1"), _GEN_141) @[Functions.scala 34:20 37:22]
    node _GEN_153 = mux(_decOut_T, UInt<1>("h1"), _GEN_139) @[Functions.scala 34:20 38:24]
    node _GEN_154 = mux(_decOut_T, UInt<1>("h1"), _GEN_140) @[Functions.scala 34:20 39:25]
    node _GEN_155 = mux(_decOut_T, UInt<1>("h0"), _GEN_140) @[Functions.scala 34:20 33:21]
    node _GEN_156 = mux(_decOut_T, UInt<1>("h0"), _GEN_142) @[Functions.scala 34:20 26:21]
    node _GEN_157 = mux(_decOut_T, UInt<1>("h0"), _GEN_143) @[Functions.scala 24:19 34:20]
    node _GEN_158 = mux(_decOut_T, UInt<1>("h0"), _GEN_144) @[Functions.scala 25:20 34:20]
    node _GEN_159 = mux(_decOut_T, UInt<1>("h0"), _GEN_145) @[Functions.scala 22:18 34:20]
    node _GEN_160 = mux(_decOut_T, UInt<1>("h0"), _GEN_146) @[Functions.scala 23:20 34:20]
    node _GEN_161 = mux(_decOut_T, UInt<1>("h0"), _GEN_147) @[Functions.scala 27:18 34:20]
    node _GEN_162 = mux(_decOut_T, UInt<1>("h0"), _GEN_148) @[Functions.scala 28:19 34:20]
    node _GEN_163 = mux(_decOut_T, UInt<1>("h0"), _GEN_149) @[Functions.scala 30:20 34:20]
    node _GEN_164 = mux(_decOut_T, UInt<1>("h0"), _GEN_150) @[Functions.scala 31:20 34:20]
    node decOut_decOut_aluOp_opcode = bits(instrReg, 6, 0) @[Functions.scala 98:29]
    node decOut_decOut_aluOp_func3 = bits(instrReg, 14, 12) @[Functions.scala 99:28]
    node decOut_decOut_aluOp_func7 = bits(instrReg, 31, 25) @[Functions.scala 100:28]
    node _decOut_decOut_aluOp_T = eq(UInt<1>("h0"), decOut_decOut_aluOp_func3) @[Functions.scala 103:19]
    node _decOut_decOut_aluOp_T_1 = neq(decOut_decOut_aluOp_opcode, UInt<5>("h13")) @[Functions.scala 106:21]
    node _decOut_decOut_aluOp_T_2 = neq(decOut_decOut_aluOp_opcode, UInt<7>("h67")) @[Functions.scala 106:44]
    node _decOut_decOut_aluOp_T_3 = and(_decOut_decOut_aluOp_T_1, _decOut_decOut_aluOp_T_2) @[Functions.scala 106:34]
    node _decOut_decOut_aluOp_T_4 = neq(decOut_decOut_aluOp_func7, UInt<1>("h0")) @[Functions.scala 106:64]
    node _decOut_decOut_aluOp_T_5 = and(_decOut_decOut_aluOp_T_3, _decOut_decOut_aluOp_T_4) @[Functions.scala 106:55]
    node _GEN_165 = mux(_decOut_decOut_aluOp_T_5, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 105:15 106:73 107:17]
    node _decOut_decOut_aluOp_T_6 = eq(UInt<1>("h1"), decOut_decOut_aluOp_func3) @[Functions.scala 103:19]
    node _decOut_decOut_aluOp_T_7 = eq(UInt<2>("h2"), decOut_decOut_aluOp_func3) @[Functions.scala 103:19]
    node _decOut_decOut_aluOp_T_8 = eq(UInt<2>("h3"), decOut_decOut_aluOp_func3) @[Functions.scala 103:19]
    node _decOut_decOut_aluOp_T_9 = eq(UInt<3>("h4"), decOut_decOut_aluOp_func3) @[Functions.scala 103:19]
    node _decOut_decOut_aluOp_T_10 = eq(UInt<3>("h5"), decOut_decOut_aluOp_func3) @[Functions.scala 103:19]
    node _decOut_decOut_aluOp_T_11 = eq(decOut_decOut_aluOp_func7, UInt<1>("h0")) @[Functions.scala 123:20]
    node _GEN_166 = mux(_decOut_decOut_aluOp_T_11, UInt<3>("h6"), UInt<3>("h7")) @[Functions.scala 123:29 124:17 126:17]
    node _decOut_decOut_aluOp_T_12 = eq(UInt<3>("h6"), decOut_decOut_aluOp_func3) @[Functions.scala 103:19]
    node _decOut_decOut_aluOp_T_13 = eq(UInt<3>("h7"), decOut_decOut_aluOp_func3) @[Functions.scala 103:19]
    node _GEN_167 = mux(_decOut_decOut_aluOp_T_13, UInt<4>("h9"), UInt<1>("h0")) @[Functions.scala 103:19 133:15 102:28]
    node _GEN_168 = mux(_decOut_decOut_aluOp_T_12, UInt<4>("h8"), _GEN_167) @[Functions.scala 103:19 130:15]
    node _GEN_169 = mux(_decOut_decOut_aluOp_T_10, _GEN_166, _GEN_168) @[Functions.scala 103:19]
    node _GEN_170 = mux(_decOut_decOut_aluOp_T_9, UInt<3>("h5"), _GEN_169) @[Functions.scala 103:19 120:15]
    node _GEN_171 = mux(_decOut_decOut_aluOp_T_8, UInt<3>("h4"), _GEN_170) @[Functions.scala 103:19 117:15]
    node _GEN_172 = mux(_decOut_decOut_aluOp_T_7, UInt<2>("h3"), _GEN_171) @[Functions.scala 103:19 114:15]
    node _GEN_173 = mux(_decOut_decOut_aluOp_T_6, UInt<2>("h2"), _GEN_172) @[Functions.scala 103:19 111:15]
    node _GEN_174 = mux(_decOut_decOut_aluOp_T, _GEN_165, _GEN_173) @[Functions.scala 103:19]
    node _decOut_decOut_imm_imm_T = bits(instrReg, 31, 20) @[Functions.scala 168:23]
    node _decOut_decOut_imm_imm_T_1 = asSInt(_decOut_decOut_imm_imm_T) @[Functions.scala 168:32]
    node decOut_instrType = _GEN_151 @[Functions.scala 19:22]
    node _decOut_decOut_imm_T = eq(UInt<1>("h1"), decOut_instrType) @[Functions.scala 169:23]
    node _decOut_decOut_imm_imm_T_2 = bits(instrReg, 31, 31) @[Functions.scala 171:37]
    node _decOut_decOut_imm_imm_T_3 = bits(_decOut_decOut_imm_imm_T_2, 0, 0) @[Bitwise.scala 77:15]
    node _decOut_decOut_imm_imm_T_4 = mux(_decOut_decOut_imm_imm_T_3, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 77:12]
    node _decOut_decOut_imm_imm_T_5 = bits(instrReg, 31, 20) @[Functions.scala 171:57]
    node _decOut_decOut_imm_imm_T_6 = cat(_decOut_decOut_imm_imm_T_4, _decOut_decOut_imm_imm_T_5) @[Functions.scala 171:43]
    node _decOut_decOut_imm_imm_T_7 = asSInt(_decOut_decOut_imm_imm_T_6) @[Functions.scala 171:67]
    node _decOut_decOut_imm_T_1 = eq(UInt<2>("h2"), decOut_instrType) @[Functions.scala 169:23]
    node _decOut_decOut_imm_imm_T_8 = bits(instrReg, 31, 31) @[Functions.scala 174:37]
    node _decOut_decOut_imm_imm_T_9 = bits(_decOut_decOut_imm_imm_T_8, 0, 0) @[Bitwise.scala 77:15]
    node _decOut_decOut_imm_imm_T_10 = mux(_decOut_decOut_imm_imm_T_9, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 77:12]
    node _decOut_decOut_imm_imm_T_11 = bits(instrReg, 31, 25) @[Functions.scala 174:57]
    node _decOut_decOut_imm_imm_T_12 = cat(_decOut_decOut_imm_imm_T_10, _decOut_decOut_imm_imm_T_11) @[Functions.scala 174:43]
    node _decOut_decOut_imm_imm_T_13 = bits(instrReg, 11, 7) @[Functions.scala 174:80]
    node _decOut_decOut_imm_imm_T_14 = cat(_decOut_decOut_imm_imm_T_12, _decOut_decOut_imm_imm_T_13) @[Functions.scala 174:66]
    node _decOut_decOut_imm_imm_T_15 = asSInt(_decOut_decOut_imm_imm_T_14) @[Functions.scala 174:89]
    node _decOut_decOut_imm_T_2 = eq(UInt<2>("h3"), decOut_instrType) @[Functions.scala 169:23]
    node _decOut_decOut_imm_imm_T_16 = bits(instrReg, 31, 31) @[Functions.scala 177:37]
    node _decOut_decOut_imm_imm_T_17 = bits(_decOut_decOut_imm_imm_T_16, 0, 0) @[Bitwise.scala 77:15]
    node _decOut_decOut_imm_imm_T_18 = mux(_decOut_decOut_imm_imm_T_17, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 77:12]
    node _decOut_decOut_imm_imm_T_19 = bits(instrReg, 7, 7) @[Functions.scala 177:57]
    node _decOut_decOut_imm_imm_T_20 = cat(_decOut_decOut_imm_imm_T_18, _decOut_decOut_imm_imm_T_19) @[Functions.scala 177:43]
    node _decOut_decOut_imm_imm_T_21 = bits(instrReg, 30, 25) @[Functions.scala 177:75]
    node _decOut_decOut_imm_imm_T_22 = cat(_decOut_decOut_imm_imm_T_20, _decOut_decOut_imm_imm_T_21) @[Functions.scala 177:61]
    node _decOut_decOut_imm_imm_T_23 = bits(instrReg, 11, 8) @[Functions.scala 177:98]
    node _decOut_decOut_imm_imm_T_24 = cat(_decOut_decOut_imm_imm_T_22, _decOut_decOut_imm_imm_T_23) @[Functions.scala 177:84]
    node _decOut_decOut_imm_imm_T_25 = cat(_decOut_decOut_imm_imm_T_24, UInt<1>("h0")) @[Functions.scala 177:106]
    node _decOut_decOut_imm_imm_T_26 = asSInt(_decOut_decOut_imm_imm_T_25) @[Functions.scala 177:119]
    node _decOut_decOut_imm_T_3 = eq(UInt<3>("h4"), decOut_instrType) @[Functions.scala 169:23]
    node _decOut_decOut_imm_imm_T_27 = bits(instrReg, 31, 12) @[Functions.scala 180:28]
    node _decOut_decOut_imm_imm_T_28 = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 77:12]
    node _decOut_decOut_imm_imm_T_29 = cat(_decOut_decOut_imm_imm_T_27, _decOut_decOut_imm_imm_T_28) @[Functions.scala 180:37]
    node _decOut_decOut_imm_imm_T_30 = asSInt(_decOut_decOut_imm_imm_T_29) @[Functions.scala 180:55]
    node _decOut_decOut_imm_T_4 = eq(UInt<3>("h5"), decOut_instrType) @[Functions.scala 169:23]
    node _decOut_decOut_imm_imm_T_31 = bits(instrReg, 31, 31) @[Functions.scala 183:37]
    node _decOut_decOut_imm_imm_T_32 = bits(_decOut_decOut_imm_imm_T_31, 0, 0) @[Bitwise.scala 77:15]
    node _decOut_decOut_imm_imm_T_33 = mux(_decOut_decOut_imm_imm_T_32, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 77:12]
    node _decOut_decOut_imm_imm_T_34 = bits(instrReg, 19, 12) @[Functions.scala 183:57]
    node _decOut_decOut_imm_imm_T_35 = cat(_decOut_decOut_imm_imm_T_33, _decOut_decOut_imm_imm_T_34) @[Functions.scala 183:43]
    node _decOut_decOut_imm_imm_T_36 = bits(instrReg, 20, 20) @[Functions.scala 183:80]
    node _decOut_decOut_imm_imm_T_37 = cat(_decOut_decOut_imm_imm_T_35, _decOut_decOut_imm_imm_T_36) @[Functions.scala 183:66]
    node _decOut_decOut_imm_imm_T_38 = bits(instrReg, 30, 21) @[Functions.scala 183:99]
    node _decOut_decOut_imm_imm_T_39 = cat(_decOut_decOut_imm_imm_T_37, _decOut_decOut_imm_imm_T_38) @[Functions.scala 183:85]
    node _decOut_decOut_imm_imm_T_40 = cat(_decOut_decOut_imm_imm_T_39, UInt<1>("h0")) @[Functions.scala 183:108]
    node _decOut_decOut_imm_imm_T_41 = asSInt(_decOut_decOut_imm_imm_T_40) @[Functions.scala 183:121]
    node _GEN_175 = mux(_decOut_decOut_imm_T_4, _decOut_decOut_imm_imm_T_41, _decOut_decOut_imm_imm_T_1) @[Functions.scala 169:23 183:13 168:9]
    node _GEN_176 = mux(_decOut_decOut_imm_T_3, _decOut_decOut_imm_imm_T_30, _GEN_175) @[Functions.scala 169:23 180:13]
    node _GEN_177 = mux(_decOut_decOut_imm_T_2, _decOut_decOut_imm_imm_T_26, _GEN_176) @[Functions.scala 169:23 177:13]
    node _GEN_178 = mux(_decOut_decOut_imm_T_1, _decOut_decOut_imm_imm_T_15, _GEN_177) @[Functions.scala 169:23 174:13]
    node _GEN_179 = mux(_decOut_decOut_imm_T, _decOut_decOut_imm_imm_T_7, _GEN_178) @[Functions.scala 169:23 171:13]
    node _decEx_valid_T = eq(doBranch, UInt<1>("h0")) @[ThreeCats.scala 77:18]
    node _decEx_rs1_T = bits(instrReg, 19, 15) @[ThreeCats.scala 79:24]
    node _decEx_rs2_T = bits(instrReg, 24, 20) @[ThreeCats.scala 80:24]
    node _decEx_rd_T = bits(instrReg, 11, 7) @[ThreeCats.scala 81:23]
    node _decEx_func3_T = bits(instrReg, 14, 12) @[ThreeCats.scala 84:26]
    node _address_T = neq(wbDest, UInt<1>("h0")) @[ThreeCats.scala 87:38]
    node _address_T_1 = and(wrEna, _address_T) @[ThreeCats.scala 87:27]
    node decEx_rs1 = _decEx_rs1_T @[ThreeCats.scala 64:19 79:13]
    node _address_T_2 = eq(wbDest, decEx_rs1) @[ThreeCats.scala 87:57]
    node _address_T_3 = and(_address_T_1, _address_T_2) @[ThreeCats.scala 87:47]
    node address = mux(_address_T_3, wbData, rs1Val) @[ThreeCats.scala 87:20]
    node _data_T = neq(wbDest, UInt<1>("h0")) @[ThreeCats.scala 88:35]
    node _data_T_1 = and(wrEna, _data_T) @[ThreeCats.scala 88:24]
    node decEx_rs2 = _decEx_rs2_T @[ThreeCats.scala 64:19 80:13]
    node _data_T_2 = eq(wbDest, decEx_rs2) @[ThreeCats.scala 88:54]
    node _data_T_3 = and(_data_T_1, _data_T_2) @[ThreeCats.scala 88:44]
    node data = mux(_data_T_3, wbData, rs2Val) @[ThreeCats.scala 88:17]
    node _memAddress_T = asSInt(address) @[ThreeCats.scala 90:29]
    node decOut_decOut_imm_imm = _GEN_179 @[Functions.scala 167:19]
    node decOut_imm = decOut_decOut_imm_imm @[Functions.scala 19:22 92:16]
    node _memAddress_T_1 = add(_memAddress_T, decOut_imm) @[ThreeCats.scala 90:36]
    node _memAddress_T_2 = tail(_memAddress_T_1, 1) @[ThreeCats.scala 90:36]
    node _memAddress_T_3 = asSInt(_memAddress_T_2) @[ThreeCats.scala 90:36]
    node memAddress = asUInt(_memAddress_T_3) @[ThreeCats.scala 90:50]
    node _decEx_memLow_T = bits(memAddress, 1, 0) @[ThreeCats.scala 91:29]
    node _T_2 = eq(doBranch, UInt<1>("h0")) @[ThreeCats.scala 98:25]
    node decOut_isLoad = _GEN_157 @[Functions.scala 19:22]
    node _T_3 = and(decOut_isLoad, _T_2) @[ThreeCats.scala 98:22]
    node _GEN_180 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[ThreeCats.scala 94:20 98:36 99:22]
    node _T_4 = eq(doBranch, UInt<1>("h0")) @[ThreeCats.scala 101:26]
    node decOut_isStore = _GEN_158 @[Functions.scala 19:22]
    node _T_5 = and(decOut_isStore, _T_4) @[ThreeCats.scala 101:23]
    node _T_6 = bits(memAddress, 1, 0) @[ThreeCats.scala 102:64]
    node decEx_func3 = _decEx_func3_T @[ThreeCats.scala 64:19 84:15]
    node _T_7 = eq(UInt<1>("h0"), decEx_func3) @[Functions.scala 317:19]
    node _wrData_T = bits(data, 7, 0) @[Functions.scala 319:23]
    node _wrData_T_1 = bits(data, 7, 0) @[Functions.scala 319:37]
    node _wrData_T_2 = cat(_wrData_T, _wrData_T_1) @[Functions.scala 319:30]
    node _wrData_T_3 = bits(data, 7, 0) @[Functions.scala 319:51]
    node _wrData_T_4 = cat(_wrData_T_2, _wrData_T_3) @[Functions.scala 319:44]
    node _wrData_T_5 = bits(data, 7, 0) @[Functions.scala 319:65]
    node _wrData_T_6 = cat(_wrData_T_4, _wrData_T_5) @[Functions.scala 319:58]
    node _wre_T_6 = UInt<1>("h1") @[Functions.scala 320:{26,26}]
    node _GEN_181 = mux(eq(UInt<1>("h0"), _T_6), _wre_T_6, UInt<1>("h0")) @[Functions.scala 320:{26,26} 316:27]
    node _GEN_182 = mux(eq(UInt<1>("h1"), _T_6), _wre_T_6, UInt<1>("h0")) @[Functions.scala 320:{26,26} 316:27]
    node _GEN_183 = mux(eq(UInt<2>("h2"), _T_6), _wre_T_6, UInt<1>("h0")) @[Functions.scala 320:{26,26} 316:27]
    node _GEN_184 = mux(eq(UInt<2>("h3"), _T_6), _wre_T_6, UInt<1>("h0")) @[Functions.scala 320:{26,26} 316:27]
    node _T_8 = eq(UInt<1>("h1"), decEx_func3) @[Functions.scala 317:19]
    node _wrData_T_7 = bits(data, 15, 0) @[Functions.scala 323:23]
    node _wrData_T_8 = bits(data, 15, 0) @[Functions.scala 323:38]
    node _wrData_T_9 = cat(_wrData_T_7, _wrData_T_8) @[Functions.scala 323:31]
    node _T_9 = eq(UInt<1>("h0"), _T_6) @[Functions.scala 324:24]
    node _T_10 = eq(UInt<2>("h2"), _T_6) @[Functions.scala 324:24]
    node _GEN_185 = mux(_T_10, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 324:24 330:25 316:27]
    node _GEN_186 = mux(_T_9, UInt<1>("h1"), UInt<1>("h0")) @[Functions.scala 324:24 326:25 316:27]
    node _GEN_187 = mux(_T_9, UInt<1>("h0"), _GEN_185) @[Functions.scala 324:24 316:27]
    node _T_11 = eq(UInt<2>("h2"), decEx_func3) @[Functions.scala 317:19]
    node _WIRE_1_0 = UInt<1>("h1") @[Functions.scala 336:{28,28}]
    node _GEN_188 = mux(_T_11, _WIRE_1_0, UInt<1>("h0")) @[Functions.scala 317:19 336:18 316:27]
    node _WIRE_1_1 = UInt<1>("h1") @[Functions.scala 336:{28,28}]
    node _GEN_189 = mux(_T_11, _WIRE_1_1, UInt<1>("h0")) @[Functions.scala 317:19 336:18 316:27]
    node _WIRE_1_2 = UInt<1>("h1") @[Functions.scala 336:{28,28}]
    node _GEN_190 = mux(_T_11, _WIRE_1_2, UInt<1>("h0")) @[Functions.scala 317:19 336:18 316:27]
    node _WIRE_1_3 = UInt<1>("h1") @[Functions.scala 336:{28,28}]
    node _GEN_191 = mux(_T_11, _WIRE_1_3, UInt<1>("h0")) @[Functions.scala 317:19 336:18 316:27]
    node _GEN_192 = mux(_T_8, _wrData_T_9, data) @[Functions.scala 317:19 323:16 315:29]
    node _GEN_193 = mux(_T_8, _GEN_186, _GEN_188) @[Functions.scala 317:19]
    node _GEN_194 = mux(_T_8, _GEN_186, _GEN_189) @[Functions.scala 317:19]
    node _GEN_195 = mux(_T_8, _GEN_187, _GEN_190) @[Functions.scala 317:19]
    node _GEN_196 = mux(_T_8, _GEN_187, _GEN_191) @[Functions.scala 317:19]
    node _GEN_197 = mux(_T_7, _wrData_T_6, _GEN_192) @[Functions.scala 317:19 319:16]
    node _GEN_198 = mux(_T_7, _GEN_181, _GEN_193) @[Functions.scala 317:19]
    node _GEN_199 = mux(_T_7, _GEN_182, _GEN_194) @[Functions.scala 317:19]
    node _GEN_200 = mux(_T_7, _GEN_183, _GEN_195) @[Functions.scala 317:19]
    node _GEN_201 = mux(_T_7, _GEN_184, _GEN_196) @[Functions.scala 317:19]
    node wrd = _GEN_197 @[Functions.scala 315:29]
    node _GEN_202 = mux(_T_5, wrd, data) @[ThreeCats.scala 101:37 103:20 96:18]
    node wre_0 = _GEN_198 @[Functions.scala 316:27]
    node _WIRE__0 = UInt<1>("h0") @[ThreeCats.scala 97:{30,30}]
    node _GEN_203 = mux(_T_5, wre_0, _WIRE__0) @[ThreeCats.scala 101:37 104:22 97:20]
    node wre_1 = _GEN_199 @[Functions.scala 316:27]
    node _WIRE__1 = UInt<1>("h0") @[ThreeCats.scala 97:{30,30}]
    node _GEN_204 = mux(_T_5, wre_1, _WIRE__1) @[ThreeCats.scala 101:37 104:22 97:20]
    node wre_2 = _GEN_200 @[Functions.scala 316:27]
    node _WIRE__2 = UInt<1>("h0") @[ThreeCats.scala 97:{30,30}]
    node _GEN_205 = mux(_T_5, wre_2, _WIRE__2) @[ThreeCats.scala 101:37 104:22 97:20]
    node wre_3 = _GEN_201 @[Functions.scala 316:27]
    node _WIRE__3 = UInt<1>("h0") @[ThreeCats.scala 97:{30,30}]
    node _GEN_206 = mux(_T_5, wre_3, _WIRE__3) @[ThreeCats.scala 101:37 104:22 97:20]
    node _decExReg_T = asSInt(UInt<32>("h0")) @[ThreeCats.scala 109:38]
    reg decExReg__decOut_instrType : UInt<3>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_instrType) @[ThreeCats.scala 109:25]
    reg decExReg__decOut_isStore : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isStore) @[ThreeCats.scala 109:25]
    reg decExReg__decOut_isECall : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isECall) @[ThreeCats.scala 109:25]
    reg decExReg__decOut_isCssrw : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_isCssrw) @[ThreeCats.scala 109:25]
    reg decExReg__decOut_rs1Valid : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_rs1Valid) @[ThreeCats.scala 109:25]
    reg decExReg__decOut_rs2Valid : UInt<1>, clock with :
      reset => (UInt<1>("h0"), decExReg__decOut_rs2Valid) @[ThreeCats.scala 109:25]
    node _exFwdReg_valid_T = neq(wbDest, UInt<1>("h0")) @[ThreeCats.scala 146:38]
    node _exFwdReg_valid_T_1 = and(wrEna, _exFwdReg_valid_T) @[ThreeCats.scala 146:27]
    node stall = UInt<1>("h0") @[ThreeCats.scala 22:{26,26}]
    node _exFwdReg_WIRE_valid = UInt<1>("h0") @[ThreeCats.scala 36:{38,38}]
    node _exFwdReg_WIRE_wbDest = UInt<5>("h0") @[ThreeCats.scala 36:{38,38}]
    node _exFwdReg_WIRE_wbData = UInt<32>("h0") @[ThreeCats.scala 36:{38,38}]
    node pcNext = _GEN_1 @[ThreeCats.scala 42:27]
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
    node decOut_decOut_aluOp_aluOp = _GEN_174 @[Functions.scala 102:28]
    node decOut_aluOp = decOut_decOut_aluOp_aluOp @[Functions.scala 19:22 91:18]
    node decOut_isImm = _GEN_152 @[Functions.scala 19:22]
    node decOut_isLui = _GEN_159 @[Functions.scala 19:22]
    node decOut_isAuiPc = _GEN_160 @[Functions.scala 19:22]
    node decOut_isBranch = _GEN_156 @[Functions.scala 19:22]
    node decOut_isJal = _GEN_161 @[Functions.scala 19:22]
    node decOut_isJalr = _GEN_162 @[Functions.scala 19:22]
    node decOut_rfWrite = _GEN_153 @[Functions.scala 19:22]
    node decOut_isECall = _GEN_163 @[Functions.scala 19:22]
    node decOut_isCssrw = _GEN_164 @[Functions.scala 19:22]
    node decOut_rs1Valid = _GEN_154 @[Functions.scala 19:22]
    node decOut_rs2Valid = _GEN_155 @[Functions.scala 19:22]
    node decEx_decOut_instrType = decOut_instrType @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_aluOp = decOut_aluOp @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_imm = decOut_imm @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isImm = decOut_isImm @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isLui = decOut_isLui @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isAuiPc = decOut_isAuiPc @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isLoad = decOut_isLoad @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isStore = decOut_isStore @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isBranch = decOut_isBranch @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isJal = decOut_isJal @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isJalr = decOut_isJalr @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_rfWrite = decOut_rfWrite @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isECall = decOut_isECall @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_isCssrw = decOut_isCssrw @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_rs1Valid = decOut_rs1Valid @[ThreeCats.scala 64:19 76:16]
    node decEx_decOut_rs2Valid = decOut_rs2Valid @[ThreeCats.scala 64:19 76:16]
    node decEx_valid = _decEx_valid_T @[ThreeCats.scala 64:19 77:15]
    node decEx_pc = pcRegReg @[ThreeCats.scala 64:19 78:12]
    node decEx_rd = _decEx_rd_T @[ThreeCats.scala 64:19 81:12]
    node decEx_rs1Val = rs1Val @[ThreeCats.scala 64:19 82:16]
    node decEx_rs2Val = rs2Val @[ThreeCats.scala 64:19 83:16]
    node decEx_memLow = _decEx_memLow_T @[ThreeCats.scala 64:19 91:16]
    node _decExReg_WIRE_decOut_instrType = UInt<3>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_aluOp = UInt<4>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_imm = _decExReg_T @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isImm = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isLui = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isAuiPc = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isLoad = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isStore = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isBranch = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isJal = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isJalr = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_rfWrite = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isECall = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_isCssrw = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_rs1Valid = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_decOut_rs2Valid = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_valid = UInt<1>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_pc = UInt<32>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_rs1 = UInt<5>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_rs2 = UInt<5>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_rd = UInt<5>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_rs1Val = UInt<32>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_rs2Val = UInt<32>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_func3 = UInt<3>("h0") @[ThreeCats.scala 109:{38,38}]
    node _decExReg_WIRE_memLow = UInt<2>("h0") @[ThreeCats.scala 109:{38,38}]
    io_imem_address <= pcNext @[ThreeCats.scala 44:19]
    io_dmem_rdAddress <= memAddress @[ThreeCats.scala 93:21]
    io_dmem_rdEnable <= _GEN_180
    io_dmem_wrAddress <= memAddress @[ThreeCats.scala 95:21]
    io_dmem_wrData <= _GEN_202
    io_dmem_wrEnable_0 <= _GEN_203
    io_dmem_wrEnable_1 <= _GEN_204
    io_dmem_wrEnable_2 <= _GEN_205
    io_dmem_wrEnable_3 <= _GEN_206
    decExReg_decOut_isECall <= decExReg__decOut_isECall
    debugRegs_0_0 <= debugRegs_0
    debugRegs_0_1 <= debugRegs_1
    debugRegs_0_2 <= debugRegs_2
    debugRegs_0_3 <= debugRegs_3
    debugRegs_0_4 <= debugRegs_4
    debugRegs_0_5 <= debugRegs_5
    debugRegs_0_6 <= debugRegs_6
    debugRegs_0_7 <= debugRegs_7
    debugRegs_0_8 <= debugRegs_8
    debugRegs_0_9 <= debugRegs_9
    debugRegs_0_10 <= debugRegs_10
    debugRegs_0_11 <= debugRegs_11
    debugRegs_0_12 <= debugRegs_12
    debugRegs_0_13 <= debugRegs_13
    debugRegs_0_14 <= debugRegs_14
    debugRegs_0_15 <= debugRegs_15
    debugRegs_0_16 <= debugRegs_16
    debugRegs_0_17 <= debugRegs_17
    debugRegs_0_18 <= debugRegs_18
    debugRegs_0_19 <= debugRegs_19
    debugRegs_0_20 <= debugRegs_20
    debugRegs_0_21 <= debugRegs_21
    debugRegs_0_22 <= debugRegs_22
    debugRegs_0_23 <= debugRegs_23
    debugRegs_0_24 <= debugRegs_24
    debugRegs_0_25 <= debugRegs_25
    debugRegs_0_26 <= debugRegs_26
    debugRegs_0_27 <= debugRegs_27
    debugRegs_0_28 <= debugRegs_28
    debugRegs_0_29 <= debugRegs_29
    debugRegs_0_30 <= debugRegs_30
    debugRegs_0_31 <= debugRegs_31
    exFwdReg_valid <= mux(reset, _exFwdReg_WIRE_valid, _exFwdReg_valid_T_1) @[ThreeCats.scala 146:18 36:{25,25}]
    exFwdReg_wbDest <= mux(reset, _exFwdReg_WIRE_wbDest, wbDest) @[ThreeCats.scala 147:19 36:{25,25}]
    exFwdReg_wbData <= mux(reset, _exFwdReg_WIRE_wbData, wbData) @[ThreeCats.scala 148:19 36:{25,25}]
    pcReg <= mux(reset, _pcReg_T, pcNext) @[ThreeCats.scala 41:{22,22} 43:9]
    pcRegReg <= pcReg @[ThreeCats.scala 54:25]
    instrReg <= mux(reset, UInt<6>("h33"), _instrReg_T) @[ThreeCats.scala 55:{25,25} 56:12]
    regs.rs1Val_MPORT.addr <= _GEN_4
    regs.rs1Val_MPORT.en <= _GEN_3
    regs.rs1Val_MPORT.clk <= _GEN_5
    regs.rs2Val_MPORT.addr <= _GEN_7
    regs.rs2Val_MPORT.en <= _GEN_3
    regs.rs2Val_MPORT.clk <= _GEN_5
    regs.MPORT.addr <= _GEN_40
    regs.MPORT.en <= _GEN_42
    regs.MPORT.clk <= _GEN_41
    regs.MPORT.data <= _GEN_44
    regs.MPORT.mask <= _GEN_43
    debugRegs_0 <= mux(reset, _debugRegs_WIRE_0, _GEN_45) @[Functions.scala 194:{30,30}]
    debugRegs_1 <= mux(reset, _debugRegs_WIRE_1, _GEN_46) @[Functions.scala 194:{30,30}]
    debugRegs_2 <= mux(reset, _debugRegs_WIRE_2, _GEN_47) @[Functions.scala 194:{30,30}]
    debugRegs_3 <= mux(reset, _debugRegs_WIRE_3, _GEN_48) @[Functions.scala 194:{30,30}]
    debugRegs_4 <= mux(reset, _debugRegs_WIRE_4, _GEN_49) @[Functions.scala 194:{30,30}]
    debugRegs_5 <= mux(reset, _debugRegs_WIRE_5, _GEN_50) @[Functions.scala 194:{30,30}]
    debugRegs_6 <= mux(reset, _debugRegs_WIRE_6, _GEN_51) @[Functions.scala 194:{30,30}]
    debugRegs_7 <= mux(reset, _debugRegs_WIRE_7, _GEN_52) @[Functions.scala 194:{30,30}]
    debugRegs_8 <= mux(reset, _debugRegs_WIRE_8, _GEN_53) @[Functions.scala 194:{30,30}]
    debugRegs_9 <= mux(reset, _debugRegs_WIRE_9, _GEN_54) @[Functions.scala 194:{30,30}]
    debugRegs_10 <= mux(reset, _debugRegs_WIRE_10, _GEN_55) @[Functions.scala 194:{30,30}]
    debugRegs_11 <= mux(reset, _debugRegs_WIRE_11, _GEN_56) @[Functions.scala 194:{30,30}]
    debugRegs_12 <= mux(reset, _debugRegs_WIRE_12, _GEN_57) @[Functions.scala 194:{30,30}]
    debugRegs_13 <= mux(reset, _debugRegs_WIRE_13, _GEN_58) @[Functions.scala 194:{30,30}]
    debugRegs_14 <= mux(reset, _debugRegs_WIRE_14, _GEN_59) @[Functions.scala 194:{30,30}]
    debugRegs_15 <= mux(reset, _debugRegs_WIRE_15, _GEN_60) @[Functions.scala 194:{30,30}]
    debugRegs_16 <= mux(reset, _debugRegs_WIRE_16, _GEN_61) @[Functions.scala 194:{30,30}]
    debugRegs_17 <= mux(reset, _debugRegs_WIRE_17, _GEN_62) @[Functions.scala 194:{30,30}]
    debugRegs_18 <= mux(reset, _debugRegs_WIRE_18, _GEN_63) @[Functions.scala 194:{30,30}]
    debugRegs_19 <= mux(reset, _debugRegs_WIRE_19, _GEN_64) @[Functions.scala 194:{30,30}]
    debugRegs_20 <= mux(reset, _debugRegs_WIRE_20, _GEN_65) @[Functions.scala 194:{30,30}]
    debugRegs_21 <= mux(reset, _debugRegs_WIRE_21, _GEN_66) @[Functions.scala 194:{30,30}]
    debugRegs_22 <= mux(reset, _debugRegs_WIRE_22, _GEN_67) @[Functions.scala 194:{30,30}]
    debugRegs_23 <= mux(reset, _debugRegs_WIRE_23, _GEN_68) @[Functions.scala 194:{30,30}]
    debugRegs_24 <= mux(reset, _debugRegs_WIRE_24, _GEN_69) @[Functions.scala 194:{30,30}]
    debugRegs_25 <= mux(reset, _debugRegs_WIRE_25, _GEN_70) @[Functions.scala 194:{30,30}]
    debugRegs_26 <= mux(reset, _debugRegs_WIRE_26, _GEN_71) @[Functions.scala 194:{30,30}]
    debugRegs_27 <= mux(reset, _debugRegs_WIRE_27, _GEN_72) @[Functions.scala 194:{30,30}]
    debugRegs_28 <= mux(reset, _debugRegs_WIRE_28, _GEN_73) @[Functions.scala 194:{30,30}]
    debugRegs_29 <= mux(reset, _debugRegs_WIRE_29, _GEN_74) @[Functions.scala 194:{30,30}]
    debugRegs_30 <= mux(reset, _debugRegs_WIRE_30, _GEN_75) @[Functions.scala 194:{30,30}]
    debugRegs_31 <= mux(reset, _debugRegs_WIRE_31, _GEN_76) @[Functions.scala 194:{30,30}]
    rs1Val_REG <= rs1 @[Functions.scala 195:31]
    rs2Val_REG <= rs2 @[Functions.scala 196:31]
    decExReg__decOut_instrType <= mux(reset, _decExReg_WIRE_decOut_instrType, decEx_decOut_instrType) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_aluOp <= mux(reset, _decExReg_WIRE_decOut_aluOp, decEx_decOut_aluOp) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_imm <= mux(reset, _decExReg_WIRE_decOut_imm, decEx_decOut_imm) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isImm <= mux(reset, _decExReg_WIRE_decOut_isImm, decEx_decOut_isImm) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isLui <= mux(reset, _decExReg_WIRE_decOut_isLui, decEx_decOut_isLui) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isAuiPc <= mux(reset, _decExReg_WIRE_decOut_isAuiPc, decEx_decOut_isAuiPc) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isLoad <= mux(reset, _decExReg_WIRE_decOut_isLoad, decEx_decOut_isLoad) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isStore <= mux(reset, _decExReg_WIRE_decOut_isStore, decEx_decOut_isStore) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isBranch <= mux(reset, _decExReg_WIRE_decOut_isBranch, decEx_decOut_isBranch) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isJal <= mux(reset, _decExReg_WIRE_decOut_isJal, decEx_decOut_isJal) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isJalr <= mux(reset, _decExReg_WIRE_decOut_isJalr, decEx_decOut_isJalr) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_rfWrite <= mux(reset, _decExReg_WIRE_decOut_rfWrite, decEx_decOut_rfWrite) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isECall <= mux(reset, _decExReg_WIRE_decOut_isECall, decEx_decOut_isECall) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_isCssrw <= mux(reset, _decExReg_WIRE_decOut_isCssrw, decEx_decOut_isCssrw) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_rs1Valid <= mux(reset, _decExReg_WIRE_decOut_rs1Valid, decEx_decOut_rs1Valid) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__decOut_rs2Valid <= mux(reset, _decExReg_WIRE_decOut_rs2Valid, decEx_decOut_rs2Valid) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__valid <= mux(reset, _decExReg_WIRE_valid, decEx_valid) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__pc <= mux(reset, _decExReg_WIRE_pc, decEx_pc) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__rs1 <= mux(reset, _decExReg_WIRE_rs1, decEx_rs1) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__rs2 <= mux(reset, _decExReg_WIRE_rs2, decEx_rs2) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__rd <= mux(reset, _decExReg_WIRE_rd, decEx_rd) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__rs1Val <= mux(reset, _decExReg_WIRE_rs1Val, decEx_rs1Val) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__rs2Val <= mux(reset, _decExReg_WIRE_rs2Val, decEx_rs2Val) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__func3 <= mux(reset, _decExReg_WIRE_func3, decEx_func3) @[ThreeCats.scala 109:{25,25} 110:12]
    decExReg__memLow <= mux(reset, _decExReg_WIRE_memLow, decEx_memLow) @[ThreeCats.scala 109:{25,25} 110:12]

  module ScratchPadMem :
    input clock : Clock
    input reset : UInt<1>
    input io_rdAddress : UInt<32>
    output io_rdData : UInt<32>
    input io_rdEnable : UInt<1>
    input io_wrAddress : UInt<32>
    input io_wrData : UInt<32>
    input io_wrEnable_0 : UInt<1>
    input io_wrEnable_1 : UInt<1>
    input io_wrEnable_2 : UInt<1>
    input io_wrEnable_3 : UInt<1>
    output io_stall : UInt<1>

    mem MEM : @[ScratchPadMem.scala 14:16]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_rdData_MPORT_3
      writer => MPORT
      read-under-write => new
    mem MEM_1 : @[ScratchPadMem.scala 15:16]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_rdData_MPORT_2
      writer => MPORT_1
      read-under-write => new
    mem MEM_2 : @[ScratchPadMem.scala 16:16]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_rdData_MPORT_1
      writer => MPORT_2
      read-under-write => new
    mem MEM_3 : @[ScratchPadMem.scala 17:16]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_rdData_MPORT
      writer => MPORT_3
      read-under-write => new
    node _io_rdData_T = bits(io_rdAddress, 12, 2) @[ScratchPadMem.scala 57:41]
    node _GEN_0 = validif(UInt<1>("h1"), _io_rdData_T) @[ScratchPadMem.scala 57:{28,28}]
    node _io_rdData_WIRE = _GEN_0 @[ScratchPadMem.scala 57:28]
    node _io_rdData_T_1 = or(_io_rdData_WIRE, UInt<10>("h0")) @[ScratchPadMem.scala 57:28]
    node _io_rdData_T_2 = bits(_io_rdData_T_1, 9, 0) @[ScratchPadMem.scala 57:28]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[ScratchPadMem.scala 17:16 57:{28,28}]
    node _GEN_2 = validif(UInt<1>("h1"), _io_rdData_T_2) @[ScratchPadMem.scala 57:{28,28}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[ScratchPadMem.scala 57:{28,28}]
    node _io_rdData_T_3 = bits(io_rdAddress, 12, 2) @[ScratchPadMem.scala 57:81]
    node _GEN_4 = validif(UInt<1>("h1"), _io_rdData_T_3) @[ScratchPadMem.scala 57:{68,68}]
    node _io_rdData_WIRE_1 = _GEN_4 @[ScratchPadMem.scala 57:68]
    node _io_rdData_T_4 = or(_io_rdData_WIRE_1, UInt<10>("h0")) @[ScratchPadMem.scala 57:68]
    node _io_rdData_T_5 = bits(_io_rdData_T_4, 9, 0) @[ScratchPadMem.scala 57:68]
    node _GEN_5 = validif(UInt<1>("h1"), _io_rdData_T_5) @[ScratchPadMem.scala 57:{68,68}]
    node _io_rdData_T_6 = cat(MEM_3.io_rdData_MPORT.data, MEM_2.io_rdData_MPORT_1.data) @[ScratchPadMem.scala 57:53]
    node _io_rdData_T_7 = bits(io_rdAddress, 12, 2) @[ScratchPadMem.scala 57:121]
    node _GEN_6 = validif(UInt<1>("h1"), _io_rdData_T_7) @[ScratchPadMem.scala 57:{108,108}]
    node _io_rdData_WIRE_2 = _GEN_6 @[ScratchPadMem.scala 57:108]
    node _io_rdData_T_8 = or(_io_rdData_WIRE_2, UInt<10>("h0")) @[ScratchPadMem.scala 57:108]
    node _io_rdData_T_9 = bits(_io_rdData_T_8, 9, 0) @[ScratchPadMem.scala 57:108]
    node _GEN_7 = validif(UInt<1>("h1"), _io_rdData_T_9) @[ScratchPadMem.scala 57:{108,108}]
    node _io_rdData_T_10 = cat(_io_rdData_T_6, MEM_1.io_rdData_MPORT_2.data) @[ScratchPadMem.scala 57:93]
    node _io_rdData_T_11 = bits(io_rdAddress, 12, 2) @[ScratchPadMem.scala 57:161]
    node _GEN_8 = validif(UInt<1>("h1"), _io_rdData_T_11) @[ScratchPadMem.scala 57:{148,148}]
    node _io_rdData_WIRE_3 = _GEN_8 @[ScratchPadMem.scala 57:148]
    node _io_rdData_T_12 = or(_io_rdData_WIRE_3, UInt<10>("h0")) @[ScratchPadMem.scala 57:148]
    node _io_rdData_T_13 = bits(_io_rdData_T_12, 9, 0) @[ScratchPadMem.scala 57:148]
    node _GEN_9 = validif(UInt<1>("h1"), _io_rdData_T_13) @[ScratchPadMem.scala 57:{148,148}]
    node _io_rdData_T_14 = cat(_io_rdData_T_10, MEM.io_rdData_MPORT_3.data) @[ScratchPadMem.scala 57:133]
    node _T = bits(io_wrAddress, 12, 2) @[ScratchPadMem.scala 59:31]
    node _T_1 = bits(io_wrData, 7, 0) @[ScratchPadMem.scala 59:52]
    node _T_2 = bits(_T, 9, 0)
    node _GEN_10 = validif(io_wrEnable_0, _T_2) @[ScratchPadMem.scala 58:24]
    node _GEN_11 = validif(io_wrEnable_0, clock) @[ScratchPadMem.scala 58:24]
    node _GEN_12 = mux(io_wrEnable_0, UInt<1>("h1"), UInt<1>("h0")) @[ScratchPadMem.scala 14:16 58:24]
    node _GEN_13 = validif(io_wrEnable_0, UInt<1>("h1")) @[ScratchPadMem.scala 58:24]
    node _GEN_14 = validif(io_wrEnable_0, _T_1) @[ScratchPadMem.scala 58:24]
    node _T_3 = bits(io_wrAddress, 12, 2) @[ScratchPadMem.scala 62:31]
    node _T_4 = bits(io_wrData, 15, 8) @[ScratchPadMem.scala 62:52]
    node _T_5 = bits(_T_3, 9, 0)
    node _GEN_15 = validif(io_wrEnable_1, _T_5) @[ScratchPadMem.scala 61:24]
    node _GEN_16 = validif(io_wrEnable_1, clock) @[ScratchPadMem.scala 61:24]
    node _GEN_17 = mux(io_wrEnable_1, UInt<1>("h1"), UInt<1>("h0")) @[ScratchPadMem.scala 15:16 61:24]
    node _GEN_18 = validif(io_wrEnable_1, UInt<1>("h1")) @[ScratchPadMem.scala 61:24]
    node _GEN_19 = validif(io_wrEnable_1, _T_4) @[ScratchPadMem.scala 61:24]
    node _T_6 = bits(io_wrAddress, 12, 2) @[ScratchPadMem.scala 65:31]
    node _T_7 = bits(io_wrData, 23, 16) @[ScratchPadMem.scala 65:52]
    node _T_8 = bits(_T_6, 9, 0)
    node _GEN_20 = validif(io_wrEnable_2, _T_8) @[ScratchPadMem.scala 64:24]
    node _GEN_21 = validif(io_wrEnable_2, clock) @[ScratchPadMem.scala 64:24]
    node _GEN_22 = mux(io_wrEnable_2, UInt<1>("h1"), UInt<1>("h0")) @[ScratchPadMem.scala 16:16 64:24]
    node _GEN_23 = validif(io_wrEnable_2, UInt<1>("h1")) @[ScratchPadMem.scala 64:24]
    node _GEN_24 = validif(io_wrEnable_2, _T_7) @[ScratchPadMem.scala 64:24]
    node _T_9 = bits(io_wrAddress, 12, 2) @[ScratchPadMem.scala 68:31]
    node _T_10 = bits(io_wrData, 31, 24) @[ScratchPadMem.scala 68:52]
    node _T_11 = bits(_T_9, 9, 0)
    node _GEN_25 = validif(io_wrEnable_3, _T_11) @[ScratchPadMem.scala 67:24]
    node _GEN_26 = validif(io_wrEnable_3, clock) @[ScratchPadMem.scala 67:24]
    node _GEN_27 = mux(io_wrEnable_3, UInt<1>("h1"), UInt<1>("h0")) @[ScratchPadMem.scala 17:16 67:24]
    node _GEN_28 = validif(io_wrEnable_3, UInt<1>("h1")) @[ScratchPadMem.scala 67:24]
    node _GEN_29 = validif(io_wrEnable_3, _T_10) @[ScratchPadMem.scala 67:24]
    io_rdData <= _io_rdData_T_14 @[ScratchPadMem.scala 57:13]
    io_stall <= UInt<1>("h0") @[ScratchPadMem.scala 70:12]
    MEM.io_rdData_MPORT_3.addr <= _GEN_9
    MEM.io_rdData_MPORT_3.en <= _GEN_1
    MEM.io_rdData_MPORT_3.clk <= _GEN_3
    MEM.MPORT.addr <= _GEN_10
    MEM.MPORT.en <= _GEN_12
    MEM.MPORT.clk <= _GEN_11
    MEM.MPORT.data <= _GEN_14
    MEM.MPORT.mask <= _GEN_13
    MEM_1.io_rdData_MPORT_2.addr <= _GEN_7
    MEM_1.io_rdData_MPORT_2.en <= _GEN_1
    MEM_1.io_rdData_MPORT_2.clk <= _GEN_3
    MEM_1.MPORT_1.addr <= _GEN_15
    MEM_1.MPORT_1.en <= _GEN_17
    MEM_1.MPORT_1.clk <= _GEN_16
    MEM_1.MPORT_1.data <= _GEN_19
    MEM_1.MPORT_1.mask <= _GEN_18
    MEM_2.io_rdData_MPORT_1.addr <= _GEN_5
    MEM_2.io_rdData_MPORT_1.en <= _GEN_1
    MEM_2.io_rdData_MPORT_1.clk <= _GEN_3
    MEM_2.MPORT_2.addr <= _GEN_20
    MEM_2.MPORT_2.en <= _GEN_22
    MEM_2.MPORT_2.clk <= _GEN_21
    MEM_2.MPORT_2.data <= _GEN_24
    MEM_2.MPORT_2.mask <= _GEN_23
    MEM_3.io_rdData_MPORT.addr <= _GEN_2
    MEM_3.io_rdData_MPORT.en <= _GEN_1
    MEM_3.io_rdData_MPORT.clk <= _GEN_3
    MEM_3.MPORT_3.addr <= _GEN_25
    MEM_3.MPORT_3.en <= _GEN_27
    MEM_3.MPORT_3.clk <= _GEN_26
    MEM_3.MPORT_3.data <= _GEN_29
    MEM_3.MPORT_3.mask <= _GEN_28

  module RAM :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<9>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 24:24]
      data-type => UInt<32>
      depth => 512
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 26:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 27:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 27:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<9>("h0")) @[RAM.scala 27:22]
    node _io_DO_T_1 = bits(_io_DO_T, 8, 0) @[RAM.scala 27:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 27:{22,22} 24:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 27:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 27:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 28:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 28:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 28:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 28:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 24:24 28:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 28:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 28:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 28:30 30:11 32:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 26:23 24:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 26:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 26:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 26:23 27:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 26:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 26:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 26:23 24:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 26:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 26:23]
    io_DO <= _GEN_13
    mem.io_DO_MPORT.addr <= _GEN_11
    mem.io_DO_MPORT.en <= _GEN_10
    mem.io_DO_MPORT.clk <= _GEN_12
    mem.MPORT.addr <= _GEN_14
    mem.MPORT.en <= _GEN_16
    mem.MPORT.clk <= _GEN_15
    mem.MPORT.data <= _GEN_18
    mem.MPORT.mask <= _GEN_17

  module RAM_1 :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<10>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 24:24]
      data-type => UInt<32>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 26:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 27:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 27:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<10>("h0")) @[RAM.scala 27:22]
    node _io_DO_T_1 = bits(_io_DO_T, 9, 0) @[RAM.scala 27:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 27:{22,22} 24:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 27:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 27:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 28:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 28:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 28:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 28:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 24:24 28:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 28:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 28:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 28:30 30:11 32:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 26:23 24:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 26:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 26:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 26:23 27:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 26:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 26:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 26:23 24:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 26:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 26:23]
    io_DO <= _GEN_13
    mem.io_DO_MPORT.addr <= _GEN_11
    mem.io_DO_MPORT.en <= _GEN_10
    mem.io_DO_MPORT.clk <= _GEN_12
    mem.MPORT.addr <= _GEN_14
    mem.MPORT.en <= _GEN_16
    mem.MPORT.clk <= _GEN_15
    mem.MPORT.data <= _GEN_18
    mem.MPORT.mask <= _GEN_17

  module RAM_2 :
    input clock : Clock
    input reset : UInt<1>
    input io_rw : UInt<1>
    input io_ad : UInt<12>
    input io_DI : UInt<32>
    input io_EN : UInt<1>
    output io_DO : UInt<32>

    mem mem : @[RAM.scala 24:24]
      data-type => UInt<32>
      depth => 4096
      read-latency => 1
      write-latency => 1
      reader => io_DO_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = and(io_rw, io_EN) @[RAM.scala 26:14]
    node _GEN_0 = validif(UInt<1>("h1"), io_ad) @[RAM.scala 27:{22,22}]
    node _io_DO_WIRE = _GEN_0 @[RAM.scala 27:22]
    node _io_DO_T = or(_io_DO_WIRE, UInt<12>("h0")) @[RAM.scala 27:22]
    node _io_DO_T_1 = bits(_io_DO_T, 11, 0) @[RAM.scala 27:22]
    node _GEN_1 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 27:{22,22} 24:24]
    node _GEN_2 = validif(UInt<1>("h1"), _io_DO_T_1) @[RAM.scala 27:{22,22}]
    node _GEN_3 = validif(UInt<1>("h1"), clock) @[RAM.scala 27:{22,22}]
    node _T_1 = eq(io_rw, UInt<1>("h0")) @[RAM.scala 28:14]
    node _T_2 = and(_T_1, io_EN) @[RAM.scala 28:21]
    node _GEN_4 = validif(_T_2, io_ad) @[RAM.scala 28:30]
    node _GEN_5 = validif(_T_2, clock) @[RAM.scala 28:30]
    node _GEN_6 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[RAM.scala 24:24 28:30]
    node _GEN_7 = validif(_T_2, UInt<1>("h1")) @[RAM.scala 28:30]
    node _GEN_8 = validif(_T_2, io_DI) @[RAM.scala 28:30]
    node _GEN_9 = mux(_T_2, UInt<1>("h0"), UInt<1>("h0")) @[RAM.scala 28:30 30:11 32:11]
    node _GEN_10 = mux(_T, _GEN_1, UInt<1>("h0")) @[RAM.scala 26:23 24:24]
    node _GEN_11 = validif(_T, _GEN_2) @[RAM.scala 26:23]
    node _GEN_12 = validif(_T, _GEN_3) @[RAM.scala 26:23]
    node _GEN_13 = mux(_T, mem.io_DO_MPORT.data, _GEN_9) @[RAM.scala 26:23 27:11]
    node _GEN_14 = validif(eq(_T, UInt<1>("h0")), _GEN_4) @[RAM.scala 26:23]
    node _GEN_15 = validif(eq(_T, UInt<1>("h0")), _GEN_5) @[RAM.scala 26:23]
    node _GEN_16 = mux(_T, UInt<1>("h0"), _GEN_6) @[RAM.scala 26:23 24:24]
    node _GEN_17 = validif(eq(_T, UInt<1>("h0")), _GEN_7) @[RAM.scala 26:23]
    node _GEN_18 = validif(eq(_T, UInt<1>("h0")), _GEN_8) @[RAM.scala 26:23]
    io_DO <= _GEN_13
    mem.io_DO_MPORT.addr <= _GEN_11
    mem.io_DO_MPORT.en <= _GEN_10
    mem.io_DO_MPORT.clk <= _GEN_12
    mem.MPORT.addr <= _GEN_14
    mem.MPORT.en <= _GEN_16
    mem.MPORT.clk <= _GEN_15
    mem.MPORT.data <= _GEN_18
    mem.MPORT.mask <= _GEN_17

  module CacheController :
    input clock : Clock
    input reset : UInt<1>
    input io_validReq : UInt<1>
    input io_rw : UInt<1>
    input io_memAdd : UInt<32>
    input io_DI : UInt<32>
    output io_DO : UInt<32>
    output io_ready : UInt<1>
    input io_memReady : UInt<1>
    output io_cacheMiss : UInt<1>
    output io_cacheInvalid : UInt<1>

    inst tagStore of RAM @[CacheController.scala 36:24]
    inst cache of RAM_1 @[CacheController.scala 37:21]
    inst extMem of RAM_2 @[CacheController.scala 38:22]
    reg lastRead : UInt<32>, clock with :
      reset => (UInt<1>("h0"), lastRead) @[CacheController.scala 35:25]
    node blockOffset = bits(io_memAdd, 3, 2) @[CacheController.scala 44:30]
    node index = bits(io_memAdd, 11, 4) @[CacheController.scala 45:24]
    node targetTag = bits(io_memAdd, 31, 12) @[CacheController.scala 46:28]
    node actualTag = bits(tagStore.io_DO, 31, 12) @[CacheController.scala 48:33]
    node cacheValid = bits(tagStore.io_DO, 11, 11) @[CacheController.scala 49:34]
    reg writeIndex : UInt<3>, clock with :
      reset => (UInt<1>("h0"), writeIndex) @[CacheController.scala 50:27]
    reg updatedTag : UInt<32>, clock with :
      reset => (UInt<1>("h0"), updatedTag) @[CacheController.scala 51:27]
    node memWordAdd = bits(io_memAdd, 31, 2) @[CacheController.scala 56:29]
    node _cacheReadAdd_T = cat(index, blockOffset) @[CacheController.scala 72:25]
    node _cacheWriteAdd_T = cat(index, writeIndex) @[CacheController.scala 73:26]
    node _targetTagWord_T = shl(targetTag, 12) @[CacheController.scala 76:30]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheController.scala 88:25]
    node _T = asUInt(UInt<1>("h0")) @[CacheController.scala 92:20]
    node _T_1 = asUInt(stateReg) @[CacheController.scala 92:20]
    node _T_2 = eq(_T, _T_1) @[CacheController.scala 92:20]
    node _GEN_0 = mux(io_rw, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 101:21 CacheFunctions.scala 13:13 8:13]
    node _GEN_1 = mux(io_rw, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 101:21 CacheFunctions.scala 14:13 9:13]
    node _GEN_2 = mux(io_rw, io_DI, io_DI) @[CacheController.scala 101:21 64:15 108:23]
    node cacheReadAdd = _cacheReadAdd_T @[CacheController.scala 53:30 72:16]
    node _GEN_3 = mux(io_validReq, cacheReadAdd, UInt<10>("h0")) @[CacheController.scala 95:25 97:18 55:26]
    node _GEN_4 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 95:25 CacheFunctions.scala 18:13 8:13]
    node _GEN_5 = mux(io_validReq, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 95:25 CacheFunctions.scala 19:13 9:13]
    node _GEN_6 = mux(io_validReq, UInt<1>("h1"), stateReg) @[CacheController.scala 95:25 99:18 88:25]
    node _GEN_7 = mux(io_validReq, _GEN_0, UInt<1>("h0")) @[CacheController.scala 95:25 CacheFunctions.scala 18:13]
    node _GEN_8 = mux(io_validReq, _GEN_1, UInt<1>("h1")) @[CacheController.scala 95:25 CacheFunctions.scala 19:13]
    node _GEN_9 = mux(io_validReq, _GEN_2, io_DI) @[CacheController.scala 64:15 95:25]
    node _T_3 = asUInt(UInt<1>("h1")) @[CacheController.scala 92:20]
    node _T_4 = asUInt(stateReg) @[CacheController.scala 92:20]
    node _T_5 = eq(_T_3, _T_4) @[CacheController.scala 92:20]
    node _T_6 = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 118:12]
    node _T_7 = eq(actualTag, targetTag) @[CacheController.scala 123:28]
    node _GEN_10 = mux(io_rw, cache.io_DO, lastRead) @[CacheController.scala 126:21 129:20 35:25]
    node _GEN_11 = mux(io_rw, UInt<1>("h0"), UInt<2>("h3")) @[CacheController.scala 126:21 130:20 135:20]
    node cacheWriteAdd = bits(_cacheWriteAdd_T, 9, 0) @[CacheController.scala 52:31 73:17]
    node _GEN_12 = mux(_T_7, cacheReadAdd, cacheWriteAdd) @[CacheController.scala 123:43 124:18 138:18]
    node _GEN_13 = mux(_T_7, _GEN_0, UInt<1>("h0")) @[CacheController.scala 123:43 63:15]
    node _GEN_14 = mux(_T_7, _GEN_10, lastRead) @[CacheController.scala 123:43 35:25]
    node _GEN_15 = mux(_T_7, _GEN_11, UInt<2>("h2")) @[CacheController.scala 123:43 141:18]
    node _GEN_16 = mux(_T_7, _GEN_1, UInt<1>("h1")) @[CacheController.scala 123:43 62:15]
    node _GEN_17 = mux(_T_7, _GEN_2, io_DI) @[CacheController.scala 123:43 64:15]
    node _GEN_18 = mux(_T_7, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 123:43 68:16 139:22]
    node _GEN_19 = mux(_T_7, UInt<1>("h1"), UInt<1>("h1")) @[CacheController.scala 123:43 65:15 CacheFunctions.scala 9:13]
    node _GEN_20 = mux(_T_6, cacheWriteAdd, _GEN_12) @[CacheController.scala 118:25 119:18]
    node _GEN_21 = mux(_T_6, UInt<1>("h1"), _GEN_18) @[CacheController.scala 118:25 120:22]
    node _GEN_22 = mux(_T_6, UInt<1>("h1"), _GEN_19) @[CacheController.scala 118:25 CacheFunctions.scala 9:13]
    node _GEN_23 = mux(_T_6, UInt<2>("h2"), _GEN_15) @[CacheController.scala 118:25 122:18]
    node _GEN_24 = mux(_T_6, UInt<1>("h0"), _GEN_13) @[CacheController.scala 118:25 63:15]
    node _GEN_25 = mux(_T_6, lastRead, _GEN_14) @[CacheController.scala 118:25 35:25]
    node _GEN_26 = mux(_T_6, UInt<1>("h1"), _GEN_16) @[CacheController.scala 118:25 62:15]
    node _GEN_27 = mux(_T_6, io_DI, _GEN_17) @[CacheController.scala 118:25 64:15]
    node _T_8 = asUInt(UInt<2>("h3")) @[CacheController.scala 92:20]
    node _T_9 = asUInt(stateReg) @[CacheController.scala 92:20]
    node _T_10 = eq(_T_8, _T_9) @[CacheController.scala 92:20]
    node _GEN_28 = mux(io_memReady, UInt<1>("h0"), stateReg) @[CacheController.scala 153:25 154:18 88:25]
    node _T_11 = asUInt(UInt<2>("h2")) @[CacheController.scala 92:20]
    node _T_12 = asUInt(stateReg) @[CacheController.scala 92:20]
    node _T_13 = eq(_T_11, _T_12) @[CacheController.scala 92:20]
    node _extMem_io_ad_T = add(memWordAdd, writeIndex) @[CacheController.scala 163:34]
    node _extMem_io_ad_T_1 = tail(_extMem_io_ad_T, 1) @[CacheController.scala 163:34]
    node _extMem_io_ad_T_2 = add(_extMem_io_ad_T_1, UInt<1>("h1")) @[CacheController.scala 163:47]
    node _extMem_io_ad_T_3 = tail(_extMem_io_ad_T_2, 1) @[CacheController.scala 163:47]
    node targetTagWord = _targetTagWord_T @[CacheController.scala 47:31 76:17]
    node _updatedTag_T = or(targetTagWord, UInt<12>("h800")) @[CacheController.scala 166:35]
    node _T_14 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 168:38]
    node _T_15 = and(io_memReady, _T_14) @[CacheController.scala 168:24]
    node _T_16 = eq(io_memReady, UInt<1>("h0")) @[CacheController.scala 173:18]
    node _T_17 = eq(writeIndex, UInt<2>("h3")) @[CacheController.scala 173:45]
    node _T_18 = and(_T_16, _T_17) @[CacheController.scala 173:31]
    node _writeIndex_T = add(writeIndex, UInt<1>("h1")) @[CacheController.scala 176:34]
    node _writeIndex_T_1 = tail(_writeIndex_T, 1) @[CacheController.scala 176:34]
    node _GEN_29 = mux(_T_18, UInt<2>("h3"), _writeIndex_T_1) @[CacheController.scala 173:73 174:20 176:20]
    node _GEN_30 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 168:66 CacheFunctions.scala 13:13 CacheController.scala 61:18]
    node _GEN_31 = mux(_T_15, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 168:66 CacheFunctions.scala 14:13 CacheController.scala 60:18]
    node _GEN_32 = mux(_T_15, UInt<1>("h1"), stateReg) @[CacheController.scala 168:66 171:18 88:25]
    node _GEN_33 = mux(_T_15, UInt<1>("h0"), _GEN_29) @[CacheController.scala 168:66 172:20]
    node _GEN_34 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[CacheController.scala 158:20 68:16 92:20]
    node _GEN_35 = mux(_T_13, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 92:20 CacheFunctions.scala 14:13 CacheController.scala 62:15]
    node _GEN_36 = mux(_T_13, cacheWriteAdd, UInt<10>("h0")) @[CacheController.scala 161:16 92:20 55:26]
    node _GEN_37 = mux(_T_13, _extMem_io_ad_T_3, memWordAdd) @[CacheController.scala 163:20 67:16 92:20]
    node _GEN_38 = mux(_T_13, extMem.io_DO, io_DI) @[CacheController.scala 164:19 64:15 92:20]
    node _GEN_39 = mux(_T_13, _updatedTag_T, updatedTag) @[CacheController.scala 166:18 92:20 51:27]
    node _GEN_40 = mux(_T_13, _GEN_30, UInt<1>("h0")) @[CacheController.scala 61:18 92:20]
    node _GEN_41 = mux(_T_13, _GEN_31, UInt<1>("h1")) @[CacheController.scala 60:18 92:20]
    node _GEN_42 = mux(_T_13, _GEN_32, stateReg) @[CacheController.scala 92:20 88:25]
    node _GEN_43 = mux(_T_13, _GEN_33, writeIndex) @[CacheController.scala 92:20 50:27]
    node _GEN_44 = mux(_T_10, cacheReadAdd, _GEN_36) @[CacheController.scala 148:16 92:20]
    node _GEN_45 = mux(_T_10, UInt<1>("h0"), UInt<1>("h1")) @[CacheController.scala 149:20 65:15 92:20]
    node _GEN_46 = mux(_T_10, UInt<1>("h1"), _GEN_34) @[CacheController.scala 150:20 92:20]
    node _GEN_47 = mux(_T_10, io_DI, UInt<32>("h0")) @[CacheController.scala 151:17 92:20 54:27]
    node _GEN_48 = mux(_T_10, _GEN_28, _GEN_42) @[CacheController.scala 92:20]
    node _GEN_49 = mux(_T_10, UInt<1>("h0"), _GEN_34) @[CacheController.scala 68:16 92:20]
    node _GEN_50 = mux(_T_10, UInt<1>("h1"), _GEN_35) @[CacheController.scala 62:15 92:20]
    node _GEN_51 = mux(_T_10, memWordAdd, _GEN_37) @[CacheController.scala 67:16 92:20]
    node _GEN_52 = mux(_T_10, io_DI, _GEN_38) @[CacheController.scala 64:15 92:20]
    node _GEN_53 = mux(_T_10, updatedTag, _GEN_39) @[CacheController.scala 92:20 51:27]
    node _GEN_54 = mux(_T_10, UInt<1>("h0"), _GEN_40) @[CacheController.scala 61:18 92:20]
    node _GEN_55 = mux(_T_10, UInt<1>("h1"), _GEN_41) @[CacheController.scala 60:18 92:20]
    node _GEN_56 = mux(_T_10, writeIndex, _GEN_43) @[CacheController.scala 92:20 50:27]
    node _GEN_57 = mux(_T_5, UInt<1>("h1"), _GEN_54) @[CacheController.scala 92:20 117:22]
    node _GEN_58 = mux(_T_5, _GEN_20, _GEN_44) @[CacheController.scala 92:20]
    node _GEN_59 = mux(_T_5, _GEN_21, _GEN_49) @[CacheController.scala 92:20]
    node _GEN_60 = mux(_T_5, _GEN_21, _GEN_46) @[CacheController.scala 92:20]
    node _GEN_61 = mux(_T_5, _GEN_22, _GEN_45) @[CacheController.scala 92:20]
    node _GEN_62 = mux(_T_5, _GEN_23, _GEN_48) @[CacheController.scala 92:20]
    node _GEN_63 = mux(_T_5, _GEN_24, _GEN_49) @[CacheController.scala 92:20]
    node _GEN_64 = mux(_T_5, _GEN_25, lastRead) @[CacheController.scala 92:20 35:25]
    node _GEN_65 = mux(_T_5, _GEN_26, _GEN_50) @[CacheController.scala 92:20]
    node _GEN_66 = mux(_T_5, _GEN_27, _GEN_52) @[CacheController.scala 92:20]
    node _GEN_67 = mux(_T_5, UInt<32>("h0"), _GEN_47) @[CacheController.scala 92:20 54:27]
    node _GEN_68 = mux(_T_5, memWordAdd, _GEN_51) @[CacheController.scala 67:16 92:20]
    node _GEN_69 = mux(_T_5, updatedTag, _GEN_53) @[CacheController.scala 92:20 51:27]
    node _GEN_70 = mux(_T_5, UInt<1>("h1"), _GEN_55) @[CacheController.scala 60:18 92:20]
    node _GEN_71 = mux(_T_5, writeIndex, _GEN_56) @[CacheController.scala 92:20 50:27]
    node _GEN_72 = mux(_T_2, UInt<1>("h0"), _GEN_60) @[CacheController.scala 92:20 CacheFunctions.scala 18:13]
    node _GEN_73 = mux(_T_2, UInt<1>("h1"), _GEN_61) @[CacheController.scala 92:20 CacheFunctions.scala 19:13]
    node _GEN_74 = mux(_T_2, _GEN_3, _GEN_58) @[CacheController.scala 92:20]
    node _GEN_75 = mux(_T_2, _GEN_4, _GEN_57) @[CacheController.scala 92:20]
    node _GEN_76 = mux(_T_2, _GEN_5, _GEN_70) @[CacheController.scala 92:20]
    node _GEN_77 = mux(_T_2, _GEN_6, _GEN_62) @[CacheController.scala 92:20]
    node _GEN_78 = mux(_T_2, _GEN_7, _GEN_63) @[CacheController.scala 92:20]
    node _GEN_79 = mux(_T_2, _GEN_8, _GEN_65) @[CacheController.scala 92:20]
    node _GEN_80 = mux(_T_2, _GEN_9, _GEN_66) @[CacheController.scala 92:20]
    node _GEN_81 = mux(_T_2, UInt<1>("h0"), _GEN_59) @[CacheController.scala 68:16 92:20]
    node _GEN_82 = mux(_T_2, lastRead, _GEN_64) @[CacheController.scala 92:20 35:25]
    node _GEN_83 = mux(_T_2, UInt<32>("h0"), _GEN_67) @[CacheController.scala 92:20 54:27]
    node _GEN_84 = mux(_T_2, memWordAdd, _GEN_68) @[CacheController.scala 67:16 92:20]
    node _GEN_85 = mux(_T_2, updatedTag, _GEN_69) @[CacheController.scala 92:20 51:27]
    node _GEN_86 = mux(_T_2, writeIndex, _GEN_71) @[CacheController.scala 92:20 50:27]
    node _io_ready_T = eq(stateReg, UInt<1>("h0")) @[CacheController.scala 184:24]
    node _io_cacheInvalid_T = eq(cacheValid, UInt<1>("h0")) @[CacheController.scala 185:22]
    node memDataIn = _GEN_83 @[CacheController.scala 54:27]
    node cacheAdd = _GEN_74 @[CacheController.scala 55:26]
    io_DO <= lastRead @[CacheController.scala 187:9]
    io_ready <= _io_ready_T @[CacheController.scala 184:12]
    io_cacheMiss <= _GEN_81
    io_cacheInvalid <= _io_cacheInvalid_T @[CacheController.scala 185:19]
    lastRead <= mux(reset, UInt<32>("h0"), _GEN_82) @[CacheController.scala 35:{25,25}]
    tagStore.clock <= clock
    tagStore.reset <= reset
    tagStore.io_rw <= _GEN_76
    tagStore.io_ad <= pad(index, 9) @[CacheController.scala 79:18]
    tagStore.io_DI <= updatedTag @[CacheController.scala 186:18]
    tagStore.io_EN <= _GEN_75
    cache.clock <= clock
    cache.reset <= reset
    cache.io_rw <= _GEN_79
    cache.io_ad <= cacheAdd @[CacheController.scala 75:15]
    cache.io_DI <= _GEN_80
    cache.io_EN <= _GEN_78
    extMem.clock <= clock
    extMem.reset <= reset
    extMem.io_rw <= _GEN_73
    extMem.io_ad <= bits(_GEN_84, 11, 0)
    extMem.io_DI <= memDataIn @[CacheController.scala 71:16]
    extMem.io_EN <= _GEN_72
    writeIndex <= mux(reset, UInt<3>("h0"), _GEN_86) @[CacheController.scala 50:{27,27}]
    updatedTag <= mux(reset, UInt<32>("h0"), _GEN_85) @[CacheController.scala 51:{27,27}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_77) @[CacheController.scala 88:{25,25}]

  module CacheTop :
    input clock : Clock
    input reset : UInt<1>
    input io_rdAddress : UInt<32>
    output io_rdData : UInt<32>
    input io_rdEnable : UInt<1>
    input io_wrAddress : UInt<32>
    input io_wrData : UInt<32>
    input io_wrEnable_0 : UInt<1>
    input io_wrEnable_1 : UInt<1>
    input io_wrEnable_2 : UInt<1>
    input io_wrEnable_3 : UInt<1>
    output io_stall : UInt<1>

    inst Controller of CacheController @[CacheTop.scala 22:26]
    node _GEN_0 = mux(Controller.io_cacheMiss, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 30:12 33:33 34:14]
    reg modifiedData : UInt<32>, clock with :
      reset => (UInt<1>("h0"), modifiedData) @[CacheTop.scala 41:29]
    node byteOffset = bits(io_wrAddress, 1, 0) @[CacheTop.scala 42:32]
    node weBits_lo = cat(io_wrEnable_1, io_wrEnable_0) @[CacheTop.scala 47:22]
    node weBits_hi = cat(io_wrEnable_3, io_wrEnable_2) @[CacheTop.scala 47:22]
    node weBits = cat(weBits_hi, weBits_lo) @[CacheTop.scala 47:22]
    node _T = eq(UInt<1>("h1"), weBits) @[CacheTop.scala 52:18]
    node _T_1 = eq(UInt<2>("h2"), weBits) @[CacheTop.scala 52:18]
    node _T_2 = eq(UInt<3>("h4"), weBits) @[CacheTop.scala 52:18]
    node _T_3 = eq(UInt<4>("h8"), weBits) @[CacheTop.scala 52:18]
    node _T_4 = eq(UInt<2>("h3"), weBits) @[CacheTop.scala 52:18]
    node _T_5 = eq(UInt<4>("hc"), weBits) @[CacheTop.scala 52:18]
    node _T_6 = eq(UInt<4>("hf"), weBits) @[CacheTop.scala 52:18]
    node _GEN_1 = mux(_T_6, UInt<2>("h2"), UInt<2>("h3")) @[CacheTop.scala 50:13 52:18 61:31]
    node _GEN_2 = mux(_T_5, UInt<1>("h1"), _GEN_1) @[CacheTop.scala 52:18 59:31]
    node _GEN_3 = mux(_T_4, UInt<1>("h1"), _GEN_2) @[CacheTop.scala 52:18 58:31]
    node _GEN_4 = mux(_T_3, UInt<1>("h0"), _GEN_3) @[CacheTop.scala 52:18 56:31]
    node _GEN_5 = mux(_T_2, UInt<1>("h0"), _GEN_4) @[CacheTop.scala 52:18 55:31]
    node _GEN_6 = mux(_T_1, UInt<1>("h0"), _GEN_5) @[CacheTop.scala 52:18 54:31]
    node _GEN_7 = mux(_T, UInt<1>("h0"), _GEN_6) @[CacheTop.scala 52:18 53:31]
    reg stateReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[CacheTop.scala 71:25]
    node _T_7 = asUInt(UInt<1>("h0")) @[CacheTop.scala 73:19]
    node _T_8 = asUInt(stateReg) @[CacheTop.scala 73:19]
    node _T_9 = eq(_T_7, _T_8) @[CacheTop.scala 73:19]
    node storeType = _GEN_7 @[CacheTop.scala 49:23]
    node _T_10 = neq(storeType, UInt<2>("h3")) @[CacheTop.scala 75:38]
    node _T_11 = or(io_rdEnable, _T_10) @[CacheTop.scala 75:24]
    node _GEN_8 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 75:47 76:18 78:18]
    node _T_12 = asUInt(UInt<1>("h1")) @[CacheTop.scala 73:19]
    node _T_13 = asUInt(stateReg) @[CacheTop.scala 73:19]
    node _T_14 = eq(_T_12, _T_13) @[CacheTop.scala 73:19]
    node _GEN_9 = mux(io_rdEnable, io_rdAddress, io_wrAddress) @[CacheTop.scala 84:25 85:30 87:30]
    node _T_15 = eq(storeType, UInt<2>("h3")) @[CacheTop.scala 90:24]
    node _modifiedData_readBytes_0_T = bits(Controller.io_DO, 7, 0) @[CacheFunctions.scala 29:31]
    node _modifiedData_writeBytes_0_T = bits(io_wrData, 7, 0) @[CacheFunctions.scala 30:33]
    node _modifiedData_readBytes_1_T = bits(Controller.io_DO, 15, 8) @[CacheFunctions.scala 29:31]
    node _modifiedData_writeBytes_1_T = bits(io_wrData, 15, 8) @[CacheFunctions.scala 30:33]
    node _modifiedData_readBytes_2_T = bits(Controller.io_DO, 23, 16) @[CacheFunctions.scala 29:31]
    node _modifiedData_writeBytes_2_T = bits(io_wrData, 23, 16) @[CacheFunctions.scala 30:33]
    node _modifiedData_readBytes_3_T = bits(Controller.io_DO, 31, 24) @[CacheFunctions.scala 29:31]
    node _modifiedData_writeBytes_3_T = bits(io_wrData, 31, 24) @[CacheFunctions.scala 30:33]
    node modifiedData_writeBytes_0 = _modifiedData_writeBytes_0_T @[CacheFunctions.scala 24:26 30:21]
    node modifiedData_readBytes_0 = _modifiedData_readBytes_0_T @[CacheFunctions.scala 25:25 29:20]
    node _modifiedData_resultBytes_0_T = mux(io_wrEnable_0, modifiedData_writeBytes_0, modifiedData_readBytes_0) @[CacheFunctions.scala 36:28]
    node modifiedData_writeBytes_1 = _modifiedData_writeBytes_1_T @[CacheFunctions.scala 24:26 30:21]
    node modifiedData_readBytes_1 = _modifiedData_readBytes_1_T @[CacheFunctions.scala 25:25 29:20]
    node _modifiedData_resultBytes_1_T = mux(io_wrEnable_1, modifiedData_writeBytes_1, modifiedData_readBytes_1) @[CacheFunctions.scala 36:28]
    node modifiedData_writeBytes_2 = _modifiedData_writeBytes_2_T @[CacheFunctions.scala 24:26 30:21]
    node modifiedData_readBytes_2 = _modifiedData_readBytes_2_T @[CacheFunctions.scala 25:25 29:20]
    node _modifiedData_resultBytes_2_T = mux(io_wrEnable_2, modifiedData_writeBytes_2, modifiedData_readBytes_2) @[CacheFunctions.scala 36:28]
    node modifiedData_writeBytes_3 = _modifiedData_writeBytes_3_T @[CacheFunctions.scala 24:26 30:21]
    node modifiedData_readBytes_3 = _modifiedData_readBytes_3_T @[CacheFunctions.scala 25:25 29:20]
    node _modifiedData_resultBytes_3_T = mux(io_wrEnable_3, modifiedData_writeBytes_3, modifiedData_readBytes_3) @[CacheFunctions.scala 36:28]
    node modifiedData_resultBytes_1 = _modifiedData_resultBytes_1_T @[CacheFunctions.scala 34:27 36:22]
    node modifiedData_resultBytes_0 = _modifiedData_resultBytes_0_T @[CacheFunctions.scala 34:27 36:22]
    node modifiedData_lo = cat(modifiedData_resultBytes_1, modifiedData_resultBytes_0) @[Cat.scala 33:92]
    node modifiedData_resultBytes_3 = _modifiedData_resultBytes_3_T @[CacheFunctions.scala 34:27 36:22]
    node modifiedData_resultBytes_2 = _modifiedData_resultBytes_2_T @[CacheFunctions.scala 34:27 36:22]
    node modifiedData_hi = cat(modifiedData_resultBytes_3, modifiedData_resultBytes_2) @[Cat.scala 33:92]
    node _modifiedData_T = cat(modifiedData_hi, modifiedData_lo) @[Cat.scala 33:92]
    node _GEN_10 = mux(_T_15, UInt<1>("h0"), UInt<2>("h2")) @[CacheTop.scala 90:33 91:20 94:20]
    node _GEN_11 = mux(_T_15, modifiedData, _modifiedData_T) @[CacheTop.scala 41:29 90:33 93:24]
    node _GEN_12 = mux(Controller.io_ready, _GEN_10, stateReg) @[CacheTop.scala 71:25 89:33]
    node _GEN_13 = mux(Controller.io_ready, _GEN_11, modifiedData) @[CacheTop.scala 41:29 89:33]
    node _T_16 = asUInt(UInt<2>("h2")) @[CacheTop.scala 73:19]
    node _T_17 = asUInt(stateReg) @[CacheTop.scala 73:19]
    node _T_18 = eq(_T_16, _T_17) @[CacheTop.scala 73:19]
    node _GEN_14 = mux(Controller.io_ready, UInt<1>("h0"), stateReg) @[CacheTop.scala 103:32 104:18 71:25]
    node _GEN_15 = mux(_T_18, UInt<1>("h1"), UInt<1>("h0")) @[CacheTop.scala 73:19 100:30 26:26]
    node _GEN_16 = mux(_T_18, UInt<1>("h0"), UInt<1>("h1")) @[CacheTop.scala 73:19 101:24 27:20]
    node _GEN_17 = mux(_T_18, io_wrAddress, io_rdAddress) @[CacheTop.scala 73:19 102:28 28:24]
    node _GEN_18 = mux(_T_18, _GEN_14, stateReg) @[CacheTop.scala 73:19 71:25]
    node _GEN_19 = mux(_T_14, UInt<1>("h1"), _GEN_15) @[CacheTop.scala 73:19 82:30]
    node _GEN_20 = mux(_T_14, UInt<1>("h1"), _GEN_16) @[CacheTop.scala 73:19 83:24]
    node _GEN_21 = mux(_T_14, _GEN_9, _GEN_17) @[CacheTop.scala 73:19]
    node _GEN_22 = mux(_T_14, _GEN_12, _GEN_18) @[CacheTop.scala 73:19]
    node _GEN_23 = mux(_T_14, _GEN_13, modifiedData) @[CacheTop.scala 73:19 41:29]
    node _GEN_24 = mux(_T_9, _GEN_8, _GEN_22) @[CacheTop.scala 73:19]
    node _GEN_25 = mux(_T_9, UInt<1>("h0"), _GEN_19) @[CacheTop.scala 73:19 26:26]
    node _GEN_26 = mux(_T_9, UInt<1>("h1"), _GEN_20) @[CacheTop.scala 73:19 27:20]
    node _GEN_27 = mux(_T_9, io_rdAddress, _GEN_21) @[CacheTop.scala 73:19 28:24]
    node _GEN_28 = mux(_T_9, modifiedData, _GEN_23) @[CacheTop.scala 73:19 41:29]
    io_rdData <= Controller.io_DO @[CacheTop.scala 29:13]
    io_stall <= _GEN_0
    Controller.clock <= clock
    Controller.reset <= reset
    Controller.io_validReq <= _GEN_25
    Controller.io_rw <= _GEN_26
    Controller.io_memAdd <= _GEN_27
    Controller.io_DI <= modifiedData @[CacheTop.scala 44:20]
    Controller.io_memReady <= UInt<1>("h1") @[CacheTop.scala 24:26]
    modifiedData <= mux(reset, UInt<32>("h0"), _GEN_28) @[CacheTop.scala 41:{29,29}]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_24) @[CacheTop.scala 71:{25,25}]

  module InstructionROM :
    input clock : Clock
    input reset : UInt<1>
    input io_address : UInt<32>
    output io_data : UInt<32>
    output io_stall : UInt<1>

    reg addrReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), addrReg) @[InstructionROM.scala 11:24]
    node _instructions_T = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_1 = asUInt(asSInt(UInt<32>("h113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_2 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_3 = asUInt(asSInt(UInt<32>("h80000eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_4 = asUInt(asSInt(UInt<32>("h200193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_5 = asUInt(asSInt(UInt<32>("h29df1263"))) @[InstructionROM.scala 13:62]
    node _instructions_T_6 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_7 = asUInt(asSInt(UInt<32>("h100113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_8 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_9 = asUInt(asSInt(UInt<32>("hc0000eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_10 = asUInt(asSInt(UInt<32>("h300193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_11 = asUInt(asSInt(UInt<32>("h27df1663"))) @[InstructionROM.scala 13:62]
    node _instructions_T_12 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_13 = asUInt(asSInt(UInt<32>("h700113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_14 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_15 = asUInt(asSInt(UInt<32>("hff000eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_16 = asUInt(asSInt(UInt<32>("h400193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_17 = asUInt(asSInt(UInt<32>("h25df1a63"))) @[InstructionROM.scala 13:62]
    node _instructions_T_18 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_19 = asUInt(asSInt(UInt<32>("he00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_20 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_21 = asUInt(asSInt(UInt<32>("hfffe0eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_22 = asUInt(asSInt(UInt<32>("h500193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_23 = asUInt(asSInt(UInt<32>("h23df1e63"))) @[InstructionROM.scala 13:62]
    node _instructions_T_24 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_25 = asUInt(asSInt(UInt<32>("h108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_26 = asUInt(asSInt(UInt<32>("h1f00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_27 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_28 = asUInt(asSInt(UInt<32>("hfff00e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_29 = asUInt(asSInt(UInt<32>("h600193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_30 = asUInt(asSInt(UInt<32>("h23df1063"))) @[InstructionROM.scala 13:62]
    node _instructions_T_31 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_32 = asUInt(asSInt(UInt<32>("hfff08093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_33 = asUInt(asSInt(UInt<32>("h113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_34 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_35 = asUInt(asSInt(UInt<32>("h80000eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_36 = asUInt(asSInt(UInt<32>("hfffe8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_37 = asUInt(asSInt(UInt<32>("h700193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_38 = asUInt(asSInt(UInt<32>("h21df1063"))) @[InstructionROM.scala 13:62]
    node _instructions_T_39 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_40 = asUInt(asSInt(UInt<32>("hfff08093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_41 = asUInt(asSInt(UInt<32>("h100113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_42 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_43 = asUInt(asSInt(UInt<32>("h40000eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_44 = asUInt(asSInt(UInt<32>("hfffe8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_45 = asUInt(asSInt(UInt<32>("h800193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_46 = asUInt(asSInt(UInt<32>("h1fdf1063"))) @[InstructionROM.scala 13:62]
    node _instructions_T_47 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_48 = asUInt(asSInt(UInt<32>("hfff08093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_49 = asUInt(asSInt(UInt<32>("h700113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_50 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_51 = asUInt(asSInt(UInt<32>("h1000eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_52 = asUInt(asSInt(UInt<32>("hfffe8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_53 = asUInt(asSInt(UInt<32>("h900193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_54 = asUInt(asSInt(UInt<32>("h1ddf1063"))) @[InstructionROM.scala 13:62]
    node _instructions_T_55 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_56 = asUInt(asSInt(UInt<32>("hfff08093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_57 = asUInt(asSInt(UInt<32>("he00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_58 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_59 = asUInt(asSInt(UInt<32>("h20eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_60 = asUInt(asSInt(UInt<32>("hfffe8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_61 = asUInt(asSInt(UInt<32>("ha00193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_62 = asUInt(asSInt(UInt<32>("h1bdf1063"))) @[InstructionROM.scala 13:62]
    node _instructions_T_63 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_64 = asUInt(asSInt(UInt<32>("hfff08093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_65 = asUInt(asSInt(UInt<32>("h1f00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_66 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_67 = asUInt(asSInt(UInt<32>("he93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_68 = asUInt(asSInt(UInt<32>("hb00193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_69 = asUInt(asSInt(UInt<32>("h19df1263"))) @[InstructionROM.scala 13:62]
    node _instructions_T_70 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_71 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_72 = asUInt(asSInt(UInt<32>("h113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_73 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_74 = asUInt(asSInt(UInt<32>("h81818eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_75 = asUInt(asSInt(UInt<32>("h181e8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_76 = asUInt(asSInt(UInt<32>("hc00193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_77 = asUInt(asSInt(UInt<32>("h17df1263"))) @[InstructionROM.scala 13:62]
    node _instructions_T_78 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_79 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_80 = asUInt(asSInt(UInt<32>("h100113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_81 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_82 = asUInt(asSInt(UInt<32>("hc0c0ceb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_83 = asUInt(asSInt(UInt<32>("hc0e8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_84 = asUInt(asSInt(UInt<32>("hd00193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_85 = asUInt(asSInt(UInt<32>("h15df1263"))) @[InstructionROM.scala 13:62]
    node _instructions_T_86 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_87 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_88 = asUInt(asSInt(UInt<32>("h700113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_89 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_90 = asUInt(asSInt(UInt<32>("hff030eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_91 = asUInt(asSInt(UInt<32>("h303e8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_92 = asUInt(asSInt(UInt<32>("he00193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_93 = asUInt(asSInt(UInt<32>("h13df1263"))) @[InstructionROM.scala 13:62]
    node _instructions_T_94 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_95 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_96 = asUInt(asSInt(UInt<32>("he00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_97 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_98 = asUInt(asSInt(UInt<32>("hfffe0eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_99 = asUInt(asSInt(UInt<32>("h606e8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_100 = asUInt(asSInt(UInt<32>("hf00193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_101 = asUInt(asSInt(UInt<32>("h11df1263"))) @[InstructionROM.scala 13:62]
    node _instructions_T_102 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_103 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_104 = asUInt(asSInt(UInt<32>("h1f00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_105 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_106 = asUInt(asSInt(UInt<32>("hfff00e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_107 = asUInt(asSInt(UInt<32>("h1000193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_108 = asUInt(asSInt(UInt<32>("hfdf1463"))) @[InstructionROM.scala 13:62]
    node _instructions_T_109 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_110 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_111 = asUInt(asSInt(UInt<32>("hfc000113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_112 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_113 = asUInt(asSInt(UInt<32>("h81818eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_114 = asUInt(asSInt(UInt<32>("h181e8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_115 = asUInt(asSInt(UInt<32>("h1100193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_116 = asUInt(asSInt(UInt<32>("hddf1463"))) @[InstructionROM.scala 13:62]
    node _instructions_T_117 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_118 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_119 = asUInt(asSInt(UInt<32>("hfc100113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_120 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_121 = asUInt(asSInt(UInt<32>("hc0c0ceb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_122 = asUInt(asSInt(UInt<32>("hc0e8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_123 = asUInt(asSInt(UInt<32>("h1200193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_124 = asUInt(asSInt(UInt<32>("hbdf1463"))) @[InstructionROM.scala 13:62]
    node _instructions_T_125 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_126 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_127 = asUInt(asSInt(UInt<32>("hfc700113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_128 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_129 = asUInt(asSInt(UInt<32>("hff030eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_130 = asUInt(asSInt(UInt<32>("h303e8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_131 = asUInt(asSInt(UInt<32>("h1300193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_132 = asUInt(asSInt(UInt<32>("h9df1463"))) @[InstructionROM.scala 13:62]
    node _instructions_T_133 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_134 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_135 = asUInt(asSInt(UInt<32>("hfce00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_136 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_137 = asUInt(asSInt(UInt<32>("hfffe0eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_138 = asUInt(asSInt(UInt<32>("h606e8e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_139 = asUInt(asSInt(UInt<32>("h1400193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_140 = asUInt(asSInt(UInt<32>("h7df1463"))) @[InstructionROM.scala 13:62]
    node _instructions_T_141 = asUInt(asSInt(UInt<32>("h818180b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_142 = asUInt(asSInt(UInt<32>("h18108093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_143 = asUInt(asSInt(UInt<32>("hfff00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_144 = asUInt(asSInt(UInt<32>("h4020df33"))) @[InstructionROM.scala 13:62]
    node _instructions_T_145 = asUInt(asSInt(UInt<32>("hfff00e93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_146 = asUInt(asSInt(UInt<32>("h1500193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_147 = asUInt(asSInt(UInt<32>("h5df1663"))) @[InstructionROM.scala 13:62]
    node _instructions_T_148 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_149 = asUInt(asSInt(UInt<32>("h700113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_150 = asUInt(asSInt(UInt<32>("h4020d0b3"))) @[InstructionROM.scala 13:62]
    node _instructions_T_151 = asUInt(asSInt(UInt<32>("hff000eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_152 = asUInt(asSInt(UInt<32>("h1600193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_153 = asUInt(asSInt(UInt<32>("h3d09a63"))) @[InstructionROM.scala 13:62]
    node _instructions_T_154 = asUInt(asSInt(UInt<32>("h800000b7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_155 = asUInt(asSInt(UInt<32>("he00113"))) @[InstructionROM.scala 13:62]
    node _instructions_T_156 = asUInt(asSInt(UInt<32>("h4020d133"))) @[InstructionROM.scala 13:62]
    node _instructions_T_157 = asUInt(asSInt(UInt<32>("hfffe0eb7"))) @[InstructionROM.scala 13:62]
    node _instructions_T_158 = asUInt(asSInt(UInt<32>("h1700193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_159 = asUInt(asSInt(UInt<32>("h1d11e63"))) @[InstructionROM.scala 13:62]
    node _instructions_T_160 = asUInt(asSInt(UInt<32>("h700093"))) @[InstructionROM.scala 13:62]
    node _instructions_T_161 = asUInt(asSInt(UInt<32>("h4010d0b3"))) @[InstructionROM.scala 13:62]
    node _instructions_T_162 = asUInt(asSInt(UInt<32>("he93"))) @[InstructionROM.scala 13:62]
    node _instructions_T_163 = asUInt(asSInt(UInt<32>("h1800193"))) @[InstructionROM.scala 13:62]
    node _instructions_T_164 = asUInt(asSInt(UInt<32>("h1d09463"))) @[InstructionROM.scala 13:62]
    node _instructions_T_165 = asUInt(asSInt(UInt<32>("h301863"))) @[InstructionROM.scala 13:62]
    node _instructions_T_166 = asUInt(asSInt(UInt<32>("h100513"))) @[InstructionROM.scala 13:62]
    node _instructions_T_167 = asUInt(asSInt(UInt<32>("h5d00893"))) @[InstructionROM.scala 13:62]
    node _instructions_T_168 = asUInt(asSInt(UInt<32>("h73"))) @[InstructionROM.scala 13:62]
    node _instructions_T_169 = asUInt(asSInt(UInt<32>("h513"))) @[InstructionROM.scala 13:62]
    node _instructions_T_170 = asUInt(asSInt(UInt<32>("h5d00893"))) @[InstructionROM.scala 13:62]
    node _instructions_T_171 = asUInt(asSInt(UInt<32>("h73"))) @[InstructionROM.scala 13:62]
    node _io_data_T = bits(addrReg, 31, 2) @[InstructionROM.scala 14:34]
    node _io_data_T_1 = bits(_io_data_T, 7, 0)
    node instructions_0 = _instructions_T @[InstructionROM.scala 13:{29,29}]
    node _GEN_0 = validif(eq(UInt<1>("h0"), _io_data_T_1), instructions_0) @[InstructionROM.scala 14:{11,11}]
    node instructions_1 = _instructions_T_1 @[InstructionROM.scala 13:{29,29}]
    node _GEN_1 = mux(eq(UInt<1>("h1"), _io_data_T_1), instructions_1, _GEN_0) @[InstructionROM.scala 14:{11,11}]
    node instructions_2 = _instructions_T_2 @[InstructionROM.scala 13:{29,29}]
    node _GEN_2 = mux(eq(UInt<2>("h2"), _io_data_T_1), instructions_2, _GEN_1) @[InstructionROM.scala 14:{11,11}]
    node instructions_3 = _instructions_T_3 @[InstructionROM.scala 13:{29,29}]
    node _GEN_3 = mux(eq(UInt<2>("h3"), _io_data_T_1), instructions_3, _GEN_2) @[InstructionROM.scala 14:{11,11}]
    node instructions_4 = _instructions_T_4 @[InstructionROM.scala 13:{29,29}]
    node _GEN_4 = mux(eq(UInt<3>("h4"), _io_data_T_1), instructions_4, _GEN_3) @[InstructionROM.scala 14:{11,11}]
    node instructions_5 = _instructions_T_5 @[InstructionROM.scala 13:{29,29}]
    node _GEN_5 = mux(eq(UInt<3>("h5"), _io_data_T_1), instructions_5, _GEN_4) @[InstructionROM.scala 14:{11,11}]
    node instructions_6 = _instructions_T_6 @[InstructionROM.scala 13:{29,29}]
    node _GEN_6 = mux(eq(UInt<3>("h6"), _io_data_T_1), instructions_6, _GEN_5) @[InstructionROM.scala 14:{11,11}]
    node instructions_7 = _instructions_T_7 @[InstructionROM.scala 13:{29,29}]
    node _GEN_7 = mux(eq(UInt<3>("h7"), _io_data_T_1), instructions_7, _GEN_6) @[InstructionROM.scala 14:{11,11}]
    node instructions_8 = _instructions_T_8 @[InstructionROM.scala 13:{29,29}]
    node _GEN_8 = mux(eq(UInt<4>("h8"), _io_data_T_1), instructions_8, _GEN_7) @[InstructionROM.scala 14:{11,11}]
    node instructions_9 = _instructions_T_9 @[InstructionROM.scala 13:{29,29}]
    node _GEN_9 = mux(eq(UInt<4>("h9"), _io_data_T_1), instructions_9, _GEN_8) @[InstructionROM.scala 14:{11,11}]
    node instructions_10 = _instructions_T_10 @[InstructionROM.scala 13:{29,29}]
    node _GEN_10 = mux(eq(UInt<4>("ha"), _io_data_T_1), instructions_10, _GEN_9) @[InstructionROM.scala 14:{11,11}]
    node instructions_11 = _instructions_T_11 @[InstructionROM.scala 13:{29,29}]
    node _GEN_11 = mux(eq(UInt<4>("hb"), _io_data_T_1), instructions_11, _GEN_10) @[InstructionROM.scala 14:{11,11}]
    node instructions_12 = _instructions_T_12 @[InstructionROM.scala 13:{29,29}]
    node _GEN_12 = mux(eq(UInt<4>("hc"), _io_data_T_1), instructions_12, _GEN_11) @[InstructionROM.scala 14:{11,11}]
    node instructions_13 = _instructions_T_13 @[InstructionROM.scala 13:{29,29}]
    node _GEN_13 = mux(eq(UInt<4>("hd"), _io_data_T_1), instructions_13, _GEN_12) @[InstructionROM.scala 14:{11,11}]
    node instructions_14 = _instructions_T_14 @[InstructionROM.scala 13:{29,29}]
    node _GEN_14 = mux(eq(UInt<4>("he"), _io_data_T_1), instructions_14, _GEN_13) @[InstructionROM.scala 14:{11,11}]
    node instructions_15 = _instructions_T_15 @[InstructionROM.scala 13:{29,29}]
    node _GEN_15 = mux(eq(UInt<4>("hf"), _io_data_T_1), instructions_15, _GEN_14) @[InstructionROM.scala 14:{11,11}]
    node instructions_16 = _instructions_T_16 @[InstructionROM.scala 13:{29,29}]
    node _GEN_16 = mux(eq(UInt<5>("h10"), _io_data_T_1), instructions_16, _GEN_15) @[InstructionROM.scala 14:{11,11}]
    node instructions_17 = _instructions_T_17 @[InstructionROM.scala 13:{29,29}]
    node _GEN_17 = mux(eq(UInt<5>("h11"), _io_data_T_1), instructions_17, _GEN_16) @[InstructionROM.scala 14:{11,11}]
    node instructions_18 = _instructions_T_18 @[InstructionROM.scala 13:{29,29}]
    node _GEN_18 = mux(eq(UInt<5>("h12"), _io_data_T_1), instructions_18, _GEN_17) @[InstructionROM.scala 14:{11,11}]
    node instructions_19 = _instructions_T_19 @[InstructionROM.scala 13:{29,29}]
    node _GEN_19 = mux(eq(UInt<5>("h13"), _io_data_T_1), instructions_19, _GEN_18) @[InstructionROM.scala 14:{11,11}]
    node instructions_20 = _instructions_T_20 @[InstructionROM.scala 13:{29,29}]
    node _GEN_20 = mux(eq(UInt<5>("h14"), _io_data_T_1), instructions_20, _GEN_19) @[InstructionROM.scala 14:{11,11}]
    node instructions_21 = _instructions_T_21 @[InstructionROM.scala 13:{29,29}]
    node _GEN_21 = mux(eq(UInt<5>("h15"), _io_data_T_1), instructions_21, _GEN_20) @[InstructionROM.scala 14:{11,11}]
    node instructions_22 = _instructions_T_22 @[InstructionROM.scala 13:{29,29}]
    node _GEN_22 = mux(eq(UInt<5>("h16"), _io_data_T_1), instructions_22, _GEN_21) @[InstructionROM.scala 14:{11,11}]
    node instructions_23 = _instructions_T_23 @[InstructionROM.scala 13:{29,29}]
    node _GEN_23 = mux(eq(UInt<5>("h17"), _io_data_T_1), instructions_23, _GEN_22) @[InstructionROM.scala 14:{11,11}]
    node instructions_24 = _instructions_T_24 @[InstructionROM.scala 13:{29,29}]
    node _GEN_24 = mux(eq(UInt<5>("h18"), _io_data_T_1), instructions_24, _GEN_23) @[InstructionROM.scala 14:{11,11}]
    node instructions_25 = _instructions_T_25 @[InstructionROM.scala 13:{29,29}]
    node _GEN_25 = mux(eq(UInt<5>("h19"), _io_data_T_1), instructions_25, _GEN_24) @[InstructionROM.scala 14:{11,11}]
    node instructions_26 = _instructions_T_26 @[InstructionROM.scala 13:{29,29}]
    node _GEN_26 = mux(eq(UInt<5>("h1a"), _io_data_T_1), instructions_26, _GEN_25) @[InstructionROM.scala 14:{11,11}]
    node instructions_27 = _instructions_T_27 @[InstructionROM.scala 13:{29,29}]
    node _GEN_27 = mux(eq(UInt<5>("h1b"), _io_data_T_1), instructions_27, _GEN_26) @[InstructionROM.scala 14:{11,11}]
    node instructions_28 = _instructions_T_28 @[InstructionROM.scala 13:{29,29}]
    node _GEN_28 = mux(eq(UInt<5>("h1c"), _io_data_T_1), instructions_28, _GEN_27) @[InstructionROM.scala 14:{11,11}]
    node instructions_29 = _instructions_T_29 @[InstructionROM.scala 13:{29,29}]
    node _GEN_29 = mux(eq(UInt<5>("h1d"), _io_data_T_1), instructions_29, _GEN_28) @[InstructionROM.scala 14:{11,11}]
    node instructions_30 = _instructions_T_30 @[InstructionROM.scala 13:{29,29}]
    node _GEN_30 = mux(eq(UInt<5>("h1e"), _io_data_T_1), instructions_30, _GEN_29) @[InstructionROM.scala 14:{11,11}]
    node instructions_31 = _instructions_T_31 @[InstructionROM.scala 13:{29,29}]
    node _GEN_31 = mux(eq(UInt<5>("h1f"), _io_data_T_1), instructions_31, _GEN_30) @[InstructionROM.scala 14:{11,11}]
    node instructions_32 = _instructions_T_32 @[InstructionROM.scala 13:{29,29}]
    node _GEN_32 = mux(eq(UInt<6>("h20"), _io_data_T_1), instructions_32, _GEN_31) @[InstructionROM.scala 14:{11,11}]
    node instructions_33 = _instructions_T_33 @[InstructionROM.scala 13:{29,29}]
    node _GEN_33 = mux(eq(UInt<6>("h21"), _io_data_T_1), instructions_33, _GEN_32) @[InstructionROM.scala 14:{11,11}]
    node instructions_34 = _instructions_T_34 @[InstructionROM.scala 13:{29,29}]
    node _GEN_34 = mux(eq(UInt<6>("h22"), _io_data_T_1), instructions_34, _GEN_33) @[InstructionROM.scala 14:{11,11}]
    node instructions_35 = _instructions_T_35 @[InstructionROM.scala 13:{29,29}]
    node _GEN_35 = mux(eq(UInt<6>("h23"), _io_data_T_1), instructions_35, _GEN_34) @[InstructionROM.scala 14:{11,11}]
    node instructions_36 = _instructions_T_36 @[InstructionROM.scala 13:{29,29}]
    node _GEN_36 = mux(eq(UInt<6>("h24"), _io_data_T_1), instructions_36, _GEN_35) @[InstructionROM.scala 14:{11,11}]
    node instructions_37 = _instructions_T_37 @[InstructionROM.scala 13:{29,29}]
    node _GEN_37 = mux(eq(UInt<6>("h25"), _io_data_T_1), instructions_37, _GEN_36) @[InstructionROM.scala 14:{11,11}]
    node instructions_38 = _instructions_T_38 @[InstructionROM.scala 13:{29,29}]
    node _GEN_38 = mux(eq(UInt<6>("h26"), _io_data_T_1), instructions_38, _GEN_37) @[InstructionROM.scala 14:{11,11}]
    node instructions_39 = _instructions_T_39 @[InstructionROM.scala 13:{29,29}]
    node _GEN_39 = mux(eq(UInt<6>("h27"), _io_data_T_1), instructions_39, _GEN_38) @[InstructionROM.scala 14:{11,11}]
    node instructions_40 = _instructions_T_40 @[InstructionROM.scala 13:{29,29}]
    node _GEN_40 = mux(eq(UInt<6>("h28"), _io_data_T_1), instructions_40, _GEN_39) @[InstructionROM.scala 14:{11,11}]
    node instructions_41 = _instructions_T_41 @[InstructionROM.scala 13:{29,29}]
    node _GEN_41 = mux(eq(UInt<6>("h29"), _io_data_T_1), instructions_41, _GEN_40) @[InstructionROM.scala 14:{11,11}]
    node instructions_42 = _instructions_T_42 @[InstructionROM.scala 13:{29,29}]
    node _GEN_42 = mux(eq(UInt<6>("h2a"), _io_data_T_1), instructions_42, _GEN_41) @[InstructionROM.scala 14:{11,11}]
    node instructions_43 = _instructions_T_43 @[InstructionROM.scala 13:{29,29}]
    node _GEN_43 = mux(eq(UInt<6>("h2b"), _io_data_T_1), instructions_43, _GEN_42) @[InstructionROM.scala 14:{11,11}]
    node instructions_44 = _instructions_T_44 @[InstructionROM.scala 13:{29,29}]
    node _GEN_44 = mux(eq(UInt<6>("h2c"), _io_data_T_1), instructions_44, _GEN_43) @[InstructionROM.scala 14:{11,11}]
    node instructions_45 = _instructions_T_45 @[InstructionROM.scala 13:{29,29}]
    node _GEN_45 = mux(eq(UInt<6>("h2d"), _io_data_T_1), instructions_45, _GEN_44) @[InstructionROM.scala 14:{11,11}]
    node instructions_46 = _instructions_T_46 @[InstructionROM.scala 13:{29,29}]
    node _GEN_46 = mux(eq(UInt<6>("h2e"), _io_data_T_1), instructions_46, _GEN_45) @[InstructionROM.scala 14:{11,11}]
    node instructions_47 = _instructions_T_47 @[InstructionROM.scala 13:{29,29}]
    node _GEN_47 = mux(eq(UInt<6>("h2f"), _io_data_T_1), instructions_47, _GEN_46) @[InstructionROM.scala 14:{11,11}]
    node instructions_48 = _instructions_T_48 @[InstructionROM.scala 13:{29,29}]
    node _GEN_48 = mux(eq(UInt<6>("h30"), _io_data_T_1), instructions_48, _GEN_47) @[InstructionROM.scala 14:{11,11}]
    node instructions_49 = _instructions_T_49 @[InstructionROM.scala 13:{29,29}]
    node _GEN_49 = mux(eq(UInt<6>("h31"), _io_data_T_1), instructions_49, _GEN_48) @[InstructionROM.scala 14:{11,11}]
    node instructions_50 = _instructions_T_50 @[InstructionROM.scala 13:{29,29}]
    node _GEN_50 = mux(eq(UInt<6>("h32"), _io_data_T_1), instructions_50, _GEN_49) @[InstructionROM.scala 14:{11,11}]
    node instructions_51 = _instructions_T_51 @[InstructionROM.scala 13:{29,29}]
    node _GEN_51 = mux(eq(UInt<6>("h33"), _io_data_T_1), instructions_51, _GEN_50) @[InstructionROM.scala 14:{11,11}]
    node instructions_52 = _instructions_T_52 @[InstructionROM.scala 13:{29,29}]
    node _GEN_52 = mux(eq(UInt<6>("h34"), _io_data_T_1), instructions_52, _GEN_51) @[InstructionROM.scala 14:{11,11}]
    node instructions_53 = _instructions_T_53 @[InstructionROM.scala 13:{29,29}]
    node _GEN_53 = mux(eq(UInt<6>("h35"), _io_data_T_1), instructions_53, _GEN_52) @[InstructionROM.scala 14:{11,11}]
    node instructions_54 = _instructions_T_54 @[InstructionROM.scala 13:{29,29}]
    node _GEN_54 = mux(eq(UInt<6>("h36"), _io_data_T_1), instructions_54, _GEN_53) @[InstructionROM.scala 14:{11,11}]
    node instructions_55 = _instructions_T_55 @[InstructionROM.scala 13:{29,29}]
    node _GEN_55 = mux(eq(UInt<6>("h37"), _io_data_T_1), instructions_55, _GEN_54) @[InstructionROM.scala 14:{11,11}]
    node instructions_56 = _instructions_T_56 @[InstructionROM.scala 13:{29,29}]
    node _GEN_56 = mux(eq(UInt<6>("h38"), _io_data_T_1), instructions_56, _GEN_55) @[InstructionROM.scala 14:{11,11}]
    node instructions_57 = _instructions_T_57 @[InstructionROM.scala 13:{29,29}]
    node _GEN_57 = mux(eq(UInt<6>("h39"), _io_data_T_1), instructions_57, _GEN_56) @[InstructionROM.scala 14:{11,11}]
    node instructions_58 = _instructions_T_58 @[InstructionROM.scala 13:{29,29}]
    node _GEN_58 = mux(eq(UInt<6>("h3a"), _io_data_T_1), instructions_58, _GEN_57) @[InstructionROM.scala 14:{11,11}]
    node instructions_59 = _instructions_T_59 @[InstructionROM.scala 13:{29,29}]
    node _GEN_59 = mux(eq(UInt<6>("h3b"), _io_data_T_1), instructions_59, _GEN_58) @[InstructionROM.scala 14:{11,11}]
    node instructions_60 = _instructions_T_60 @[InstructionROM.scala 13:{29,29}]
    node _GEN_60 = mux(eq(UInt<6>("h3c"), _io_data_T_1), instructions_60, _GEN_59) @[InstructionROM.scala 14:{11,11}]
    node instructions_61 = _instructions_T_61 @[InstructionROM.scala 13:{29,29}]
    node _GEN_61 = mux(eq(UInt<6>("h3d"), _io_data_T_1), instructions_61, _GEN_60) @[InstructionROM.scala 14:{11,11}]
    node instructions_62 = _instructions_T_62 @[InstructionROM.scala 13:{29,29}]
    node _GEN_62 = mux(eq(UInt<6>("h3e"), _io_data_T_1), instructions_62, _GEN_61) @[InstructionROM.scala 14:{11,11}]
    node instructions_63 = _instructions_T_63 @[InstructionROM.scala 13:{29,29}]
    node _GEN_63 = mux(eq(UInt<6>("h3f"), _io_data_T_1), instructions_63, _GEN_62) @[InstructionROM.scala 14:{11,11}]
    node instructions_64 = _instructions_T_64 @[InstructionROM.scala 13:{29,29}]
    node _GEN_64 = mux(eq(UInt<7>("h40"), _io_data_T_1), instructions_64, _GEN_63) @[InstructionROM.scala 14:{11,11}]
    node instructions_65 = _instructions_T_65 @[InstructionROM.scala 13:{29,29}]
    node _GEN_65 = mux(eq(UInt<7>("h41"), _io_data_T_1), instructions_65, _GEN_64) @[InstructionROM.scala 14:{11,11}]
    node instructions_66 = _instructions_T_66 @[InstructionROM.scala 13:{29,29}]
    node _GEN_66 = mux(eq(UInt<7>("h42"), _io_data_T_1), instructions_66, _GEN_65) @[InstructionROM.scala 14:{11,11}]
    node instructions_67 = _instructions_T_67 @[InstructionROM.scala 13:{29,29}]
    node _GEN_67 = mux(eq(UInt<7>("h43"), _io_data_T_1), instructions_67, _GEN_66) @[InstructionROM.scala 14:{11,11}]
    node instructions_68 = _instructions_T_68 @[InstructionROM.scala 13:{29,29}]
    node _GEN_68 = mux(eq(UInt<7>("h44"), _io_data_T_1), instructions_68, _GEN_67) @[InstructionROM.scala 14:{11,11}]
    node instructions_69 = _instructions_T_69 @[InstructionROM.scala 13:{29,29}]
    node _GEN_69 = mux(eq(UInt<7>("h45"), _io_data_T_1), instructions_69, _GEN_68) @[InstructionROM.scala 14:{11,11}]
    node instructions_70 = _instructions_T_70 @[InstructionROM.scala 13:{29,29}]
    node _GEN_70 = mux(eq(UInt<7>("h46"), _io_data_T_1), instructions_70, _GEN_69) @[InstructionROM.scala 14:{11,11}]
    node instructions_71 = _instructions_T_71 @[InstructionROM.scala 13:{29,29}]
    node _GEN_71 = mux(eq(UInt<7>("h47"), _io_data_T_1), instructions_71, _GEN_70) @[InstructionROM.scala 14:{11,11}]
    node instructions_72 = _instructions_T_72 @[InstructionROM.scala 13:{29,29}]
    node _GEN_72 = mux(eq(UInt<7>("h48"), _io_data_T_1), instructions_72, _GEN_71) @[InstructionROM.scala 14:{11,11}]
    node instructions_73 = _instructions_T_73 @[InstructionROM.scala 13:{29,29}]
    node _GEN_73 = mux(eq(UInt<7>("h49"), _io_data_T_1), instructions_73, _GEN_72) @[InstructionROM.scala 14:{11,11}]
    node instructions_74 = _instructions_T_74 @[InstructionROM.scala 13:{29,29}]
    node _GEN_74 = mux(eq(UInt<7>("h4a"), _io_data_T_1), instructions_74, _GEN_73) @[InstructionROM.scala 14:{11,11}]
    node instructions_75 = _instructions_T_75 @[InstructionROM.scala 13:{29,29}]
    node _GEN_75 = mux(eq(UInt<7>("h4b"), _io_data_T_1), instructions_75, _GEN_74) @[InstructionROM.scala 14:{11,11}]
    node instructions_76 = _instructions_T_76 @[InstructionROM.scala 13:{29,29}]
    node _GEN_76 = mux(eq(UInt<7>("h4c"), _io_data_T_1), instructions_76, _GEN_75) @[InstructionROM.scala 14:{11,11}]
    node instructions_77 = _instructions_T_77 @[InstructionROM.scala 13:{29,29}]
    node _GEN_77 = mux(eq(UInt<7>("h4d"), _io_data_T_1), instructions_77, _GEN_76) @[InstructionROM.scala 14:{11,11}]
    node instructions_78 = _instructions_T_78 @[InstructionROM.scala 13:{29,29}]
    node _GEN_78 = mux(eq(UInt<7>("h4e"), _io_data_T_1), instructions_78, _GEN_77) @[InstructionROM.scala 14:{11,11}]
    node instructions_79 = _instructions_T_79 @[InstructionROM.scala 13:{29,29}]
    node _GEN_79 = mux(eq(UInt<7>("h4f"), _io_data_T_1), instructions_79, _GEN_78) @[InstructionROM.scala 14:{11,11}]
    node instructions_80 = _instructions_T_80 @[InstructionROM.scala 13:{29,29}]
    node _GEN_80 = mux(eq(UInt<7>("h50"), _io_data_T_1), instructions_80, _GEN_79) @[InstructionROM.scala 14:{11,11}]
    node instructions_81 = _instructions_T_81 @[InstructionROM.scala 13:{29,29}]
    node _GEN_81 = mux(eq(UInt<7>("h51"), _io_data_T_1), instructions_81, _GEN_80) @[InstructionROM.scala 14:{11,11}]
    node instructions_82 = _instructions_T_82 @[InstructionROM.scala 13:{29,29}]
    node _GEN_82 = mux(eq(UInt<7>("h52"), _io_data_T_1), instructions_82, _GEN_81) @[InstructionROM.scala 14:{11,11}]
    node instructions_83 = _instructions_T_83 @[InstructionROM.scala 13:{29,29}]
    node _GEN_83 = mux(eq(UInt<7>("h53"), _io_data_T_1), instructions_83, _GEN_82) @[InstructionROM.scala 14:{11,11}]
    node instructions_84 = _instructions_T_84 @[InstructionROM.scala 13:{29,29}]
    node _GEN_84 = mux(eq(UInt<7>("h54"), _io_data_T_1), instructions_84, _GEN_83) @[InstructionROM.scala 14:{11,11}]
    node instructions_85 = _instructions_T_85 @[InstructionROM.scala 13:{29,29}]
    node _GEN_85 = mux(eq(UInt<7>("h55"), _io_data_T_1), instructions_85, _GEN_84) @[InstructionROM.scala 14:{11,11}]
    node instructions_86 = _instructions_T_86 @[InstructionROM.scala 13:{29,29}]
    node _GEN_86 = mux(eq(UInt<7>("h56"), _io_data_T_1), instructions_86, _GEN_85) @[InstructionROM.scala 14:{11,11}]
    node instructions_87 = _instructions_T_87 @[InstructionROM.scala 13:{29,29}]
    node _GEN_87 = mux(eq(UInt<7>("h57"), _io_data_T_1), instructions_87, _GEN_86) @[InstructionROM.scala 14:{11,11}]
    node instructions_88 = _instructions_T_88 @[InstructionROM.scala 13:{29,29}]
    node _GEN_88 = mux(eq(UInt<7>("h58"), _io_data_T_1), instructions_88, _GEN_87) @[InstructionROM.scala 14:{11,11}]
    node instructions_89 = _instructions_T_89 @[InstructionROM.scala 13:{29,29}]
    node _GEN_89 = mux(eq(UInt<7>("h59"), _io_data_T_1), instructions_89, _GEN_88) @[InstructionROM.scala 14:{11,11}]
    node instructions_90 = _instructions_T_90 @[InstructionROM.scala 13:{29,29}]
    node _GEN_90 = mux(eq(UInt<7>("h5a"), _io_data_T_1), instructions_90, _GEN_89) @[InstructionROM.scala 14:{11,11}]
    node instructions_91 = _instructions_T_91 @[InstructionROM.scala 13:{29,29}]
    node _GEN_91 = mux(eq(UInt<7>("h5b"), _io_data_T_1), instructions_91, _GEN_90) @[InstructionROM.scala 14:{11,11}]
    node instructions_92 = _instructions_T_92 @[InstructionROM.scala 13:{29,29}]
    node _GEN_92 = mux(eq(UInt<7>("h5c"), _io_data_T_1), instructions_92, _GEN_91) @[InstructionROM.scala 14:{11,11}]
    node instructions_93 = _instructions_T_93 @[InstructionROM.scala 13:{29,29}]
    node _GEN_93 = mux(eq(UInt<7>("h5d"), _io_data_T_1), instructions_93, _GEN_92) @[InstructionROM.scala 14:{11,11}]
    node instructions_94 = _instructions_T_94 @[InstructionROM.scala 13:{29,29}]
    node _GEN_94 = mux(eq(UInt<7>("h5e"), _io_data_T_1), instructions_94, _GEN_93) @[InstructionROM.scala 14:{11,11}]
    node instructions_95 = _instructions_T_95 @[InstructionROM.scala 13:{29,29}]
    node _GEN_95 = mux(eq(UInt<7>("h5f"), _io_data_T_1), instructions_95, _GEN_94) @[InstructionROM.scala 14:{11,11}]
    node instructions_96 = _instructions_T_96 @[InstructionROM.scala 13:{29,29}]
    node _GEN_96 = mux(eq(UInt<7>("h60"), _io_data_T_1), instructions_96, _GEN_95) @[InstructionROM.scala 14:{11,11}]
    node instructions_97 = _instructions_T_97 @[InstructionROM.scala 13:{29,29}]
    node _GEN_97 = mux(eq(UInt<7>("h61"), _io_data_T_1), instructions_97, _GEN_96) @[InstructionROM.scala 14:{11,11}]
    node instructions_98 = _instructions_T_98 @[InstructionROM.scala 13:{29,29}]
    node _GEN_98 = mux(eq(UInt<7>("h62"), _io_data_T_1), instructions_98, _GEN_97) @[InstructionROM.scala 14:{11,11}]
    node instructions_99 = _instructions_T_99 @[InstructionROM.scala 13:{29,29}]
    node _GEN_99 = mux(eq(UInt<7>("h63"), _io_data_T_1), instructions_99, _GEN_98) @[InstructionROM.scala 14:{11,11}]
    node instructions_100 = _instructions_T_100 @[InstructionROM.scala 13:{29,29}]
    node _GEN_100 = mux(eq(UInt<7>("h64"), _io_data_T_1), instructions_100, _GEN_99) @[InstructionROM.scala 14:{11,11}]
    node instructions_101 = _instructions_T_101 @[InstructionROM.scala 13:{29,29}]
    node _GEN_101 = mux(eq(UInt<7>("h65"), _io_data_T_1), instructions_101, _GEN_100) @[InstructionROM.scala 14:{11,11}]
    node instructions_102 = _instructions_T_102 @[InstructionROM.scala 13:{29,29}]
    node _GEN_102 = mux(eq(UInt<7>("h66"), _io_data_T_1), instructions_102, _GEN_101) @[InstructionROM.scala 14:{11,11}]
    node instructions_103 = _instructions_T_103 @[InstructionROM.scala 13:{29,29}]
    node _GEN_103 = mux(eq(UInt<7>("h67"), _io_data_T_1), instructions_103, _GEN_102) @[InstructionROM.scala 14:{11,11}]
    node instructions_104 = _instructions_T_104 @[InstructionROM.scala 13:{29,29}]
    node _GEN_104 = mux(eq(UInt<7>("h68"), _io_data_T_1), instructions_104, _GEN_103) @[InstructionROM.scala 14:{11,11}]
    node instructions_105 = _instructions_T_105 @[InstructionROM.scala 13:{29,29}]
    node _GEN_105 = mux(eq(UInt<7>("h69"), _io_data_T_1), instructions_105, _GEN_104) @[InstructionROM.scala 14:{11,11}]
    node instructions_106 = _instructions_T_106 @[InstructionROM.scala 13:{29,29}]
    node _GEN_106 = mux(eq(UInt<7>("h6a"), _io_data_T_1), instructions_106, _GEN_105) @[InstructionROM.scala 14:{11,11}]
    node instructions_107 = _instructions_T_107 @[InstructionROM.scala 13:{29,29}]
    node _GEN_107 = mux(eq(UInt<7>("h6b"), _io_data_T_1), instructions_107, _GEN_106) @[InstructionROM.scala 14:{11,11}]
    node instructions_108 = _instructions_T_108 @[InstructionROM.scala 13:{29,29}]
    node _GEN_108 = mux(eq(UInt<7>("h6c"), _io_data_T_1), instructions_108, _GEN_107) @[InstructionROM.scala 14:{11,11}]
    node instructions_109 = _instructions_T_109 @[InstructionROM.scala 13:{29,29}]
    node _GEN_109 = mux(eq(UInt<7>("h6d"), _io_data_T_1), instructions_109, _GEN_108) @[InstructionROM.scala 14:{11,11}]
    node instructions_110 = _instructions_T_110 @[InstructionROM.scala 13:{29,29}]
    node _GEN_110 = mux(eq(UInt<7>("h6e"), _io_data_T_1), instructions_110, _GEN_109) @[InstructionROM.scala 14:{11,11}]
    node instructions_111 = _instructions_T_111 @[InstructionROM.scala 13:{29,29}]
    node _GEN_111 = mux(eq(UInt<7>("h6f"), _io_data_T_1), instructions_111, _GEN_110) @[InstructionROM.scala 14:{11,11}]
    node instructions_112 = _instructions_T_112 @[InstructionROM.scala 13:{29,29}]
    node _GEN_112 = mux(eq(UInt<7>("h70"), _io_data_T_1), instructions_112, _GEN_111) @[InstructionROM.scala 14:{11,11}]
    node instructions_113 = _instructions_T_113 @[InstructionROM.scala 13:{29,29}]
    node _GEN_113 = mux(eq(UInt<7>("h71"), _io_data_T_1), instructions_113, _GEN_112) @[InstructionROM.scala 14:{11,11}]
    node instructions_114 = _instructions_T_114 @[InstructionROM.scala 13:{29,29}]
    node _GEN_114 = mux(eq(UInt<7>("h72"), _io_data_T_1), instructions_114, _GEN_113) @[InstructionROM.scala 14:{11,11}]
    node instructions_115 = _instructions_T_115 @[InstructionROM.scala 13:{29,29}]
    node _GEN_115 = mux(eq(UInt<7>("h73"), _io_data_T_1), instructions_115, _GEN_114) @[InstructionROM.scala 14:{11,11}]
    node instructions_116 = _instructions_T_116 @[InstructionROM.scala 13:{29,29}]
    node _GEN_116 = mux(eq(UInt<7>("h74"), _io_data_T_1), instructions_116, _GEN_115) @[InstructionROM.scala 14:{11,11}]
    node instructions_117 = _instructions_T_117 @[InstructionROM.scala 13:{29,29}]
    node _GEN_117 = mux(eq(UInt<7>("h75"), _io_data_T_1), instructions_117, _GEN_116) @[InstructionROM.scala 14:{11,11}]
    node instructions_118 = _instructions_T_118 @[InstructionROM.scala 13:{29,29}]
    node _GEN_118 = mux(eq(UInt<7>("h76"), _io_data_T_1), instructions_118, _GEN_117) @[InstructionROM.scala 14:{11,11}]
    node instructions_119 = _instructions_T_119 @[InstructionROM.scala 13:{29,29}]
    node _GEN_119 = mux(eq(UInt<7>("h77"), _io_data_T_1), instructions_119, _GEN_118) @[InstructionROM.scala 14:{11,11}]
    node instructions_120 = _instructions_T_120 @[InstructionROM.scala 13:{29,29}]
    node _GEN_120 = mux(eq(UInt<7>("h78"), _io_data_T_1), instructions_120, _GEN_119) @[InstructionROM.scala 14:{11,11}]
    node instructions_121 = _instructions_T_121 @[InstructionROM.scala 13:{29,29}]
    node _GEN_121 = mux(eq(UInt<7>("h79"), _io_data_T_1), instructions_121, _GEN_120) @[InstructionROM.scala 14:{11,11}]
    node instructions_122 = _instructions_T_122 @[InstructionROM.scala 13:{29,29}]
    node _GEN_122 = mux(eq(UInt<7>("h7a"), _io_data_T_1), instructions_122, _GEN_121) @[InstructionROM.scala 14:{11,11}]
    node instructions_123 = _instructions_T_123 @[InstructionROM.scala 13:{29,29}]
    node _GEN_123 = mux(eq(UInt<7>("h7b"), _io_data_T_1), instructions_123, _GEN_122) @[InstructionROM.scala 14:{11,11}]
    node instructions_124 = _instructions_T_124 @[InstructionROM.scala 13:{29,29}]
    node _GEN_124 = mux(eq(UInt<7>("h7c"), _io_data_T_1), instructions_124, _GEN_123) @[InstructionROM.scala 14:{11,11}]
    node instructions_125 = _instructions_T_125 @[InstructionROM.scala 13:{29,29}]
    node _GEN_125 = mux(eq(UInt<7>("h7d"), _io_data_T_1), instructions_125, _GEN_124) @[InstructionROM.scala 14:{11,11}]
    node instructions_126 = _instructions_T_126 @[InstructionROM.scala 13:{29,29}]
    node _GEN_126 = mux(eq(UInt<7>("h7e"), _io_data_T_1), instructions_126, _GEN_125) @[InstructionROM.scala 14:{11,11}]
    node instructions_127 = _instructions_T_127 @[InstructionROM.scala 13:{29,29}]
    node _GEN_127 = mux(eq(UInt<7>("h7f"), _io_data_T_1), instructions_127, _GEN_126) @[InstructionROM.scala 14:{11,11}]
    node instructions_128 = _instructions_T_128 @[InstructionROM.scala 13:{29,29}]
    node _GEN_128 = mux(eq(UInt<8>("h80"), _io_data_T_1), instructions_128, _GEN_127) @[InstructionROM.scala 14:{11,11}]
    node instructions_129 = _instructions_T_129 @[InstructionROM.scala 13:{29,29}]
    node _GEN_129 = mux(eq(UInt<8>("h81"), _io_data_T_1), instructions_129, _GEN_128) @[InstructionROM.scala 14:{11,11}]
    node instructions_130 = _instructions_T_130 @[InstructionROM.scala 13:{29,29}]
    node _GEN_130 = mux(eq(UInt<8>("h82"), _io_data_T_1), instructions_130, _GEN_129) @[InstructionROM.scala 14:{11,11}]
    node instructions_131 = _instructions_T_131 @[InstructionROM.scala 13:{29,29}]
    node _GEN_131 = mux(eq(UInt<8>("h83"), _io_data_T_1), instructions_131, _GEN_130) @[InstructionROM.scala 14:{11,11}]
    node instructions_132 = _instructions_T_132 @[InstructionROM.scala 13:{29,29}]
    node _GEN_132 = mux(eq(UInt<8>("h84"), _io_data_T_1), instructions_132, _GEN_131) @[InstructionROM.scala 14:{11,11}]
    node instructions_133 = _instructions_T_133 @[InstructionROM.scala 13:{29,29}]
    node _GEN_133 = mux(eq(UInt<8>("h85"), _io_data_T_1), instructions_133, _GEN_132) @[InstructionROM.scala 14:{11,11}]
    node instructions_134 = _instructions_T_134 @[InstructionROM.scala 13:{29,29}]
    node _GEN_134 = mux(eq(UInt<8>("h86"), _io_data_T_1), instructions_134, _GEN_133) @[InstructionROM.scala 14:{11,11}]
    node instructions_135 = _instructions_T_135 @[InstructionROM.scala 13:{29,29}]
    node _GEN_135 = mux(eq(UInt<8>("h87"), _io_data_T_1), instructions_135, _GEN_134) @[InstructionROM.scala 14:{11,11}]
    node instructions_136 = _instructions_T_136 @[InstructionROM.scala 13:{29,29}]
    node _GEN_136 = mux(eq(UInt<8>("h88"), _io_data_T_1), instructions_136, _GEN_135) @[InstructionROM.scala 14:{11,11}]
    node instructions_137 = _instructions_T_137 @[InstructionROM.scala 13:{29,29}]
    node _GEN_137 = mux(eq(UInt<8>("h89"), _io_data_T_1), instructions_137, _GEN_136) @[InstructionROM.scala 14:{11,11}]
    node instructions_138 = _instructions_T_138 @[InstructionROM.scala 13:{29,29}]
    node _GEN_138 = mux(eq(UInt<8>("h8a"), _io_data_T_1), instructions_138, _GEN_137) @[InstructionROM.scala 14:{11,11}]
    node instructions_139 = _instructions_T_139 @[InstructionROM.scala 13:{29,29}]
    node _GEN_139 = mux(eq(UInt<8>("h8b"), _io_data_T_1), instructions_139, _GEN_138) @[InstructionROM.scala 14:{11,11}]
    node instructions_140 = _instructions_T_140 @[InstructionROM.scala 13:{29,29}]
    node _GEN_140 = mux(eq(UInt<8>("h8c"), _io_data_T_1), instructions_140, _GEN_139) @[InstructionROM.scala 14:{11,11}]
    node instructions_141 = _instructions_T_141 @[InstructionROM.scala 13:{29,29}]
    node _GEN_141 = mux(eq(UInt<8>("h8d"), _io_data_T_1), instructions_141, _GEN_140) @[InstructionROM.scala 14:{11,11}]
    node instructions_142 = _instructions_T_142 @[InstructionROM.scala 13:{29,29}]
    node _GEN_142 = mux(eq(UInt<8>("h8e"), _io_data_T_1), instructions_142, _GEN_141) @[InstructionROM.scala 14:{11,11}]
    node instructions_143 = _instructions_T_143 @[InstructionROM.scala 13:{29,29}]
    node _GEN_143 = mux(eq(UInt<8>("h8f"), _io_data_T_1), instructions_143, _GEN_142) @[InstructionROM.scala 14:{11,11}]
    node instructions_144 = _instructions_T_144 @[InstructionROM.scala 13:{29,29}]
    node _GEN_144 = mux(eq(UInt<8>("h90"), _io_data_T_1), instructions_144, _GEN_143) @[InstructionROM.scala 14:{11,11}]
    node instructions_145 = _instructions_T_145 @[InstructionROM.scala 13:{29,29}]
    node _GEN_145 = mux(eq(UInt<8>("h91"), _io_data_T_1), instructions_145, _GEN_144) @[InstructionROM.scala 14:{11,11}]
    node instructions_146 = _instructions_T_146 @[InstructionROM.scala 13:{29,29}]
    node _GEN_146 = mux(eq(UInt<8>("h92"), _io_data_T_1), instructions_146, _GEN_145) @[InstructionROM.scala 14:{11,11}]
    node instructions_147 = _instructions_T_147 @[InstructionROM.scala 13:{29,29}]
    node _GEN_147 = mux(eq(UInt<8>("h93"), _io_data_T_1), instructions_147, _GEN_146) @[InstructionROM.scala 14:{11,11}]
    node instructions_148 = _instructions_T_148 @[InstructionROM.scala 13:{29,29}]
    node _GEN_148 = mux(eq(UInt<8>("h94"), _io_data_T_1), instructions_148, _GEN_147) @[InstructionROM.scala 14:{11,11}]
    node instructions_149 = _instructions_T_149 @[InstructionROM.scala 13:{29,29}]
    node _GEN_149 = mux(eq(UInt<8>("h95"), _io_data_T_1), instructions_149, _GEN_148) @[InstructionROM.scala 14:{11,11}]
    node instructions_150 = _instructions_T_150 @[InstructionROM.scala 13:{29,29}]
    node _GEN_150 = mux(eq(UInt<8>("h96"), _io_data_T_1), instructions_150, _GEN_149) @[InstructionROM.scala 14:{11,11}]
    node instructions_151 = _instructions_T_151 @[InstructionROM.scala 13:{29,29}]
    node _GEN_151 = mux(eq(UInt<8>("h97"), _io_data_T_1), instructions_151, _GEN_150) @[InstructionROM.scala 14:{11,11}]
    node instructions_152 = _instructions_T_152 @[InstructionROM.scala 13:{29,29}]
    node _GEN_152 = mux(eq(UInt<8>("h98"), _io_data_T_1), instructions_152, _GEN_151) @[InstructionROM.scala 14:{11,11}]
    node instructions_153 = _instructions_T_153 @[InstructionROM.scala 13:{29,29}]
    node _GEN_153 = mux(eq(UInt<8>("h99"), _io_data_T_1), instructions_153, _GEN_152) @[InstructionROM.scala 14:{11,11}]
    node instructions_154 = _instructions_T_154 @[InstructionROM.scala 13:{29,29}]
    node _GEN_154 = mux(eq(UInt<8>("h9a"), _io_data_T_1), instructions_154, _GEN_153) @[InstructionROM.scala 14:{11,11}]
    node instructions_155 = _instructions_T_155 @[InstructionROM.scala 13:{29,29}]
    node _GEN_155 = mux(eq(UInt<8>("h9b"), _io_data_T_1), instructions_155, _GEN_154) @[InstructionROM.scala 14:{11,11}]
    node instructions_156 = _instructions_T_156 @[InstructionROM.scala 13:{29,29}]
    node _GEN_156 = mux(eq(UInt<8>("h9c"), _io_data_T_1), instructions_156, _GEN_155) @[InstructionROM.scala 14:{11,11}]
    node instructions_157 = _instructions_T_157 @[InstructionROM.scala 13:{29,29}]
    node _GEN_157 = mux(eq(UInt<8>("h9d"), _io_data_T_1), instructions_157, _GEN_156) @[InstructionROM.scala 14:{11,11}]
    node instructions_158 = _instructions_T_158 @[InstructionROM.scala 13:{29,29}]
    node _GEN_158 = mux(eq(UInt<8>("h9e"), _io_data_T_1), instructions_158, _GEN_157) @[InstructionROM.scala 14:{11,11}]
    node instructions_159 = _instructions_T_159 @[InstructionROM.scala 13:{29,29}]
    node _GEN_159 = mux(eq(UInt<8>("h9f"), _io_data_T_1), instructions_159, _GEN_158) @[InstructionROM.scala 14:{11,11}]
    node instructions_160 = _instructions_T_160 @[InstructionROM.scala 13:{29,29}]
    node _GEN_160 = mux(eq(UInt<8>("ha0"), _io_data_T_1), instructions_160, _GEN_159) @[InstructionROM.scala 14:{11,11}]
    node instructions_161 = _instructions_T_161 @[InstructionROM.scala 13:{29,29}]
    node _GEN_161 = mux(eq(UInt<8>("ha1"), _io_data_T_1), instructions_161, _GEN_160) @[InstructionROM.scala 14:{11,11}]
    node instructions_162 = _instructions_T_162 @[InstructionROM.scala 13:{29,29}]
    node _GEN_162 = mux(eq(UInt<8>("ha2"), _io_data_T_1), instructions_162, _GEN_161) @[InstructionROM.scala 14:{11,11}]
    node instructions_163 = _instructions_T_163 @[InstructionROM.scala 13:{29,29}]
    node _GEN_163 = mux(eq(UInt<8>("ha3"), _io_data_T_1), instructions_163, _GEN_162) @[InstructionROM.scala 14:{11,11}]
    node instructions_164 = _instructions_T_164 @[InstructionROM.scala 13:{29,29}]
    node _GEN_164 = mux(eq(UInt<8>("ha4"), _io_data_T_1), instructions_164, _GEN_163) @[InstructionROM.scala 14:{11,11}]
    node instructions_165 = _instructions_T_165 @[InstructionROM.scala 13:{29,29}]
    node _GEN_165 = mux(eq(UInt<8>("ha5"), _io_data_T_1), instructions_165, _GEN_164) @[InstructionROM.scala 14:{11,11}]
    node instructions_166 = _instructions_T_166 @[InstructionROM.scala 13:{29,29}]
    node _GEN_166 = mux(eq(UInt<8>("ha6"), _io_data_T_1), instructions_166, _GEN_165) @[InstructionROM.scala 14:{11,11}]
    node instructions_167 = _instructions_T_167 @[InstructionROM.scala 13:{29,29}]
    node _GEN_167 = mux(eq(UInt<8>("ha7"), _io_data_T_1), instructions_167, _GEN_166) @[InstructionROM.scala 14:{11,11}]
    node instructions_168 = _instructions_T_168 @[InstructionROM.scala 13:{29,29}]
    node _GEN_168 = mux(eq(UInt<8>("ha8"), _io_data_T_1), instructions_168, _GEN_167) @[InstructionROM.scala 14:{11,11}]
    node instructions_169 = _instructions_T_169 @[InstructionROM.scala 13:{29,29}]
    node _GEN_169 = mux(eq(UInt<8>("ha9"), _io_data_T_1), instructions_169, _GEN_168) @[InstructionROM.scala 14:{11,11}]
    node instructions_170 = _instructions_T_170 @[InstructionROM.scala 13:{29,29}]
    node _GEN_170 = mux(eq(UInt<8>("haa"), _io_data_T_1), instructions_170, _GEN_169) @[InstructionROM.scala 14:{11,11}]
    node instructions_171 = _instructions_T_171 @[InstructionROM.scala 13:{29,29}]
    node _GEN_171 = mux(eq(UInt<8>("hab"), _io_data_T_1), instructions_171, _GEN_170) @[InstructionROM.scala 14:{11,11}]
    reg toggle : UInt<1>, clock with :
      reset => (UInt<1>("h0"), toggle) @[InstructionROM.scala 16:23]
    node _toggle_T = eq(toggle, UInt<1>("h0")) @[InstructionROM.scala 17:13]
    node _instructions_io_data_T_1 = _GEN_171 @[InstructionROM.scala 14:11]
    io_data <= _instructions_io_data_T_1 @[InstructionROM.scala 14:11]
    io_stall <= UInt<1>("h0") @[InstructionROM.scala 18:12]
    addrReg <= mux(reset, UInt<32>("h0"), io_address) @[InstructionROM.scala 11:{24,24} 12:11]
    toggle <= mux(reset, UInt<1>("h0"), _toggle_T) @[InstructionROM.scala 16:{23,23} 17:10]

  module Tx :
    input clock : Clock
    input reset : UInt<1>
    output io_txd : UInt<1>
    output io_channel_ready : UInt<1>
    input io_channel_valid : UInt<1>
    input io_channel_bits : UInt<8>

    reg shiftReg : UInt<11>, clock with :
      reset => (UInt<1>("h0"), shiftReg) @[Uart.scala 30:25]
    reg cntReg : UInt<20>, clock with :
      reset => (UInt<1>("h0"), cntReg) @[Uart.scala 31:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (UInt<1>("h0"), bitsReg) @[Uart.scala 32:24]
    node _io_channel_ready_T = eq(cntReg, UInt<1>("h0")) @[Uart.scala 34:31]
    node _io_channel_ready_T_1 = eq(bitsReg, UInt<1>("h0")) @[Uart.scala 34:52]
    node _io_channel_ready_T_2 = and(_io_channel_ready_T, _io_channel_ready_T_1) @[Uart.scala 34:40]
    node _io_txd_T = bits(shiftReg, 0, 0) @[Uart.scala 35:21]
    node _T = eq(cntReg, UInt<1>("h0")) @[Uart.scala 37:15]
    node _T_1 = neq(bitsReg, UInt<1>("h0")) @[Uart.scala 40:18]
    node shift = shr(shiftReg, 1) @[Uart.scala 41:28]
    node _shiftReg_T = bits(shift, 9, 0) @[Uart.scala 42:33]
    node _shiftReg_T_1 = cat(UInt<1>("h1"), _shiftReg_T) @[Cat.scala 33:92]
    node _bitsReg_T = sub(bitsReg, UInt<1>("h1")) @[Uart.scala 43:26]
    node _bitsReg_T_1 = tail(_bitsReg_T, 1) @[Uart.scala 43:26]
    node _shiftReg_T_2 = cat(UInt<2>("h3"), io_channel_bits) @[Cat.scala 33:92]
    node _shiftReg_T_3 = cat(_shiftReg_T_2, UInt<1>("h0")) @[Cat.scala 33:92]
    node _GEN_0 = mux(io_channel_valid, _shiftReg_T_3, UInt<11>("h7ff")) @[Uart.scala 45:30 46:18 49:18]
    node _GEN_1 = mux(io_channel_valid, UInt<4>("hb"), bitsReg) @[Uart.scala 45:30 47:17 32:24]
    node _GEN_2 = mux(_T_1, _shiftReg_T_1, _GEN_0) @[Uart.scala 40:27 42:16]
    node _GEN_3 = mux(_T_1, _bitsReg_T_1, _GEN_1) @[Uart.scala 40:27 43:15]
    node _cntReg_T = sub(cntReg, UInt<1>("h1")) @[Uart.scala 54:22]
    node _cntReg_T_1 = tail(_cntReg_T, 1) @[Uart.scala 54:22]
    node _GEN_4 = mux(_T, UInt<10>("h363"), _cntReg_T_1) @[Uart.scala 37:24 39:12 54:12]
    node _GEN_5 = mux(_T, _GEN_2, shiftReg) @[Uart.scala 37:24 30:25]
    node _GEN_6 = mux(_T, _GEN_3, bitsReg) @[Uart.scala 32:24 37:24]
    io_txd <= _io_txd_T @[Uart.scala 35:10]
    io_channel_ready <= _io_channel_ready_T_2 @[Uart.scala 34:20]
    shiftReg <= mux(reset, UInt<11>("h7ff"), _GEN_5) @[Uart.scala 30:{25,25}]
    cntReg <= mux(reset, UInt<20>("h0"), _GEN_4) @[Uart.scala 31:{23,23}]
    bitsReg <= mux(reset, UInt<4>("h0"), _GEN_6) @[Uart.scala 32:{24,24}]

  module Buffer :
    input clock : Clock
    input reset : UInt<1>
    output io_in_ready : UInt<1>
    input io_in_valid : UInt<1>
    input io_in_bits : UInt<8>
    input io_out_ready : UInt<1>
    output io_out_valid : UInt<1>
    output io_out_bits : UInt<8>

    reg stateReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[Uart.scala 117:25]
    reg dataReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), dataReg) @[Uart.scala 118:24]
    node _io_in_ready_T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 120:27]
    node _io_out_valid_T = eq(stateReg, UInt<1>("h1")) @[Uart.scala 121:28]
    node _T = eq(stateReg, UInt<1>("h0")) @[Uart.scala 123:17]
    node _GEN_0 = mux(io_in_valid, io_in_bits, dataReg) @[Uart.scala 124:23 125:15 118:24]
    node _GEN_1 = mux(io_in_valid, UInt<1>("h1"), stateReg) @[Uart.scala 124:23 126:16 117:25]
    node _GEN_2 = mux(io_out_ready, UInt<1>("h0"), stateReg) @[Uart.scala 129:24 130:16 117:25]
    node _GEN_3 = mux(_T, _GEN_0, dataReg) @[Uart.scala 118:24 123:28]
    node _GEN_4 = mux(_T, _GEN_1, _GEN_2) @[Uart.scala 123:28]
    io_in_ready <= _io_in_ready_T @[Uart.scala 120:15]
    io_out_valid <= _io_out_valid_T @[Uart.scala 121:16]
    io_out_bits <= dataReg @[Uart.scala 133:15]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_4) @[Uart.scala 117:{25,25}]
    dataReg <= mux(reset, UInt<8>("h0"), _GEN_3) @[Uart.scala 118:{24,24}]

  module BufferedTx :
    input clock : Clock
    input reset : UInt<1>
    output io_txd : UInt<1>
    output io_channel_ready : UInt<1>
    input io_channel_valid : UInt<1>
    input io_channel_bits : UInt<8>

    inst tx of Tx @[Uart.scala 144:18]
    inst buf of Buffer @[Uart.scala 145:19]
    io_txd <= tx.io_txd @[Uart.scala 149:10]
    io_channel_ready <= buf.io_in_ready @[Uart.scala 147:13]
    tx.clock <= clock
    tx.reset <= reset
    tx.io_channel_valid <= buf.io_out_valid @[Uart.scala 148:17]
    tx.io_channel_bits <= buf.io_out_bits @[Uart.scala 148:17]
    buf.clock <= clock
    buf.reset <= reset
    buf.io_in_valid <= io_channel_valid @[Uart.scala 147:13]
    buf.io_in_bits <= io_channel_bits @[Uart.scala 147:13]
    buf.io_out_ready <= tx.io_channel_ready @[Uart.scala 148:17]

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
    node _GEN_1 = mux(falling, UInt<11>("h514"), cntReg) @[Uart.scala 94:23 95:12 80:23]
    node _GEN_2 = mux(falling, UInt<4>("h8"), bitsReg) @[Uart.scala 94:23 96:13 81:24]
    node _GEN_3 = mux(_T_1, UInt<10>("h363"), _GEN_1) @[Uart.scala 86:31 87:12]
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
    cntReg <= mux(reset, UInt<20>("h363"), _GEN_7) @[Uart.scala 80:{23,23}]
    bitsReg <= mux(reset, UInt<4>("h0"), _GEN_9) @[Uart.scala 81:{24,24}]
    valReg <= mux(reset, UInt<1>("h0"), _GEN_11) @[Uart.scala 82:{23,23}]

  module WildcatTop :
    input clock : Clock
    input reset : UInt<1>
    output io_led : UInt<16>
    output io_tx : UInt<1>
    input io_rx : UInt<1>
    output decExReg_decOut_isECall : UInt<1>
    output ledReg_0 : UInt<8>
    output debugRegs_0 : UInt<32>
    output debugRegs_1 : UInt<32>
    output debugRegs_2 : UInt<32>
    output debugRegs_3 : UInt<32>
    output debugRegs_4 : UInt<32>
    output debugRegs_5 : UInt<32>
    output debugRegs_6 : UInt<32>
    output debugRegs_7 : UInt<32>
    output debugRegs_8 : UInt<32>
    output debugRegs_9 : UInt<32>
    output debugRegs_10 : UInt<32>
    output debugRegs_11 : UInt<32>
    output debugRegs_12 : UInt<32>
    output debugRegs_13 : UInt<32>
    output debugRegs_14 : UInt<32>
    output debugRegs_15 : UInt<32>
    output debugRegs_16 : UInt<32>
    output debugRegs_17 : UInt<32>
    output debugRegs_18 : UInt<32>
    output debugRegs_19 : UInt<32>
    output debugRegs_20 : UInt<32>
    output debugRegs_21 : UInt<32>
    output debugRegs_22 : UInt<32>
    output debugRegs_23 : UInt<32>
    output debugRegs_24 : UInt<32>
    output debugRegs_25 : UInt<32>
    output debugRegs_26 : UInt<32>
    output debugRegs_27 : UInt<32>
    output debugRegs_28 : UInt<32>
    output debugRegs_29 : UInt<32>
    output debugRegs_30 : UInt<32>
    output debugRegs_31 : UInt<32>

    inst cpu of ThreeCats @[WildcatTop.scala 27:19]
    inst dmem of ScratchPadMem @[WildcatTop.scala 30:20]
    inst SimpleCache of CacheTop @[WildcatTop.scala 33:27]
    inst imem of InstructionROM @[WildcatTop.scala 40:20]
    inst tx of BufferedTx @[WildcatTop.scala 57:18]
    inst rx of Rx @[WildcatTop.scala 58:18]
    node _cpu_io_imem_stall_T = or(imem.io_stall, SimpleCache.io_stall) @[WildcatTop.scala 43:38]
    node _tx_io_channel_bits_T = bits(cpu.io_dmem_wrData, 7, 0) @[WildcatTop.scala 62:43]
    node _uartStatusReg_T = cat(rx.io_channel_valid, tx.io_channel_ready) @[WildcatTop.scala 66:51]
    reg uartStatusReg : UInt<2>, clock with :
      reset => (UInt<1>("h0"), uartStatusReg) @[WildcatTop.scala 66:30]
    reg memAddressReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), memAddressReg) @[WildcatTop.scala 67:30]
    node _T = bits(memAddressReg, 31, 28) @[WildcatTop.scala 68:22]
    node _T_1 = eq(_T, UInt<4>("hf")) @[WildcatTop.scala 68:31]
    node _T_2 = bits(memAddressReg, 19, 16) @[WildcatTop.scala 68:57]
    node _T_3 = eq(_T_2, UInt<1>("h0")) @[WildcatTop.scala 68:65]
    node _T_4 = and(_T_1, _T_3) @[WildcatTop.scala 68:41]
    node _T_5 = bits(memAddressReg, 3, 0) @[WildcatTop.scala 69:24]
    node _T_6 = eq(_T_5, UInt<1>("h0")) @[WildcatTop.scala 69:31]
    node _T_7 = bits(memAddressReg, 3, 0) @[WildcatTop.scala 71:30]
    node _T_8 = eq(_T_7, UInt<3>("h4")) @[WildcatTop.scala 71:37]
    node _GEN_0 = mux(_T_8, rx.io_channel_bits, dmem.io_rdData) @[WildcatTop.scala 31:15 71:46 72:26]
    node _GEN_1 = mux(_T_8, cpu.io_dmem_rdEnable, UInt<1>("h0")) @[WildcatTop.scala 64:23 71:46 73:27]
    node _GEN_2 = mux(_T_6, uartStatusReg, _GEN_0) @[WildcatTop.scala 69:40 70:26]
    node _GEN_3 = mux(_T_6, UInt<1>("h0"), _GEN_1) @[WildcatTop.scala 64:23 69:40]
    node _GEN_4 = mux(_T_4, _GEN_2, dmem.io_rdData) @[WildcatTop.scala 31:15 68:74]
    node _GEN_5 = mux(_T_4, _GEN_3, UInt<1>("h0")) @[WildcatTop.scala 64:23 68:74]
    reg ledReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), ledReg) @[WildcatTop.scala 77:23]
    node _T_9 = bits(cpu.io_dmem_wrAddress, 31, 28) @[WildcatTop.scala 78:31]
    node _T_10 = eq(_T_9, UInt<4>("hf")) @[WildcatTop.scala 78:40]
    node _T_11 = and(_T_10, cpu.io_dmem_wrEnable_0) @[WildcatTop.scala 78:51]
    node _T_12 = bits(cpu.io_dmem_wrAddress, 19, 16) @[WildcatTop.scala 79:32]
    node _T_13 = eq(_T_12, UInt<1>("h0")) @[WildcatTop.scala 79:40]
    node _T_14 = bits(cpu.io_dmem_wrAddress, 3, 0) @[WildcatTop.scala 79:72]
    node _T_15 = eq(_T_14, UInt<3>("h4")) @[WildcatTop.scala 79:79]
    node _T_16 = and(_T_13, _T_15) @[WildcatTop.scala 79:48]
    node _T_17 = bits(cpu.io_dmem_wrData, 7, 0) @[WildcatTop.scala 80:44]
    node _T_18 = bits(cpu.io_dmem_wrData, 7, 0) @[WildcatTop.scala 80:70]
    node _T_19 = asUInt(reset) @[WildcatTop.scala 80:13]
    node _T_20 = eq(_T_19, UInt<1>("h0")) @[WildcatTop.scala 80:13]
    node _T_21 = bits(cpu.io_dmem_wrAddress, 19, 16) @[WildcatTop.scala 82:39]
    node _T_22 = eq(_T_21, UInt<1>("h1")) @[WildcatTop.scala 82:47]
    node _ledReg_T = bits(cpu.io_dmem_wrData, 7, 0) @[WildcatTop.scala 83:35]
    node _GEN_6 = mux(_T_22, _ledReg_T, ledReg) @[WildcatTop.scala 82:56 83:14 77:23]
    node _GEN_7 = mux(_T_16, UInt<1>("h1"), UInt<1>("h0")) @[WildcatTop.scala 63:23 79:88 81:27]
    node _GEN_8 = mux(_T_16, ledReg, _GEN_6) @[WildcatTop.scala 77:23 79:88]
    node _GEN_9 = mux(_T_11, _GEN_7, UInt<1>("h0")) @[WildcatTop.scala 63:23 78:79]
    node _GEN_10 = mux(_T_11, _GEN_8, ledReg) @[WildcatTop.scala 77:23 78:79]
    node _WIRE_0 = UInt<1>("h0") @[WildcatTop.scala 85:{32,32}]
    node _GEN_11 = mux(_T_11, _WIRE_0, cpu.io_dmem_wrEnable_0) @[WildcatTop.scala 31:15 78:79 85:22]
    node _WIRE_1 = UInt<1>("h0") @[WildcatTop.scala 85:{32,32}]
    node _GEN_12 = mux(_T_11, _WIRE_1, cpu.io_dmem_wrEnable_1) @[WildcatTop.scala 31:15 78:79 85:22]
    node _WIRE_2 = UInt<1>("h0") @[WildcatTop.scala 85:{32,32}]
    node _GEN_13 = mux(_T_11, _WIRE_2, cpu.io_dmem_wrEnable_2) @[WildcatTop.scala 31:15 78:79 85:22]
    node _WIRE_3 = UInt<1>("h0") @[WildcatTop.scala 85:{32,32}]
    node _GEN_14 = mux(_T_11, _WIRE_3, cpu.io_dmem_wrEnable_3) @[WildcatTop.scala 31:15 78:79 85:22]
    node _io_led_T = cat(UInt<1>("h1"), UInt<7>("h0")) @[WildcatTop.scala 88:17]
    reg io_led_REG : UInt<8>, clock with :
      reset => (UInt<1>("h0"), io_led_REG) @[WildcatTop.scala 88:39]
    node _io_led_T_1 = cat(_io_led_T, io_led_REG) @[WildcatTop.scala 88:29]
    io_led <= _io_led_T_1 @[WildcatTop.scala 88:10]
    io_tx <= tx.io_txd @[WildcatTop.scala 59:9]
    decExReg_decOut_isECall <= cpu.decExReg_decOut_isECall
    ledReg_0 <= ledReg
    debugRegs_0 <= cpu.debugRegs_0_0
    debugRegs_1 <= cpu.debugRegs_0_1
    debugRegs_2 <= cpu.debugRegs_0_2
    debugRegs_3 <= cpu.debugRegs_0_3
    debugRegs_4 <= cpu.debugRegs_0_4
    debugRegs_5 <= cpu.debugRegs_0_5
    debugRegs_6 <= cpu.debugRegs_0_6
    debugRegs_7 <= cpu.debugRegs_0_7
    debugRegs_8 <= cpu.debugRegs_0_8
    debugRegs_9 <= cpu.debugRegs_0_9
    debugRegs_10 <= cpu.debugRegs_0_10
    debugRegs_11 <= cpu.debugRegs_0_11
    debugRegs_12 <= cpu.debugRegs_0_12
    debugRegs_13 <= cpu.debugRegs_0_13
    debugRegs_14 <= cpu.debugRegs_0_14
    debugRegs_15 <= cpu.debugRegs_0_15
    debugRegs_16 <= cpu.debugRegs_0_16
    debugRegs_17 <= cpu.debugRegs_0_17
    debugRegs_18 <= cpu.debugRegs_0_18
    debugRegs_19 <= cpu.debugRegs_0_19
    debugRegs_20 <= cpu.debugRegs_0_20
    debugRegs_21 <= cpu.debugRegs_0_21
    debugRegs_22 <= cpu.debugRegs_0_22
    debugRegs_23 <= cpu.debugRegs_0_23
    debugRegs_24 <= cpu.debugRegs_0_24
    debugRegs_25 <= cpu.debugRegs_0_25
    debugRegs_26 <= cpu.debugRegs_0_26
    debugRegs_27 <= cpu.debugRegs_0_27
    debugRegs_28 <= cpu.debugRegs_0_28
    debugRegs_29 <= cpu.debugRegs_0_29
    debugRegs_30 <= cpu.debugRegs_0_30
    debugRegs_31 <= cpu.debugRegs_0_31
    cpu.clock <= clock
    cpu.reset <= reset
    cpu.io_imem_data <= imem.io_data @[WildcatTop.scala 42:20]
    cpu.io_imem_stall <= _cpu_io_imem_stall_T @[WildcatTop.scala 43:21]
    cpu.io_dmem_rdData <= _GEN_4
    cpu.io_dmem_stall <= dmem.io_stall @[WildcatTop.scala 31:15]
    dmem.clock <= clock
    dmem.reset <= reset
    dmem.io_rdAddress <= cpu.io_dmem_rdAddress @[WildcatTop.scala 31:15]
    dmem.io_rdEnable <= cpu.io_dmem_rdEnable @[WildcatTop.scala 31:15]
    dmem.io_wrAddress <= cpu.io_dmem_wrAddress @[WildcatTop.scala 31:15]
    dmem.io_wrData <= cpu.io_dmem_wrData @[WildcatTop.scala 31:15]
    dmem.io_wrEnable_0 <= _GEN_11
    dmem.io_wrEnable_1 <= _GEN_12
    dmem.io_wrEnable_2 <= _GEN_13
    dmem.io_wrEnable_3 <= _GEN_14
    SimpleCache.clock <= clock
    SimpleCache.reset <= reset
    SimpleCache.io_rdAddress <= cpu.io_dmem_rdAddress @[WildcatTop.scala 37:28]
    SimpleCache.io_rdEnable <= cpu.io_dmem_rdEnable @[WildcatTop.scala 34:27]
    SimpleCache.io_wrAddress <= cpu.io_dmem_wrAddress @[WildcatTop.scala 36:28]
    SimpleCache.io_wrData <= cpu.io_dmem_wrData @[WildcatTop.scala 38:25]
    SimpleCache.io_wrEnable_0 <= cpu.io_dmem_wrEnable_0 @[WildcatTop.scala 35:27]
    SimpleCache.io_wrEnable_1 <= cpu.io_dmem_wrEnable_1 @[WildcatTop.scala 35:27]
    SimpleCache.io_wrEnable_2 <= cpu.io_dmem_wrEnable_2 @[WildcatTop.scala 35:27]
    SimpleCache.io_wrEnable_3 <= cpu.io_dmem_wrEnable_3 @[WildcatTop.scala 35:27]
    imem.clock <= clock
    imem.reset <= reset
    imem.io_address <= cpu.io_imem_address @[WildcatTop.scala 41:19]
    tx.clock <= clock
    tx.reset <= reset
    tx.io_channel_valid <= _GEN_9
    tx.io_channel_bits <= _tx_io_channel_bits_T @[WildcatTop.scala 62:22]
    rx.clock <= clock
    rx.reset <= reset
    rx.io_rxd <= io_rx @[WildcatTop.scala 60:13]
    rx.io_channel_ready <= _GEN_5
    uartStatusReg <= _uartStatusReg_T @[WildcatTop.scala 66:30]
    memAddressReg <= cpu.io_dmem_rdAddress @[WildcatTop.scala 67:30]
    ledReg <= mux(reset, UInt<8>("h0"), _GEN_10) @[WildcatTop.scala 77:{23,23}]
    io_led_REG <= ledReg @[WildcatTop.scala 88:39]
    printf(clock, and(and(and(and(UInt<1>("h1"), _T_11), _T_16), _T_20), UInt<1>("h1")), " %c %d\n", _T_17, _T_18) : printf @[WildcatTop.scala 80:13]

  module WildcatTestTop :
    input clock : Clock
    input reset : UInt<1>
    output io_regFile_0 : UInt<32>
    output io_regFile_1 : UInt<32>
    output io_regFile_2 : UInt<32>
    output io_regFile_3 : UInt<32>
    output io_regFile_4 : UInt<32>
    output io_regFile_5 : UInt<32>
    output io_regFile_6 : UInt<32>
    output io_regFile_7 : UInt<32>
    output io_regFile_8 : UInt<32>
    output io_regFile_9 : UInt<32>
    output io_regFile_10 : UInt<32>
    output io_regFile_11 : UInt<32>
    output io_regFile_12 : UInt<32>
    output io_regFile_13 : UInt<32>
    output io_regFile_14 : UInt<32>
    output io_regFile_15 : UInt<32>
    output io_regFile_16 : UInt<32>
    output io_regFile_17 : UInt<32>
    output io_regFile_18 : UInt<32>
    output io_regFile_19 : UInt<32>
    output io_regFile_20 : UInt<32>
    output io_regFile_21 : UInt<32>
    output io_regFile_22 : UInt<32>
    output io_regFile_23 : UInt<32>
    output io_regFile_24 : UInt<32>
    output io_regFile_25 : UInt<32>
    output io_regFile_26 : UInt<32>
    output io_regFile_27 : UInt<32>
    output io_regFile_28 : UInt<32>
    output io_regFile_29 : UInt<32>
    output io_regFile_30 : UInt<32>
    output io_regFile_31 : UInt<32>
    output io_led : UInt<8>
    output io_tx : UInt<1>
    input io_rx : UInt<1>
    output io_stop : UInt<1>

    inst cpuTop of WildcatTop @[WildcatTestTop.scala 21:22]
    node debugRegs_33_0 = cpuTop.debugRegs_0
    node debugRegs_33_1 = cpuTop.debugRegs_1
    node debugRegs_33_2 = cpuTop.debugRegs_2
    node debugRegs_33_3 = cpuTop.debugRegs_3
    node debugRegs_33_4 = cpuTop.debugRegs_4
    node debugRegs_33_5 = cpuTop.debugRegs_5
    node debugRegs_33_6 = cpuTop.debugRegs_6
    node debugRegs_33_7 = cpuTop.debugRegs_7
    node debugRegs_33_8 = cpuTop.debugRegs_8
    node debugRegs_33_9 = cpuTop.debugRegs_9
    node debugRegs_33_10 = cpuTop.debugRegs_10
    node debugRegs_33_11 = cpuTop.debugRegs_11
    node debugRegs_33_12 = cpuTop.debugRegs_12
    node debugRegs_33_13 = cpuTop.debugRegs_13
    node debugRegs_33_14 = cpuTop.debugRegs_14
    node debugRegs_33_15 = cpuTop.debugRegs_15
    node debugRegs_33_16 = cpuTop.debugRegs_16
    node debugRegs_33_17 = cpuTop.debugRegs_17
    node debugRegs_33_18 = cpuTop.debugRegs_18
    node debugRegs_33_19 = cpuTop.debugRegs_19
    node debugRegs_33_20 = cpuTop.debugRegs_20
    node debugRegs_33_21 = cpuTop.debugRegs_21
    node debugRegs_33_22 = cpuTop.debugRegs_22
    node debugRegs_33_23 = cpuTop.debugRegs_23
    node debugRegs_33_24 = cpuTop.debugRegs_24
    node debugRegs_33_25 = cpuTop.debugRegs_25
    node debugRegs_33_26 = cpuTop.debugRegs_26
    node debugRegs_33_27 = cpuTop.debugRegs_27
    node debugRegs_33_28 = cpuTop.debugRegs_28
    node debugRegs_33_29 = cpuTop.debugRegs_29
    node debugRegs_33_30 = cpuTop.debugRegs_30
    node debugRegs_33_31 = cpuTop.debugRegs_31
    node ledReg_33 = cpuTop.ledReg_0
    node decExRegdecOutisECall_33 = cpuTop.decExReg_decOut_isECall
    io_regFile_0 <= debugRegs_33_0
    io_regFile_1 <= debugRegs_33_1
    io_regFile_2 <= debugRegs_33_2
    io_regFile_3 <= debugRegs_33_3
    io_regFile_4 <= debugRegs_33_4
    io_regFile_5 <= debugRegs_33_5
    io_regFile_6 <= debugRegs_33_6
    io_regFile_7 <= debugRegs_33_7
    io_regFile_8 <= debugRegs_33_8
    io_regFile_9 <= debugRegs_33_9
    io_regFile_10 <= debugRegs_33_10
    io_regFile_11 <= debugRegs_33_11
    io_regFile_12 <= debugRegs_33_12
    io_regFile_13 <= debugRegs_33_13
    io_regFile_14 <= debugRegs_33_14
    io_regFile_15 <= debugRegs_33_15
    io_regFile_16 <= debugRegs_33_16
    io_regFile_17 <= debugRegs_33_17
    io_regFile_18 <= debugRegs_33_18
    io_regFile_19 <= debugRegs_33_19
    io_regFile_20 <= debugRegs_33_20
    io_regFile_21 <= debugRegs_33_21
    io_regFile_22 <= debugRegs_33_22
    io_regFile_23 <= debugRegs_33_23
    io_regFile_24 <= debugRegs_33_24
    io_regFile_25 <= debugRegs_33_25
    io_regFile_26 <= debugRegs_33_26
    io_regFile_27 <= debugRegs_33_27
    io_regFile_28 <= debugRegs_33_28
    io_regFile_29 <= debugRegs_33_29
    io_regFile_30 <= debugRegs_33_30
    io_regFile_31 <= debugRegs_33_31
    io_led <= ledReg_33
    io_tx <= cpuTop.io_tx @[WildcatTestTop.scala 31:9]
    io_stop <= decExRegdecOutisECall_33
    cpuTop.clock <= clock
    cpuTop.reset <= reset
    cpuTop.io_rx <= io_rx @[WildcatTestTop.scala 30:16]
