section .data
    prompt db "Enter a number: ", 0        ; Input prompt
    result_msg db "Factorial is: ", 0      ; Output message

section .bss
    num resb 1                             ; Reserve space for the input number
    factorial resd 1                       ; Reserve space for the factorial result

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4                             ; syscall: sys_write
    mov ebx, 1                             ; stdout
    mov ecx, prompt                        ; message address
    mov edx, 15                            ; message length
    int 0x80                               ; call kernel to print the prompt

    ; Read input number
    mov eax, 3                             ; syscall: sys_read
    mov ebx, 0                             ; stdin
    mov ecx, num                           ; buffer to store input
    mov edx, 1                             ; number of bytes to read
    int 0x80                               ; call kernel to read input from stdin

    ; Convert input character to integer
    movzx eax, byte [num]                  ; load the input character into eax
    sub eax, '0'                           ; convert ASCII to integer (subtract '0')
    mov ebx, eax                           ; store the number in ebx for use in subroutine

    ; Call factorial subroutine
    push ebx                               ; push input number onto stack (for preservation)
    call factorial_calc                    ; call the factorial calculation subroutine
    add esp, 4                             ; clean up the stack by adjusting the stack pointer

    ; Store result for printing
    mov [factorial], eax                   ; store the factorial result from eax to memory

    ; Display result message
    mov eax, 4                             ; syscall: sys_write
    mov ebx, 1                             ; stdout
    mov ecx, result_msg                    ; message address for factorial result
    mov edx, 14                            ; message length
    int 0x80                               ; call kernel to print the result message

    ; Print result (convert integer to string for display)
    mov eax, [factorial]                   ; load the factorial result from memory
    call print_number                      ; call subroutine to print the number

    ; Exit program
    mov eax, 1                             ; syscall: sys_exit
    xor ebx, ebx                           ; exit code 0
    int 0x80                               ; call kernel to exit the program

; Subroutine: Factorial Calculation
factorial_calc:
    push ebp                               ; save the base pointer (old stack frame)
    mov ebp, esp                           ; set up new base pointer for this function's stack frame
    push ebx                               ; save ebx (caller-saved register)

    mov eax, 1                             ; initialize result to 1 (eax will store the result)
    mov ecx, [ebp+8]                       ; load input number from stack into ecx

.factorial_loop:
    cmp ecx, 1                             ; compare the current value of ecx (input number)
    jle .done                              ; if ecx <= 1, jump to done (exit loop)

    mul ecx                                ; multiply eax by ecx (eax = eax * ecx)
    dec ecx                                ; decrement ecx
    jmp .factorial_loop                    ; repeat the loop

.done:
    pop ebx                                ; restore ebx from stack (preserved value)
    pop ebp                                ; restore the previous base pointer
    ret                                    ; return, with the result in eax

; Subroutine: Print Number (converts integer to string and prints it)
print_number:
    push ebp                               ; save the base pointer (for stack frame preservation)
    mov ebp, esp                           ; set up new base pointer for this function's stack frame
    sub esp, 16                            ; reserve 16 bytes for the number string

    mov edi, esp                           ; pointer to the buffer where the string will be stored
    mov ecx, 10                            ; divisor (base 10 for decimal number)

.convert_loop:
    xor edx, edx                           ; clear edx for division
    div ecx                                ; divide eax by 10, quotient in eax, remainder in edx
    add dl, '0'                            ; convert remainder (digit) to ASCII
    dec edi                                ; move the pointer backward
    mov [edi], dl                          ; store the ASCII character in the buffer
    test eax, eax                          ; check if the quotient is 0 (finished)
    jnz .convert_loop                      ; repeat if quotient is not zero

    ; Print the number string
    mov eax, 4                             ; syscall: sys_write
    mov ebx, 1                             ; stdout
    mov ecx, edi                           ; pointer to the number string
    mov edx, esp                           ; calculate string length by subtracting buffer start from current pointer
    sub edx, edi
    int 0x80                               ; call kernel to print the number

    add esp, 16                            ; clean up stack space used for the buffer
    pop ebp                                ; restore base pointer
    ret                                    ; return from the subroutine
