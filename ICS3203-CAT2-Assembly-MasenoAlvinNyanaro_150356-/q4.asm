section .data
    sensor_reading db 20      ; Simulated sensor reading (e.g., 20 = low, 60 = high)
    motor_state db 0          ; 0 = motor OFF, 1 = motor ON
    alarm_state db 0          ; 0 = no alarm, 1 = alarm triggered

section .text
    global _start

_start:
    ; Read the simulated sensor value (from the data section)
    mov al, [sensor_reading]   ; Load sensor reading into AL register

    ; Compare the sensor value to determine the appropriate action
    cmp al, 50
    jg trigger_alarm_action    ; If sensor value > 50, trigger the alarm

    cmp al, 30
    jge stop_motor_action      ; If sensor value >= 30, stop the motor

    ; If sensor value < 30, turn motor ON
    mov byte [motor_state], 1  ; Set motor_state to 1 (Motor ON)
    jmp end_program             ; Skip further checks

trigger_alarm_action:
    ; If sensor value is high (greater than 50), trigger the alarm
    mov byte [alarm_state], 1  ; Set alarm_state to 1 (Alarm triggered)
    jmp end_program             ; Skip further checks

stop_motor_action:
    ; If sensor value is moderate (between 30 and 50), stop the motor
    mov byte [motor_state], 0  ; Set motor_state to 0 (Motor OFF)

end_program:
    ; Save motor state to another register to avoid overwriting AL
    mov bl, [motor_state]       ; Load motor state into BL register

    ; Print motor status (ON/OFF)
    call display_motor_status

    ; Save alarm state to another register
    mov bl, [alarm_state]       ; Load alarm state into BL register

    ; Print alarm status (Triggered/Not Triggered)
    call display_alarm_status

    ; Exit program
    mov eax, 1                  ; Syscall: exit
    xor ebx, ebx                ; Exit code 0
    int 0x80                    ; Call kernel to exit the program

; Subroutine: Print Motor Status (ON/OFF)
display_motor_status:
    cmp bl, 1                   ; Check if motor_state is 1 (Motor ON)
    je motor_on                 ; If yes, jump to motor_on

    ; If motor is OFF
    mov eax, 4                  ; Syscall: sys_write
    mov ebx, 1                  ; File descriptor: stdout
    mov ecx, motor_off_msg      ; Load "Motor OFF" message
    mov edx, 20                 ; Message length
    int 0x80                    ; Call kernel to print message
    ret

motor_on:
    ; If motor is ON
    mov eax, 4                  ; Syscall: sys_write
    mov ebx, 1                  ; File descriptor: stdout
    mov ecx, motor_on_msg       ; Load "Motor ON" message
    mov edx, 20                 ; Message length
    int 0x80                    ; Call kernel to print message
    ret

; Subroutine: Print Alarm Status (Triggered/Not Triggered)
display_alarm_status:
    cmp bl, 1                   ; Check if alarm_state is 1 (Alarm Triggered)
    je alarm_triggered          ; If yes, jump to alarm_triggered

    ; If alarm is not triggered
    mov eax, 4                  ; Syscall: sys_write
    mov ebx, 1                  ; File descriptor: stdout
    mov ecx, alarm_not_triggered_msg ; Load "Alarm Not Triggered" message
    mov edx, 30                 ; Message length
    int 0x80                    ; Call kernel to print message
    ret

alarm_triggered:
    ; If alarm is triggered
    mov eax, 4                  ; Syscall: sys_write
    mov ebx, 1                  ; File descriptor: stdout
    mov ecx, alarm_triggered_msg    ; Load "Alarm Triggered" message
    mov edx, 30                 ; Message length
    int 0x80                    ; Call kernel to print message
    ret

section .data
    motor_on_msg db 'Motor Status: ON', 0xA
    motor_off_msg db 'Motor Status: OFF', 0xA
    alarm_triggered_msg db 'Alarm Status: Triggered', 0xA
    alarm_not_triggered_msg db 'Alarm Status: Not Triggered', 0xA
