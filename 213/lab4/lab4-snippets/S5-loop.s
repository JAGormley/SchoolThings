.address 0x100
			#initialization
                 ld   $0x0, r0            # r0 = 0 (temp for i)
                 ld   $a, r1              # r1 = address of a[0]
                 ld   $0x0, r2            # r2 = 0 (temp for s)
                 ld   $0xfffffff7, r4     # r4 = -9

			# set loop condition
loop:            mov  r0, r5              # r5 = i
                 add  r4, r5              # r5 = i-9
                 bgt  r5, end_loop        # if i>9 goto end_loop

			# loop body
                 ld   (r1, r0, 4), r3     # r3 = a[i]
                 add  r3, r2              # r2 += a[i]
                 inc  r0                  # i++
                 br   loop                # goto loop

			# after the loop
end_loop:        ld   $s, r1              # r1 = address of s
                 st   r2, 0x0(r1)         # s = temp s
			ld   $i, r1              # r1 = address of i 
			st   r0, 0x0(r1)         # i = temp i 
                 halt 

                    
.address 0x1000
s:               .long 0x00000000         # s
i:               .long 0x00000000         # i
a:               .long 0x00000002         # a[0]
                 .long 0x00000004         # a[1]
                 .long 0x00000006         # a[2]
                 .long 0x00000008         # a[3]
                 .long 0x0000000a         # a[4]
                 .long 0x0000000c         # a[5]
                 .long 0x0000000e         # a[6]
                 .long 0x00000010         # a[7]
                 .long 0x00000012         # a[8]
                 .long 0x00000014         # a[9]
