######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata


###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	shoot_a_board
	.type	shoot_a_board, @function
shoot_a_board:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)

# 	hit = shoot_it(shoot, board);
	call	shoot_it
	movl	%eax, -8(%rbp) 		# hit

# 	if (hit) sink = check_sink(board);
	cmpl	$0, -8(%rbp)
	je		sab_return
	# sink = check_sink(board);
	movq	-32(%rbp), %rdi
	call	check_sink
	movl	%eax, -4(%rbp)

sab_return:
# 	return sink;
	movl	-4(%rbp), %eax

	leave
	ret



# Boolean shoot_a_board(char *shoot, char board[10][10]) {
# 	Boolean hit, sink;
# 	hit = shoot_it(shoot, board);
# 	if (hit) sink = check_sink(board);
# 	return sink;
# }


#############################################
