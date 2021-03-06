##############################################
#
# READ ONLY SECTION
#
##############################################
        .section        .rodata
fmt_string: .string "%s"
fmt_prompt: .string "Enter your name: "

###############################################
#
# Text (Code) Segment
#
###############################################
        .text
        .globl 	get_name
        .type   get_name, @function


###############################################


get_name:
        pushq   %rbp
        movq    %rsp, %rbp

        # calls scanf to get user_name
        movq    $fmt_prompt, %rdi
        movq    $0, %rax
        call    printf

        mov     $user_name, %rax
        mov     %rax, %rsi
        mov     $fmt_string, %rdi
        movq    $0, %rax
        call    __isoc99_scanf

        call    getchar

        popq    %rbp
        ret


