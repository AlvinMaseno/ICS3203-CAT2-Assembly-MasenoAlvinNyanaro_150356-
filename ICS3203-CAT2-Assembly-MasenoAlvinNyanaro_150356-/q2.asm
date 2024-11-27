section .data
    input_prompt db "Enter 5 integers: ", 0         ; Prompt for user input
    input_prompt_len equ $ - input_prompt            ; Length of the prompt message
    reversed_message db "Reversed array: ", 0       ; Message to indicate reversed array
    reversed_message_len equ $ - reversed_message   ; Length of the reversed array message
    numbers_array times 5 dd 0                       ; Space for 5 integers

section .bss
    input_buffer resb 16                             ; Buffer to store input

section .text
    global _start

_start:
    ; Print input prompt
    mov eax, 4               ; Syscall: write
    mov ebx, 1               ; File descriptor: stdout
    mov ecx, input_prompt    ; Address of the input prompt
    mov edx, input_prompt_len ; Length of the input prompt
    int 0x80                 ; Invoke syscall

    ; Read 5 integers into the array
    mov ecx, 5               ; Loop counter for 5 integers
    lea esi, [numbers_array] ; Load address of the numbers array
read_loop:
    ; Clear the input buffer
    mov eax, 3               ; Syscall: read
    mov ebx, 0               ; File descriptor: stdin
    lea edx, [input_buffer]   ; Address of the input buffer
    mov edi, 16              ; Maximum input length
    int 0x80                 ; Invoke syscall

    ; Check if input was successfully read
    test eax, eax            ; If eax is 0, no bytes were read
    jz reverse_array         ; Jump to reversal if no bytes read

    ; Null-terminate the input string
    mov byte [input_buffer + eax - 1], 0

    ; Convert input string to integer
    call string_to_int       ; Convert the input to integer
    mov [esi], eax           ; Store the integer in the array
    add esi, 4               ; Move to the next array element

    dec ecx                  ; Decrement loop counter
    jnz read_loop            ; Repeat if counter is not zero

reverse_array:
    ; Reverse the array in place
    ; The challenge here is to swap elements in memory without using extra space.
    ; We manipulate the array directly using two pointers: one starting at the beginning
    ; and the other at the end. After each swap, the pointers move towards the middle.
    lea esi, [numbers_array]  ; Load address of the first element (start pointer)
    lea edi, [numbers_array + 16] ; Load address of the last element (end pointer)

reverse_loop:
    cmp esi, edi            ; If start pointer >= end pointer, stop
    jge done_reversing       ; If pointers crossed, finish reversing

    ; Swap the values at start and end pointers
    mov eax, [esi]          ; Load value at start pointer
    mov ebx, [edi]          ; Load value at end pointer
    mov [esi], ebx          ; Store end value at start pointer
    mov [edi], eax          ; Store start value at end pointer

    add esi, 4              ; Move start pointer forward
    sub edi, 4              ; Move end pointer backward
    jmp reverse_loop        ; Repeat the loop

done_reversing:
    ; Output reversed array message
    mov eax, 4               ; Syscall: write
    mov ebx, 1               ; File descriptor: stdout
    mov ecx, reversed_message ; Address of the reversed array message
    mov edx, reversed_message_len ; Length of the message
    int 0x80                 ; Invoke syscall

    ; Print the reversed array
    lea esi, [numbers_array] ; Load address of the first element
    mov ecx, 5               ; Loop counter for 5 elements
print_loop:
    mov eax, [esi]           ; Load integer to print
    call int_to_string       ; Convert integer to string
    mov eax, 4               ; Syscall: write
    mov ebx, 1               ; File descriptor: stdout
    lea edx, [input_buffer]   ; Address of the buffer with the string
    mov ecx, 16              ; Max string length
    int 0x80                 ; Invoke syscall

    add esi, 4               ; Move to the next integer in the array
    dec ecx                  ; Decrement the loop counter
    jnz print_loop           ; Repeat until all integers are printed

    ; Exit the program
    mov eax, 1               ; Syscall: exit
    xor ebx, ebx             ; Exit code 0
    int 0x80                 ; Invoke syscall

; Convert string to integer
string_to_int:
    xor eax, eax             ; Clear eax (result)
    xor ebx, ebx             ; Clear ebx (temporary digit)
    xor ecx, ecx             ; Clear ecx (sign)
    lea edx, [input_buffer]  ; Load address of the input string

    ; Check for optional '+' or '-'
    mov cl, [edx]            ; Load first character
    cmp cl, '-'              ; Check for negative sign
    jne check_plus
    mov ecx, -1              ; Set sign to negative
    inc edx                  ; Move past the negative sign
    jmp start_conversion
check_plus:
    cmp cl, '+'              ; Check for positive sign
    jne start_conversion
    inc edx                  ; Move past the plus sign

start_conversion:
    xor ecx, ecx             ; Default sign is positive
convert_loop:
    mov cl, [edx]            ; Load the current character
    cmp cl, 0                ; Check for null terminator
    je end_string_to_int     ; End if null terminator

    sub cl, '0'              ; Convert ASCII to numeric value
    cmp cl, 9
    ja end_string_to_int     ; End if invalid digit

    mov ebx, eax             ; Store current result in ebx
    imul eax, eax, 10        ; Multiply by 10
    add eax, ebx             ; Add the digit value

    inc edx                  ; Move to the next character
    jmp convert_loop

end_string_to_int:
    cmp ecx, -1              ; Check for negative sign
    jne done_string_to_int
    neg eax                  ; Negate result for negative numbers
done_string_to_int:
    ret

; Convert integer to string
int_to_string:
    xor ebx, ebx             ; Clear ebx
    xor ecx, ecx             ; Clear ecx
    lea edx, [input_buffer]  ; Load address of output buffer

    cmp eax, 0
    jge skip_negative
    mov byte [edx], '-'      ; Add '-' for negative numbers
    inc edx                  ; Move buffer pointer
    neg eax                  ; Convert to positive
skip_negative:
    xor ebx, ebx
store_digits:
    xor edx, edx             ; Clear edx for division
    mov ebx, 10
    div ebx                  ; Divide eax by 10, quotient in eax, remainder in edx
    add dl, '0'              ; Convert digit to ASCII
    push dx                  ; Store digit on stack (reversed order)
    inc ecx                  ; Increment digit counter
    test eax, eax            ; Check if quotient is 0
    jnz store_digits

write_digits:
    pop dx
    mov [edx], dl            ; Write ASCII character to buffer
    inc edx
    loop write_digits

    mov byte [edx], 0        ; Null-terminate the string
    ret
