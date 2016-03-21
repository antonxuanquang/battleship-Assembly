######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata
msg_cannot_put:
	.string	"Can't put this ship on board, please try again!"

###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl		get_end_coordinate
	.type		get_end_coordinate, @function


##############################################
#
# Start Function (P55)
#
##############################################

get_end_coordinate:

	pushq	%rbp
	movq	%rsp, %rbp

	subq	$48, %rsp
	movq	%rdi, -24(%rbp)		# possible_positions
	movq	%rsi, -32(%rbp)		# end_position
	movl	%edx, -36(%rbp)		# computer_turn

# 	int num_choices = strlen(possible_positions) / 2;
	movq	-24(%rbp), %rdi
	call 	strlen
	shrq	%rax
	movl	%eax, -8(%rbp)		# num_choices

# 	if (num_choices == 0) {
	cmpl	$0, -8(%rbp)
	jne		get_option
# 	printf("Can't put this ship on board, please try again!\n");
	movl	$msg_cannot_put, %edi
	call	puts
# 	return;
	jmp		gec_end


get_option:
# 	if (computer_turn) 	option = rand() % num_choices;
	cmpl	$0, -36(%rbp)
	je		prompt_end
	# option = rand() % num_choices;
	call	rand
	movl	-8(%rbp), %edx
	andl	%eax, %edx
	movl	%edx, -4(%rbp)		# option
	jmp	get_end_cord

prompt_end:
# 	else 				option = prompt_for_end_possition(possible_positions, num_choices);
	movl	-8(%rbp), %esi
	movq	-24(%rbp), %rdi
	call	prompt_for_end_possition
	movl	%eax, -4(%rbp)		# option

get_end_cord:
##############################################
#
# having a bug in this one
#
##############################################

# 	# option - 1
# 	movl	-4(%rbp), %eax
# 	subl	$1, %eax
# 	# (option - 1) * 2
# 	addl	%eax, %eax

# # end_position[0] = possible_positions[(option - 1) * 2];
# 	movq 	-32(%rbp), %rcx		# end_position
# 	movq 	-24(%rbp), %rdx		# possible_positions
# 	addq	%rax, %rdx
# 	movzbl 	(%rdx), %edx
# 	movb 	%dl, (%rcx)

# # end_position[1] = possible_positions[(option - 1) * 2 + 1];
# 	movq 	-32(%rbp), %rcx		# end_position
# 	addq	$1, %rcx
# 	movq 	-24(%rbp), %rdx		# possible_positions
# 	addq	%rax, %rdx
# 	addq	$1, %rdx
# 	movzbl 	(%rdx), %edx
# 	movb 	%dl, (%rcx)



# 	end_position[0] = possible_positions[(option - 1) * 2];
	movl	-4(%rbp), %eax
	subl	$1, %eax 			# option - 1
	addl	%eax, %eax 			
	movslq	%eax, %rdx 		# (option - 1) * 2
	movq	-24(%rbp), %rax
	addq	%rdx, %rax 			# possible_positions[(option - 1) * 2]
	movzbl	(%rax), %edx
	movq	-32(%rbp), %rax
	movb	%dl, (%rax)			# end_position[0]
	
# 	end_position[1] = possible_positions[(option - 1) * 2 + 1];
	movq	-32(%rbp), %rax 	
	leaq	1(%rax), %rdx		# end_position[1]
	movl	-4(%rbp), %eax
	subl	$1, %eax
	addl	%eax, %eax 			# (option - 1) * 2
	cltq
	leaq	1(%rax), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movb	%al, (%rdx)

gec_end:

	leave
	ret

prompt_for_end_possition:
	
	pushq	%rbp
	movq 	%rsp, %rbp

	subq 	$48, %rsp
	movq 	%rdi, -40(%rbp)		# possible_positions
	movl 	%esi, -44(%rbp) 	# num_choices

# 	char *choice = (char*) malloc(2);
	movl 	$2, %edi
	call 	malloc
	movq 	%rax, -16(%rbp) 	# choice

# 	printf(">0: Retry\n");
	movl 	$msg_retry, %edi
	call 	puts

# 	for (counter = 0; counter < num_choices; counter++) {
	movl 	$0, -4(%rbp) 		# counter
	jmp 	pfep_loop_condition


pfep_for_loop:

# 	memset(choice, '\0', 2);
	movq 	-16(%rbp), %rdi
	movl 	$0, %esi
	movl 	$2, %edx
	call 	memset


# 	choice[0] = possible_positions[counter * 2];
	# counter
	movl	-4(%rbp), %eax
	# counter * 2
	addl	%eax, %eax
	movq 	-16(%rbp), %rcx		# choice
	movq 	-40(%rbp), %rdx		# possible_positions
	addq	%rax, %rdx
	movzbl 	(%rdx), %edx
	movb 	%dl, (%rcx)	

# 	choice[1] = possible_positions[counter * 2 + 1];
	movq 	-16(%rbp), %rcx		# choice
	addq 	$1, %rcx
	movq 	-40(%rbp), %rdx		# possible_positions
	addq	%rax, %rdx
	addq	$1, %rdx
	movzbl 	(%rdx), %edx
	movb 	%dl, (%rcx)


# 	printf(">%d: %s\n", counter + 1, choice);
	movl 	$msg_option_counter, %edi
	movl 	-4(%rbp), %esi
	addl 	$1, %esi
	movq 	-16(%rbp), %rdx
	movl 	$0, %eax
	call 	printf

	# counter++
	addl	$1, -4(%rbp)

pfep_loop_condition:

	# counter < num_choices
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	pfep_for_loop

# 	free(choice);
	movq	-16(%rbp), %rdi
	call	free

pfep_while_loop:
# 	printf("%s", "Please input end position: ");
	movl	$msg_prompt_end, %esi
	movl	$msg_s, %edi
	movl	$0, %eax
	call	printf

# 	scanf("%d", &choice_int);
	leaq	-20(%rbp), %rsi
	movl	$msg_d, %edi
	movl	$0, %eax
	call	__isoc99_scanf

# 	} while(choice_int < 0 || choice_int > num_choices);
	# choice_int < 0
	movl	-20(%rbp), %eax
	testl	%eax, %eax
	js	pfep_while_loop
	# choice_int > num_choices
	movl	-20(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jg	pfep_while_loop

# 	return choice_int;
	movl	-20(%rbp), %eax


	leave
	ret
#############################################
