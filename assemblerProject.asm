org 100h

section .text
start:

main_loop:
    mov ah, 9
    mov dx, start_text
    int 21h

    xor ax, ax
    xor dx, dx
    xor cx, cx   

    mov ah, 1

input_char:
    int 21h

    cmp al, 0
    je special_key

    cmp al, 32           
    je end_program_message

    cmp al, 13           
    je input_word2

    cmp al, 48
    jb invalid_char
    cmp al, 57
    jbe valid_char

    cmp al, 65
    jb invalid_char
    cmp al, 90
    jbe valid_char

    cmp al, 97
    jb invalid_char
    cmp al, 122
    jbe valid_char

    jmp invalid_char

input_word2:
    int 21h

    cmp al, 32           
    je end_program_message

    cmp al, 13           
    je check_enter

    cmp al, 48
    jb invalid_char
    cmp al, 57
    jbe valid_word2_char

    cmp al, 65
    jb invalid_char
    cmp al, 90
    jbe valid_word2_char

    cmp al, 97
    jb invalid_char
    cmp al, 122
    jbe valid_word2_char

    jmp invalid_char

check_enter:
    cmp cx, 0            
    je empty_enter_error        

check_word_length:
    sub cx, bx
    cmp cx, bx
    jne unequal_length
    add cx, bx
    mov bx, 0

save_to_stack:
    pop ax
    mov [buffer + bx], al
    inc bx
    loop save_to_stack

print_result:
    mov si, bx
    shr bx, 1
    mov ah, 2

display_from_buffer:
    dec si
    dec bx
    cmp si, bx
    je main_loop
    inc bx
    mov dl, [buffer + si]
    int 21h
    sub si, bx
    mov dl, [buffer + si]
    int 21h
    add si, bx
    jmp display_from_buffer

special_key:
    mov ah, 1
    int 21h
    cmp ah, 75
    je invalid_char
    cmp ah, 77
    je invalid_char
    cmp ah, 72
    je invalid_char
    cmp ah, 80
    je invalid_char
    cmp ah, 82
    je invalid_char
    cmp ah, 83
    je invalid_char
    cmp ah, 65
    je invalid_char
    cmp ah, 66
    je invalid_char
    cmp ah, 67
    je invalid_char
    cmp ah, 68
    je invalid_char
    jmp main_loop

empty_enter_error:
    mov ah, 9
    mov dx, empty_enter_text
    int 21h
    jmp main_loop

invalid_char:
    mov ah, 9
    mov dx, invalid_key_message
    int 21h
    jmp main_loop

valid_char:
    push ax
    inc cx
    mov bx, cx
    jmp input_char

valid_word2_char:
    push ax
    inc cx
    jmp input_word2

unequal_length:
    mov ah, 9
    mov dx, unequal_length_message
    int 21h
    jmp main_loop

end_program_message:
    call print_end_message
    jmp program_end

print_end_message:
    mov ah, 9
    mov dx, end_text
    int 21h
    ret

program_end:
    mov ax, 4c00h
    int 21h

section .data
buffer db 255 dup(0)
start_text db 10, 13, "Enter two words of the same length (no special characters):", 10, 13, "$"
invalid_key_message db "Invalid key pressed. Use only letters or digits.$"
unequal_length_message db "The lengths of the words are different. Try again.$"
empty_enter_text db "Two empty enters were entered. Try again.$"
end_text db "Program ended.$"
