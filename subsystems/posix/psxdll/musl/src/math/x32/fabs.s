.set _fabs, fabs
.global _fabs
fabs:
	xor %eax,%eax
	dec %rax
	shr %rax
	movq %rax,%xmm1
	andpd %xmm1,%xmm0
	ret
