;Федоровцев Данил Вячеславович

format binary as 'img'   ;сразу делает из файла .bin файл .img
org 0x7C00     ;установка начального адреса программы
jmp start

;текст
msg1 db "Fedorovtsev", 0
msg2 db "Danil", 0
msg3 db "Vyaceslavovich", 0
msg4 db "NMT-313901", 0         


;Общая настройка стека
start:
    cli
    mov ax, 0
    mov ss, ax
    mov sp, 0xFFFF
    sti

    mov ax, 0x13        ; Переключение режима
    int 0x10
    mov ax, 0x0010      ; Установка графического режима текста
    int 0x10

push 520        ; начало по х
push 280        ; начало по у
push 80        ; радиус по х
push 50         ; радиус по у
push 6          ; Цвет линии овала (коричневый)
call RisOval ; Вызов функции

; Установка цвета фона
    mov ah, 0x0B        ; Функция для установки цвета фона
    mov bl, 0x3        ; Бирюзовый цвет фона
    int 0x10

;Вывод текста
    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x15    ;фиолетовый цвет текста
    mov dl, 3       ;столбец
    mov dh, 2       ;строка
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

;Бесконечный цикл
hang:
    jmp hang

; Функция рисования овала
RisOval:
push bp
mov bp, sp
sub sp, 2         ; Выделение места(2 байта) для локальной переменной

;Вычисление значения приращения угла для рисования овала
fld1
fadd st, st
fadd st, st
fimul word [bp+8]
fldpi
fdivrp

fldz             ; Загрузка 0.0 на вершину стека FPU

;установка значений регистров
mov cx, [bp+8]
shl cx, 3
xor bh, bh
mov ax, [bp+4]
mov ah, 0ch

;Цикл, который рисует эллипс на экране
@@: push cx          ; Сохранение счетчика цикла
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

;Восстановление значений регистров и возврат из функции с удалением памяти из стека
mov sp, bp      
pop bp
ret 10     ;удаление 10 байтов памяти из стека

; Заполнение оставшихся байт загрузочного сектора нулями
times 510-($-$$) db 0
; Подпись загрузчика
dw 0xAA55