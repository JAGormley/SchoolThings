#ituple->size = 5;

ld $5, r0                   #r0 = 5
ld $ituple, r1              #r1 = addr of ituple ptr
ld 0(r1), r1                #r1 = val of ituple (the struct)
st r0, 0(r1)                #ituple->size = 5

#ituple->arr[3] = ituple->arr[4];

ld $ituple, r0              #r0 = addr of ituple ptr
ld 0(r0), r0                #r0 = addr of ituple struct
ld 4(r0), r1                #r1 = addr of ituple->arr
ld 0(r1), r1                #r1 = val of ituple->arr
ld 16(r1), r2               #r2 = ituple->arr[4]
st r2, 12(r1)               #ituple->arr[3] = ituple->arr[4]

#ituple->arr[ituple->size - 3] = ituple->arr[ituple->size - 1];

ld $ituple, r0              #r0 = addr of ituple ptr
ld 0(r0), r0                #r0 = addr of ituple struct
ld 0(r0), r1                #r1 = ituple->size
mov r1, r3                  #r3 = ituple->size
dec r1                      #r1 = ituple->size - 1
ld 4(r0), r2                #r2 = ituple->arr
ld (r2, r1, 4), r1          #r2 = ituple->arr[ituple->size - 1]
dec r3
dec r3
dec r3
st r2 (r1, r3, 4)           #ituple->arr[ituple->size - 3] = ituple->arr[ituple->size - 1]

halt

.pos 0x200
# Data area

ituple:  .long 1000             # ituple

.pos 0x1000
# The pointer tuple is holding the address of this unnamed struct
size     .long 0
arr      .long 2000

.pos 0x2000
# The pointer arr is holding the address of the array
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0