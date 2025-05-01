package TileLink

import chisel3._
import chisel3.util._

// Defines various bit widths for our configuration
case class TLConfig() {
  val AW = 32                  // address width
  val DW = 32                  // data width
  val ASW = 1                  // Channel A source identifier width
  val DSW = 1                  // Channel D sink identifier width
  val DBW = (DW >> 3)          // Number of data bytes
  val SZW = log2Ceil(DBW)      // The size width of operation in power of 2 represented in bytes
}