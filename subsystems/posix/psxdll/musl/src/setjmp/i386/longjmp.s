.set __longjmp, _longjmp
.global __longjmp
.set _longjmp, longjmp
.global _longjmp
_longjmp:
longjmp:
	mov  4(%esp),%edx
	mov  8(%esp),%eax
	cmp       $1,%eax
	adc       $0, %al
	mov   (%edx),%ebx
	mov  4(%edx),%esi
	mov  8(%edx),%edi
	mov 12(%edx),%ebp
	mov 16(%edx),%esp
	jmp *20(%edx)
