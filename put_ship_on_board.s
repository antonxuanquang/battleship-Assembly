###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl		put_ship_on_board
	.type		put_ship_on_board, @function

put_ship_on_board:

	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, -40(%rbp) 	# start_position
	movq	%rsi, -48(%rbp) 	# end_position
	movq	%rdx, %rax
	movb	%al, -52(%rbp) 		# letter
	movq	%rcx, -64(%rbp) 	# board

# 	int col_start = (int) start_position[0] - (int) 'A';
	movq	-40(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$65, %eax
	movl	%eax, -8(%rbp) 		# col_start

# 	int row_start = (int) start_position[1] - (int) '0';
	movq	-40(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$48, %eax
	movl	%eax, -12(%rbp) 	# row_start

# 	int col_end = (int) end_position[0] - (int) 'A';
	movq	-48(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$65, %eax
	movl	%eax, -16(%rbp) 	# col_end

# 	int row_end = (int) end_position[1] - (int) '0';
	movq	-48(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$48, %eax
	movl	%eax, -20(%rbp) 	# row_end

# 	if (col_start == col_end) {			// vertical case
	movl	-8(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jne		psob_horizontal

# 	if (row_start > row_end) {		// up case
	movl	-12(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle	psob_down

# 	for (i = row_end; i <= row_start; i++) {
	movl	-20(%rbp), %eax
	movl	%eax, -4(%rbp) 		# i = row_end
	jmp	psob_up_condition

psob_up_loop:

# 	board[i][col_start] = letter;
	# board[i][col_start]
	movl 	-4(%rbp), %eax
	imulq 	$10, %rax
	movl 	-8(%rbp), %edi
	addq	%rdi, %rax
	movq 	-64(%rbp), %rdi
	addq 	%rax, %rdi

	# board[i][col_start] = letter;
	movzbl 	-52(%rbp), %edx
	movb 	%dl, (%rdi)

	# i++
	addl	$1, -4(%rbp)
psob_up_condition:
	# i <= row_start
	movl	-4(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jle	psob_up_loop
	jmp	psob_end

psob_down:
# 	for (i = row_start; i <= row_end; i++) {
	movl	-12(%rbp), %eax
	movl	%eax, -4(%rbp) 		# i = row_start
	jmp		psob_down_condition
psob_down_loop:

# 	board[i][col_start] = letter;
	# board[i][col_start]
	movl 	-4(%rbp), %eax
	imulq 	$10, %rax
	movl 	-8(%rbp), %edi
	addq	%rdi, %rax
	movq 	-64(%rbp), %rdi
	addq 	%rax, %rdi

	# board[i][col_start] = letter;
	movzbl 	-52(%rbp), %edx
	movb 	%dl, (%rdi)

	# i++
	addl	$1, -4(%rbp)
psob_down_condition:
	
	# i <= row_end
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle		psob_down_loop
	jmp		psob_end


psob_horizontal:
# 	if (col_start > col_end) {		// right case
	movl	-8(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jle	psob_left
# 	for (i = col_end; i <= col_start; i++) {
	movl	-16(%rbp), %eax
	movl	%eax, -4(%rbp)		# i = col_end
	jmp	psob_right_condition

psob_right_loop:

# 	board[row_start][i] = letter;
	# board[row_start][i]
	movl 	-12(%rbp), %eax
	imulq 	$10, %rax
	movl 	-4(%rbp), %edx
	addq 	%rax, %rdx
	movq 	-64(%rbp), %rdi
	addq 	%rdx, %rdi
	# board[row_start][i] = letter;
	movzbl	-52(%rbp), %edx
	movb	%dl, (%rdi)

	# i++
	addl	$1, -4(%rbp)

psob_right_condition:
	# i <= col_start
	movl	-4(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jle	psob_right_loop
	jmp	psob_end


psob_left:
# 	for (i = col_start; i <= col_end; i++) {
	movl	-8(%rbp), %eax
	movl	%eax, -4(%rbp) 		# i = col_start
	jmp	psob_left_condition

psob_left_loop:
# 	board[row_start][i] = letter;
	# board[row_start][i]
	movl 	-12(%rbp), %eax
	imulq 	$10, %rax
	movl 	-4(%rbp), %edx
	addq 	%rax, %rdx
	movq 	-64(%rbp), %rdi
	addq 	%rdx, %rdi
	# board[row_start][i] = letter;
	movzbl	-52(%rbp), %edx
	movb	%dl, (%rdi)

	# i++
	addl	$1, -4(%rbp)

psob_left_condition:
	# i <= col_end
	movl	-4(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jle	psob_left_loop

psob_end:
	popq	%rbp
	ret
#############################################
