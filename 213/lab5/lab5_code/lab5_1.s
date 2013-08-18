# int a[] = { 7, 5, 3, 1, 4, 8, 6, 8 };
# int n = 8;
# int p;


.pos 0x100
    # stub
start:
ld $stacktop, r5    # initialise stack pointer
gpc $6, r6          # set return address
j main              # exe main
halt

main:
        deca r5
        st r6, 0(r5)        # prev ret. addr on stack
        gpc $6, r6          # set new return address
        j shuffle           # exe shuffle
        gpc $6, r6          # set return address
        j pick              # exe pick
        ld $p, r1
        st r0, 0(r1)        # p = pick();
        ld 0(r5), r6
        inca r5
        j 0x0(r6)           # return to start

shuffle:
        deca r5
        st r4, 0(r5)
        deca r5
        st r6, 0(r5)
        deca r5
        st r7, 0(r5)
        ld $0, r0               # r0 = i = 0

loop:   #loopcheck

        ld $n, r1
        ld 0(r1), r1            # r1 = n
        mov r1, r2              # r2 = n
        shr $1, r2              # r2 = n/2
        mov r0, r3
        not r3
        inc r3                  # r3 = -i
        add r2, r4              # r3 = n/2 - i
        bgt r4, endloop

        #loop body
        ld $a, r2
        mov r2, r7              # r7 = $a
        ld (r2, r0, 4), r2      # r2 = t = a[i]
        ld $n, r4
        ld 0(r4), r4
        add r3, r4              #r4 = n - i
        dec r4                  #r4 = n - i - 1
        ld (r7, r4, 4), r6      #r6 = a[n - i - 1]
        st r6, (r7, r0, 4)      #a[i] = a[n - i - 1]
        st r2, (r7, r4, 4)      #a[n - i - 1] = t;
        inc r0
        br loop

endloop:
    ld 0(r5), r7            #restore vals
        inca r5
        ld 0(r5), r6
        inca r5
        ld 0(r5), r4
        inca r5
        j 0x0(r6)         # return to main

pick: 
        deca r5
        st r4, 0(r5)
        deca r5
        st r6, 0(r5)
        deca r5
        st r7, 0(r5)

        ld $a, r0       
        ld $n, r1
        ld 0(r1), r1        
        shr $1, r1              # r1 = n/2
        mov r1, r2
        shr $1, r2              # r2 = n/4
        ld (r0, r1, 4), r1      # r1 = a[n/2]
        ld (r0, r2, 4), r2      # r2 = a[n/4]
        add r1, r2              # r2 = a[n/2] + a[n/4]
        shr $1, r2
        mov r2, r0              # return (a[n/2] + a[n/4]) / 2

        ld 0(r5), r7            #restore vals
        inca r5
        ld 0(r5), r6
        inca r5
        ld 0(r5), r4
        inca r5
        j 0x0(r6)



.pos 0x200
#data area

# int a[] = { 7, 5, 3, 1, 4, 8, 6, 8 };

n:  .long 8             # n
p:  .long 0
a:  .long 7
    .long 5
    .long 3
    .long 1
    .long 4
    .long 8
    .long 6
    .long 8


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

