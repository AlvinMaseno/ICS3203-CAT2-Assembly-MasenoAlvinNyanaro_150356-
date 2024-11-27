section .data
    msg_prompt db "Input a number: ", 0     ; Prompt message for the user
    msg_positive db "Number is POSITIVE.", 0 ; Message for positive numbers
    msg_negative db "Number is NEGATIVE.", 0 ; Message for negative numbers
    msg_zero db "Number is ZERO.", 0         ; Message for zero

section .bss
    user_input resb 10   ; Reserve 10 bytes for user input

section .text
    global _start

_start:
    ; Display a prompt to the user
    mov eax, 4             ; Syscall to write
    mov ebx, 1             ; File descriptor for stdout
    mov ecx, msg_prompt    ; Address of the prompt message
    mov edx, 17            ; Length of the message
    int 0x80               ; Make the syscall

    ; Read user input from stdin
    mov eax, 3             ; Syscall to read
    mov ebx, 0             ; File descriptor for stdin
    mov ecx, user_input    ; Buffer to store input
    mov edx, 10            ; Max buffer size
    int 0x80               ; Make the syscall

    ; Convert input to an integer
    mov esi, user_input    ; Address of the input buffer
    xor eax, eax           ; Clear EAX (accumulator for the number)
    xor ebx, ebx           ; Clear EBX (unused here but kept for clarity)

convert_loop:
    movzx ecx, byte [esi]  ; Load a byte from the input buffer
    cmp ecx, 10            ; Check if it's a newline character
    je evaluate_number     ; If newline, jump to classification logic
    sub ecx, '0'           ; Convert ASCII to numeric digit
    imul eax, eax, 10      ; Shift accumulator by 10 (multiply)
    add eax, ecx           ; Add the digit to the accumulator
    inc esi                ; Move to the next character in the buffer
    jmp convert_loop ; Unconditional jump to continue conversion

evaluate_number:
    ; Check if the number is zero, positive, or negative
    cmp eax, 0
    je case_zero           ; Jump to handle zero if EAX == 0
    jg case_positive       ; Jump to handle positive if EAX > 0
    jmp case_negative      ; Unconditional jump to handle negative

case_positive:
    ; Display message for positive numbers
    mov eax, 4             ; Syscall to write
    mov ebx, 1             ; File descriptor for stdout
    mov ecx, msg_positive  ; Address of the positive message
    mov edx, 22            ; Length of the message
    int 0x80               ; Make the syscall
    jmp end_program        ; Unconditional jump to terminate

case_negative:
    ; Display message for negative numbers
    mov eax, 4             ; Syscall to write
    mov ebx, 1             ; File descriptor for stdout
    mov ecx, msg_negative  ; Address of the negative message
    mov edx, 22            ; Length of the message
    int 0x80               ; Make the syscall
    jmp end_program        ; Unconditional jump to terminate

case_zero:
    ; Display message for zero
    mov eax, 4             ; Syscall to write
    mov ebx, 1             ; File descriptor for stdout
    mov ecx, msg_zero      ; Address of the zero message
    mov edx, 18            ; Length of the message
    int 0x80               ; Make the syscall

end_program:
    ; Exit the program
    mov eax, 1             ; Syscall to exit
    xor ebx, ebx           ; Exit status 0
    int 0x80               ; Make the syscall


