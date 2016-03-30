#########################################
#
# BATTLESHIP
#
# Kaitlin Hendrick
# Quang Nguyen
#
# 03/29/16
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
	.string	"%s shoot at: "
msg_computer_coordinate:
	.string	"%s...\n\n%s"
msg_you_coordinate:
	.string	"\n%s"
msg_you_won:
	.string	"Congratulations!!!! %s won"
msg_computer_won:
	.string	"Computer won"
msg_your_board:
	.string	"%s's game board"
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
	.lcomm user_name, 16		#username 
	.lcomm shoot, 8



###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	main
	.globl	user_name
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$4, %rsp

	movl	$0, -4(%rbp)
	movq	$0, %r15

# 	begin();
	call	begin

# 	printf("Let's create some ships\n\n\n");
	movq	$msg_begin, %rdi
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
	movq	$msg_battle_begin, %rdi
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
	movq	$msg_computer_shoot, %rdi
	movq	$0, %rax
	call	printf
	jmp		main_get_cooridate

# 	else 				printf("You shoot at: ");
main_you_shoot:
	movq	$user_name, %rsi
	movq	$msg_you_shoot, %rdi
	movq	$0, %rax
	call	printf

main_get_cooridate:
# 	get_coordinate(shoot, 2, computer_turn);
	movl	-4(%rbp), %edx
	movq	$shoot, %rdi
	movq	$2, %rsi
	call	get_coordinate

# 	if (computer_turn) 	printf("%s...\n\n%s", shoot, shoot);
	cmpl	$0, -4(%rbp)
	je		main_prompt_after_shoot

	# printf("%s...\n\n%s", shoot, shoot);
	movq	$shoot, %rdx
	movq	$shoot, %rsi
	movq	$msg_computer_coordinate, %rdi
	movq	$0, %rax
	call	printf
	jmp		main_check_sink

main_prompt_after_shoot:
	movq	$shoot, %rsi
	movq	$msg_you_coordinate, %rdi
	movq	$0, %rax
	call	printf


main_check_sink:
# 	if (computer_turn) {
	cmpl	$0, -4(%rbp)
	je		main_shoot_computer_board

# 	sink = shoot_a_board(shoot, player_board);	
	movq	$player_board, %rsi
	movq	$shoot, %rdi
	call	shoot_a_board
	movq	%rax, %r15 			# sink
	jmp	main_loop_end

# 	sink = shoot_a_board(shoot, computer_board);
main_shoot_computer_board:
	movq 	$computer_board, %rsi
	movq	$shoot, %rdi
	call	shoot_a_board
	movq	%rax, %r15 			# sink

main_loop_end:
# 	computer_turn = !computer_turn;
	cmpl	$0, -4(%rbp)
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -4(%rbp)

	movq	$0, %rax
	call	clear_screen

# 	} while (!sink);
	cmpq	$0, %r15
	je		main_loop

# 	if (computer_turn) 		printf("%s\n", "Congratulations!!!! You won");
	cmpl	$0, -4(%rbp)
	je		main_computer_won
	# printf("%s\n", "Congratulations!!!! You won");
	movq	$user_name, %rsi
	movq	$msg_you_won, %rdi
	movq	$0, %rax
	call	printf
	jmp		main_end

main_computer_won:
# 	else 					printf("%s\n", "Computer won");
	movq	$msg_computer_won, %rdi
	call	puts


main_end:
# 	printf("Your game board\n");
	movq	$user_name, %rsi
	movq	$msg_your_board, %rdi
	movq	$0, %rax
	call	printf

# 	show_board(player_board, computer_board);
	movq 	$computer_board, %rsi
	movq	$player_board, %rdi
	call	show_board

# 	printf("Computer's game board\n");
	movq	$msg_computer_board, %rdi
	call	puts

# 	show_board(computer_board, player_board);
	movq	$player_board, %rsi
	movq 	$computer_board, %rdi
	call	show_board

# 	return (EXIT_SUCCESS);	
	movq	$0, %rax


	leave
	ret
