###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	lower_case
	.type	lower_case, @function

lower_case:
	pushq	%rbp
	movq	%rsp, %rbp

	# save character
	movl	%edi, %eax
	movb	%al, -20(%rbp)

	# range
	movl	$25, -4(%rbp)

	# > 'a'
	cmpb	$96, -20(%rbp)
	jle		lc_false

	# within the range
	movsbl	-20(%rbp), %eax
	subl	$97, %eax
	cmpl	-4(%rbp), %eax
	jg		lc_false

	# return false
	movl	$1, %eax
	jmp		lc_true
lc_false:
	# return true
	movl	$0, %eax
lc_true:
	popq	%rbp
	ret
#############################################
