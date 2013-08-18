.pos 0x100

    # assume r0:a, r1:b, r2:c, r3:i
    ld $a, r0
    ld 0(r0), r0		
    ld $0, r1			
    ld $c, r2
    ld 0(r2), r2		
    ld $8, r3			
    ld $1, r4			
L1:
    beq r3, L4
    shl $1, r1			
    mov r0, r5			
    shr $3, r5			
    and r4, r5         
    add r5, r1			
    shl $1, r0
    mov r1, r5			
    not r5
    inc r5				
    add r2, r5			
    bgt r5, L2			
    br L3
L2:    
    inc r0				
    not r5				
    inc r5				
    mov r5, r1			
L3:    
    dec r3				
    br L1
L4:
    ld $a, r2
    st r0, 0(r2)
    ld $b, r2
    st r1, 0(r2)
    ld $i, r2
    st r3, 0(r2)


    ld $g, r2
    st r0, 0(r2)
    ld $r, r2
    st r1, 0(r2)

    halt

.pos 0x200
# Data area
a:  .long 40000       
b:  .long 0           
c:  .long 3500 
i:  .long 0             
g:  .long 0              
r:  .long 0              
