.set _sigsetjmp, sigsetjmp
.global _sigsetjmp
.set ___sigsetjmp, __sigsetjmp
.global ___sigsetjmp
sigsetjmp:
__sigsetjmp:
	test %esi,%esi
	jz 1f

	popq 64(%rdi)
	mov %rbx,72+8(%rdi)
	mov %rdi,%rbx

	call setjmp@PLT

	pushq 64(%rbx)
	mov %rbx,%rdi
	mov %eax,%esi
	mov 72+8(%rbx),%rbx

	jmp __sigsetjmp_tail

1:	jmp setjmp@PLT
