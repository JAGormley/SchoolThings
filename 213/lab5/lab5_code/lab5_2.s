.pos 0x100
    #stub
start:

ld $stacktop, r5    # initialise stack pointer
gpc $6, r6          # set return address
j dosearch          # exe dosearch
halt


dosearch:

deca r5
st r6, 0(r5)            #store return addr from start

ld $215, r0             #r0 = 215
ld $tree, r1            #r1 &tree
deca r5
st r0, 0(r5)            # params onto stack before call
deca r5                 #
st r1, 0(r5)            #
gpc $6, r6              # r6 = ret addr for after call
j search                # call search
ld $s1, r1              # r1 = &s1
st r0, 0(r1)            # s1 = search(tree, 215)
inca r5                 # pop params off stack
inca r5                 #

ld $450, r0
ld $tree, r1            #r1 &tree
deca r5
st r0, 0(r5)            # params onto stack before call
deca r5                 #
st r1, 0(r5)            #
gpc $6, r6              # r6 = ret addr for after call
j search                # call search
ld $s2, r1              # r1 = &s2
st r0, 0(r1)            # s2 = search(tree, 215)
inca r5                 # pop params off stack
inca r5                 #

ld $9, r0
ld $tree, r1            #r1 &tree
deca r5
st r0, 0(r5)            # params onto stack before call
deca r5                 #
st r1, 0(r5)            #
gpc $6, r6              # r6 = ret addr for after call
j search                # call search
ld $s3, r1              # r1 = &s3
st r0, 0(r1)            # s3 = search(tree, 215)
inca r5                 # pop params off stack
inca r5                 #

ld $115, r0
ld $tree, r1            #r1 &tree
deca r5
st r0, 0(r5)            # params onto stack before call
deca r5                 #
st r1, 0(r5)            #
gpc $6, r6              # r6 = ret addr for after call
j search                # call search
ld $s4, r1              # r1 = &s4
st r0, 0(r1)            # s4 = search(tree, 215)
inca r5                 # pop params off stack
inca r5                 #

ld 0(r5), r6
inca r5
j 0x0(r6)               #return to start


search:

ld 0(r5), r0                # r0 = param1(tree root)
ld 4(r5), r2                # r2 = param2(item); stays constant
mov r2, r3
not r3
inc r3                      # r3 = -item

recurse:

beq r0, end                 # end if tree == NULL (r0 has 0 [no tree] in it)
ld 0(r0), r1                # r1 = node data
add r3, r1                  # r1 = tree->data - item
beq r1, end                 # return if tree root == item (r0 has tree in it)
bgt r1, prep_recurse_left         # recurse if tree->data - item > 0
br prep_recurse_right

prep_recurse_left:
ld 4(r0), r0                # r0 = &left tree
br recurse

prep_recurse_right:
ld 8(r0), r0                # r0 = &right tree
br recurse

end:
j 0x0(r6)                   # jump to dosearch (r0 has return value)

	
.pos 0x400
# Data area
s1: .long 0             # s1
s2: .long 0             # s2
s3: .long 0             # s3
s4: .long 0             # s4

.pos 0x1000
tree:
.long 412           # bst_node->data
.long 0x1100	    # bst_node->left
.long 0x1200	    # bst_node->right

.pos 0x1100
.long 106          # data
.long 0x1300	   # left
.long 0x1400	   # right

.pos 0x1200
.long 900	       # data
.long 0x1500	   # left
.long 0x1600	   # right

.pos 0x1300
.long 7            # data
.long 0x1700	   # left
.long 0x1800	   # right

.pos 0x1400
.long 215	       # data
.long 0x1500	   # left
.long 0x1600	   # right

.pos 0x1500
.long 450          # data
.long 0            # left
.long 0x1900	   # right

.pos 0x1600
.long 1024	       # data
.long 0            # left
.long 0            # right

.pos 0x1700
.long 1             # data
.long 0             # left
.long 0             # right

.pos 0x1800
.long 9             # data
.long 0             # left
.long 0             # right

.pos 0x1900
.long 512           # data
.long 0             # left
.long 0             # right


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
