package TileLink

import chisel3._

object ChA_Opcode {
  val Get = 4.U(3.W)
  val PutFullData = 0.U(3.W)
  val PutPartialData = 1.U(3.W)
  val ArithmeticData = 2.U(3.W)
  val LogicalData = 3.U(3.W)
  val Intent = 5.U(3.W)
}

object ChD_Opcode {
  val AccessAckData = 1.U(3.W)
  val AccessAck = 0.U(3.W)
  val HintAck = 2.U(3.W)
}