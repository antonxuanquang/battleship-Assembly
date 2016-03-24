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
	movq	%rdi, %rax
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
	movq	$1, %rax
	jmp		lc_true
lc_false:
	# return true
	movq	$0, %rax
lc_true:
	popq	%rbp
	ret
#############################################
