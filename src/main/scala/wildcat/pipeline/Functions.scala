package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.AluFunct3._
import wildcat.AluType._
import wildcat.BranchFunct3._
import wildcat.InstrType._
import wildcat.LoadStoreFunct3._
import wildcat.Opcode._


object Functions {

  def decode(instruction: UInt) = {

    val opcode = instruction(6, 0)
    val func3 = instruction(14, 12)
    val func7 = instruction(31, 25)
    val rs1 = instruction(19, 15)
    val rs2 = instruction(24, 20)
    val rd = instruction(11, 7)

    val decOut = Wire(new DecodedInstr())
    decOut.instrType := R.id.U
    decOut.isImm := false.B
    decOut.isLui := false.B
    decOut.isAuiPc := false.B
    decOut.isLoad := false.B
    decOut.isStore := false.B
    decOut.isBranch := false.B
    decOut.isJal := false.B
    decOut.isJalr := false.B
    decOut.rfWrite := false.B
    decOut.rs1Valid := false.B
    decOut.rs2Valid := false.B
    decOut.isLr := false.B
    decOut.isSc := false.B

    //Added for CSR / SYS Instructions
    decOut.isECall := false.B
    decOut.isMret := false.B
    decOut.isCsrrw := false.B
    decOut.isCsrrs := false.B
    decOut.isCsrrc := false.B
    decOut.isCsrrwi := false.B
    decOut.isCsrrsi := false.B
    decOut.isCsrrci := false.B

    //Added for exception handling
    decOut.isIllegal := true.B //Default to illegal, set false if legal instruction encountered

    switch(opcode) {
      is(AluImm.U) {
        decOut.instrType := I.id.U
        decOut.isImm := true.B
        decOut.rfWrite := true.B
        decOut.rs1Valid := true.B
        decOut.isIllegal := false.B  // Valid instruction
      }
      is(Alu.U) {
        decOut.instrType := R.id.U
        decOut.rfWrite := true.B
        decOut.rs1Valid := true.B // TODO: do I need this?
        decOut.rs2Valid := true.B
        decOut.isIllegal := false.B  // Valid instruction
      }
      is(Branch.U) {
        decOut.instrType := SBT.id.U
        decOut.isImm := true.B
        decOut.isBranch := true.B

        // Check for valid funct3 values
        when(func3 === 0.U || func3 === 1.U || // BEQ, BNE
          func3 === 4.U || func3 === 5.U || // BLT, BGE
          func3 === 6.U || func3 === 7.U) { // BLTU, BGEU
          decOut.isIllegal := false.B
        }
      }
      is(Load.U) {
        decOut.instrType := I.id.U
        decOut.isLoad := true.B
        decOut.rfWrite := true.B

        // Check for valid funct3 values
        when(func3 === 0.U || func3 === 1.U ||  // LB, LH
             func3 === 2.U || func3 === 4.U ||  // LW, LBU
             func3 === 5.U ) {                   // LHU
          decOut.isIllegal := false.B
        }
      }
      is(Store.U) {
        decOut.instrType := S.id.U
        decOut.isStore := true.B

        // Check for valid funct3 values
        when(func3 === 0.U || func3 === 1.U || func3 === 2.U) { // SB, SH, SW
          decOut.isIllegal := false.B
        }
      }
      is(Lui.U) {
        decOut.instrType := U.id.U
        decOut.rfWrite := true.B
        decOut.isLui := true.B
        decOut.isIllegal := false.B
      }
      is(AuiPc.U) {
        decOut.instrType := U.id.U
        decOut.rfWrite := true.B
        decOut.isAuiPc := true.B
        decOut.isIllegal := false.B
      }
      is(Jal.U) {
        decOut.instrType := UJ.id.U
        decOut.rfWrite := true.B
        decOut.isJal := true.B
        decOut.isIllegal := false.B
      }
      is(JalR.U) {
        when(func3 === 0.U) { // JALR requires func3 to be 0
          decOut.instrType := I.id.U
          decOut.isJalr := true.B
          decOut.rfWrite := true.B
          decOut.isIllegal := false.B
        }
      }
      is(System.U) {
        decOut.instrType := I.id.U
        when (func3 === 0.U) {
          when(instruction(31, 20) === 0.U) {
            decOut.isECall := true.B
            decOut.isIllegal := false.B  // Valid instruction
          }.elsewhen(instruction(31, 20) === 0x302.U && rs1 === 0.U && rd === 0.U) {
            decOut.isMret := true.B
            decOut.isIllegal := false.B  // Valid instruction
          }
        } .otherwise {
          switch(func3) {
            is(1.U) { // CSRRW
              decOut.isCsrrw := true.B
              decOut.rfWrite := true.B
              decOut.isIllegal := false.B  // Valid instruction
            }
            is(2.U) { // CSRRS
              decOut.isCsrrs := true.B
              decOut.rfWrite := true.B
              decOut.isIllegal := false.B  // Valid instruction
            }
            is(3.U) { // CSRRC
              decOut.isCsrrc := true.B
              decOut.rfWrite := true.B
              decOut.isIllegal := false.B  // Valid instruction
            }
            is(5.U) { // CSRRWI
              decOut.isCsrrwi := true.B
              decOut.rfWrite := true.B
              decOut.isIllegal := false.B  // Valid instruction
            }
            is(6.U) { // CSRRSI
              decOut.isCsrrsi := true.B
              decOut.rfWrite := true.B
              decOut.isIllegal := false.B  // Valid instruction
            }
            is(7.U) { // CSRRCI
              decOut.isCsrrci := true.B
              decOut.rfWrite := true.B
              decOut.isIllegal := false.B  // Valid instruction
            }
          }
        }
      }
      // For Load Reserved and Store Conditional instructions
      is(0x2F.U) { // AMO operations
        when(func3 === 2.U) { // Word size operations
          val funct5 = func7(6, 2)
          when(funct5 === 2.U) { // LR.W
            when(rs2 === 0.U) { // LR.W requires rs2=0
              decOut.isLr := true.B
              decOut.rfWrite := true.B
              decOut.isIllegal := false.B
            }
          }.elsewhen(funct5 === 3.U) { // SC.W
            decOut.isSc := true.B
            decOut.rfWrite := true.B
            decOut.isIllegal := false.B
          }
          // Other funct5 values remain marked as illegal
        }
      }
    }
    decOut.aluOp := getAluOp(instruction)
    decOut.imm := getImm(instruction, decOut.instrType)
    decOut
  }

