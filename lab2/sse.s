.data

array:
	.float 28, 28, 224, 47, 47, 90, 78, 1, 88, 88, 124, 254, 17, 58, 17, 17, 38, 1, 0, 1, 1, 77, 254, 254, 254, 254, 48, 0
array_size:
	.quad 108
 
.global _start

.section .text

_start:
	mov		$1, %rax      		# write
	mov		$1, %rdi      		# file descriptor (stdout)
	mov		$array, %rsi  		# array pointer
	mov		(array_size), %rdx	# array size   
	syscall

    movq    $array, %r8         # array pointer
    movq    $7, %rax            # iterator

    movups  (%r8), %xmm0        # move n to n+4 elms to xmm0
    
loop:
    movups  4(%r8), %xmm1       # move n+1 to n+5 elms to xmm1 
    movups  %xmm1, %xmm2        # copy mm1 to mm2
    cmpps   $0x4, %xmm0, %xmm2  # compare xmm0 and xmm2, 1 if not equal else 0
    andps   %xmm2, %xmm0        # zero dublicates in xmm0
    andps   %xmm2, %xmm1        # zero dublicates in xmm1
    andps   (%r8), %xmm0        
    movups  %xmm0, (%r8)        # populate xmm0 result to array[n:n+4]
    movups  16(%r8), %xmm0      # save next 4 elms to mm0, not to be overwrited by xmm1
    movups  4(%r8), %xmm3       # move current zeroed elms to xmm3
    andps   %xmm3, %xmm1        # compare current zeroed elems and xmm1
    movups  %xmm1, 4(%r8)       # populate xmm1 result to array[n+1:n+5]
    addq    $16, %r8            # move pointer to next 4 elements
    decq    %rax                # decrement iterator
    jnz     loop                # continue if iterator not zero

exit:
	mov		$1, %rax      		# write
	mov		$1, %rdi      		# file descriptor (stdout)
	mov		$array, %rsi  		# array pointer
	mov		(array_size), %rdx	# array size   
	syscall
	
	mov     $60, %rax			# exit
	xor     %rdi, %rdi			# zero rdi
	syscall
    