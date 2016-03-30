###############################################
#
# Equ
#
###############################################
.equ 	MISS, 0x6F 		# character 'o'

###############################################
#
# Format
#
###############################################
.section 	.rodata
fmt_shot: 
	.string 	"Shots fired: %d\n"
fmt_hit:
	.string 	"Hits: %d\n"
fmt_misses:
	.string 	"Misses: %d\n"

###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	print_stat
	.type	print_stat, @function
print_stat:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %r10 		#board


	movq	$0, %r15		# counter = 0
	movq 	$0, %r12 		# shot_count = 0
	movq 	$0, %r13 		# misses = 0
	movq 	$0, %r14 		# hits = 0
	jmp 	ps_loop_condition

ps_loop:
	movq 	(%r10, %r15, 1), %rdi
	call 	lower_case
	cmpq 	$0, %rax
	je 		ps_loop1
	incq 	%r12

	cmpb 	$MISS, (%r10, %r15, 1)
	jne		ps_loop1
	incq 	%r13

ps_loop1:
	incq 	%r15

ps_loop_condition:
	cmpq	$99, %r15
	jle		ps_loop

	movq 	%r12, %r14
	subq 	%r13, %r14

	movq 	$fmt_shot, %rdi
	movq 	%r12, %rsi
	movq 	$0, %rax
	call 	printf

	movq 	$fmt_hit, %rdi
	movq 	%r14, %rsi
	movq 	$0, %rax
	call 	printf

	movq 	$fmt_misses, %rdi
	movq 	%r13, %rsi
	movq 	$0, %rax
	call 	printf




	leave
	ret


#############################################