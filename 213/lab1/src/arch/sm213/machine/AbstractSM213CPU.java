package arch.sm213.machine;

import machine.AbstractCPU;
import machine.Register;
import machine.RegisterSet;
import machine.AbstractMainMemory;
import util.HalfByteNumber;
import util.SixByteNumber;

/**
 * Infrastructure for executing an SM213 CPU implementation.
 */

public abstract class AbstractSM213CPU extends AbstractCPU {
  /** Internal machine registers. */
  private RegisterSet ps;
  /** Program counter (address of next instruction). */
  protected Register.Port    pc;
  /** Value of current instruction (in its entirety). */
  protected Register.Port    instruction;  
  /** Opcode. */
  protected Register.Port    insOpCode; 
  /** Operand 0. */
  protected Register.Port    insOp0; 
  /** Operand 1. */
  protected Register.Port    insOp1; 
  /** Operand 2. */
  protected Register.Port    insOp2; 
  /** Immediate-value operand. */
  protected Register.Port    insOpImm; 
  /** Extended operand (extra 4 bytes). */
  protected Register.Port    insOpExt;
  /** Special register used to store address of current instruction for gui. */
  private Register    curInst; 
  
  /**
   * Create a new CPU.
   *
   * @param name   fully-qualified name of CPU implementation.
   * @param memory main memory used by CPU.
   */
  public AbstractSM213CPU (String name, AbstractMainMemory memory) {
    super (name, memory);
    for (int r=0; r<8; r++)
      is.regFile.addSigned (String.format ("r%d", r), true);
    ps = new RegisterSet ("");
    is.processorState.add (ps);
    pc          = ps.addUnsigned ("PC",          Integer.class, true).getPort();
    instruction = ps.addUnsigned ("Instruction", SixByteNumber.class).getPort();
    insOpCode   = ps.addUnsigned ("Ins Op Code", HalfByteNumber.class).getPort();
    insOp0      = ps.addUnsigned ("Ins Op 0",    HalfByteNumber.class).getPort();
    insOp1      = ps.addUnsigned ("Ins Op 1",    HalfByteNumber.class).getPort();
    insOp2      = ps.addUnsigned ("Ins Op 2",    HalfByteNumber.class).getPort();
    insOpImm    = ps.addSigned   ("Ins Op Imm",  Byte.class).getPort();
    insOpExt    = ps.addSigned   ("Ins Op Ext",  Integer.class).getPort();
    curInst     = ps.add         (AbstractCPU.InternalState.CURRENT_INSTRUCTION_ADDRESS, Integer.class, true, false, false, -1);
  }

  /**
   * Compute one cycle of the SM213 CPU
   */
  protected void cycle () throws InvalidInstructionException, MachineHaltException, AbstractMainMemory.InvalidAddressException {
    try {
      try {
	curInst.set (pc.get ());
	fetch ();
      } finally {
	tickClock ();
      }
      try {
	execute ();
      } finally {
	tickClock ();
      }
    } catch (RegisterSet.InvalidRegisterNumberException ire) {
      throw new InvalidInstructionException ();
    }
  }
  
  /**
   * Set PC.  
   *
   * @param aPC New memory address for PC.
   */
  @Override public void setPC (int aPC) {
    ps.tickClock (Register.ClockTransition.BUBBLE);
    super.setPC (aPC);
  }
  
  /**
   * Fetch next instruction from memory into CPU processorState registers.
   *
   * @throws AbstractMainMemory.InvalidAddressException Program counter stores an invalid memory address for fetching a new instruction.
   */
  protected abstract void fetch () throws AbstractMainMemory.InvalidAddressException;
  
  /**
   * Execute instruction currently loaded in processorState registers.
   *
   * @throws AbstractCPU.InvalidInstructionException    instruction is invalid.
   * @throws AbstractCPU.MachineHaltException           instruction is the halt instruction.
   * @throws RegisterSet.InvalidRegisterNumberException instruction encodes an invalid register number.
   * @throws AbstractMainMemory.InvalidAddressException instruction encodes an invalid memory address.
   */
  protected abstract void execute () throws InvalidInstructionException, MachineHaltException, RegisterSet.InvalidRegisterNumberException, AbstractMainMemory.InvalidAddressException ;
  
  /**
   * Implement a clock tick by telling registerFile and processorState to save their current
   * input values and to start presenting them on their outputs.
   */
  private void tickClock () {
    is.regFile.tickClock (Register.ClockTransition.NORMAL);
    ps.tickClock  (Register.ClockTransition.NORMAL);
  }
}