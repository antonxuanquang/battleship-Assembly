#########################################
#
# BATTLESHIP
#
# KAitlin Hendrick
#
# 03/03/16
#
#########################################

#########################################
#
# Equate Section
#
#
########################################
.equ SPACE, 0x20      # character ' '
.equ DOT,   0x2E      # character '.'
.equ HIT,   0x58      # character 'X'
.equ MISS,  0x5F      # character 'o'
.equ NULL, 0x88       # charactr '\0' (NULL)



######################################
#
# READ ONLY SECTION
#
######################################
	.section	.rodata

##  constant single characters
const_y:	.string "y"
const_n:	.string "n"
const_Y:	.string "Y"
const_N:	.string "N"

## Messages
msg_instructions:
	.ascii "These\n"
	.ascii "are\n"
	.ascii "the\n"
	.ascii "instructions\n"
	.ascii "\n"
msg_pressenter: .string "Press[ENTER] to continue..."

## Command Strings
cmd_clear: .string "clear"

## Format strings used by scanf() and printf()
fmt_char:	.string "%c"
fmt_int:	.string "%d"
fmt_string:	.string "%s"
fmt_charint:	.string "%c%d"
fmt_charvalue:	.string "Value is %c\n"
fmt_intvalue: 	.string "Value is %d\n"
fmt_strvalue:	.string "Value is %s\n"



################################################
#
# Data Section
#
###############################################
	.section .data
foo:
	.int 12

###############################################
#
# Block Started by Symbol Section
#
###############################################
.bss
	.lcomm buffer, 256	#used to store answer for y/n question
	.lcomm shipboard, 100 	#data structure for ship board
	.lcomm shotboard, 100	#data structure for shot board
	.lcomm turn, 4		#which "turn" is it? Player=0 computer=1



###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl main


##############################################
#
# Start Function (P55)
#
##############################################

main:

	## clear screen and dispaly game instructions
##	call clear_screen
##	call disp_inst

#	call press_enter

#	call disp_board

	call mess

	movl $1, %eax # exit(0)
	movl $0, %ebx
	int  $0x80
#############################################
