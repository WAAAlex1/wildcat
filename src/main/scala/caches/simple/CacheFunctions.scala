package caches.simple

import chisel3._
import chisel3.util._
import chiseltest._
import java.io.PrintWriter

object CacheFunctions {
  def startRead(M: SRAM) = {
    M.io.EN := true.B
    M.io.rw := true.B
  }

  def writeRAM(M: SRAM): Unit = {
    M.io.EN := true.B
    M.io.rw := false.B
  }

  def setIdle(M: SRAM): Unit = {
    M.io.EN := false.B
    M.io.rw := true.B
  }


  def maskedWriteData(readData: UInt, writeData: UInt,writeMask: Vec[Bool]): UInt = {
    val writeBytes = Wire(Vec(4, UInt(8.W)))
    val readBytes = Wire(Vec(4, UInt(8.W)))

    // Break into bytes
    for (i <- 0 until 4) {
      readBytes(i) := readData(8 * (i + 1) - 1, 8 * i)
      writeBytes(i) := writeData(8 * (i + 1) - 1, 8 * i)
    }

    // Mix based on write mask
    val resultBytes = Wire(Vec(4, UInt(8.W)))
    for (i <- 0 until 4) {
      resultBytes(i) := Mux(writeMask(i), writeBytes(i), readBytes(i))
    }

    // Recombine into 32-bit word
    Cat(resultBytes.reverse)
  }

  def pokeVecBool(vec: Vec[Bool], value: Int): Unit = {
    for (i <- 0 until vec.length) {
      vec(i).poke(((value >> i) & 1).B)
    }
  }

  def expectVec(actual: Vec[Bool], expected: Seq[Boolean]): Unit = {
    expected.zipWithIndex.foreach { case (exp, i) =>
      actual(actual.length - 1 - i).expect(exp.B)
    }
  }


}

