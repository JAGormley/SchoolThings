.address 0x100
    # stub
start:
    ld $stacktop, r5
    gpc $6, r6
    j get
    halt

fun:
    deca r5
    st r6, 0(r5)
    deca r5
    st r4, 0(r5)
    ld 8(r5), r0    
    mov r0, r1      
    not r1
    inc r1          
    ld $2, r2
    add r2, r1
    bgt r1, ret             #if !(p >= 2)
    dec r0
    deca r5
    st r0, 0(r5)
    gpc $6, r6
    j fun                   #fun (p-1)
    mov r0, r4
    ld 12(r5), r0
    dec r0
    dec r0
    st r0, 0(r5)
    gpc $6, r6
    j fun                   #fun (p-2)
    inca r5
    shl $1, r4
    mov r0, r1
    shl $1, r0
    add r1, r0
    add r4, r0
ret:
    ld 0(r5), r4
    inca r5
    ld 0(r5), r6
    inca r5
    j 0(r6)

get:
    deca r5
    st r6, 0(r5)
    ld $k, r0
    ld 0(r0), r0
    shr $1, r0
    deca r5
    st r0, 0(r5)
    gpc $6, r6
    j fun
    inca r5
    ld $res, r1
    st r0, 0(r1)
    ld 0(r5), r6
    inca r5
    j 0(r6)

.address 0x200
# Static data area
res:    .long 0
k:  	.long 10

.address 0x7FC0
# These are here so you can see (some of) the stack contents.
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
# Stack top (one word past end of stack)
stacktop:
    .long 0