  def getAluOp(instruction: UInt): UInt = {

    val opcode = instruction(6, 0)
    val func3 = instruction(14, 12)
    val func7 = instruction(31, 25)

    val aluOp = WireDefault(ADD.id.U)
    switch(func3) {
      is(F3_ADD_SUB.U) {
        aluOp := ADD.id.U
        when(opcode =/= AluImm.U && opcode =/= JalR.U && func7 =/= 0.U) {
          aluOp := SUB.id.U
        }
      }
      is(F3_SLL.U) {
        aluOp := SLL.id.U
      }
      is(F3_SLT.U) {
        aluOp := SLT.id.U
      }
      is(F3_SLTU.U) {
        aluOp := SLTU.id.U
      }
      is(F3_XOR.U) {
        aluOp := XOR.id.U
      }
      is(F3_SRL_SRA.U) {
        when(func7 === 0.U) {
          aluOp := SRL.id.U
        }.otherwise {
          aluOp := SRA.id.U
        }
      }
      is(F3_OR.U) {
        aluOp := OR.id.U
      }
      is(F3_AND.U) {
        aluOp := AND.id.U
      }
    }
    aluOp
  }

  def compare(funct3: UInt, op1: UInt, op2: UInt): Bool = {
    val res = Wire(Bool())
    res := false.B
    switch(funct3) {
      is(BEQ.U) {
        res := op1 === op2
      }
      is(BNE.U) {
        res := op1 =/= op2
      }
      is(BLT.U) {
        res := op1.asSInt < op2.asSInt
      }
      is(BGE.U) {
        res := op1.asSInt >= op2.asSInt
      }
      is(BLTU.U) {
        res := op1 < op2
      }
      is(BGEU.U) {
        res := op1 >= op2
      }
    }
    res
  }

