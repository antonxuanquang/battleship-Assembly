######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata
msg_HIT:
	.string	" is a HIT"
msg_already_HIT:
	.string	", hmmmm...., it has already  been hit :("
msg_MISS:
	.string	" is a MISS"


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

shoot_it:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)

# 	int column = (int) shoot[0] - (int)'A';	
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$65, %eax
	movl	%eax, -4(%rbp) 		# int column

# 	int row = (int) shoot[1] - (int)'0';
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$48, %eax
	movl	%eax, -8(%rbp) 		# int row

# 	char point = board[row][column];
	movl 	-8(%rbp), %eax
	imulq 	$10, %rax
	movl 	-4(%rbp), %edx
	addq 	%rax, %rdx
	movq 	-32(%rbp), %rcx
	movzbl 	(%rcx, %rdx), %eax
	movb 	%al, -9(%rbp)

# 	if (upper_case(point)) {
	movsbl	-9(%rbp), %edi
	call	upper_case
	testl	%eax, %eax
	je	si_else_if

# 	board[row][column] = (char)(point + 32);
	# board[row][column]
	movl 	-8(%rbp), %eax
	imulq 	$10, %rax
	movl 	-4(%rbp), %edx
	addq 	%rax, %rdx
	movq 	-32(%rbp), %rcx

	# (char)(point + 32);
	movzbl 	-9(%rbp), %eax
	addq 	$32, %rax

	movb 	%al, (%rcx, %rdx)

# 	printf("%s\n", " is a HIT");
	movq	$msg_HIT, %rdi
	call	puts
# 	return true;
	movq	$1, %rax
	jmp	si_return


si_else_if:
# 	} else if (lower_case(point)) {
	movsbl	-9(%rbp), %edi
	call	lower_case
	testl	%eax, %eax
	je	si_else
# 	printf("%s\n", ", hmmmm...., it has already  been hit :(");
	movq	$msg_already_HIT, %rdi
	call	puts
	jmp	si_false


si_else:

# 	board[row][column] = 'o';
	movl 	-8(%rbp), %eax
	imulq 	$10, %rax
	movl 	-4(%rbp), %edx
	addq 	%rax, %rdx
	movq 	-32(%rbp), %rcx
	movb	$111, (%rdx,%rcx)

# 	printf("%s\n", " is a MISS");
	movq	$msg_MISS, %rdi
	call	puts

# 	return false;
si_false:
	movq	$0, %rax

si_return:
	leave
	ret

check_sink:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$64, %rsp
	movq	%rdi, -56(%rbp)

# 	memset(sum_string, '\0', 20);
	leaq	-48(%rbp), %rdi
	movq	$20, %rdx
	movq	$0, %rsi
	call	memset

# 	for (row = 0; row < 10; row++) {
	movl	$0, -4(%rbp)		# row = 0
	jmp	cs_outside_condition

# 	for (column = 0; column < 10; column++) {
cs_outside_loop:
	movl	$0, -8(%rbp)		# column = 0
	jmp	cs_inside_condition

cs_inside_loop:
# 	char point = board[row][column];
	movl 	-4(%rbp), %eax
	imulq 	$10, %rax
	movl 	-8(%rbp), %edx
	addq 	%rax, %rdx
	movq 	-56(%rbp), %rcx

	movzbl 	(%rdx, %rcx), %eax
	movb	%al, -9(%rbp)

# 	if (point != '.' && point != 'X' && point != 'o'
# 		&& !strchr(sum_string, point)
# 		&& upper_case(point)) {
	# if (point == 'b')
	# # point != '.'
	# cmpb	$46, -9(%rbp)
	# je		cs_inside_increment
	# # point != 'X'
	# cmpb	$88, -9(%rbp)
	# je		cs_inside_increment
	# # point != 'o'
	# cmpb	$111, -9(%rbp)
	# je		cs_inside_increment
	# # !strchr(sum_string, point)
	# movsbl	-9(%rbp), %esi
	# leaq	-48(%rbp), %rdi
	# call	strchr
	# testq	%rax, %rax
	# jne		cs_inside_increment

	# # upper_case(point)
	# movsbl	-9(%rbp), %edi
	# call	upper_case
	# testl	%eax, %eax
	# je		cs_inside_increment

	cmpb 	$66, -9(%rbp)
	jne		cs_inside_increment

# 	int length = strlen(sum_string);	
	leaq	-48(%rbp), %rdi
	call	strlen
	movl	%eax, -16(%rbp)

# 	sum_string[length++] = point;
	movl	-16(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -16(%rbp)
	cltq
	movzbl	-9(%rbp), %edx
	movb	%dl, -48(%rbp,%rax)

# 	sum_string[length] = '\0';
	movl	-16(%rbp), %eax
	cltq
	movb	$0, -48(%rbp,%rax)

cs_inside_increment:
	# column++
	addl	$1, -8(%rbp)

cs_inside_condition:
	# column < 10
	cmpl	$9, -8(%rbp)
	jle		cs_inside_loop

	# row++
	addl	$1, -4(%rbp)
cs_outside_condition:
	# row < 10
	cmpl	$9, -4(%rbp)
	jle		cs_outside_loop

# 	return strlen(sum_string) == 0;
	# strlen(sum_string)
	leaq	-48(%rbp), %rdi
	call	strlen
	cmpq	$0, %rax
	sete	%al
	movzbl	%al, %eax

	leave
	ret


#############################################
