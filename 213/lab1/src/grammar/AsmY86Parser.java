// $ANTLR 3.3 Nov 30, 2010 12:45:30 /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g 2011-05-16 13:47:14

package grammar;

import isa.Memory;
import isa.MemoryCell;
import isa.Instruction;
import isa.Datum;
import arch.y86.isa.Assembler;


import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

public class AsmY86Parser extends Parser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "NewLine", "Comment", "Identifier", "Hex", "Decimal", "Character", "Digit", "HexDigit", "WS", "':'", "'halt'", "'nop'", "'rrmovl'", "'cmovle'", "'cmovl'", "'cmove'", "'cmovne'", "'cmovge'", "'cmovg'", "'irmovl'", "'rmmovl'", "'mrmovl'", "'addl'", "'subl'", "'andl'", "'xorl'", "'iaddl'", "'isubl'", "'iandl'", "'ixorl'", "'jmp'", "'jle'", "'jl'", "'je'", "'jne'", "'jge'", "'jg'", "'call'", "'pushl'", "'popl'", "'leave'", "','", "'*'", "'ret'", "'$'", "'('", "')'", "'1'", "'2'", "'4'", "'%eax'", "'%ecx'", "'%edx'", "'%ebx'", "'%esp'", "'%ebp'", "'%esi'", "'%edi'", "'-'", "'.pos'", "'.long'", "'.word'", "'.byte'", "'.align'"
    };
    public static final int EOF=-1;
    public static final int T__13=13;
    public static final int T__14=14;
    public static final int T__15=15;
    public static final int T__16=16;
    public static final int T__17=17;
    public static final int T__18=18;
    public static final int T__19=19;
    public static final int T__20=20;
    public static final int T__21=21;
    public static final int T__22=22;
    public static final int T__23=23;
    public static final int T__24=24;
    public static final int T__25=25;
    public static final int T__26=26;
    public static final int T__27=27;
    public static final int T__28=28;
    public static final int T__29=29;
    public static final int T__30=30;
    public static final int T__31=31;
    public static final int T__32=32;
    public static final int T__33=33;
    public static final int T__34=34;
    public static final int T__35=35;
    public static final int T__36=36;
    public static final int T__37=37;
    public static final int T__38=38;
    public static final int T__39=39;
    public static final int T__40=40;
    public static final int T__41=41;
    public static final int T__42=42;
    public static final int T__43=43;
    public static final int T__44=44;
    public static final int T__45=45;
    public static final int T__46=46;
    public static final int T__47=47;
    public static final int T__48=48;
    public static final int T__49=49;
    public static final int T__50=50;
    public static final int T__51=51;
    public static final int T__52=52;
    public static final int T__53=53;
    public static final int T__54=54;
    public static final int T__55=55;
    public static final int T__56=56;
    public static final int T__57=57;
    public static final int T__58=58;
    public static final int T__59=59;
    public static final int T__60=60;
    public static final int T__61=61;
    public static final int T__62=62;
    public static final int T__63=63;
    public static final int T__64=64;
    public static final int T__65=65;
    public static final int T__66=66;
    public static final int T__67=67;
    public static final int NewLine=4;
    public static final int Comment=5;
    public static final int Identifier=6;
    public static final int Hex=7;
    public static final int Decimal=8;
    public static final int Character=9;
    public static final int Digit=10;
    public static final int HexDigit=11;
    public static final int WS=12;

    // delegates
    // delegators


        public AsmY86Parser(TokenStream input) {
            this(input, new RecognizerSharedState());
        }
        public AsmY86Parser(TokenStream input, RecognizerSharedState state) {
            super(input, state);
             
        }
        

    public String[] getTokenNames() { return AsmY86Parser.tokenNames; }
    public String getGrammarFileName() { return "/Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g"; }


    public enum LineType {INSTRUCTION, DATA, NULL};
    Memory memory;
    LineType lineType;
    int pc;
    int opCode;
    int[] op = new int[4];
    int opLength;
    String label;
    String comment;
    int dataSize;
    int dataValue;
    int dataCount;
    int pass;

    void init (Memory aMemory, int startingAddress) {
      memory      = aMemory;
      pc          = startingAddress;
      lineType    = LineType.NULL;
      comment     = "";
      label       = "";
    }

    public void checkSyntax (Memory aMemory, int startingAddress) throws Assembler.AssemblyException {
      init (aMemory, startingAddress);
      pass = 0;
      try {
        program ();
      } catch (RecognitionException e) {
        throw new Assembler.AssemblyException ("");
      }
    }

    public void passOne (Memory aMemory, int startingAddress) throws Assembler.AssemblyException {
      init (aMemory, startingAddress);
      pass = 1;
      try {
        program ();
      } catch (RecognitionException e) {
        throw new Assembler.AssemblyException ("");
      }
    }

    public void passTwo (Memory aMemory, int startingAddress) throws Assembler.AssemblyException {
      init (aMemory, startingAddress);
      pass = 2;
      try {
        program ();
      } catch (RecognitionException e) {
        throw new Assembler.AssemblyException ("");
      }
    }

    @Override
    public void emitErrorMessage(String msg) {
      throw new Assembler.AssemblyException (msg);
    }

    int getLabelValue (String label) {
      Integer value = memory.getLabelMap ().getAddress (label);
      if (value==null) {
        if (pass==1)
          value = pc;
        else
          emitErrorMessage (String.format ("Label not found: %s at address %d", label, pc));
      }
      return value.intValue ();
    }

    void writeLine () throws RecognitionException {
      MemoryCell cell = null;
      switch (lineType) {
        case INSTRUCTION:
          try {
            cell = Instruction.valueOf (memory, pc, opCode, op, label, comment);
            if (cell==null)
              throw new RecognitionException ();
            if (pass==1 && !label.trim ().equals ("")) 
              memory.addLabelOnly (cell);
            else if (pass==2)
              memory.add (cell);
            label = "";
            comment = "";
            pc += cell.length ();
          } catch (IndexOutOfBoundsException e) {
            throw new RecognitionException ();
          }
          break;
        case DATA:
          for (int i=0; i<dataCount; i++) {
            cell = Datum.valueOf (memory, pc, dataValue, dataSize, label, comment);
            if (cell==null)
              throw new RecognitionException ();
            if (pass==1 && !label.trim ().equals (""))
              memory.addLabelOnly (cell);
            else if (pass==2)
              memory.add (cell);
            label = "";
            comment = "";
            pc += dataSize;
          }
          label = "";
          comment = "";
          break;
        default:
      }
      lineType = LineType.NULL;
      op[0]=0;
      op[1]=0;
      op[2]=0;
      op[3]=0;
    }



    // $ANTLR start "program"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:143:1: program : ( line )* EOF ;
    public final void program() throws RecognitionException {
        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:143:9: ( ( line )* EOF )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:143:11: ( line )* EOF
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:143:11: ( line )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( ((LA1_0>=NewLine && LA1_0<=Identifier)||(LA1_0>=14 && LA1_0<=44)||LA1_0==47||(LA1_0>=63 && LA1_0<=67)) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:143:11: line
            	    {
            	    pushFollow(FOLLOW_line_in_program46);
            	    line();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

            match(input,EOF,FOLLOW_EOF_in_program49); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "program"


    // $ANTLR start "line"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:1: line : ( labelDeclaration )? ( instruction | directive )? ( NewLine | ( Comment ) ) ;
    public final void line() throws RecognitionException {
        Token Comment1=null;

        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:6: ( ( labelDeclaration )? ( instruction | directive )? ( NewLine | ( Comment ) ) )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:8: ( labelDeclaration )? ( instruction | directive )? ( NewLine | ( Comment ) )
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:8: ( labelDeclaration )?
            int alt2=2;
            alt2 = dfa2.predict(input);
            switch (alt2) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:9: labelDeclaration
                    {
                    pushFollow(FOLLOW_labelDeclaration_in_line58);
                    labelDeclaration();

                    state._fsp--;


                    }
                    break;

            }

            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:28: ( instruction | directive )?
            int alt3=3;
            int LA3_0 = input.LA(1);

            if ( ((LA3_0>=14 && LA3_0<=44)||LA3_0==47) ) {
                alt3=1;
            }
            else if ( ((LA3_0>=63 && LA3_0<=67)) ) {
                alt3=2;
            }
            switch (alt3) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:30: instruction
                    {
                    pushFollow(FOLLOW_instruction_in_line64);
                    instruction();

                    state._fsp--;


                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:44: directive
                    {
                    pushFollow(FOLLOW_directive_in_line68);
                    directive();

                    state._fsp--;


                    }
                    break;

            }

            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:57: ( NewLine | ( Comment ) )
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0==NewLine) ) {
                alt4=1;
            }
            else if ( (LA4_0==Comment) ) {
                alt4=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 4, 0, input);

                throw nvae;
            }
            switch (alt4) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:59: NewLine
                    {
                    match(input,NewLine,FOLLOW_NewLine_in_line75); 

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:69: ( Comment )
                    {
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:69: ( Comment )
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:145:70: Comment
                    {
                    Comment1=(Token)match(input,Comment,FOLLOW_Comment_in_line80); 
                     comment = (Comment1!=null?Comment1.getText():null).substring(1).trim(); 

                    }


                    }
                    break;

            }

            writeLine ();

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "line"

    public static class labelDeclaration_return extends ParserRuleReturnScope {
    };

    // $ANTLR start "labelDeclaration"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:148:1: labelDeclaration : ( Identifier | operand ) ':' ;
    public final AsmY86Parser.labelDeclaration_return labelDeclaration() throws RecognitionException {
        AsmY86Parser.labelDeclaration_return retval = new AsmY86Parser.labelDeclaration_return();
        retval.start = input.LT(1);

        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:149:2: ( ( Identifier | operand ) ':' )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:149:4: ( Identifier | operand ) ':'
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:149:4: ( Identifier | operand )
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==Identifier) ) {
                alt5=1;
            }
            else if ( ((LA5_0>=14 && LA5_0<=44)) ) {
                alt5=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 5, 0, input);

                throw nvae;
            }
            switch (alt5) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:149:5: Identifier
                    {
                    match(input,Identifier,FOLLOW_Identifier_in_labelDeclaration100); 

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:149:18: operand
                    {
                    pushFollow(FOLLOW_operand_in_labelDeclaration104);
                    operand();

                    state._fsp--;


                    }
                    break;

            }

            match(input,13,FOLLOW_13_in_labelDeclaration107); 
            label = input.toString(retval.start,input.LT(-1)).substring (0, input.toString(retval.start,input.LT(-1)).length ()-1);

            }

            retval.stop = input.LT(-1);

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return retval;
    }
    // $ANTLR end "labelDeclaration"

    public static class label_return extends ParserRuleReturnScope {
        public int value;
    };

    // $ANTLR start "label"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:150:1: label returns [int value] : ( Identifier | operand ) ;
    public final AsmY86Parser.label_return label() throws RecognitionException {
        AsmY86Parser.label_return retval = new AsmY86Parser.label_return();
        retval.start = input.LT(1);

        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:151:2: ( ( Identifier | operand ) )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:151:4: ( Identifier | operand )
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:151:4: ( Identifier | operand )
            int alt6=2;
            int LA6_0 = input.LA(1);

            if ( (LA6_0==Identifier) ) {
                alt6=1;
            }
            else if ( ((LA6_0>=14 && LA6_0<=44)) ) {
                alt6=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 6, 0, input);

                throw nvae;
            }
            switch (alt6) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:151:5: Identifier
                    {
                    match(input,Identifier,FOLLOW_Identifier_in_label122); 

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:151:18: operand
                    {
                    pushFollow(FOLLOW_operand_in_label126);
                    operand();

                    state._fsp--;


                    }
                    break;

            }

            retval.value = getLabelValue (input.toString(retval.start,input.LT(-1)));

            }

            retval.stop = input.LT(-1);

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return retval;
    }
    // $ANTLR end "label"


    // $ANTLR start "instruction"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:154:1: instruction : ( nop | halt | rrmovxx | irmovl | rmmovl | mrmovl | opl | jxx | call | ret | pushl | popl | iopl | leave | jmp ) ;
    public final void instruction() throws RecognitionException {
        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:2: ( ( nop | halt | rrmovxx | irmovl | rmmovl | mrmovl | opl | jxx | call | ret | pushl | popl | iopl | leave | jmp ) )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:4: ( nop | halt | rrmovxx | irmovl | rmmovl | mrmovl | opl | jxx | call | ret | pushl | popl | iopl | leave | jmp )
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:4: ( nop | halt | rrmovxx | irmovl | rmmovl | mrmovl | opl | jxx | call | ret | pushl | popl | iopl | leave | jmp )
            int alt7=15;
            alt7 = dfa7.predict(input);
            switch (alt7) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:5: nop
                    {
                    pushFollow(FOLLOW_nop_in_instruction140);
                    nop();

                    state._fsp--;


                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:11: halt
                    {
                    pushFollow(FOLLOW_halt_in_instruction144);
                    halt();

                    state._fsp--;


                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:18: rrmovxx
                    {
                    pushFollow(FOLLOW_rrmovxx_in_instruction148);
                    rrmovxx();

                    state._fsp--;


                    }
                    break;
                case 4 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:28: irmovl
                    {
                    pushFollow(FOLLOW_irmovl_in_instruction152);
                    irmovl();

                    state._fsp--;


                    }
                    break;
                case 5 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:37: rmmovl
                    {
                    pushFollow(FOLLOW_rmmovl_in_instruction156);
                    rmmovl();

                    state._fsp--;


                    }
                    break;
                case 6 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:46: mrmovl
                    {
                    pushFollow(FOLLOW_mrmovl_in_instruction160);
                    mrmovl();

                    state._fsp--;


                    }
                    break;
                case 7 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:55: opl
                    {
                    pushFollow(FOLLOW_opl_in_instruction164);
                    opl();

                    state._fsp--;


                    }
                    break;
                case 8 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:61: jxx
                    {
                    pushFollow(FOLLOW_jxx_in_instruction168);
                    jxx();

                    state._fsp--;


                    }
                    break;
                case 9 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:67: call
                    {
                    pushFollow(FOLLOW_call_in_instruction172);
                    call();

                    state._fsp--;


                    }
                    break;
                case 10 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:74: ret
                    {
                    pushFollow(FOLLOW_ret_in_instruction176);
                    ret();

                    state._fsp--;


                    }
                    break;
                case 11 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:80: pushl
                    {
                    pushFollow(FOLLOW_pushl_in_instruction180);
                    pushl();

                    state._fsp--;


                    }
                    break;
                case 12 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:88: popl
                    {
                    pushFollow(FOLLOW_popl_in_instruction184);
                    popl();

                    state._fsp--;


                    }
                    break;
                case 13 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:95: iopl
                    {
                    pushFollow(FOLLOW_iopl_in_instruction188);
                    iopl();

                    state._fsp--;


                    }
                    break;
                case 14 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:102: leave
                    {
                    pushFollow(FOLLOW_leave_in_instruction192);
                    leave();

                    state._fsp--;


                    }
                    break;
                case 15 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:155:110: jmp
                    {
                    pushFollow(FOLLOW_jmp_in_instruction196);
                    jmp();

                    state._fsp--;


                    }
                    break;

            }

            lineType = LineType.INSTRUCTION;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "instruction"


    // $ANTLR start "operand"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:157:1: operand : ( 'halt' | 'nop' | 'rrmovl' | 'cmovle' | 'cmovl' | 'cmove' | 'cmovne' | 'cmovge' | 'cmovg' | 'irmovl' | 'rmmovl' | 'mrmovl' | 'addl' | 'subl' | 'andl' | 'xorl' | 'iaddl' | 'isubl' | 'iandl' | 'ixorl' | 'jmp' | 'jle' | 'jl' | 'je' | 'jne' | 'jge' | 'jg' | 'call' | 'pushl' | 'popl' | 'leave' ) ;
    public final void operand() throws RecognitionException {
        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:157:9: ( ( 'halt' | 'nop' | 'rrmovl' | 'cmovle' | 'cmovl' | 'cmove' | 'cmovne' | 'cmovge' | 'cmovg' | 'irmovl' | 'rmmovl' | 'mrmovl' | 'addl' | 'subl' | 'andl' | 'xorl' | 'iaddl' | 'isubl' | 'iandl' | 'ixorl' | 'jmp' | 'jle' | 'jl' | 'je' | 'jne' | 'jge' | 'jg' | 'call' | 'pushl' | 'popl' | 'leave' ) )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:157:11: ( 'halt' | 'nop' | 'rrmovl' | 'cmovle' | 'cmovl' | 'cmove' | 'cmovne' | 'cmovge' | 'cmovg' | 'irmovl' | 'rmmovl' | 'mrmovl' | 'addl' | 'subl' | 'andl' | 'xorl' | 'iaddl' | 'isubl' | 'iandl' | 'ixorl' | 'jmp' | 'jle' | 'jl' | 'je' | 'jne' | 'jge' | 'jg' | 'call' | 'pushl' | 'popl' | 'leave' )
            {
            if ( (input.LA(1)>=14 && input.LA(1)<=44) ) {
                input.consume();
                state.errorRecovery=false;
            }
            else {
                MismatchedSetException mse = new MismatchedSetException(null,input);
                throw mse;
            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "operand"


    // $ANTLR start "halt"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:161:1: halt : 'halt' ;
    public final void halt() throws RecognitionException {
        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:161:6: ( 'halt' )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:161:8: 'halt'
            {
            match(input,14,FOLLOW_14_in_halt347); 
            opCode = 0x00;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "halt"


    // $ANTLR start "nop"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:162:1: nop : 'nop' ;
    public final void nop() throws RecognitionException {
        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:162:5: ( 'nop' )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:162:7: 'nop'
            {
            match(input,15,FOLLOW_15_in_nop356); 
            opCode = 0x10;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "nop"


    // $ANTLR start "rrmovxx"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:1: rrmovxx : ( 'rrmovl' | 'cmovle' | 'cmovl' | 'cmove' | 'cmovne' | 'cmovge' | 'cmovg' ) src= register ',' dst= register ;
    public final void rrmovxx() throws RecognitionException {
        int src = 0;

        int dst = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:9: ( ( 'rrmovl' | 'cmovle' | 'cmovl' | 'cmove' | 'cmovne' | 'cmovge' | 'cmovg' ) src= register ',' dst= register )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:11: ( 'rrmovl' | 'cmovle' | 'cmovl' | 'cmove' | 'cmovne' | 'cmovge' | 'cmovg' ) src= register ',' dst= register
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:11: ( 'rrmovl' | 'cmovle' | 'cmovl' | 'cmove' | 'cmovne' | 'cmovge' | 'cmovg' )
            int alt8=7;
            switch ( input.LA(1) ) {
            case 16:
                {
                alt8=1;
                }
                break;
            case 17:
                {
                alt8=2;
                }
                break;
            case 18:
                {
                alt8=3;
                }
                break;
            case 19:
                {
                alt8=4;
                }
                break;
            case 20:
                {
                alt8=5;
                }
                break;
            case 21:
                {
                alt8=6;
                }
                break;
            case 22:
                {
                alt8=7;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 8, 0, input);

                throw nvae;
            }

            switch (alt8) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:12: 'rrmovl'
                    {
                    match(input,16,FOLLOW_16_in_rrmovxx366); 
                    opCode=0x20;

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:38: 'cmovle'
                    {
                    match(input,17,FOLLOW_17_in_rrmovxx372); 
                    opCode=0x21;

                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:64: 'cmovl'
                    {
                    match(input,18,FOLLOW_18_in_rrmovxx378); 
                    opCode=0x22;

                    }
                    break;
                case 4 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:89: 'cmove'
                    {
                    match(input,19,FOLLOW_19_in_rrmovxx384); 
                    opCode=0x23;

                    }
                    break;
                case 5 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:163:114: 'cmovne'
                    {
                    match(input,20,FOLLOW_20_in_rrmovxx390); 
                    opCode=0x24;

                    }
                    break;
                case 6 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:164:4: 'cmovge'
                    {
                    match(input,21,FOLLOW_21_in_rrmovxx399); 
                    opCode=0x25;

                    }
                    break;
                case 7 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:164:30: 'cmovg'
                    {
                    match(input,22,FOLLOW_22_in_rrmovxx405); 
                    opCode=0x26;

                    }
                    break;

            }

            pushFollow(FOLLOW_register_in_rrmovxx412);
            src=register();

            state._fsp--;

            match(input,45,FOLLOW_45_in_rrmovxx414); 
            pushFollow(FOLLOW_register_in_rrmovxx418);
            dst=register();

            state._fsp--;

            op[0]=src; op[1]=dst;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "rrmovxx"


    // $ANTLR start "irmovl"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:165:1: irmovl : 'irmovl' immediate ',' register ;
    public final void irmovl() throws RecognitionException {
        int register2 = 0;

        int immediate3 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:165:8: ( 'irmovl' immediate ',' register )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:165:10: 'irmovl' immediate ',' register
            {
            match(input,23,FOLLOW_23_in_irmovl427); 
            pushFollow(FOLLOW_immediate_in_irmovl429);
            immediate3=immediate();

            state._fsp--;

            match(input,45,FOLLOW_45_in_irmovl431); 
            pushFollow(FOLLOW_register_in_irmovl433);
            register2=register();

            state._fsp--;

             opCode = 0x30; op[0]=0xf; op[1]=register2; op[2]=immediate3; 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "irmovl"


    // $ANTLR start "rmmovl"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:166:1: rmmovl : 'rmmovl' register ',' baseOffset ;
    public final void rmmovl() throws RecognitionException {
        AsmY86Parser.baseOffset_return baseOffset4 = null;

        int register5 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:166:9: ( 'rmmovl' register ',' baseOffset )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:166:11: 'rmmovl' register ',' baseOffset
            {
            match(input,24,FOLLOW_24_in_rmmovl443); 
            pushFollow(FOLLOW_register_in_rmmovl445);
            register5=register();

            state._fsp--;

            match(input,45,FOLLOW_45_in_rmmovl447); 
            pushFollow(FOLLOW_baseOffset_in_rmmovl448);
            baseOffset4=baseOffset();

            state._fsp--;

             opCode = 0x40+(baseOffset4!=null?baseOffset4.scale:0); op[0]=register5; op[1]=(baseOffset4!=null?baseOffset4.base:0); op[2]=(baseOffset4!=null?baseOffset4.offset:0); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "rmmovl"


    // $ANTLR start "mrmovl"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:167:1: mrmovl : 'mrmovl' baseOffset ',' register ;
    public final void mrmovl() throws RecognitionException {
        AsmY86Parser.baseOffset_return baseOffset6 = null;

        int register7 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:167:8: ( 'mrmovl' baseOffset ',' register )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:167:10: 'mrmovl' baseOffset ',' register
            {
            match(input,25,FOLLOW_25_in_mrmovl457); 
            pushFollow(FOLLOW_baseOffset_in_mrmovl459);
            baseOffset6=baseOffset();

            state._fsp--;

            match(input,45,FOLLOW_45_in_mrmovl461); 
            pushFollow(FOLLOW_register_in_mrmovl463);
            register7=register();

            state._fsp--;

             opCode = 0x50+(baseOffset6!=null?baseOffset6.scale:0); op[0]=register7; op[1]=(baseOffset6!=null?baseOffset6.base:0); op[2]=(baseOffset6!=null?baseOffset6.offset:0); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "mrmovl"


    // $ANTLR start "opl"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:168:1: opl : ( 'addl' | 'subl' | 'andl' | 'xorl' ) a= register ',' b= register ;
    public final void opl() throws RecognitionException {
        int a = 0;

        int b = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:168:5: ( ( 'addl' | 'subl' | 'andl' | 'xorl' ) a= register ',' b= register )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:168:7: ( 'addl' | 'subl' | 'andl' | 'xorl' ) a= register ',' b= register
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:168:7: ( 'addl' | 'subl' | 'andl' | 'xorl' )
            int alt9=4;
            switch ( input.LA(1) ) {
            case 26:
                {
                alt9=1;
                }
                break;
            case 27:
                {
                alt9=2;
                }
                break;
            case 28:
                {
                alt9=3;
                }
                break;
            case 29:
                {
                alt9=4;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 9, 0, input);

                throw nvae;
            }

            switch (alt9) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:168:8: 'addl'
                    {
                    match(input,26,FOLLOW_26_in_opl473); 
                    opCode=0x60;

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:168:32: 'subl'
                    {
                    match(input,27,FOLLOW_27_in_opl479); 
                    opCode=0x61;

                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:168:56: 'andl'
                    {
                    match(input,28,FOLLOW_28_in_opl485); 
                    opCode=0x62;

                    }
                    break;
                case 4 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:168:80: 'xorl'
                    {
                    match(input,29,FOLLOW_29_in_opl491); 
                    opCode=0x63;

                    }
                    break;

            }

            pushFollow(FOLLOW_register_in_opl501);
            a=register();

            state._fsp--;

            match(input,45,FOLLOW_45_in_opl503); 
            pushFollow(FOLLOW_register_in_opl507);
            b=register();

            state._fsp--;

            op[0]=a; op[1]=b;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "opl"


    // $ANTLR start "iopl"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:170:1: iopl : ( 'iaddl' | 'isubl' | 'iandl' | 'ixorl' ) immediate ',' register ;
    public final void iopl() throws RecognitionException {
        int register8 = 0;

        int immediate9 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:170:6: ( ( 'iaddl' | 'isubl' | 'iandl' | 'ixorl' ) immediate ',' register )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:170:8: ( 'iaddl' | 'isubl' | 'iandl' | 'ixorl' ) immediate ',' register
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:170:8: ( 'iaddl' | 'isubl' | 'iandl' | 'ixorl' )
            int alt10=4;
            switch ( input.LA(1) ) {
            case 30:
                {
                alt10=1;
                }
                break;
            case 31:
                {
                alt10=2;
                }
                break;
            case 32:
                {
                alt10=3;
                }
                break;
            case 33:
                {
                alt10=4;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 10, 0, input);

                throw nvae;
            }

            switch (alt10) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:170:9: 'iaddl'
                    {
                    match(input,30,FOLLOW_30_in_iopl517); 
                    opCode=0xc0;

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:170:34: 'isubl'
                    {
                    match(input,31,FOLLOW_31_in_iopl523); 
                    opCode=0xc1;

                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:170:59: 'iandl'
                    {
                    match(input,32,FOLLOW_32_in_iopl529); 
                    opCode=0xc2;

                    }
                    break;
                case 4 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:170:84: 'ixorl'
                    {
                    match(input,33,FOLLOW_33_in_iopl535); 
                    opCode=0xc3;

                    }
                    break;

            }

            pushFollow(FOLLOW_immediate_in_iopl543);
            immediate9=immediate();

            state._fsp--;

            match(input,45,FOLLOW_45_in_iopl545); 
            pushFollow(FOLLOW_register_in_iopl547);
            register8=register();

            state._fsp--;

            op[0]=0xf; op[1]=register8; op[2]=immediate9;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "iopl"


    // $ANTLR start "jxx"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:172:1: jxx : ( 'jmp' | 'jle' | 'jl' | 'je' | 'jne' | 'jge' | 'jg' ) literal ;
    public final void jxx() throws RecognitionException {
        int literal10 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:172:5: ( ( 'jmp' | 'jle' | 'jl' | 'je' | 'jne' | 'jge' | 'jg' ) literal )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:172:7: ( 'jmp' | 'jle' | 'jl' | 'je' | 'jne' | 'jge' | 'jg' ) literal
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:172:7: ( 'jmp' | 'jle' | 'jl' | 'je' | 'jne' | 'jge' | 'jg' )
            int alt11=7;
            switch ( input.LA(1) ) {
            case 34:
                {
                alt11=1;
                }
                break;
            case 35:
                {
                alt11=2;
                }
                break;
            case 36:
                {
                alt11=3;
                }
                break;
            case 37:
                {
                alt11=4;
                }
                break;
            case 38:
                {
                alt11=5;
                }
                break;
            case 39:
                {
                alt11=6;
                }
                break;
            case 40:
                {
                alt11=7;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 11, 0, input);

                throw nvae;
            }

            switch (alt11) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:172:8: 'jmp'
                    {
                    match(input,34,FOLLOW_34_in_jxx557); 
                    opCode=0x70;

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:172:31: 'jle'
                    {
                    match(input,35,FOLLOW_35_in_jxx563); 
                    opCode=0x71;

                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:172:54: 'jl'
                    {
                    match(input,36,FOLLOW_36_in_jxx569); 
                    opCode=0x72;

                    }
                    break;
                case 4 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:172:76: 'je'
                    {
                    match(input,37,FOLLOW_37_in_jxx575); 
                    opCode=0x73;

                    }
                    break;
                case 5 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:173:4: 'jne'
                    {
                    match(input,38,FOLLOW_38_in_jxx585); 
                    opCode=0x74;

                    }
                    break;
                case 6 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:173:27: 'jge'
                    {
                    match(input,39,FOLLOW_39_in_jxx591); 
                    opCode=0x75;

                    }
                    break;
                case 7 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:173:50: 'jg'
                    {
                    match(input,40,FOLLOW_40_in_jxx597); 
                    opCode=0x76;

                    }
                    break;

            }

            pushFollow(FOLLOW_literal_in_jxx606);
            literal10=literal();

            state._fsp--;

             op[0] = literal10;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "jxx"


    // $ANTLR start "call"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:175:1: call : 'call' ( literal | a= regIndirect | '*' b= regIndirect ) ;
    public final void call() throws RecognitionException {
        int a = 0;

        int b = 0;

        int literal11 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:175:6: ( 'call' ( literal | a= regIndirect | '*' b= regIndirect ) )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:175:8: 'call' ( literal | a= regIndirect | '*' b= regIndirect )
            {
            match(input,41,FOLLOW_41_in_call615); 
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:175:15: ( literal | a= regIndirect | '*' b= regIndirect )
            int alt12=3;
            switch ( input.LA(1) ) {
            case Identifier:
            case Hex:
            case Decimal:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            case 23:
            case 24:
            case 25:
            case 26:
            case 27:
            case 28:
            case 29:
            case 30:
            case 31:
            case 32:
            case 33:
            case 34:
            case 35:
            case 36:
            case 37:
            case 38:
            case 39:
            case 40:
            case 41:
            case 42:
            case 43:
            case 44:
            case 62:
                {
                alt12=1;
                }
                break;
            case 49:
                {
                alt12=2;
                }
                break;
            case 46:
                {
                alt12=3;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 12, 0, input);

                throw nvae;
            }

            switch (alt12) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:175:16: literal
                    {
                    pushFollow(FOLLOW_literal_in_call618);
                    literal11=literal();

                    state._fsp--;

                    opCode=0x80; op[0]=literal11;

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:176:4: a= regIndirect
                    {
                    pushFollow(FOLLOW_regIndirect_in_call630);
                    a=regIndirect();

                    state._fsp--;

                    opCode=0xf0; op[0]=a; op[1]=0xf;

                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:177:4: '*' b= regIndirect
                    {
                    match(input,46,FOLLOW_46_in_call639); 
                    pushFollow(FOLLOW_regIndirect_in_call643);
                    b=regIndirect();

                    state._fsp--;

                    opCode=0xf1; op[0]=b; op[1]=0xf;

                    }
                    break;

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "call"


    // $ANTLR start "ret"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:178:1: ret : 'ret' ;
    public final void ret() throws RecognitionException {
        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:178:5: ( 'ret' )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:178:7: 'ret'
            {
            match(input,47,FOLLOW_47_in_ret653); 
            opCode=0x90;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "ret"


    // $ANTLR start "pushl"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:179:1: pushl : 'pushl' register ;
    public final void pushl() throws RecognitionException {
        int register12 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:179:7: ( 'pushl' register )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:179:9: 'pushl' register
            {
            match(input,42,FOLLOW_42_in_pushl662); 
            pushFollow(FOLLOW_register_in_pushl664);
            register12=register();

            state._fsp--;

            opCode=0xa0; op[0] = register12; op[1]=0xf;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "pushl"


    // $ANTLR start "popl"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:180:1: popl : 'popl' register ;
    public final void popl() throws RecognitionException {
        int register13 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:180:6: ( 'popl' register )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:180:8: 'popl' register
            {
            match(input,43,FOLLOW_43_in_popl673); 
            pushFollow(FOLLOW_register_in_popl675);
            register13=register();

            state._fsp--;

            opCode=0xb0; op[0] = register13; op[1]=0xf;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "popl"


    // $ANTLR start "leave"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:181:1: leave : 'leave' ;
    public final void leave() throws RecognitionException {
        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:181:7: ( 'leave' )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:181:9: 'leave'
            {
            match(input,44,FOLLOW_44_in_leave684); 
            opCode = 0xd0;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "leave"


    // $ANTLR start "jmp"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:182:1: jmp : 'jmp' (a= baseOffset | '*' b= baseOffset ) ;
    public final void jmp() throws RecognitionException {
        AsmY86Parser.baseOffset_return a = null;

        AsmY86Parser.baseOffset_return b = null;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:182:5: ( 'jmp' (a= baseOffset | '*' b= baseOffset ) )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:182:7: 'jmp' (a= baseOffset | '*' b= baseOffset )
            {
            match(input,34,FOLLOW_34_in_jmp693); 
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:182:13: (a= baseOffset | '*' b= baseOffset )
            int alt13=2;
            int LA13_0 = input.LA(1);

            if ( ((LA13_0>=Identifier && LA13_0<=Decimal)||(LA13_0>=14 && LA13_0<=44)||LA13_0==49||LA13_0==62) ) {
                alt13=1;
            }
            else if ( (LA13_0==46) ) {
                alt13=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 13, 0, input);

                throw nvae;
            }
            switch (alt13) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:182:14: a= baseOffset
                    {
                    pushFollow(FOLLOW_baseOffset_in_jmp698);
                    a=baseOffset();

                    state._fsp--;

                    opCode=0xe0; op[0]=0xf; op[1]=(a!=null?a.base:0); op[2]=(a!=null?a.offset:0);

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:183:10: '*' b= baseOffset
                    {
                    match(input,46,FOLLOW_46_in_jmp713); 
                    pushFollow(FOLLOW_baseOffset_in_jmp717);
                    b=baseOffset();

                    state._fsp--;

                    opCode=0xe1; op[0]=0xf; op[1]=(b!=null?b.base:0); op[2]=(b!=null?b.offset:0);

                    }
                    break;

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "jmp"


    // $ANTLR start "immediate"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:185:1: immediate returns [int value] : ( ( '$' )? label | ( '$' )? number );
    public final int immediate() throws RecognitionException {
        int value = 0;

        AsmY86Parser.label_return label14 = null;

        int number15 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:186:2: ( ( '$' )? label | ( '$' )? number )
            int alt16=2;
            switch ( input.LA(1) ) {
            case 48:
                {
                int LA16_1 = input.LA(2);

                if ( (LA16_1==Identifier||(LA16_1>=14 && LA16_1<=44)) ) {
                    alt16=1;
                }
                else if ( ((LA16_1>=Hex && LA16_1<=Decimal)||LA16_1==62) ) {
                    alt16=2;
                }
                else {
                    NoViableAltException nvae =
                        new NoViableAltException("", 16, 1, input);

                    throw nvae;
                }
                }
                break;
            case Identifier:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20:
            case 21:
            case 22:
            case 23:
            case 24:
            case 25:
            case 26:
            case 27:
            case 28:
            case 29:
            case 30:
            case 31:
            case 32:
            case 33:
            case 34:
            case 35:
            case 36:
            case 37:
            case 38:
            case 39:
            case 40:
            case 41:
            case 42:
            case 43:
            case 44:
                {
                alt16=1;
                }
                break;
            case Hex:
            case Decimal:
            case 62:
                {
                alt16=2;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 16, 0, input);

                throw nvae;
            }

            switch (alt16) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:186:4: ( '$' )? label
                    {
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:186:4: ( '$' )?
                    int alt14=2;
                    int LA14_0 = input.LA(1);

                    if ( (LA14_0==48) ) {
                        alt14=1;
                    }
                    switch (alt14) {
                        case 1 :
                            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:186:4: '$'
                            {
                            match(input,48,FOLLOW_48_in_immediate733); 

                            }
                            break;

                    }

                    pushFollow(FOLLOW_label_in_immediate736);
                    label14=label();

                    state._fsp--;

                    value = (label14!=null?label14.value:0);

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:186:42: ( '$' )? number
                    {
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:186:42: ( '$' )?
                    int alt15=2;
                    int LA15_0 = input.LA(1);

                    if ( (LA15_0==48) ) {
                        alt15=1;
                    }
                    switch (alt15) {
                        case 1 :
                            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:186:42: '$'
                            {
                            match(input,48,FOLLOW_48_in_immediate742); 

                            }
                            break;

                    }

                    pushFollow(FOLLOW_number_in_immediate745);
                    number15=number();

                    state._fsp--;

                    value = number15;

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return value;
    }
    // $ANTLR end "immediate"


    // $ANTLR start "literal"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:187:1: literal returns [int value] : ( label | number );
    public final int literal() throws RecognitionException {
        int value = 0;

        AsmY86Parser.label_return label16 = null;

        int number17 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:188:2: ( label | number )
            int alt17=2;
            int LA17_0 = input.LA(1);

            if ( (LA17_0==Identifier||(LA17_0>=14 && LA17_0<=44)) ) {
                alt17=1;
            }
            else if ( ((LA17_0>=Hex && LA17_0<=Decimal)||LA17_0==62) ) {
                alt17=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 17, 0, input);

                throw nvae;
            }
            switch (alt17) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:188:4: label
                    {
                    pushFollow(FOLLOW_label_in_literal759);
                    label16=label();

                    state._fsp--;

                    value = (label16!=null?label16.value:0);

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:188:37: number
                    {
                    pushFollow(FOLLOW_number_in_literal765);
                    number17=number();

                    state._fsp--;

                    value = number17;

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return value;
    }
    // $ANTLR end "literal"

    public static class baseOffset_return extends ParserRuleReturnScope {
        public int offset;
        public int base;
        public int scale;
    };

    // $ANTLR start "baseOffset"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:189:1: baseOffset returns [int offset, int base, int scale] : ( literal )? regIndirectScale ;
    public final AsmY86Parser.baseOffset_return baseOffset() throws RecognitionException {
        AsmY86Parser.baseOffset_return retval = new AsmY86Parser.baseOffset_return();
        retval.start = input.LT(1);

        int literal18 = 0;

        AsmY86Parser.regIndirectScale_return regIndirectScale19 = null;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:190:2: ( ( literal )? regIndirectScale )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:190:4: ( literal )? regIndirectScale
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:190:4: ( literal )?
            int alt18=2;
            int LA18_0 = input.LA(1);

            if ( ((LA18_0>=Identifier && LA18_0<=Decimal)||(LA18_0>=14 && LA18_0<=44)||LA18_0==62) ) {
                alt18=1;
            }
            switch (alt18) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:190:4: literal
                    {
                    pushFollow(FOLLOW_literal_in_baseOffset779);
                    literal18=literal();

                    state._fsp--;


                    }
                    break;

            }

            pushFollow(FOLLOW_regIndirectScale_in_baseOffset782);
            regIndirectScale19=regIndirectScale();

            state._fsp--;

            retval.offset =literal18; retval.base =(regIndirectScale19!=null?regIndirectScale19.value:0); retval.scale =(regIndirectScale19!=null?regIndirectScale19.scale:0);

            }

            retval.stop = input.LT(-1);

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return retval;
    }
    // $ANTLR end "baseOffset"


    // $ANTLR start "regIndirect"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:191:1: regIndirect returns [int value] : '(' register ')' ;
    public final int regIndirect() throws RecognitionException {
        int value = 0;

        int register20 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:192:2: ( '(' register ')' )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:192:4: '(' register ')'
            {
            match(input,49,FOLLOW_49_in_regIndirect796); 
            pushFollow(FOLLOW_register_in_regIndirect798);
            register20=register();

            state._fsp--;

            match(input,50,FOLLOW_50_in_regIndirect800); 
            value =register20;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return value;
    }
    // $ANTLR end "regIndirect"

    public static class regIndirectScale_return extends ParserRuleReturnScope {
        public int value;
        public int scale;
    };

    // $ANTLR start "regIndirectScale"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:193:1: regIndirectScale returns [int value, int scale] : '(' register ( ',' scaleLit )? ')' ;
    public final AsmY86Parser.regIndirectScale_return regIndirectScale() throws RecognitionException {
        AsmY86Parser.regIndirectScale_return retval = new AsmY86Parser.regIndirectScale_return();
        retval.start = input.LT(1);

        int register21 = 0;

        Integer scaleLit22 = null;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:194:9: ( '(' register ( ',' scaleLit )? ')' )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:194:11: '(' register ( ',' scaleLit )? ')'
            {
            match(input,49,FOLLOW_49_in_regIndirectScale821); 
            pushFollow(FOLLOW_register_in_regIndirectScale823);
            register21=register();

            state._fsp--;

            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:194:24: ( ',' scaleLit )?
            int alt19=2;
            int LA19_0 = input.LA(1);

            if ( (LA19_0==45) ) {
                alt19=1;
            }
            switch (alt19) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:194:25: ',' scaleLit
                    {
                    match(input,45,FOLLOW_45_in_regIndirectScale826); 
                    pushFollow(FOLLOW_scaleLit_in_regIndirectScale828);
                    scaleLit22=scaleLit();

                    state._fsp--;


                    }
                    break;

            }

            match(input,50,FOLLOW_50_in_regIndirectScale833); 
            retval.value =register21; retval.scale =scaleLit22!=null? scaleLit22 : 0;

            }

            retval.stop = input.LT(-1);

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return retval;
    }
    // $ANTLR end "regIndirectScale"


    // $ANTLR start "scaleLit"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:195:1: scaleLit returns [Integer value] : ( '1' | '2' | '4' );
    public final Integer scaleLit() throws RecognitionException {
        Integer value = null;

        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:196:9: ( '1' | '2' | '4' )
            int alt20=3;
            switch ( input.LA(1) ) {
            case 51:
                {
                alt20=1;
                }
                break;
            case 52:
                {
                alt20=2;
                }
                break;
            case 53:
                {
                alt20=3;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 20, 0, input);

                throw nvae;
            }

            switch (alt20) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:196:17: '1'
                    {
                    match(input,51,FOLLOW_51_in_scaleLit860); 
                    value=1;

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:196:34: '2'
                    {
                    match(input,52,FOLLOW_52_in_scaleLit866); 
                    value=2;

                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:196:51: '4'
                    {
                    match(input,53,FOLLOW_53_in_scaleLit872); 
                    value=4;

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return value;
    }
    // $ANTLR end "scaleLit"


    // $ANTLR start "register"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:197:1: register returns [int value] : ( '%eax' | '%ecx' | '%edx' | '%ebx' | '%esp' | '%ebp' | '%esi' | '%edi' );
    public final int register() throws RecognitionException {
        int value = 0;

        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:198:2: ( '%eax' | '%ecx' | '%edx' | '%ebx' | '%esp' | '%ebp' | '%esi' | '%edi' )
            int alt21=8;
            switch ( input.LA(1) ) {
            case 54:
                {
                alt21=1;
                }
                break;
            case 55:
                {
                alt21=2;
                }
                break;
            case 56:
                {
                alt21=3;
                }
                break;
            case 57:
                {
                alt21=4;
                }
                break;
            case 58:
                {
                alt21=5;
                }
                break;
            case 59:
                {
                alt21=6;
                }
                break;
            case 60:
                {
                alt21=7;
                }
                break;
            case 61:
                {
                alt21=8;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 21, 0, input);

                throw nvae;
            }

            switch (alt21) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:198:4: '%eax'
                    {
                    match(input,54,FOLLOW_54_in_register886); 
                    value = 0;

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:198:27: '%ecx'
                    {
                    match(input,55,FOLLOW_55_in_register892); 
                    value = 1;

                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:198:50: '%edx'
                    {
                    match(input,56,FOLLOW_56_in_register898); 
                    value = 2;

                    }
                    break;
                case 4 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:198:73: '%ebx'
                    {
                    match(input,57,FOLLOW_57_in_register904); 
                    value = 3;

                    }
                    break;
                case 5 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:198:96: '%esp'
                    {
                    match(input,58,FOLLOW_58_in_register910); 
                    value = 4;

                    }
                    break;
                case 6 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:199:3: '%ebp'
                    {
                    match(input,59,FOLLOW_59_in_register919); 
                    value = 5;

                    }
                    break;
                case 7 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:199:26: '%esi'
                    {
                    match(input,60,FOLLOW_60_in_register925); 
                    value = 6;

                    }
                    break;
                case 8 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:199:49: '%edi'
                    {
                    match(input,61,FOLLOW_61_in_register931); 
                    value = 7;

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return value;
    }
    // $ANTLR end "register"


    // $ANTLR start "number"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:200:1: number returns [int value] : ( '-' )? ( decimal | hex ) ;
    public final int number() throws RecognitionException {
        int value = 0;

        int decimal23 = 0;

        int hex24 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:201:3: ( ( '-' )? ( decimal | hex ) )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:201:5: ( '-' )? ( decimal | hex )
            {
            value = 1;
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:201:19: ( '-' )?
            int alt22=2;
            int LA22_0 = input.LA(1);

            if ( (LA22_0==62) ) {
                alt22=1;
            }
            switch (alt22) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:201:20: '-'
                    {
                    match(input,62,FOLLOW_62_in_number949); 
                    value = -1;

                    }
                    break;

            }

            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:201:41: ( decimal | hex )
            int alt23=2;
            int LA23_0 = input.LA(1);

            if ( (LA23_0==Decimal) ) {
                alt23=1;
            }
            else if ( (LA23_0==Hex) ) {
                alt23=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 23, 0, input);

                throw nvae;
            }
            switch (alt23) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:201:43: decimal
                    {
                    pushFollow(FOLLOW_decimal_in_number957);
                    decimal23=decimal();

                    state._fsp--;

                    value*=decimal23; 

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:201:80: hex
                    {
                    pushFollow(FOLLOW_hex_in_number963);
                    hex24=hex();

                    state._fsp--;

                    value*=hex24;

                    }
                    break;

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return value;
    }
    // $ANTLR end "number"


    // $ANTLR start "hex"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:202:1: hex returns [int value] : Hex ;
    public final int hex() throws RecognitionException {
        int value = 0;

        Token Hex25=null;

        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:203:2: ( Hex )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:203:4: Hex
            {
            Hex25=(Token)match(input,Hex,FOLLOW_Hex_in_hex979); 
            value =(int)(Long.parseLong((Hex25!=null?Hex25.getText():null).substring(2),16));

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return value;
    }
    // $ANTLR end "hex"


    // $ANTLR start "decimal"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:205:1: decimal returns [int value] : Decimal ;
    public final int decimal() throws RecognitionException {
        int value = 0;

        Token Decimal26=null;

        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:206:3: ( Decimal )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:206:5: Decimal
            {
            Decimal26=(Token)match(input,Decimal,FOLLOW_Decimal_in_decimal997); 
            value =(int)(Long.parseLong((Decimal26!=null?Decimal26.getText():null)));

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return value;
    }
    // $ANTLR end "decimal"


    // $ANTLR start "directive"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:208:1: directive : ( pos | data | align );
    public final void directive() throws RecognitionException {
        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:209:2: ( pos | data | align )
            int alt24=3;
            switch ( input.LA(1) ) {
            case 63:
                {
                alt24=1;
                }
                break;
            case 64:
            case 65:
            case 66:
                {
                alt24=2;
                }
                break;
            case 67:
                {
                alt24=3;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 24, 0, input);

                throw nvae;
            }

            switch (alt24) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:209:4: pos
                    {
                    pushFollow(FOLLOW_pos_in_directive1014);
                    pos();

                    state._fsp--;


                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:209:10: data
                    {
                    pushFollow(FOLLOW_data_in_directive1018);
                    data();

                    state._fsp--;


                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:209:17: align
                    {
                    pushFollow(FOLLOW_align_in_directive1022);
                    align();

                    state._fsp--;


                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "directive"


    // $ANTLR start "pos"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:210:1: pos : ( '.pos' number ) ;
    public final void pos() throws RecognitionException {
        int number27 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:210:5: ( ( '.pos' number ) )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:210:7: ( '.pos' number )
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:210:7: ( '.pos' number )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:210:8: '.pos' number
            {
            match(input,63,FOLLOW_63_in_pos1030); 
            pushFollow(FOLLOW_number_in_pos1032);
            number27=number();

            state._fsp--;

            pc = number27;

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "pos"


    // $ANTLR start "data"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:1: data : ( '.long' | '.word' | '.byte' ) literal ( ',' count= number )? ;
    public final void data() throws RecognitionException {
        int count = 0;

        int literal28 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:6: ( ( '.long' | '.word' | '.byte' ) literal ( ',' count= number )? )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:8: ( '.long' | '.word' | '.byte' ) literal ( ',' count= number )?
            {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:8: ( '.long' | '.word' | '.byte' )
            int alt25=3;
            switch ( input.LA(1) ) {
            case 64:
                {
                alt25=1;
                }
                break;
            case 65:
                {
                alt25=2;
                }
                break;
            case 66:
                {
                alt25=3;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 25, 0, input);

                throw nvae;
            }

            switch (alt25) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:9: '.long'
                    {
                    match(input,64,FOLLOW_64_in_data1043); 
                    dataSize=4;

                    }
                    break;
                case 2 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:33: '.word'
                    {
                    match(input,65,FOLLOW_65_in_data1049); 
                    dataSize=2;

                    }
                    break;
                case 3 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:57: '.byte'
                    {
                    match(input,66,FOLLOW_66_in_data1055); 
                    dataSize=1;

                    }
                    break;

            }

            pushFollow(FOLLOW_literal_in_data1060);
            literal28=literal();

            state._fsp--;

            dataValue=literal28;
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:116: ( ',' count= number )?
            int alt26=2;
            int LA26_0 = input.LA(1);

            if ( (LA26_0==45) ) {
                alt26=1;
            }
            switch (alt26) {
                case 1 :
                    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:211:117: ',' count= number
                    {
                    match(input,45,FOLLOW_45_in_data1065); 
                    pushFollow(FOLLOW_number_in_data1069);
                    count=number();

                    state._fsp--;


                    }
                    break;

            }

            lineType = LineType.DATA; dataCount=count>0? count : 1;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "data"


    // $ANTLR start "align"
    // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:213:1: align : '.align' number ;
    public final void align() throws RecognitionException {
        int number29 = 0;


        try {
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:213:7: ( '.align' number )
            // /Users/feeley/Documents/Work/Courses/SimpleMachine/Grammar/Source/AsmY86.g:213:9: '.align' number
            {
            match(input,67,FOLLOW_67_in_align1082); 
            pushFollow(FOLLOW_number_in_align1084);
            number29=number();

            state._fsp--;

            pc = (pc + number29 - 1) / number29 * number29;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "align"

    // Delegated rules


    protected DFA2 dfa2 = new DFA2(this);
    protected DFA7 dfa7 = new DFA7(this);
    static final String DFA2_eotS =
        "\42\uffff";
    static final String DFA2_eofS =
        "\42\uffff";
    static final String DFA2_minS =
        "\1\4\1\uffff\2\4\7\15\1\6\1\15\1\6\4\15\10\6\1\15\1\uffff\1\15\4"+
        "\6\1\4";
    static final String DFA2_maxS =
        "\1\103\1\uffff\2\15\7\75\1\76\1\75\1\76\4\75\10\76\1\75\1\uffff"+
        "\1\75\4\76\1\15";
    static final String DFA2_acceptS =
        "\1\uffff\1\1\31\uffff\1\2\6\uffff";
    static final String DFA2_specialS =
        "\42\uffff}>";
    static final String[] DFA2_transitionS = {
            "\2\33\1\1\7\uffff\1\3\1\2\1\4\1\5\1\6\1\7\1\10\1\11\1\12\1\13"+
            "\1\14\1\15\1\16\1\17\1\20\1\21\1\35\1\36\1\37\1\40\1\22\1\23"+
            "\1\24\1\25\1\26\1\27\1\30\1\31\1\32\1\34\1\41\2\uffff\1\33\17"+
            "\uffff\5\33",
            "",
            "\2\33\7\uffff\1\1",
            "\2\33\7\uffff\1\1",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\3\33\4\uffff\1\1\37\33\3\uffff\1\33\15\uffff\1\33",
            "\1\1\50\uffff\10\33",
            "\3\33\4\uffff\1\1\37\33\4\uffff\1\33\14\uffff\1\33",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\1\1\50\uffff\10\33",
            "\3\33\4\uffff\1\1\37\33\1\uffff\1\33\2\uffff\1\33\14\uffff"+
            "\1\33",
            "\3\33\4\uffff\1\1\37\33\21\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\21\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\21\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\21\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\21\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\21\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\1\uffff\1\33\2\uffff\1\33\14\uffff"+
            "\1\33",
            "\1\1\50\uffff\10\33",
            "",
            "\1\1\50\uffff\10\33",
            "\3\33\4\uffff\1\1\37\33\3\uffff\1\33\15\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\3\uffff\1\33\15\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\3\uffff\1\33\15\uffff\1\33",
            "\3\33\4\uffff\1\1\37\33\3\uffff\1\33\15\uffff\1\33",
            "\2\33\7\uffff\1\1"
    };

    static final short[] DFA2_eot = DFA.unpackEncodedString(DFA2_eotS);
    static final short[] DFA2_eof = DFA.unpackEncodedString(DFA2_eofS);
    static final char[] DFA2_min = DFA.unpackEncodedStringToUnsignedChars(DFA2_minS);
    static final char[] DFA2_max = DFA.unpackEncodedStringToUnsignedChars(DFA2_maxS);
    static final short[] DFA2_accept = DFA.unpackEncodedString(DFA2_acceptS);
    static final short[] DFA2_special = DFA.unpackEncodedString(DFA2_specialS);
    static final short[][] DFA2_transition;

    static {
        int numStates = DFA2_transitionS.length;
        DFA2_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA2_transition[i] = DFA.unpackEncodedString(DFA2_transitionS[i]);
        }
    }

    class DFA2 extends DFA {

        public DFA2(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 2;
            this.eot = DFA2_eot;
            this.eof = DFA2_eof;
            this.min = DFA2_min;
            this.max = DFA2_max;
            this.accept = DFA2_accept;
            this.special = DFA2_special;
            this.transition = DFA2_transition;
        }
        public String getDescription() {
            return "145:8: ( labelDeclaration )?";
        }
    }
    static final String DFA7_eotS =
        "\26\uffff";
    static final String DFA7_eofS =
        "\26\uffff";
    static final String DFA7_minS =
        "\1\16\7\uffff\1\6\7\uffff\2\4\1\7\2\4\1\uffff";
    static final String DFA7_maxS =
        "\1\57\7\uffff\1\76\7\uffff\2\61\1\10\2\61\1\uffff";
    static final String DFA7_acceptS =
        "\1\uffff\1\1\1\2\1\3\1\4\1\5\1\6\1\7\1\uffff\1\10\1\11\1\12\1\13"+
        "\1\14\1\15\1\16\5\uffff\1\17";
    static final String DFA7_specialS =
        "\26\uffff}>";
    static final String[] DFA7_transitionS = {
            "\1\2\1\1\7\3\1\4\1\5\1\6\4\7\4\16\1\10\6\11\1\12\1\14\1\15\1"+
            "\17\2\uffff\1\13",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "\1\20\1\24\1\23\5\uffff\37\21\1\uffff\1\25\2\uffff\1\25\14"+
            "\uffff\1\22",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "\2\11\53\uffff\1\25",
            "\2\11\53\uffff\1\25",
            "\1\24\1\23",
            "\2\11\53\uffff\1\25",
            "\2\11\53\uffff\1\25",
            ""
    };

    static final short[] DFA7_eot = DFA.unpackEncodedString(DFA7_eotS);
    static final short[] DFA7_eof = DFA.unpackEncodedString(DFA7_eofS);
    static final char[] DFA7_min = DFA.unpackEncodedStringToUnsignedChars(DFA7_minS);
    static final char[] DFA7_max = DFA.unpackEncodedStringToUnsignedChars(DFA7_maxS);
    static final short[] DFA7_accept = DFA.unpackEncodedString(DFA7_acceptS);
    static final short[] DFA7_special = DFA.unpackEncodedString(DFA7_specialS);
    static final short[][] DFA7_transition;

    static {
        int numStates = DFA7_transitionS.length;
        DFA7_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA7_transition[i] = DFA.unpackEncodedString(DFA7_transitionS[i]);
        }
    }

    class DFA7 extends DFA {

        public DFA7(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 7;
            this.eot = DFA7_eot;
            this.eof = DFA7_eof;
            this.min = DFA7_min;
            this.max = DFA7_max;
            this.accept = DFA7_accept;
            this.special = DFA7_special;
            this.transition = DFA7_transition;
        }
        public String getDescription() {
            return "155:4: ( nop | halt | rrmovxx | irmovl | rmmovl | mrmovl | opl | jxx | call | ret | pushl | popl | iopl | leave | jmp )";
        }
    }
 

    public static final BitSet FOLLOW_line_in_program46 = new BitSet(new long[]{0x80009FFFFFFFC070L,0x000000000000000FL});
    public static final BitSet FOLLOW_EOF_in_program49 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_labelDeclaration_in_line58 = new BitSet(new long[]{0x80009FFFFFFFC030L,0x000000000000000FL});
    public static final BitSet FOLLOW_instruction_in_line64 = new BitSet(new long[]{0x0000000000000030L});
    public static final BitSet FOLLOW_directive_in_line68 = new BitSet(new long[]{0x0000000000000030L});
    public static final BitSet FOLLOW_NewLine_in_line75 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_Comment_in_line80 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_Identifier_in_labelDeclaration100 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_operand_in_labelDeclaration104 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_13_in_labelDeclaration107 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_Identifier_in_label122 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_operand_in_label126 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_nop_in_instruction140 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_halt_in_instruction144 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_rrmovxx_in_instruction148 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_irmovl_in_instruction152 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_rmmovl_in_instruction156 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_mrmovl_in_instruction160 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_opl_in_instruction164 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_jxx_in_instruction168 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_call_in_instruction172 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_ret_in_instruction176 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_pushl_in_instruction180 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_popl_in_instruction184 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_iopl_in_instruction188 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_leave_in_instruction192 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_jmp_in_instruction196 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_set_in_operand209 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_14_in_halt347 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_15_in_nop356 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_16_in_rrmovxx366 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_17_in_rrmovxx372 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_18_in_rrmovxx378 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_19_in_rrmovxx384 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_20_in_rrmovxx390 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_21_in_rrmovxx399 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_22_in_rrmovxx405 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_rrmovxx412 = new BitSet(new long[]{0x0000200000000000L});
    public static final BitSet FOLLOW_45_in_rrmovxx414 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_rrmovxx418 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_23_in_irmovl427 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_immediate_in_irmovl429 = new BitSet(new long[]{0x0000200000000000L});
    public static final BitSet FOLLOW_45_in_irmovl431 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_irmovl433 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_24_in_rmmovl443 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_rmmovl445 = new BitSet(new long[]{0x0000200000000000L});
    public static final BitSet FOLLOW_45_in_rmmovl447 = new BitSet(new long[]{0x40031FFFFFFFC1C0L});
    public static final BitSet FOLLOW_baseOffset_in_rmmovl448 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_25_in_mrmovl457 = new BitSet(new long[]{0x40031FFFFFFFC1C0L});
    public static final BitSet FOLLOW_baseOffset_in_mrmovl459 = new BitSet(new long[]{0x0000200000000000L});
    public static final BitSet FOLLOW_45_in_mrmovl461 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_mrmovl463 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_26_in_opl473 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_27_in_opl479 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_28_in_opl485 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_29_in_opl491 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_opl501 = new BitSet(new long[]{0x0000200000000000L});
    public static final BitSet FOLLOW_45_in_opl503 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_opl507 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_30_in_iopl517 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_31_in_iopl523 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_32_in_iopl529 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_33_in_iopl535 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_immediate_in_iopl543 = new BitSet(new long[]{0x0000200000000000L});
    public static final BitSet FOLLOW_45_in_iopl545 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_iopl547 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_34_in_jxx557 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_35_in_jxx563 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_36_in_jxx569 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_37_in_jxx575 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_38_in_jxx585 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_39_in_jxx591 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_40_in_jxx597 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_literal_in_jxx606 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_41_in_call615 = new BitSet(new long[]{0x40035FFFFFFFC1C0L});
    public static final BitSet FOLLOW_literal_in_call618 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_regIndirect_in_call630 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_46_in_call639 = new BitSet(new long[]{0x0002000000000000L});
    public static final BitSet FOLLOW_regIndirect_in_call643 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_47_in_ret653 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_42_in_pushl662 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_pushl664 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_43_in_popl673 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_popl675 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_44_in_leave684 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_34_in_jmp693 = new BitSet(new long[]{0x40035FFFFFFFC1C0L});
    public static final BitSet FOLLOW_baseOffset_in_jmp698 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_46_in_jmp713 = new BitSet(new long[]{0x40031FFFFFFFC1C0L});
    public static final BitSet FOLLOW_baseOffset_in_jmp717 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_48_in_immediate733 = new BitSet(new long[]{0x00011FFFFFFFC040L});
    public static final BitSet FOLLOW_label_in_immediate736 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_48_in_immediate742 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_number_in_immediate745 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_label_in_literal759 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_number_in_literal765 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_literal_in_baseOffset779 = new BitSet(new long[]{0x40031FFFFFFFC1C0L});
    public static final BitSet FOLLOW_regIndirectScale_in_baseOffset782 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_49_in_regIndirect796 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_regIndirect798 = new BitSet(new long[]{0x0004000000000000L});
    public static final BitSet FOLLOW_50_in_regIndirect800 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_49_in_regIndirectScale821 = new BitSet(new long[]{0x3FC0000000000000L});
    public static final BitSet FOLLOW_register_in_regIndirectScale823 = new BitSet(new long[]{0x0004200000000000L});
    public static final BitSet FOLLOW_45_in_regIndirectScale826 = new BitSet(new long[]{0x0038000000000000L});
    public static final BitSet FOLLOW_scaleLit_in_regIndirectScale828 = new BitSet(new long[]{0x0004000000000000L});
    public static final BitSet FOLLOW_50_in_regIndirectScale833 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_51_in_scaleLit860 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_52_in_scaleLit866 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_53_in_scaleLit872 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_54_in_register886 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_55_in_register892 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_56_in_register898 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_57_in_register904 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_58_in_register910 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_59_in_register919 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_60_in_register925 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_61_in_register931 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_62_in_number949 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_decimal_in_number957 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_hex_in_number963 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_Hex_in_hex979 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_Decimal_in_decimal997 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_pos_in_directive1014 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_data_in_directive1018 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_align_in_directive1022 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_63_in_pos1030 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_number_in_pos1032 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_64_in_data1043 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_65_in_data1049 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_66_in_data1055 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_literal_in_data1060 = new BitSet(new long[]{0x0000200000000002L});
    public static final BitSet FOLLOW_45_in_data1065 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_number_in_data1069 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_67_in_align1082 = new BitSet(new long[]{0x40011FFFFFFFC1C0L});
    public static final BitSet FOLLOW_number_in_align1084 = new BitSet(new long[]{0x0000000000000002L});

}