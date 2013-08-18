.pos 0x100
    #stub
start:
    ld $stacktop, r5    # initialise stack pointer
    gpc $6, r6
    j dosearch          # call dosearch
    halt

# int search(int i, int n)
# stack layout
# r5+8    n
# r5+4    i
# r5+0    r6 (saved return address)
search:
    deca r5
    st r6, 0(r5)        # save return address
    ld 4(r5), r0        # r0 = i
    mov r0, r1          # r1 = i
    not r0              # r0 = ~i
    inc r0              # r0 = -i
    bgt r0, return_i    # goto return_i if -i > 0 i.e. i < 0
    ld $tree, r2        # r2 = address of tree
    mov r1, r0          # r0 = i
    add r1, r0          # r0 = 2*i
    add r1, r0          # r0 = 3*i
    shl $2, r0          # r0 = 12*i
    add r2, r0          # r0 = address of tree + 12*i i.e. tree[i]
    ld 0(r0), r3        # r3 = tree[i].d
    not r3              # r3 = ~tree[i].d
    inc r3              # r3 = -tree[i].d
    ld 8(r5), r2        # r2 = n
    add r2, r3          # r3 = n - tree[i].d
    beq r3, return_i    # goto return_i if n - tree[i].d == 0 i.e. tree[i].d == n
    bgt r3, search_r    # goto search_r if n - tree[i].d > 0 i.e. n > tree[i].d
    ld 4(r0), r1        # r1 = tree[i].l
    br do_recurse
search_r:
    ld 8(r0), r1        # r1 = tree[i].r
do_recurse:
    deca r5
    st r2, 0(r5)        # push n
    deca r5
    st r1, 0(r5)        # push tree[i].l or tree[i].r (depending on above)
    gpc $6, r6
    j search            # call search
    inca r5
    inca r5             # discard pushed parameters
    br if_done          # goto finish, r0 contains return value already
return_i:
    mov r1, r0          # r0 = i
if_done:
    ld 0(r5), r6
    inca r5             # restore return address
    j 0(r6)             # return with right value in r0

# void dosearch()
# stack layout
# r5+4    r6 (saved return address)
# r5+0    r4 (saved callee-save register)

dosearch:
    deca r5
    st r6, 0(r5)        # save return address
    deca r5
    st r4, 0(r5)        # save r4
    ld $0, r4           # r4 will be used to hold constant 0.
    ld $215, r0
    deca r5
    st r0, 0(r5)        # push 215
    deca r5
    st r4, 0(r5)        # push 0
    gpc $6, r6
    j search            # call search
    ld $s1, r1          # r1 = address of s1
    st r0, 0(r1)        # s1 = return value
    # note we can reuse the 2 parameter slots 0(r5) and 4(r5) for the next few calls
    ld $450, r0
    st r0, 4(r5)        # write parameter 450
    st r4, 0(r5)        # write parameter 0
    gpc $6, r6
    j search            # call search
    ld $s2, r1          # r1 = address of s2
    st r0, 0(r1)        # s2 = return value
    ld $9, r0
    st r0, 4(r5)        # write parameter 9
    st r4, 0(r5)        # write parameter 0
    gpc $6, r6
    j search            # call search
    ld $s3, r1          # r1 = address of s3
    st r0, 0(r1)        # s3 = return value
    ld $115, r0
    st r0, 4(r5)        # write parameter 115
    st r4, 0(r5)        # write parameter 0
    gpc $6, r6
    j search            # call search
    ld $s4, r1          # r1 = address of s4
    st r0, 0(r1)        # s4 = return value
    inca r5
    inca r5             # discard pushed parameters
    ld 0(r5), r4
    inca r5             # restore r4
    ld 0(r5), r6
    inca r5             # restore return address
    j 0(r6)             # return

.pos 0x400
# Data area
s1: .long 0             # s1
s2: .long 0             # s2
s3: .long 0             # s3
s4: .long 0             # s4
tree:
    .long 412           # tree[0].d
    .long 1             # tree[0].l
    .long 6             # tree[0].r
    .long 106           # tree[1].d
    .long 2             # tree[1].l
    .long 5             # tree[1].r
    .long 7             # tree[2].d
    .long 3             # tree[2].l
    .long 4             # tree[2].r
    .long 1             # tree[3].d
    .long 0xffffffff    # tree[3].l
    .long 0xffffffff    # tree[3].r
    .long 9             # tree[4].d
    .long 0xffffffff    # tree[4].l
    .long 0xffffffff    # tree[4].r
    .long 215           # tree[5].d
    .long 0xffffffff    # tree[5].l
    .long 0xffffffff    # tree[5].r
    .long 900           # tree[6].d
    .long 7             # tree[6].l
    .long 10            # tree[6].r
    .long 450           # tree[7].d
    .long 8             # tree[7].l
    .long 9             # tree[7].r
    .long 420           # tree[8].d
    .long 0xffffffff    # tree[8].l
    .long 0xffffffff    # tree[8].r
    .long 512           # tree[9].d
    .long 0xffffffff    # tree[9].l
    .long 0xffffffff    # tree[9].r
    .long 1024          # tree[10].d
    .long 0xffffffff    # tree[10].l
    .long 0xffffffff    # tree[10].r

.pos 0x7FC0
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
