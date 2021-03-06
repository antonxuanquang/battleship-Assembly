##############################################
#
# Equate Section
#
#
##############################################
.equ DOT,   0x2E      # character '.'
.equ HIT,   0x58      # character 'X'
.equ MISS,  0x6F      # character 'o'


###############################################
#
# READ ONLY SECTION
#
###############################################
	.section	.rodata
msg1: .string "SHIPS BOARD\n"
msg2: .string "SHOTS BOARD\n"
strletter: .string "   A B C D E F G H I J"
newline: .string "\n"

## Format strings used by scanf() and printf()
fmt_char:       .string "%c "
fmt_int:        .string "%2d "
fmt_string:     .string "%s"
fmt_charint:    .string "%c%d"


###############################################
#
# Text (Code) Segment
#
###############################################
	.text
	.globl	show_board
	.type	show_board, @function


##############################################
# void show_board(char player_board[10][10], char computer_board[10][10])


show_board:

    	pushq   %rbp
   	movq    %rsp, %rbp

	movq 	%rdi, %r12	#move player_board to %r12
	movq	%rsi, %r13	#move computer_board to %r13

#print title Ships Board
	movq 	$1, %rax
        movq 	$1, %rdi
        mov 	$msg1, %rsi
        mov 	$12, %rdx
        syscall
#prints columns headers
	movq    $1, %rax
        movq    $1, %rdi
        mov     $strletter, %rsi
        mov     $22, %rdx
        syscall


	movq 	$0, %r14	#row output counter
	movq	$0, %r15	#position in array counter
	
#print 	rownumber
rownum:
	# resets to zero
	movq   	$0, %rbx
	
	# prints balnk line
	movq    $newline, %rdi
        movq    $0, %rax
        call    printf

	# prints the correct row lnumber label 
	movq 	%r14, %rsi
	movq	$fmt_int, %rdi
	movq 	$0, %rax
	call 	printf
	
#proceed to print values of array in row
arylp:
	movq    (%r12, %r15, 1), %rsi
        movq    $fmt_char, %rdi
        movq    $0, %rax
        call    printf

	# increments the array counter to go to the next index/ elements of the array
	incq	%r15
	incq	%rbx
	cmp	$99, %r15
	jg	half
	cmp    $9, %rbx
        jle	arylp

nextrow:
	incq	%r14
	jmp	rownum


half:
	movq    $newline, %rdi
        movq    $0, %rax
        call    printf
#print title of shots board
	movq    $1, %rax
        movq    $1, %rdi
        mov     $msg2, %rsi
        mov     $12, %rdx
        syscall
#print column labels
	movq    $1, %rax
        movq    $1, %rdi
        mov     $strletter, %rsi
        mov     $22, %rdx
        syscall

	movq    $0, %r14        #row counter
        movq    $0, %r15        #array counter
        
#print  rownumber
rownum2:
        movq    $0, %rbx
        movq    $newline, %rdi
        movq    $0, %rax
        call    printf

        movq    %r14, %rsi
        movq    $fmt_int, %rdi
        movq    $0, %rax
        call  	printf
#proceed to print values of array in row
loop:
        movq    (%r13, %r15, 1), %rcx
	movq	%rcx, %rdi
	call 	upper_case
	cmp	$0, %rax
	je	else
	movq	$DOT, %rsi
        movq    $fmt_char, %rdi
        movq    $0, %rax
        call    printf
	jmp	endlp
else:
    	cmpb $MISS, (%r13, %r15, 1)
    	je  else2
	movq	%rcx, %rdi
	call	lower_case
	testq   %rax, %rax
	je	else2
	movq    $HIT, %rsi
        movq    $fmt_char, %rdi
        movq    $0, %rax
        call    printf
        jmp     endlp
else2:
	movq    %rcx, %rsi
        movq    $fmt_char, %rdi
        movq    $0, %rax
        call    printf
endlp:
	incq    %r15
        incq    %rbx
        cmp    $99, %r15
        jg      done
        cmp    $9, %rbx
        jle     loop
nextrow2:
        incq    %r14
        jmp     rownum2

done:   
        movq    $newline, %rdi
        call    puts
	
	leave
	ret


