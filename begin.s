######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata
.LC0:
	.string	"clear"
	.align 8
.LC1:
	.string	"*******************************"
	.align 8
.LC2:
	.string	"*                             *"
	.align 8
.LC3:
	.string	"* Welcome to battle ship game.*"
.LC4:
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
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$.LC0, %edi
	call	system
	movl	$.LC1, %edi
	call	puts
	movl	$.LC2, %edi
	call	puts
	movl	$.LC3, %edi
	call	puts
	movl	$.LC2, %edi
	call	puts
	movl	$.LC1, %edi
	call	puts
	movl	$.LC4, %edi
	call	puts
	movl	$0, %eax
	call	clear_screen
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	begin, .-begin
#############################################
