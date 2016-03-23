#########################################
#
# BATTLESHIP
#
# KAitlin Hendrick
#
# 03/03/16
#
#########################################



######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata

.section	.rodata
msg_begin:
	.string	"Let's create some ships\n\n"
msg_battle_begin:
	.string	"The battle begin\n\n"
msg_computer_shoot:
	.string	"Computer shoot you at: "
msg_you_shoot:
	.string	"You shoot at: "
msg_computer_coordinate:
	.string	"%s...\n\n%s"
msg_you_coordinate:
	.string	"\n%s"
msg_you_won:
	.string	"Congratulations!!!! You won"
msg_computer_won:
	.string	"Computer won"
msg_your_board:
	.string	"Your game board"
msg_computer_board:
	.string	"Computer's game board"



###############################################
#
# Block Started by Symbol Section
#
###############################################
.bss
	.lcomm player_board, 100 	#data structure for player_board
	.lcomm computer_board, 100	#data structure for computer_board



###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp

	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)

# 	begin();
	call	begin


# 	char* shoot = malloc(2);
	movl	$2, %edi
	call	malloc
	movq	%rax, -16(%rbp)		# shoot

# 	printf("Let's create some ships\n\n\n");
	movl	$msg_begin, %edi
	call	puts

# 	create_board(player_board);
	movq	$player_board, %rdi
	call	create_board
# 	create_board(computer_board);
	movq 	$computer_board, %rdi
	call	create_board

# 	create_ship(player_board, computer_turn);
	movl	-4(%rbp), %esi
	movq	$player_board, %rdi
	call	create_ship

# 	create_ship(computer_board, !computer_turn);
	# !computer_turn
	cmpl	$0, -4(%rbp)
	sete	%al
	movzbl	%al, %edx
	movl	%edx, %esi

	movq 	$computer_board, %rdi
	call	create_ship

# 	printf("The battle begin\n\n\n");
	movl	$msg_battle_begin, %edi
	call	puts

main_loop:

# 	show_board(player_board, computer_board);
	movq 	$computer_board, %rsi
	movq	$player_board, %rdi
	call	show_board

# 	if (computer_turn) 	printf("Computer shoot you at: ");
	cmpl	$0, -4(%rbp)
	je		main_you_shoot

	# printf("Computer shoot you at: ");
	movl	$msg_computer_shoot, %edi
	movl	$0, %eax
	call	printf
	jmp		main_get_cooridate

# 	else 				printf("You shoot at: ");
main_you_shoot:
	movl	$msg_you_shoot, %edi
	movl	$0, %eax
	call	printf

main_get_cooridate:
# 	get_coordinate(shoot, 2, computer_turn);
	movl	-4(%rbp), %edx
	movq	-16(%rbp), %rdi
	movl	$2, %esi
	call	get_coordinate

# 	if (computer_turn) 	printf("%s...\n\n%s", shoot, shoot);
	cmpl	$0, -4(%rbp)
	je		main_prompt_after_shoot

	# printf("%s...\n\n%s", shoot, shoot);
	movq	-16(%rbp), %rdx
	movq	-16(%rbp), %rsi
	movl	$msg_computer_coordinate, %edi
	movl	$0, %eax
	call	printf
	jmp		main_check_sink

main_prompt_after_shoot:
	movq	-16(%rbp), %rsi
	movl	$msg_you_coordinate, %edi
	movl	$0, %eax
	call	printf


main_check_sink:
# 	if (computer_turn) {
	cmpl	$0, -4(%rbp)
	je		main_shoot_computer_board

# 	sink = shoot_a_board(shoot, player_board);	
	movq	$player_board, %rsi
	movq	-16(%rbp), %rdi
	call	shoot_a_board
	movl	%eax, -8(%rbp) 			# sink
	jmp	main_loop_end

# 	sink = shoot_a_board(shoot, computer_board);
main_shoot_computer_board:
	movq 	$computer_board, %rsi
	movq	-16(%rbp), %rdi
	call	shoot_a_board
	movl	%eax, -8(%rbp) 			# sink

main_loop_end:
# 	computer_turn = !computer_turn;
	cmpl	$0, -4(%rbp)
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -4(%rbp)


	call	clear_screen

# 	} while (!sink);
	cmpl	$0, -8(%rbp)
	je		main_loop

# 	if (computer_turn) 		printf("%s\n", "Congratulations!!!! You won");
	cmpl	$0, -4(%rbp)
	je		main_computer_won
	# printf("%s\n", "Congratulations!!!! You won");
	movl	$msg_you_won, %edi
	call	puts
	jmp		main_end

main_computer_won:
# 	else 					printf("%s\n", "Computer won");
	movl	$msg_computer_won, %edi
	call	puts


main_end:
# 	printf("Your game board\n");
	movl	$msg_your_board, %edi
	call	puts

# 	show_board(player_board, computer_board);
	movq 	$computer_board, %rsi
	movq	$player_board, %rdi
	call	show_board

# 	printf("Computer's game board\n");
	movl	$msg_computer_board, %edi
	call	puts

# 	show_board(computer_board, player_board);
	movq	$player_board, %rsi
	movq 	$computer_board, %rdi
	call	show_board

# 	free(shoot);
	movq	-16(%rbp), %rdi
	call	free

# 	return (EXIT_SUCCESS);	
	movl	$0, %eax

	leave
	ret
