org 100h    

mov dx, offset msg           
mov ah, 9                    
int 21h
                       
mov cx, 0
mov dx, offset filename
mov ah, 3ch
int 21h
jc exit
mov file, ax

main:

    mov ah, 03h            
    mov bh, 0
    int 10h
    mov curpx, dl
    mov curpy, dh
     
    mov ah, 7  
    int 21h                       
    mov char, al

    cmp char, 7eh
    jna valid                   
jmp main

valid:
    cmp char, 1bh
    je exit
                           
    mov ah, 08h
    int 10h
    mov curc, al
    
    cmp char, 20h              
    jl spcl
    
    cmp curc, 00h
    jg main

    mov dl, char           
    mov ah, 2
    int 21h
    
    write:           
        mov bx, file
        mov cx, 1 
        mov dx, offset char
        mov ah, 40h
        int 21h
        jc exit
        jmp main
    
draw:
    mov ah, 9     
    int 21h
    jmp write


spcl:   
    cmp char, 01h
    je left                    

    cmp char, 04h
    je right
    
    cmp char, 17h
    je up
    
    cmp char, 13h
    je down
    
    cmp curc, 00h
    jg main
    
    cmp char, 0dh
    je enter
    
    cmp char, 08h
    je backs
     
    jmp main

enter:
    mov dx, offset ent
    jmp draw

backs:
    mov dx, offset bcspc
    mov ah, 9
    int 21h                 
    
    mov al, 1
	mov bx, file
	mov cx, 0
	mov dx, -1
	mov ah, 42h
	pusha
	int 21h
    jc exit
           
    mov cx, 1
    mov dx, " "
    mov ah, 40h
    int 21h
    jc exit       
           
    popa
	int 21h
	
	jmp main


left:
    dec curpx
    jmp move
    
right:
    inc curpx
    jmp move


up:
    dec curpy
    jmp move

down:
    inc curpy
    jmp move


move:
    mov dh, curpy
    mov dl, curpx
    mov bh, 0
    mov ah, 2
    int 10h
    jmp main

exit:
mov ah, 3eh
mov bx, file
int 21h
ret

char db ?
curpx db ?
curpy db ?
file dw ?
curc db ? 
filename db "notas_output.txt", 0

msg db "[Notas++]"
    db "[../emu8086/notas_output.txt]"
    db "[Cltr + a,s,d,w | Esc - sair]"
    db ,0ah, 0ah, 0dh, "$"

ent db 0ah, 0dh, "$"
bcspc db 08h, 00h, 08h, "$"