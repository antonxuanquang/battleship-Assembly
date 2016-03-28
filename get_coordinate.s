######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata
msg_1:
	.string	"Invalid input!!!!"
	.align 8
msg_2:
	.string	"A valid cordinate consists of a capital character from A to J"
msg_3:
	.string	"and a number from 0 to 9"
msg_4:
	.string	"Example: B2, J3, G7"
msg_s:
	.string "%s"


###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	get_coordinate
	.type	get_coordinate, @function

##############################################
# void get_coordinate(char *result, int size, Boolean computer_turn) {
# 	if (computer_turn) 	generate_random_input(result, size);
# 	else 				prompt_for_coordinate(result, size);
# }
##############################################

get_coordinate:
	pushq	%rbp
	movq	%rsp, %rbp
#	if (computer_turn) 	generate_random_input(result, size);
	cmpl	$0, %edx
	je		user_turn
	call	generate_random_input
	jmp		end

#	else 				prompt_for_coordinate(result, size);
user_turn:
	call	prompt_for_coordinate

end:
	leave
	ret

##############################################
# void prompt_for_coordinate(char *result, int size) {
# 	char input[20];
# 	do {
# 		scanf("%s", input);
# 	} while (!is_valid(input));
# 	strncpy(result, input, size);
# }
##############################################
prompt_for_coordinate:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$48, %rsp				#save space
	movq	%rdi, -40(%rbp)			#char *result
	movl	%esi, -44(%rbp)			#int size
validate_input:
#	char input[20];
#	do {
#		scanf("%s", input);
	leaq	-32(%rbp), %rsi
	movq	$msg_s, %rdi
	movq	$0, %rax
	call	scanf
#	} while (!is_valid(input));
	leaq	-32(%rbp), %rdi
	call	is_valid
	testq	%rax, %rax
	je		validate_input

#	strncpy(result, input, size);
	movl	-44(%rbp), %edx
	leaq	-32(%rbp), %rsi
	movq	-40(%rbp), %rdi
	call	strncpy

	addq 	$48, %rsp
	movq	%rbp, %rsp
	popq 	%rbp
	ret

#############################################
# Boolean is_valid(char *input) {
# 	if (strlen(input) == 2) {
# 		int first = (int)input[0] - (int)'A';
# 		int second = (int)input[1] - (int)'0';
# 		if (first >= 0 && first < 10 && second >= 0 && second < 10) {
# 			return true;
# 		}
# 	}
# 	printf("Invalid input!!!!\n");
# 	printf("A valid cordinate consists of a capital character from A to J\n");
# 	printf("and a number from 0 to 9\n");
# 	printf("Example: B2, J3, G7\n");
# 	return false;
# }
#############################################
is_valid:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$32, %rsp			#save space
	movq	%rdi, -24(%rbp)		#char *input

#	if (strlen(input) == 2) {	
	call	strlen
	cmpq	$2, %rax
	jne		invalid_input

#	int first = (int)input[0] - (int)'A';
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	subq	$65, %rax
	movl	%eax, -4(%rbp)

#	int second = (int)input[1] - (int)'0';
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	subq	$48, %rax
	movl	%eax, -8(%rbp)

#	if (first >= 0 && first < 10 && second >= 0 && second < 10) {
	cmpl	$0, -4(%rbp)		# first >= 0
	js		invalid_input
	cmpl	$9, -4(%rbp)		# first < 10
	jg		invalid_input
	cmpl	$0, -8(%rbp)		# second >= 0
	js		invalid_input
	cmpl	$9, -8(%rbp)		# second < 10
	jg		invalid_input

#	return true;
	movq	$1, %rax
	jmp		end_is_valid

invalid_input:
#	printf("Invalid input!!!!\n");
	movq	$msg_1, %rdi
	call	puts
#	printf("A valid cordinate consists of a capital character from A to J\n");
	movq	$msg_2, %rdi
	call	puts
#	printf("and a number from 0 to 9\n");
	movq	$msg_3, %rdi
	call	puts
#	printf("Example: B2, J3, G7\n");
	movq	$msg_4, %rdi
	call	puts
#	return false;
	movq	$0, %rax

end_is_valid:
	leave
	ret

#############################################
#void generate_random_input(char *result, int size) {
#	char input[2];
#	input[0] = (char) ((int)'A' + rand()%10);
#	input[1] = (char) ((int)'0' + rand()%10);
#	strncpy(result, input, size);
#}
#############################################
generate_random_input:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)

#	input[0] = (char) ((int)'A' + rand()%10);
	call	rand
	and		$9, %rax
	addq	$65, %rax
	movb	%al, -16(%rbp)

#	input[1] = (char) ((int)'0' + rand()%10);
	call	rand
	and		$9, %rax
	addq	$48, %rax
	movb	%al, -15(%rbp)

#	strncpy(result, input, size);
	movl	-28(%rbp), %edx
	leaq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdi
	call	strncpy

	leave	
	ret




#############################################
