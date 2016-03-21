###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	upper_case
	.type	upper_case, @function

upper_case:
	pushq	%rbp
	movq	%rsp, %rbp

	# save character
	movl	%edi, %eax
	movb	%al, -20(%rbp)

	# range
	movl	$25, -4(%rbp)

	# > 'A'
	cmpb	$64, -20(%rbp)
	jle		uc_false

	# within the range
	movsbl	-20(%rbp), %eax
	subl	$65, %eax
	cmpl	-4(%rbp), %eax
	jg		uc_false

	# return false
	movl	$1, %eax
	jmp		uc_true
uc_false:
	# return true
	movl	$0, %eax
uc_true:
	popq	%rbp
	ret
#############################################
