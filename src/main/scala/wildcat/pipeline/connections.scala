package wildcat.pipeline

import chisel3._

class InstrIO extends Bundle {
  val address = Output(UInt(32.W))
  val data = Input(UInt(32.W))
  val stall = Input(Bool())
}

class MemIO extends Bundle {
  val rdAddress = Output(UInt(32.W))
  val rdData = Input(UInt(32.W))
  val rdEnable = Output(Bool())
  val wrAddress = Output(UInt(32.W))
  val wrData = Output(UInt(32.W))
  val wrEnable = Output(Vec (4, Bool()))
  val stall = Input(Bool())
}

class DecodedInstr extends Bundle {
  val instrType = UInt(3.W)
  val aluOp = UInt(4.W)
  val imm = SInt(32.W)
  val isImm = Bool()
  val isLui = Bool()
  val isAuiPc = Bool()
  val isLoad = Bool()
  val isStore = Bool()
  val isLr = Bool()  // Load Reserved
  val isSc = Bool()  // Store Conditional
  val isBranch = Bool()
  val isJal = Bool()
  val isJalr = Bool()
  val rfWrite = Bool()
  val rs1Valid = Bool()
  val rs2Valid = Bool()

  //Added for CSR / SYS Instructions
  val isECall = Bool()
  val isMret = Bool()
  val isCsrrw = Bool()
  val isCsrrs = Bool()
  val isCsrrc = Bool()
  val isCsrrwi = Bool()
  val isCsrrsi = Bool()
  val isCsrrci = Bool()

  //Added for exception handling
  // Function to check if instruction is valid
  val isIllegal = Bool()

}
