.data

array:
	.byte 28, 28, 224, 47, 90, 90, 78, 1, 88, 12, 124, 254, 17, 58, 17, 17, 38, 1, 0, 1, 1, 77, 254, 254, 254, 254, 48, 0, 0, 0, 0, 0
array_end:

array_size:
	.quad 27
leading_one:
    .byte 255, 0,0,0,0,0,0,0
all_ones:
    .quad 0xFFFFFFFFFFFFFFFF
 
.global _start

.section .text

_start:
	mov	$1, %rax      	    # write
	mov	$1, %rdi      	    # file descriptor (stdout)
	mov	$array, %rsi  	    # array pointer
	mov	(array_size), %rdx  # array size   
	syscall

	movq    $array, %r8         # array start
	movq    $4, %rax            # iterator

loop:
	movq    (%r8), %mm0         # next eight elms to mm0
	movq    1(%r8), %mm1        # next eight elms shited by 1 el to mm1
	movq    %mm1, %mm2          # copy mm1 to mm2

	pcmpeqb %mm0, %mm2          # compare mm0 and mm2
	pxor    (all_ones), %mm2    # invert compare result
	pand    %mm2, %mm0          # zero dublicates in mm0
	pand    %mm2, %mm1          # zero dublicates in mm1
	psllq   $8, %mm1            # shift mm1 by one elem back
	por     (leading_one), %mm1 # extend shift with ones
	pand    %mm1, %mm0          # and to get final result for elms
	movq    %mm0, (%r8)         # populate result to array
	addq    $8, %r8             # move to next 8 elements
	decq    %rax                # decrement iterator
	jnz     loop                # continue if iterator not zero

exit:
	mov	$1, %rax      	    # write
	mov	$1, %rdi      	    # file descriptor (stdout)
	mov	$array, %rsi  	    # array pointer
	mov	(array_size), %rdx  # array size   
	syscall
	
	mov     $60, %rax	    # exit
	xor     %rdi, %rdi	    # zero rdi
	syscall
	
