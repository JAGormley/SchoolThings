
#parray[6].x = parray[3].y;

ld $parray, r0                  #r0 = addr of parray(pointer)
ld 0(r0), r0                    #r0 = addr of parray struct
ld 28(r0), r1                   #r1 = val of parray[3].y
st r1, 48(r0)                   #parray[6].x = parray[3].y

#parray[i].x = parray[i].y;

ld $parray, r0                  #r0 = addr of parray(pointer)
ld 0(r0), r0                    #r0 = addr of parray struct
ld $i, r1                       #r1 = addr of i
ld 0(r1), r1                    #r1 = val of i
shl $1, r1                      #r1 = i*2
mov r1, r2                      #r2 = i*2
inc r2                          #r2 = i*2 + 1
ld (r0, r2, 4), r3              #r3 = parray[i].y
st r3, (r0, r1, 4)              #parray[i].x = parray[i].y


#parray[i].x = parray[i-1].y + parray[i+1].y;

ld $parray, r0                  #r0 = addr of parray(pointer)
ld 0(r0), r0                    #r0 = addr of parray struct
ld $i, r1                       #r1 = addr of i
ld 0(r1), r1                    #r1 = val of i
mov r1, r2                      #r2 = val of i
mov r1, r3                      #r3 = val of i
shl $1, r3                      #r2 = i*2
inc r3                          #r3 = i+1
shl $1, r3                      #r3 = 2(i+1)
inc r3                          #r3 = 2(i+1)+1
ld (r0, r3, 4), r4              #r4 = parray[i+1].y
mov r1, r3                      #r3 = val of i
dec r3                          #r3 = i-1
shl $1, r3                      #r3 = 2(i-1)
ld (r0, r3, 4), r3              #r3 = parray[i-1].y
add r4, r3                      #r3 = parray[i-1].y + parray[i+1].y
st r3, (r0, r2, 4)              #parray[i].x = parray[i-1].y + parray[i+1].y

halt

.pos 0x200
# Data area

parray:  .long 1000             # parray[0]
i:  .long 0                     # i

.pos 0x1000
# The pointer parray is holding the address of this unnamed struct
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