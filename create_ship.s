######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata

msg_Aircaft:
	.string	"You are creating an Aircraft Carrier\n"
msg_Battleship:
	.string	"You are creating a Battleship\n"
msg_Cruiser:
	.string	"You are creating a Cruiser\n"
msg_Submarine:
	.string	"You are creating a Submarine\n"
msg_Destroyer:
	.string	"You are creating a Destroyer\n"
msg_Input:
	.string	"Please input a start coordinate: "
msg_s:
	.string "%s"

##############################################
#
# Equate Section
#
#
##############################################
.equ 	A, 	65      # character 'A'
.equ 	B,	66      # character 'B'
.equ 	C,	67      # character 'C'
.equ 	S,	83      # character 'S'
.equ 	D,	68      # character 'D'


###############################################
#
# Block Started by Symbol Section
#
###############################################
.bss
	.lcomm start_position, 2
	.lcomm possible_positions, 8
	.lcomm end_position, 2
	


###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	create_ship
	.type	create_ship, @function


##############################################
#
# Start Function (P55)
#
##############################################


create_ship:
	
    pushq   %rbp
    movq    %rsp, %rbp


    subq	$64, %rsp				# save space
	
	movl	%esi, -60(%rbp)			# computer_turn
	movq	%rdi, -56(%rbp)			# board

#	char type[] = {'A', 'B', 'C', 'S', 'D'};
	movb	$65, -48(%rbp)			
	movb	$66, -47(%rbp)			
	movb	$67, -46(%rbp)			
	movb	$83, -45(%rbp)			
	movb	$68, -44(%rbp)



# 	for (i = 0; i < 5; i++)

#	int i = 0;
	movl	$0, -4(%rbp)
	jmp		loop

#	if (!computer_turn) show_board(board, board);
showboard:
	cmpl	$0, -60(%rbp)			# if (!computer_turn)
	jne	letter
	movq	-56(%rbp), %rsi
	movq	-56(%rbp), %rdi
	call	show_board

letter:
#	letter = type[i];
	movl	-4(%rbp), %eax
	cltq
	movzbl	-48(%rbp,%rax), %eax
	movb	%al, -33(%rbp)
	movsbl	-33(%rbp), %eax

#	switch (letter) {




#	case 'A': length = 5; if (!computer_turn) printf("You are creating an Aircraft Carrier\n\n"); 	break;
	cmpl	$0, -4(%rbp)
	je		caseA
#	case 'B': length = 4; if (!computer_turn) printf("You are creating a Battleship\n\n"); 			break;
	cmpl	$1, -4(%rbp)
	je		caseB	
#	case 'C': length = 3; if (!computer_turn) printf("You are creating a Cruiser\n\n"); 			break;
	cmpl	$2, -4(%rbp)
	je		caseC	
#	case 'S': length = 2; if (!computer_turn) printf("You are creating a Submarine\n\n"); 			break;
	cmpl	$3, -4(%rbp)
	je		caseS	
#	case 'D': length = 2; if (!computer_turn) printf("You are creating a Destroyer\n\n"); 			break;
	cmpl	$4, -4(%rbp)
	je		caseD

#	length = 5; if (!computer_turn) printf("You are creating an Aircraft Carrier\n\n"); 	break;
caseA:
	movl	$5, -8(%rbp)
	cmpl	$0, -60(%rbp)
	jne	get_positions
	movq	$msg_Aircaft, %rdi
	call	puts
	jmp		get_positions

#	length = 4; if (!computer_turn) printf("You are creating a Battleship\n\n"); 			break;
caseB:
	movl	$4, -8(%rbp)
	cmpl	$0, -60(%rbp)
	jne	get_positions
	movq	$msg_Battleship, %rdi
	call	puts
	jmp		get_positions

#	length = 3; if (!computer_turn) printf("You are creating a Cruiser\n\n"); 			break;
caseC:
	movl	$3, -8(%rbp)
	cmpl	$0, -60(%rbp)
	jne	get_positions
	movq	$msg_Cruiser, %rdi
	call	puts
	jmp		get_positions

#	length = 2; if (!computer_turn) printf("You are creating a Submarine\n\n"); 			break;
caseS:
	movl	$2, -8(%rbp)
	cmpl	$0, -60(%rbp)
	jne		get_positions
	movq	$msg_Submarine, %rdi
	call	puts
	jmp		get_positions

#	length = 2; if (!computer_turn) printf("You are creating a Destroyer\n\n"); 			break;
caseD:
	movl	$2, -8(%rbp)
	cmpl	$0, -60(%rbp)
	jne		get_positions
	movq	$msg_Destroyer, %rdi
	call	puts
	jmp		get_positions

get_positions:
#	memset(possible_positions,'\0', 8);
	movq	$possible_positions, %rax
	movq	$8, %rdx
	movq	$0, %rsi
	movq	%rax, %rdi
	call	memset

#	memset(end_position, '\0', 2);
	movq	$end_position, %rax
	movq	$2, %rdx
	movq	$0, %rsi
	movq	%rax, %rdi
	call	memset

#	if (!computer_turn) printf("%s", "Please input a start coordinate: ");
	cmpl	$0, -60(%rbp)
	jne		get_positions2
	movq	$msg_Input, %rsi
	movq	$msg_s, %rdi
	movq	$0, %rax
	call	printf

get_positions2:
#	get_coordinate(start_position, 2, computer_turn);
	movl	-60(%rbp), %edx
	movq	$start_position, %rdi
	movq	$2, %rsi
	call	get_coordinate

#	generate_possible_positions(
#	possible_positions, start_position, length - 1, board);
	movq	$possible_positions, %rdi
	movq	$start_position, %rsi
	movl	-8(%rbp), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rcx
	call	generate_possible_positions

#	get_end_coordinate(possible_positions, end_position, computer_turn);
	movl	-60(%rbp), %edx
	movq	$end_position, %rsi
	movq	$possible_positions, %rdi
	call	get_end_coordinate

#	while (end_position[0] == '\0');
	movq	$end_position, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je		get_positions

#	put_ship_on_board(start_position, end_position, letter, board);
	movsbl	-33(%rbp), %edx
	movq	-56(%rbp), %rcx
	movq	$end_position, %rsi
	movq	$start_position, %rdi
	call	put_ship_on_board

#	if (!computer_turn) clear_screen();
	cmpl	$0, -60(%rbp)
	jne		inc
	movq	$0, %rax
	call	clear_screen

inc:
	# i++ in for loop
	addl	$1, -4(%rbp)
loop:
	# i < 5;
	cmpl	$4, -4(%rbp)
	jle		showboard


    leave
    ret

#############################################
