	.text
	.globl mess
.type mess, @function

mess:
	push %rbp
        mov %rsp, %rbp

	movq $1, %rax
        movq $1, %rdi
        mov $message1, %rsi
        mov $56, %rdx
        syscall

	pop %rbp
	ret

message1: .ascii "Aren't you broads a little old to be trick or treating?\n"
