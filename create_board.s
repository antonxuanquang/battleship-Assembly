###############################################
#
# Equate Section
#
#
###############################################
.equ DOT,   0x2E      # character '.'


###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	create_board
	.type	create_board, @function

##############################################
#void create_board(char board[10][10]) {
#	int row, column;
#
#	for (row = 0; row < 10; row++) {
#		for (column = 0; column < 10; column++) {
#			board[row][column] = '.';
#		}
#	}
# }
##############################################

create_board:
	pushq	%rbp
	movq	%rsp, %rbp

	movq 	$0, %r12	#counter= 0

loop:
	cmp	$99, %r12
	jg	done

#	movq 	$DOT, (%rdi, %r12, 1)
	incq	%r12
	jmp	loop

done:	popq 	%rbp
	ret
