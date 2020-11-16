.data
array:
	.byte 28, 28, 224, 47, 90, 90, 78, 1, 88, 12, 124, 254, 17, 58, 17, 17, 38, 1, 0, 1, 1, 77, 254, 254, 48, 48, 48
array_end:

array_size:
	.quad 27
 
.global _start

.section .text  

_start:
	mov	$1, %rax      		# write
	mov	$1, %rdi      		# file descriptor (stdout)
	mov	$array, %rsi  		# array pointer
	mov	(array_size), %rdx	# array size
	syscall	

	mov     $0, %r10	  	# bool flag
	movq	$array+1, %r9 		# starting from 2nd arrays element

loop_start:    	
	movb    (%r9), %al	  	# currnet element to al
	movb    -1(%r9), %bl  		# priv element to bl
	cmpb	%al, %bl		# check if current and priv are equal
	jne		check_flag    	# skip zeroing if elements not match

zero_priv:	
	movb 	$0, -1(%r9)   		# zero priv element if it has dublicate
	mov 	$1, %r10	  	# flag indicating that current element has dublicate
	jmp	next_iteration	

check_flag:	
	cmp 	$1, %r10	  	# check flag if priv element already had dublicate
	jne	next_iteration	  	# skip if not
	movb    $0, -1(%r9)   		# zero priv element
	mov  	$0, %r10	  	# uncheck flag

next_iteration:	
	addq  	$1, %r9			# increment currnet element
	cmpq  	$array_end, %r9 	# check current element adress and array_end address
	jne    	loop_start      	# got to the start of the loop

exit:
	mov	$1, %rax      		# write
	mov	$1, %rdi      		# file descriptor (stdout)
	mov	$array, %rsi  		# array pointer
	mov	(array_size), %rdx	# array size   
	syscall
	
	mov     $60, %rax		# exit
	xor     %rdi, %rdi		# zero rdi
	syscall
	
