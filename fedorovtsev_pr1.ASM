;���������� ����� ������������

format binary as 'img'   ;����� ������ �� ����� .bin ���� .img
org 0x7C00     ;��������� ���������� ������ ���������
jmp start

;�����
msg1 db "Fedorovtsev", 0
msg2 db "Danil", 0
msg3 db "Vyaceslavovich", 0
msg4 db "NMT-313901", 0         


;����� ��������� �����
start:
    cli
    mov ax, 0
    mov ss, ax
    mov sp, 0xFFFF
    sti

    mov ax, 0x13        ; ������������ ������
    int 0x10
    mov ax, 0x0010      ; ��������� ������������ ������ ������
    int 0x10

push 520        ; ������ �� �
push 280        ; ������ �� �
push 80        ; ������ �� �
push 50         ; ������ �� �
push 6          ; ���� ����� ����� (����������)
call RisOval ; ����� �������

; ��������� ����� ����
    mov ah, 0x0B        ; ������� ��� ��������� ����� ����
    mov bl, 0x3        ; ��������� ���� ����
    int 0x10

;����� ������
    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x15    ;���������� ���� ������
    mov dl, 3       ;�������
    mov dh, 2       ;������
    push cs
    pop es
    mov bp, msg1
    mov cx, 11
    int 0x10

    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x15
    mov dl, 3
    mov dh, 3
    push cs
    pop es
    mov bp, msg2
    mov cx, 5
    int 0x10

    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x15
    mov dl, 3
    mov dh, 4
    push cs
    pop es
    mov bp, msg3
    mov cx, 14
    int 0x10

    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x15
    mov dl, 3
    mov dh, 5
    push cs
    pop es
    mov bp, msg4
    mov cx, 10          
    int 0x10

;����������� ����
hang:
    jmp hang

; ������� ��������� �����
RisOval:
push bp
mov bp, sp
sub sp, 2         ; ��������� �����(2 �����) ��� ��������� ����������

;���������� �������� ���������� ���� ��� ��������� �����
fld1
fadd st, st
fadd st, st
fimul word [bp+8]
fldpi
fdivrp

fldz             ; �������� 0.0 �� ������� ����� FPU

;��������� �������� ���������
mov cx, [bp+8]
shl cx, 3
xor bh, bh
mov ax, [bp+4]
mov ah, 0ch

;����, ������� ������ ������ �� ������
@@: push cx          ; ���������� �������� �����
    fld st
    fsincos
    fimul word [bp+8]
    fistp word [bp-2]
    mov cx, [bp-2]
    add cx, [bp+12]
    fimul word [bp+6]
    fistp word [bp-2]
    mov dx, [bp-2]
    add dx, [bp+10]
    int 10h             
    fadd st, st1
    pop cx
    loop @b

;�������������� �������� ��������� � ������� �� ������� � ��������� ������ �� �����
mov sp, bp      
pop bp
ret 10     ;�������� 10 ������ ������ �� �����

; ���������� ���������� ���� ������������ ������� ������
times 510-($-$$) db 0
; ������� ����������
dw 0xAA55