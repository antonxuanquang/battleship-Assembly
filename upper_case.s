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
	movq	%rdi, %rax
	movb	%al, -20(%rbp)

	# range
	movl	$25, -4(%rbp)

	# > 'A'
	cmpb	$64, -20(%rbp)
	jle		uc_false

	# within the range
	movsbl	-20(%rbp), %eax
	subq	$65, %rax
	cmpl	-4(%rbp), %eax
	jg		uc_false

	# return false
	movq	$1, %rax
	jmp		uc_true
uc_false:
	# return true
	movq	$0, %rax
uc_true:
	popq	%rbp
	ret
#############################################