  def getImm(instruction: UInt, instrType: UInt): SInt = {

    val imm = Wire(SInt(32.W))
    imm := instruction(31, 20).asSInt
    switch(instrType) {
      is(I.id.U) {
        imm := (Fill(20, instruction(31)) ## instruction(31, 20)).asSInt
      }
      is(S.id.U) {
        imm := (Fill(20, instruction(31)) ## instruction(31, 25) ## instruction(11, 7)).asSInt
      }
      is(SBT.id.U) {
        imm := (Fill(19, instruction(31)) ## instruction(7) ## instruction(30, 25) ## instruction(11, 8) ## 0.U(1.W)).asSInt
      }
      is(U.id.U) {
        imm := (instruction(31, 12) ## Fill(12, 0.U)).asSInt
      }
      is(UJ.id.U) {
        imm := (Fill(11, instruction(31)) ## instruction(19, 12) ## instruction(20) ## instruction(30, 21) ## 0.U(1.W)).asSInt
      }
    }
    imm
  }

  // Input direct from instruction fetch, the synchronous memory contains the pipeline register
  def registerFile(rs1: UInt, rs2: UInt, rd: UInt, wrData: UInt, wrEna: Bool, useMem: Boolean = true) = {

    if (useMem) {
      val regs = SyncReadMem(32, UInt(32.W), SyncReadMem.WriteFirst)
      val debugRegs = RegInit(VecInit(Seq.fill(32)(0.U(32.W)))) // only for debugging, not used in synthesis
      val rs1Val = Mux(RegNext(rs1) === 0.U, 0.U, regs.read(rs1))
      val rs2Val = Mux(RegNext(rs2) === 0.U, 0.U, regs.read(rs2))
      when(wrEna && rd =/= 0.U) {
        regs.write(rd, wrData)
        debugRegs(rd) := wrData
      }
      (rs1Val, rs2Val, debugRegs)
    } else {
      // non need for forwarding as read address is delayed
      val regs = RegInit(VecInit(Seq.fill(32)(0.U(32.W))))
      val rs1Val = regs(RegNext(rs1))
      val rs2Val = regs(RegNext(rs2))
      when(wrEna && rd =/= 0.U) {
        regs(rd) := wrData
      }
      (rs1Val, rs2Val, regs)
    }
  }

  // TODO: something missing? Looks OK now. Wait for the tests.
  def alu(op: UInt, a: UInt, b: UInt): UInt = {
    val res = Wire(UInt(32.W))
    res := DontCare
    switch(op) {
      is(ADD.id.U) {
        res := a + b
      }
      is(SUB.id.U) {
        res := a - b
      }
      is(AND.id.U) {
        res := a & b
      }
      is(OR.id.U) {
        res := a | b
      }
      is(XOR.id.U) {
        res := a ^ b
      }
      is(SLL.id.U) {
        res := a << b(4, 0)
      }
      is(SRL.id.U) {
        res := a >> b(4, 0)
      }
      is(SRA.id.U) {
        res := (a.asSInt >> b(4, 0)).asUInt
      }
      is(SLT.id.U) {
        res := (a.asSInt < b.asSInt).asUInt
      }
      is(SLTU.id.U) {
        res := (a < b).asUInt
      }
    }
    res
  }

  def selectLoadData(data: UInt, func3: UInt, memLow: UInt): UInt = {
    val res = Wire(UInt(32.W))
    res := data
    switch(func3) {
      is(LB.U) {
        switch(memLow) {
          is(0.U) {
            res := Fill(24, data(7)) ## data(7, 0)
          }
          is(1.U) {
            res := Fill(24, data(15)) ## data(15, 8)
          }
          is(2.U) {
            res := Fill(24, data(23)) ## data(23, 16)

          }
          is(3.U) {
            res := Fill(24, data(31)) ## data(31, 24)
          }
        }
      }
      is(LH.U) {
        switch(memLow) {
          is(0.U) {
            res := Fill(16, data(15)) ## data(15, 0)
          }
          is(2.U) {
            res := Fill(16, data(31)) ## data(31, 16)
          }
        }
      }
      is(LBU.U) {
        switch(memLow) {
          is(0.U) {
            res := data(7, 0)
          }
          is(1.U) {
            res := data(15, 8)
          }
          is(2.U) {
            res := data(23, 16)
          }
          is(3.U) {
            res := data(31, 24)
          }
        }
      }
      is(LHU.U) {
        switch(memLow) {
          is(0.U) {
            res := data(15, 0)
          }
          is(2.U) {
            res := data(31, 16)
          }
        }
      }
    }
    res
  }

  def getWriteData(data: UInt, func3: UInt, memLow: UInt) = {
    val wrData = WireDefault(data)
    val wrEnable = VecInit(Seq.fill(4)(false.B))
    switch(func3) {
      is(SB.U) {
        wrData := data(7, 0) ## data(7, 0) ## data(7, 0) ## data(7, 0)
        wrEnable(memLow) := true.B
      }
      is(SH.U) {
        wrData := data(15, 0) ## data(15, 0)
        switch(memLow) {
          is(0.U) {
            wrEnable(0) := true.B
            wrEnable(1) := true.B
          }
          is(2.U) {
            wrEnable(2) := true.B
            wrEnable(3) := true.B
          }
        }
      }
      is(SW.U) {
        wrEnable := VecInit(Seq.fill(4)(true.B))
      }
    }
    (wrData, wrEnable)
  }
}
