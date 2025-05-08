package ExtMemory

import chisel3._

object SPICommands {
  // Commands for PSRAM
  val QUAD_MODE_ENABLE = "h35".U(8.W)
  val QPI_FAST_QUAD_READ = "hEB".U(8.W)
  val QPI_WRITE = "h38".U(8.W)
  val QUAD_MODE_EXIT = "hF5".U(8.W)
  val WRAP_BOUNDARY_TOGGLE = "hC0".U(8.W)

  // Commands for Flash
  val WRITE_ENABLE = "h06".U(8.W)
  val WRITE_DISABLE = "h04".U(8.W)
  val QUAD_ENABLE = "b0000_0010".U(8.W)
  val FAST_READ_QUAD_IO = "hEB".U(8.W)
  val QUAD_INPUT_PAGE_PROGRAM = "h32".U(8.W)
  val READ_STATUS_REGISTER_1 = "h05".U(8.W)
  val READ_STATUS_REGISTER_2 = "h35".U(8.W)
  val READ_STATUS_REGISTER_3 = "h15".U(8.W)
  val WRITE_STATUS_REGISTER_1 = "h01".U(8.W)
  val WRITE_STATUS_REGISTER_2 = "h31".U(8.W)
  val WRITE_STATUS_REGISTER_3 = "h11".U(8.W)
}
