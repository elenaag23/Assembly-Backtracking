.data
	formatScanf: .asciz "%s"
	formatPrintf: .asciz "%d "
	formatPrintfchr: .asciz "%c"
	formatNewLine: .asciz "\n"
	sir: .space 130
	chDelim: .asciz " "
	n: .long 5
	m: .long 1
	ok: .long 1
	k: .space 4 
	i: .long 1
	trein: .space 4
	t: .space 4
	contor: .long 1
	elem_curent: .space 4
	new: .asciz "\n"
	p: .space 4
	v: .space 1000
	unu: .long 1
	doi: .long 2
	pf: .space 4
	minus: .long 45

.text

afisare:
	movl $1, %ecx
	
next:
	pushl %ecx

	cmp trein, %ecx
	ja end
	
	movl (%esi, %ecx, 4), %eax
	
	pushl %eax
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx
	
	popl %ecx
	incl %ecx
	jmp next

end:
	pushl $formatNewLine
	call printf
	popl %ebx

	popl %ebx
	ret
		

ok_proc:
	pushl %ebp
	movl %esp, %ebp
	pushl %edi

	pushl %esi

debug_1:	
	movl 8(%ebp), %eax
	movl %eax, k
	
	movl (%esi, %eax, 4), %ebx
	movl %ebx, elem_curent
	
	
	cmp m ,%eax
	ja scadere
	
	movl $0, t
	movl $1, p
	movl $0, contor
	jmp ok_for
	
scadere:
	movl $1, p
	subl m, %eax
	movl %eax, t
	movl $0, contor
	
	
ok_for:
	movl p, %ecx
	cmp %ecx, k
	je end_ok_1
	
	
	movl (%esi, %ecx, 4), %eax
	cmp %eax, elem_curent
	je incrementare
	
	
	jmp ok_for_nou
	
incrementare:
	cmp t, %ecx
	jae end_ok_0
	
	incl contor
	movl contor, %ebx
	cmp $3, %ebx
	jae end_ok_0
	
	jmp ok_for_nou

ok_for_nou:
	incl p
	jmp ok_for

end_ok_2:
	movl $2, %eax
	popl %esi
	popl %edi
	popl %ebp
	ret
		
end_ok_1:
	movl $1, %eax
	popl %esi
	popl %edi
debug_2:
	popl %ebp
	ret
	
end_ok_0:
	cmp $1, pf
	je end_ok_2
	
	movl $0, %eax
	popl %esi
	popl %edi
	popl %ebp
	ret	
	
bkt:
	pushl %ebp
	movl %esp, %ebp
	pushl %edi
	
	
	movl 8(%ebp), %eax 
	movl %eax, k
	movl $1, i

	
	movl (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je not_punct
	
	movl $1, pf
	movl %ebx, (%esi, %eax, 4)
	jmp verificare
	
not_punct:
	movl $0, pf

	
bkt_for:
	
	movl i, %ecx
	cmp %ecx, n
	jb final_bkt
	
	movl k, %ecx
	movl i, %eax
	movl %eax, (%esi, %ecx, 4)

verificare:
		
	pushl k
	call ok_proc
	popl %ebx
	
iesire:	
	cmp $1, %eax
	je sol
	
	cmp $2, %eax
	je inapoi
	
bkt_for_nou:
	incl i
	jmp bkt_for

inapoi:
	movl k, %ecx
	movl (%edi, %ecx, 4), %eax
	cmp $0, %eax
	jne back
	
	movl (%esi, %ecx, 4), %ebx
	cmp %ebx, n
	jne creste

back:	
	decl k
	jmp inapoi

creste:	
	incl %ebx
	movl %ebx, i
	movl (%edi, %ecx, 4), %ebx
	cmp $0, %ebx
	jne punct
	
	movl $0, pf
	jmp bkt_for
	
 
punct:
	movl $1, pf
	jmp verificare
	
sol:
	movl k, %eax
	cmp %eax, trein
	je afis
	
	jmp bkt_nou
	
afis:
	call afisare
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
	

bkt_nou:
	incl k
	
	pushl k
	call bkt
	popl %ebx
	
	
final_bkt:
	movl k, %ecx
	cmp %ecx, n
	jne inapoi
	
	popl %edi
	popl %ebp
	ret

.global main

main: 

citire:
	
	pushl $sir
	call gets
	popl %ebx
	

afis_n:
	
	pushl $chDelim
	pushl $sir
	call strtok 
	popl %ebx
	popl %ebx
	
	pushl %eax
	call atoi
	popl %ebx
	
	
	movl %eax, n

	
afis_m:

	pushl $chDelim
	pushl $0
	call strtok 
	popl %ebx
	popl %ebx
	
	pushl %eax
	call atoi
	popl %ebx
	
	movl %eax, m
	
	lea v, %esi


vector:

	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 
	
	cmp $0, %eax
	je start_bkt
	
	pushl %eax
	call atoi
	popl %ebx
	
adaugare:	
	movl contor, %ecx
	incl contor
	
	movl %eax, (%edi, %ecx, 4)
		
	jmp vector

start_bkt:

	movl n, %eax
	addl n, %eax
	addl n, %eax
	movl %eax, trein

	
	pushl $1
	call bkt
	popl %ebx

	
exit:
	pushl minus
	pushl $formatPrintfchr
	call printf
aici:
	popl %ebx
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx
	
	pushl $1
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	
	pushl $formatNewLine
	call printf
	popl %ebx
	
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
	
