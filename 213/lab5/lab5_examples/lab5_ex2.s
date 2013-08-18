.pos 0x100
    #stub
start:
    ld $stacktop, r5    # initialise stack pointer
    ld $a, r0           # r0 = address of a
    ld 0(r0), r0        # r0 = a
    deca r5
    st r0, 0(r5)        # push a
    gpc $6, r6
    j traverse
    inca r5
    halt

# int nodefunc(struct ll_node *n)
# stack layout is
# r5+0    n
nodefunc:
    # let r0 hold t
    ld 0(r5), r1        # r1 = n
    ld 4(r1), r2        # r2 = n->data
    mov r2, r0          # t = n->data
    inca r2             # r2 = n->data + 4
    dec r2              # r2 = n->data + 3
    st r2, 4(r1)        # n->data = n->data + 3 i.e. n->data += 3
    j 0(r6)             # return t in r0

# void traverse(struct ll_node *n)
# stack layout is
# r5+8    n
# r5+4    saved r6 (return address)
# r5+0    t
traverse:
    deca r5
    st r6, 0(r5)        # save return address
    deca r5             # allocate t
    ld $0, r0           # r0 = 0
    st r0, 0(r5)        # t = 0
while_check:
    ld 8(r5), r0        # r0 = n
    beq r0, while_end   # goto while_end if n == 0
    deca r5
    st r0, 0(r5)        # push n
    gpc $6, r6
    j nodefunc          # call nodefunc
    inca r5             # discard pushed parameter
    ld 0(r5), r1        # r1 = t
    add r1, r0          # r0 = t + nodefunc(n)
    st r0, 0(r5)        # t = t + nodefunc(n) i.e. t += nodefunc(n)
    ld 8(r5), r0        # r0 = n
    ld 0(r0), r0        # r0 = n->next
    st r0, 8(r5)        # n = n->next
    br while_check      # repeat
while_end:
    ld $s, r0           # r0 = address of s
    ld 0(r5), r1        # r1 = t
    st r1, 0(r0)        # s = t
    inca r5             # deallocate t
    ld 0(r5), r6
    inca r5             # restore return address
    j 0(r6)             # return

.pos 0x400
# Static data area
s:  .long 0             # s
a:  .long 0x1000        # a (points to anonymous structure)

.pos 0x1000
# Area holding the linked list elements
# Note that they are not in sequential order, but are in order by following the pointers
    .long 0x1010        # next
    .long 3             # data

.pos 0x1010
    .long 0x1040        # next
    .long 5             # data

.pos 0x1020
    .long 0             # next (null pointer to indicate end)
    .long 16            # data

.pos 0x1040
    .long 0x1020        # next
    .long 1             # data

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
