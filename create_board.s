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
#void create_board(char board[10][10]) 

create_board:
	pushq	%rbp
	movq	%rsp, %rbp

	movq 	$0, %r12	#counter= 0 goes until <100 

loop:
	# test if <100
	cmp	$99, %r12
	jg	done

	# initializes the ith index of the array to DOT
	movq 	$DOT, (%rdi, %r12, 1)
	incq	%r12
	jmp	loop

done:	

	leave
	ret
