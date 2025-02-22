	.file	"add.c"
	.intel_syntax noprefix
# GNU C17 (Debian 14.2.0-8) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -fasynchronous-unwind-tables
	.text
	.globl	tambah
	.type	tambah, @function
tambah:
.LFB0:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	mov	DWORD PTR -4[rbp], edi	# a, a
	mov	DWORD PTR -8[rbp], esi	# b, b
# add.c:2:     return a + b;
	mov	edx, DWORD PTR -4[rbp]	# tmp100, a
	mov	eax, DWORD PTR -8[rbp]	# tmp101, b
	add	eax, edx	# _3, tmp100
# add.c:3: }
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE0:
	.size	tambah, .-tambah
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	sub	rsp, 16	#,
# add.c:6:     int a = 4;
	mov	DWORD PTR -4[rbp], 4	# a,
# add.c:7:     int b = 5;
	mov	DWORD PTR -8[rbp], 5	# b,
# add.c:8:     int c = tambah(a, b);
	mov	edx, DWORD PTR -8[rbp]	# tmp100, b
	mov	eax, DWORD PTR -4[rbp]	# tmp101, a
	mov	esi, edx	#, tmp100
	mov	edi, eax	#, tmp101
	call	tambah	#
	mov	DWORD PTR -12[rbp], eax	# c, tmp102
# add.c:9:     return 0;
	mov	eax, 0	# _6,
# add.c:10: }
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Debian 14.2.0-8) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
