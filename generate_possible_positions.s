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
	.globl generate_possible_possitions


##############################################
#
# Start Function (P55)
#
##############################################

generate_possible_possitions:
	pushq	%rbp
	movq	%rsp, %rbp


	subq	$64, %rsp
	movq	%rdi, -40(%rbp)			#possible_positions
	movq	%rsi, -48(%rbp)			#start_position
	movl	%edx, -52(%rbp)			#length
	movq	%rcx, -64(%rbp)			#board

# 	char *new_coordinate = (char*)malloc(2);
	movl	$2, %edi
	call	malloc
	movq	%rax, -16(%rbp)			#new_coordinate

# 	int column = (int) start_position[0] - (int)'A';
	movq	-48(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$65, %eax
	movl	%eax, -20(%rbp)			#column

# 	int row = (int) start_position[1] - (int)'0';
	movq	-48(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	subl	$48, %eax
	movl	%eax, -24(%rbp)			#row

# 	flag = true;
	movl	$1, -8(%rbp)			#flag

# 	//left case
# 	if (column - length >= 0) {
	movl	-20(%rbp), %eax
	subl	-52(%rbp), %eax
	testl	%eax, %eax
	js	right_case

# 	for (counter = column; counter >= column - length; counter--) {
	
	# counter = column
	movl	-20(%rbp), %eax 		
	movl	%eax, -4(%rbp)			#counter
	jmp	left_condition

left_flag:
	#board[row][counter]

	movl	-24(%rbp), %eax
	imulq	$10, %rax
	movq	-64(%rbp), %rdi
	addq	%rax, %rdi
	movl 	-4(%rbp), %esi	
	movzbl	(%rdi,%rsi), %eax

# 	if (!(board[row][counter] == '.')) {
	cmpb	$46, %al
	je	left_iterate
# 	flag = false;
	movl	$0, -8(%rbp)
# 	break;
	jmp	left_end

left_iterate:
	# counter--
	subl	$1, -4(%rbp)

left_condition:
	# counter >= column - length
	movl	-20(%rbp), %eax
	subl	-52(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jle	left_flag

left_end:
# 	new_coordinate[0] = (char) ((int) start_position[0] - length);
	movq	-48(%rbp), %rax
	movzbl	(%rax), %edx
	movl	-52(%rbp), %eax
	subl	%eax, %edx
	movq	-16(%rbp), %rax			#new_coordinate
	movb	%dl, (%rax)

# 	new_coordinate[1] = start_position[1];
	movq	-16(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	-48(%rbp), %rax
	movzbl	1(%rax), %eax
	movb	%al, (%rdx)

# 	if (flag) strcat(possible_positions, new_coordinate);
	cmpl	$0, -8(%rbp)
	je	right_case
	# strcat(possible_positions, new_coordinate);
	movq	-16(%rbp), %rsi
	movq	-40(%rbp), %rdi
	call	strcat

# 	//right
right_case:
# 	flag = true;
	movl	$1, -8(%rbp)

# 	if (column + length < 10) {
	movl	-20(%rbp), %edx
	movl	-52(%rbp), %eax
	addl	%edx, %eax
	cmpl	$9, %eax
	jg	up_case

# 	for (counter = column; counter <= column + length; counter++) {

	# counter = column
	movl	-20(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	right_condition

right_flag:
	#board[row][counter]
	movl	-24(%rbp), %eax
	imulq	$10, %rax
	movq	-64(%rbp), %rdi
	addq	%rax, %rdi
	movl 	-4(%rbp), %esi	
	movzbl	(%rdi,%rsi), %eax

# 	if (!(board[row][counter] == '.')) {
	cmpb	$46, %al
	je	right_iterate
# 	flag = false;
	movl	$0, -8(%rbp)
# 	break;
	jmp	right_end

right_iterate:
	# counter++
	addl	$1, -4(%rbp)

right_condition:
	# counter <= column + length
	movl	-20(%rbp), %edx
	movl	-52(%rbp), %eax
	addl	%edx, %eax
	cmpl	-4(%rbp), %eax
	jge	right_flag

right_end:
# 	new_coordinate[0] = (char) ((int) start_position[0] + length);
	movq	-48(%rbp), %rax
	movzbl	(%rax), %edx
	movl	-52(%rbp), %eax
	addl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	

# 	new_coordinate[1] = start_position[1];
	movq	-16(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	-48(%rbp), %rax
	movzbl	1(%rax), %eax
	movb	%al, (%rdx)

# 	if (flag) strcat(possible_positions, new_coordinate);
	cmpl	$0, -8(%rbp)
	je	up_case
	# strcat(possible_positions, new_coordinate);
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcat

# 	//up case
up_case:
# 	flag = true;
	movl	$1, -8(%rbp)

# 	if (row - length >= 0) {
	movl	-24(%rbp), %eax
	subl	-52(%rbp), %eax
	testl	%eax, %eax
	js	down_case

# 	for (counter = row; counter >= row - length; counter--) {
	movl	-24(%rbp), %eax
	# counter = row
	movl	%eax, -4(%rbp)
	jmp	up_condition

up_flag:
	
	#board[counter][column]
	movl	-4(%rbp), %eax
	imulq	$10, %rax
	movq	-64(%rbp), %rdi
	addq	%rax, %rdi
	movl 	-20(%rbp), %esi
	movzbl	(%rdi,%rsi), %eax

# 	if (!(board[counter][column] == '.')) {
	cmpb	$46, %al
	je	up_iterate
# 	flag = false;
	movl	$0, -8(%rbp)
# 	break;
	jmp	up_end

up_iterate:
	# counter--
	subl	$1, -4(%rbp)

up_condition:
	# counter >= row - length
	movl	-24(%rbp), %eax
	subl	-52(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jle	up_flag


up_end:
# 	new_coordinate[0] = start_position[0];
	movq	-48(%rbp), %rax
	movzbl	(%rax), %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)

# 	new_coordinate[1] = (char) ((int) start_position[1] - length);
	movq	-16(%rbp, 1), %rax
	addq	$1, %rax
	movq	-48(%rbp, 1), %rdx
	addq	$1, %rdx
	movzbl	(%rdx), %edx
	movl	%edx, %ecx
	movl	-52(%rbp), %edx
	subl	%edx, %ecx
	movl	%ecx, %edx
	movb	%dl, (%rax)

# 	if (flag) strcat(possible_positions, new_coordinate);
	cmpl	$0, -8(%rbp)
	je	down_case
	# strcat(possible_positions, new_coordinate);
	movq	-16(%rbp), %rsi
	movq	-40(%rbp), %rdi
	call	strcat

# 	//down
down_case:
# 	flag = true;
	movl	$1, -8(%rbp)

# 	if (row + length < 10) {
	movl	-24(%rbp), %edx
	movl	-52(%rbp), %eax
	addl	%edx, %eax
	cmpl	$9, %eax
	jg	gpp_end

# 	for (counter = row; counter <= row + length; counter++) {
	movl	-24(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	down_condition

down_flag:
	
	#board[counter][column]
	movl	-4(%rbp), %eax
	imulq	$10, %rax
	movq	-64(%rbp), %rdi
	addq	%rax, %rdi
	movl 	-20(%rbp), %esi
	movzbl	(%rdi,%rsi), %eax

# 	if (!(board[counter][column] == '.')) {
	cmpb	$46, %al
	je	down_iterate
# 	flag = false;
	movl	$0, -8(%rbp)
# 	break;
	jmp	down_end

down_iterate:
	# counter++
	addl	$1, -4(%rbp)

down_condition:
	# counter <= row + length
	movl	-24(%rbp), %edx
	movl	-52(%rbp), %eax
	addl	%edx, %eax
	cmpl	-4(%rbp), %eax
	jge	down_flag

down_end:
# 	new_coordinate[0] = start_position[0];
	movq	-48(%rbp), %rax
	movzbl	(%rax), %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)

# 	new_coordinate[1] = (char) ((int) start_position[1] + length);
	movq	-16(%rbp), %rax
	addq	$1, %rax
	movq	-48(%rbp), %rdx
	addq	$1, %rdx
	movzbl	(%rdx), %edx
	movl	%edx, %ecx
	movl	-52(%rbp), %edx
	addl	%ecx, %edx
	movb	%dl, (%rax)

# 	if (flag) strcat(possible_positions, new_coordinate);
	cmpl	$0, -8(%rbp)
	je	gpp_end
	# strcat(possible_positions, new_coordinate);
	movq	-16(%rbp), %rsi
	movq	-40(%rbp), %rdi
	call	strcat


gpp_end:

# 	free(new_coordinate);
	movq	-16(%rbp), %rdi
	call	free

	leave
	ret

#############################################
