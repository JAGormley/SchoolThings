package arch.y86.isa;

import java.lang.String;
import java.util.HashMap;
import isa.AbstractISA;
import util.DataModel;

public class ISA extends AbstractISA {
  HashMap <Integer,String> registerNames = new HashMap <Integer,String> ();
  InsLayout opCode, register, regIndirect, immediate, literal, baseOffset, baseOffset1, baseOffset2, baseOffset4, indirect, f;
  
  public ISA () {
    super ("Y86", Endianness.LITTLE, new Assembler ());
  
    registerNames.put (0, "eax");
    registerNames.put (1, "ecx");
    registerNames.put (2, "edx");
    registerNames.put (3, "ebx");
    registerNames.put (4, "esp");
    registerNames.put (5, "ebp");
    registerNames.put (6, "esi");
    registerNames.put (7, "edi");
    
    opCode      = new OpCodeField    (8,  "%02x",  "%s",     "%s");
    register    = new DictonaryField (4,  "%x",    "%%%s",   "r[%s]",    registerNames);
    immediate   = new LabelableField (32, " %08x", "$0x%x",  "%s", "0x%x", "%s");
    literal     = new LabelableField (32, " %08x", "0x%x",   "%s", "0x%x", "%s");
    baseOffset  = new CompoundField  (new InsLayout[] {register,literal}, new int[] {1,0}, new String[] {"%s","(%s)"},   new int[] {1,0}, new String[] {"m[%s ","+ %s]"});
    baseOffset1 = new CompoundField  (new InsLayout[] {register,literal}, new int[] {1,0}, new String[] {"%s","(%s,1)"}, new int[] {1,0}, new String[] {"m[%s ","+ %s]"});
    baseOffset2 = new CompoundField  (new InsLayout[] {register,literal}, new int[] {1,0}, new String[] {"%s","(%s,2)"}, new int[] {1,0}, new String[] {"m[%s ","+ %s*2]"});
    baseOffset4 = new CompoundField  (new InsLayout[] {register,literal}, new int[] {1,0}, new String[] {"%s","(%s,4)"}, new int[] {1,0}, new String[] {"m[%s ","+ %s*4]"});
    indirect    = new CompoundField  (new InsLayout[] {register,literal}, new int[] {1,0}, new String[] {"%s","(%s)"},   new int[] {1,0}, new String[] {"%s ","+ %s"});
    f           = new ConstantField  (4,  "%x",     "%s", "%s", 0xf);
    
    define (0x00, new CompoundField (new InsLayout[] {opCode},                          new int[] {0},     new String[] {"halt"},                new int[] {0},     new String[] {"halt"}));
    define (0x10, new CompoundField (new InsLayout[] {opCode},                          new int[] {0},     new String[] {"nop"},                 new int[] {0},     new String[] {"nop"}));
    define (0x20, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"rrmovl ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s if CC <= 0"}));
    define (0x21, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"cmovle ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s if CC < 0"}));
    define (0x22, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"cmovl  ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s if CC == 0"}));
    define (0x23, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"cmove  ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s if CC != 0"}));
    define (0x24, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"cmovne ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s if CC >= 0"}));
    define (0x25, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"cmovge ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s if CC == 0"}));
    define (0x26, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"cmovg  ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s"}));
    define (0x30, new CompoundField (new InsLayout[] {opCode, f, register, immediate},  new int[] {0,3,2}, new String[] {"irmovl ","%s, ","%s"}, new int[] {2,3},   new String[] {"%s = ","%s"}));
    define (0x40, new CompoundField (new InsLayout[] {opCode, register, baseOffset},    new int[] {0,1,2}, new String[] {"rmmovl ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s"}));
    define (0x41, new CompoundField (new InsLayout[] {opCode, register, baseOffset1},   new int[] {0,1,2}, new String[] {"rmmovl ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s"}));
    define (0x42, new CompoundField (new InsLayout[] {opCode, register, baseOffset2},   new int[] {0,1,2}, new String[] {"rmmovl ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s"}));
    define (0x44, new CompoundField (new InsLayout[] {opCode, register, baseOffset4},   new int[] {0,1,2}, new String[] {"rmmovl ","%s, ","%s"}, new int[] {2,1},   new String[] {"%s = ","%s"}));
    define (0x50, new CompoundField (new InsLayout[] {opCode, register, baseOffset},    new int[] {0,2,1}, new String[] {"mrmovl ","%s, ","%s"}, new int[] {1,2},   new String[] {"%s = ","%s"}));
    define (0x51, new CompoundField (new InsLayout[] {opCode, register, baseOffset1},   new int[] {0,2,1}, new String[] {"mrmovl ","%s, ","%s"}, new int[] {1,2},   new String[] {"%s = ","%s"}));
    define (0x52, new CompoundField (new InsLayout[] {opCode, register, baseOffset2},   new int[] {0,2,1}, new String[] {"mrmovl ","%s, ","%s"}, new int[] {1,2},   new String[] {"%s = ","%s"}));
    define (0x54, new CompoundField (new InsLayout[] {opCode, register, baseOffset4},   new int[] {0,2,1}, new String[] {"mrmovl ","%s, ","%s"}, new int[] {1,2},   new String[] {"%s = ","%s"}));
    define (0x60, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"addl   ","%s, ","%s"}, new int[] {2,2,1}, new String[] {"%s = ","%s + ","%s"}));
    define (0x61, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"subl   ","%s, ","%s"}, new int[] {2,2,1}, new String[] {"%s = ","%s - ","%s"}));
    define (0x62, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"andl   ","%s, ","%s"}, new int[] {2,2,1}, new String[] {"%s = ","%s & ","%s"}));
    define (0x63, new CompoundField (new InsLayout[] {opCode, register, register},      new int[] {0,1,2}, new String[] {"xorl   ","%s, ","%s"}, new int[] {2,2,1}, new String[] {"%s = ","%s xor ","%s"}));
    define (0x70, new CompoundField (new InsLayout[] {opCode, literal},                 new int[] {0,1},   new String[] {"jmp    ","%s"},        new int[] {1},     new String[] {"pc = %s"}));
    define (0x71, new CompoundField (new InsLayout[] {opCode, literal},                 new int[] {0,1},   new String[] {"jle    ","%s"},        new int[] {1},     new String[] {"pc = %s if CC <= 0"}));
    define (0x72, new CompoundField (new InsLayout[] {opCode, literal},                 new int[] {0,1},   new String[] {"jl     ","%s"},        new int[] {1},     new String[] {"pc = %s if CC < 0"}));
    define (0x73, new CompoundField (new InsLayout[] {opCode, literal},                 new int[] {0,1},   new String[] {"je     ","%s"},        new int[] {1},     new String[] {"pc = %s if CC == 0"}));
    define (0x74, new CompoundField (new InsLayout[] {opCode, literal},                 new int[] {0,1},   new String[] {"jne    ","%s"},        new int[] {1},     new String[] {"pc = %s if CC != 0"}));
    define (0x75, new CompoundField (new InsLayout[] {opCode, literal},                 new int[] {0,1},   new String[] {"jge    ","%s"},        new int[] {1},     new String[] {"pc = %s if CC >= 0"}));
    define (0x76, new CompoundField (new InsLayout[] {opCode, literal},                 new int[] {0,1},   new String[] {"jg     ","%s"},        new int[] {1},     new String[] {"pc = %s if CC > 0"}));
    define (0x80, new CompoundField (new InsLayout[] {opCode, literal},                 new int[] {0,1},   new String[] {"call   ","%s"},        new int[] {1},     new String[] {"push pc; pc = %s"}));
    define (0x90, new CompoundField (new InsLayout[] {opCode},                          new int[] {0},     new String[] {"ret"},                 new int[] {0},     new String[] {"pop pc"}));
    define (0xa0, new CompoundField (new InsLayout[] {opCode, register, f},             new int[] {0,1},   new String[] {"pushl  ","%s"},        new int[] {1},     new String[] {"m[r[esp]] <= %s; r[esp] += 4"}));
    define (0xb0, new CompoundField (new InsLayout[] {opCode, register, f},             new int[] {0,1},   new String[] {"popl   ","%s"},        new int[] {1},     new String[] {"%s = m[r[esp]-4]; r[esp] -= 4"}));
    define (0xc0, new CompoundField (new InsLayout[] {opCode, f, register, immediate},  new int[] {0,3,2}, new String[] {"iaddl  ","%s, ","%s"}, new int[] {2,2,3}, new String[] {"%s = ","%s + ","%s"}));
    define (0xc1, new CompoundField (new InsLayout[] {opCode, f, register, immediate},  new int[] {0,3,2}, new String[] {"isubl  ","%s, ","%s"}, new int[] {2,2,1}, new String[] {"%s = ","%s - ","%s"}));
    define (0xc2, new CompoundField (new InsLayout[] {opCode, f, register, immediate},  new int[] {0,3,2}, new String[] {"iandl  ","%s, ","%s"}, new int[] {2,2,1}, new String[] {"%s = ","%s & ","%s"}));
    define (0xc3, new CompoundField (new InsLayout[] {opCode, f, register, immediate},  new int[] {0,3,2}, new String[] {"ixorl  ","%s, ","%s"}, new int[] {2,2,1}, new String[] {"%s = ","%s xor ","%s"}));
    define (0xd0, new CompoundField (new InsLayout[] {opCode},                          new int[] {0},     new String[] {"leave"},               new int[] {0},     new String[] {"r[esp] = r[ebp] + 4; r[ebp] = m[r[ebp]]"}));
    define (0xe0, new CompoundField (new InsLayout[] {opCode, f, indirect},             new int[] {0,2},   new String[] {"jmp    ","%s"},        new int[] {2},     new String[] {"pc = %s"}));
    define (0xe1, new CompoundField (new InsLayout[] {opCode, f, baseOffset},           new int[] {0,2},   new String[] {"jmp    ","*%s"},       new int[] {2},     new String[] {"pc = m[%s]"}));
    define (0xe2, new CompoundField (new InsLayout[] {opCode, f, baseOffset2},          new int[] {0,2},   new String[] {"jmp    ","*%s"},       new int[] {2},     new String[] {"pc = m[%s]"}));
    define (0xe4, new CompoundField (new InsLayout[] {opCode, f, baseOffset4},          new int[] {0,2},   new String[] {"jmp    ","*%s"},       new int[] {2},     new String[] {"pc = m[%s]"}));
    define (0xf0, new CompoundField (new InsLayout[] {opCode, register, f},             new int[] {0,1},   new String[] {"call   ","(%s)"},      new int[] {1},     new String[] {"push pc; pc = %s"}));
    define (0xf1, new CompoundField (new InsLayout[] {opCode, register, f},             new int[] {0,1},   new String[] {"call   ","*(%s)"},     new int[] {1},     new String[] {"push pc; pc = m[%s]"}));
    
    setPlaceholderInstruction (0x10);
  }  
}