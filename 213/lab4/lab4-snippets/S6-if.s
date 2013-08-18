.address 0x100
                 ld   $a, r0              # r0 = address of a
                 ld   0x0(r0), r0         # r0 = a
                 ld   $b, r1              # r1 = address of b
                 ld   0x0(r1), r1         # r1 = b
                 mov  r1, r2              # r2 = b
                 not  r2                  # r2 = ~b
                 inc  r2                  # r2 = -b
                 add  r0, r2              # r2 = a-b
                 bgt  r2, then            # if (a>b) goto then
else:            mov  r1, r3              # r3 = b
                 br   end_if              # goto end_if
then:            mov  r0, r3              # r3 = a
end_if:          ld   $max, r0            # r0 = address of max
                 st   r3, 0x0(r0)         # max = r3
                 halt                     
.address 0x1000
a:               .long 0x00000001         # a
.address 0x2000
b:               .long 0x00000002         # b
.address 0x3000
max:             .long 0x00000000         # max
