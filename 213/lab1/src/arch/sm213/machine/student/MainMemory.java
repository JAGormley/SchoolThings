package arch.sm213.machine.student;

import machine.AbstractMainMemory;
import machine.AbstractMainMemory.InvalidAddressException;
import util.UnsignedByte;

/**
 * Main Memory of Simple CPU.
 *
 * Provides an abstraction of main memory (DRAM).
 */

public class MainMemory extends AbstractMainMemory {
	  private byte [] mem;
	  
	  /**
	   * Allocate memory.
	   * @param byteCapacity size of memory in bytes.
	   */
	  public MainMemory (int byteCapacity) {
	    
		// Need to implement the method
	  }
	  
	  /**
	   * Determine whether an address is aligned to specified length.
	   * @param address memory address.
	   * @param length byte length.
	   * @return true iff address is aligned to length.
	   */
	  @Override protected boolean isAccessAligned (int address, int length) {
	    
		  // Need to implement this method and change the returned value 
		  return false; 
	  }
	  
	  /**
	   * Convert an sequence of four bytes into a Big Endian integer.
	   * @param byteAtAddrPlus0 value of byte with lowest memory address (base address).
	   * @param byteAtAddrPlus1 value of byte at base address plus 1.
	   * @param byteAtAddrPlus2 value of byte at base address plus 2.
	   * @param byteAtAddrPlus3 value of byte at base address plus 3 (highest memory address).
	   * @return Big Endian integer formed by these four bytes.
	   */
	  @Override public int bytesToInteger (UnsignedByte byteAtAddrPlus0, UnsignedByte byteAtAddrPlus1, UnsignedByte byteAtAddrPlus2, UnsignedByte byteAtAddrPlus3) {
	    
		  // Need to implement this method and change the returned value 
		  return 0;
	  }
	  
	  /**
	   * Convert a Big Endian integer into an array of 4 bytes organized by memory address.
	   * @param  i an Big Endian integer.
	   * @return an array of UnsignedByte where [0] is value of low-address byte of the number etc.
	   */
	  @Override public UnsignedByte[] integerToBytes (int i) {
	   
		  //Need to implement this method and change the returned value
		  return null;
	  }
	  
	  /**
	   * Fetch a sequence of bytes from memory.
	   * @param address address of the first byte to fetch.
	   * @param length  number of bytes to fetch.
	   * @return an array of UnsignedByte where [0] is memory value at address, [1] is memory value at address+1 etc.
	   */
	  @Override protected UnsignedByte[] get (int address, int length) throws InvalidAddressException {
	    
		  // Need to implement the method and change the return value 
		  return null;
	  }
	  
	  /**
	   * Store a sequence of bytes into memory.
	   * @param  address                  address of the first byte in memory to recieve the specified value.
	   * @param  value                    an array of UnsignedByte values to store in memory at the specified address.
	   * @throws InvalidAddressException  if any address in the range address to address+value.length-1 is invalide.
	   */
	  @Override protected void set (int address, UnsignedByte[] value) throws InvalidAddressException {
	    
		  // Need to implement the method
	  }
	  
	  /**
	   * Determine the size of memory.
	   * @return the number of bytes allocated to this memory.
	   */
	  @Override public int length () {
	    
		  // Need to implement the method and change the return value  
		  return 0;
	  }
	}
