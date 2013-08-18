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
    beq r3, L4                  # i > 0 ?, if yes exit while loop
    shl $1, r1                  # b *= 2
    mov r0, r5                  # r5 = a
    shr $3, r5                  # r5 = a/8
    and r4, r5                  # r5 = r4 & r5 (a/8 & 1)
    add r5, r1                  # b += (a/8 & 1)
    shl $1, r0                  # a *= 2
    mov r1, r5                  # r5 = b (which is now (b*2)+(a/8 & 1))
    not r5                      # 
    inc r5                      # r5 = -((b*2)+(a/8 & 1))
    add r2, r5                  # r5 = c - b
    bgt r5, L2                  # if ^ is > 0, L2
    br L3                       
L2:
    inc r0                      # a += 1
    not r5
    inc r5                      # -(b + -(b + &thing))
    mov r5, r1                  # b is now ^
L3:
    dec r3                      # i--
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
