##############################################
#
# READ ONLY SECTION
#
##############################################
	.section	.rodata
msg_1:
	.string	"Press [[ENTER]] to continue\n"

###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	clear_screen
	.type	clear_screen, @function


###############################################
#
# void clear_screen() {
#	printf("Press [[ENTER]] to continue\n");
#	getchar();
#	getchar();
#	system("clear");
# }
#
###############################################


clear_screen:
	pushq   %rbp
	movq    %rsp, %rbp

	movl	$msg_1, %edi
	call 	puts

	call getchar

	popq %rbp
	ret

