######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata
msg_clear:
	.string	"clear"
msg_star:
	.string	"*******************************"
msg_space:
	.string	"*                             *"
msg_welcome:
	.string	"* Welcome to battle ship game.*"
msg_new_line:
	.string	"\n"

###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	begin
	.type	begin, @function
begin:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	$msg_clear, %rdi
	call	system
	movq	$msg_star, %rdi
	call	puts
	movq	$msg_space, %rdi
	call	puts
	movq	$msg_welcome, %rdi
	call	puts
	movq	$msg_space, %rdi
	call	puts
	movq	$msg_star, %rdi
	call	puts
	movq	$msg_new_line, %rdi
	call	puts

	movq	$0, %rax
	call	clear_screen

	popq	%rbp
	ret
#############################################
