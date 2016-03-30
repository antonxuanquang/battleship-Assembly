##############################################
#
# READ ONLY SECTION
#
##############################################
	.section	.rodata
msg_1:
	.string	"Press [[ENTER]] to continue\n"
msg_2:
	.string "clear"

###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	clear_screen
	.type	clear_screen, @function


###############################################
clear_screen:
	pushq   %rbp
	movq    %rsp, %rbp

	# outputs "Please press [ENTER] to continue"
	movq	$msg_1, %rdi
	call 	puts

	# waits
	call getchar
	call getchar
	
	# calls system clear
	movq	$msg_2, %rdi
	call system

	popq %rbp
	ret

