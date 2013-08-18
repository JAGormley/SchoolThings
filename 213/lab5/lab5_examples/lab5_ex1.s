.pos 0x100
    # stub
start:
    ld $stacktop, r5    # initialise stack pointer
    ld $n, r0           # r0 = address of n
    ld 0(r0), r0        # r0 = n
    dec r0              # r0 = n - 1
    deca r5
    st r0, 0(r5)        # push n - 1
    ld $0, r0           # r0 = 0
    deca r5
    st r0, 0(r5)        # push 0
    ld $a, r0           # r0 = address of a
    ld 0(r0), r0        # r0 = a (which is itself an address)
    deca r5
    st r0, 0(r5)        # push a
    gpc $6, r6
    j sort              # call sort
    inca r5
    inca r5
    inca r5             # discard pushed parameters
    halt

# int part(int arr[], int l, int r)
# stack layout is
# r5+20 r
# r5+16 l
# r5+12 arr
# r5+8  saved r4
# r5+4  saved r6
# r5+0  saved r7
part:
    deca r5
    st r4, 0(r5)        # save r4
    deca r5
    st r6, 0(r5)        # save r6
    deca r5
    st r7, 0(r5)        # save r7
    ld 12(r5), r0       # r0 = arr
    ld 16(r5), r1       # r1 = l
    ld 20(r5), r2       # r2 = r
    # t is kept in r3
    ld (r0,r2,4), r3    # t = arr[r]
    ld (r0,r1,4), r4    # r4 = arr[l]
    st r4, (r0,r2,4)    # arr[r] = arr[l]
    st r3, (r0,r1,4)    # arr[l] = t
    # i is kept in r4, -p in r6 (see below for why -p instead of p)
    mov r1, r4          # i = l
    ld (r0,r2,4), r6    # p = arr[r]
    not r6              # r6 = ~p
    inc r6              # r6 = -p
    br part_whilecheck
    # body of while loop
part_whilebody:
    ld (r0,r4,4), r7    # r7 = arr[i]
    add r6, r7          # r7 = arr[i] - p
    bgt r7, part_iffalse # goto part_iffalse if arr[i] - p > 0 i.e. arr[i] > p
    ld (r0,r4,4), r3    # t = arr[i]
    ld (r0,r1,4), r7    # r7 = arr[l]
    st r7, (r0,r4,4)    # arr[i] = arr[l]
    st r3, (r0,r1,4)    # arr[l] = t
    inc r1
part_iffalse:
    inc r4
    # check of while loop
part_whilecheck:
    mov r4, r7          # r7 = i
    not r7
    inc r7              # r7 = -i
    add r2, r7          # r7 = r - i
    bgt r7, part_whilebody # goto part_whilebody if r - i > 0 i.e. i < r
    # code after while loop
    ld (r0,r1,4), r3    # t = arr[l]
    ld (r0,r2,4), r4    # r4 = arr[r]
    st r4, (r0,r1,4)    # arr[l] = arr[r]
    st r3, (r0,r2,4)    # arr[r] = t
    mov r1, r0          # return value of l in r0
    ld 0(r5), r7        # restore r7 from stack
    inca r5
    ld 0(r5), r6        # restore r6 from stack
    inca r5
    ld 0(r5), r4        # restore r4 from stack
    inca r5
    j 0(r6)             # return to caller

# void sort(int arr[], int a, int b)
# stack layout is
# r5+16   b
# r5+12   a
# r5+8    arr
# r5+4    saved r6 (return address)
# r5+0    m
sort:
    deca r5
    st r6, 0(r5)        # save r6
    deca r5             # allocate m
    ld 12(r5), r0       # r0 = a
    not r0              # r0 = ~a
    inc r0              # r0 = -a
    ld 16(r5), r1       # r1 = b
    add r1, r0          # r0 = b - a
    bgt r0, sort_iftrue # goto sort_iftrue if b - a > 0 i.e. b > a
    br sort_iffalse
sort_iftrue:
    deca r5
    st r1, 0(r5)        # push b
    ld 16(r5), r0       # r0 = a (note offset changed because b was pushed)
    deca r5
    st r0, 0(r5)        # push a
    ld 16(r5), r0       # r0 = arr (note offset changed because b and a were pushef)
    deca r5
    st r0, 0(r5)        # push arr
    gpc $6, r6
    j part              # call part
    inca r5             # discard pushed parameters
    inca r5
    inca r5
    st r0, 0(r5)        # save return value m = part(arr, a, b)
    dec r0
    deca r5
    st r0, 0(r5)        # push m - 1
    ld 16(r5), r0       # r0 = a (note offset changed because m - 1 was pushed)
    deca r5
    st r0, 0(r5)        # push a
    ld 16(r5), r0       # r0 = arr (note offset changed because m - 1, arr were pushed)
    deca r5
    st r0, 0(r5)        # push arr
    gpc $6, r6
    j sort              # call sort
    # note that we can reuse the space allocated to parameters to avoid moving r5
    ld 28(r5), r0
    st r0, 8(r5)        # place parameter b
    ld 12(r5), r0       # get m
    inc r0              # m + 1
    st r0, 4(r5)        # place parameter m + 1
    ld 20(r5), r0       # get arr
    st r0, 0(r5)        # place parameter m
    gpc $6, r6
    j sort              # call sort
    inca r5
    inca r5
    inca r5             # discard pushed parameters
sort_iffalse:
    inca r5             # discard m
    ld 0(r5), r6        # restore return address
    inca r5
    j 0(r6)             # return

.pos 0x400
# Static data area
a:  .long 0x1000        # a (points to anonymous dynamic array)
n:  .long 9             # n

.pos 0x1000
# Area holding anonymous dynamic array
    .long 8
    .long 6
    .long 0
    .long 7
    .long 4
    .long 5
    .long 2
    .long 9
    .long 1

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
