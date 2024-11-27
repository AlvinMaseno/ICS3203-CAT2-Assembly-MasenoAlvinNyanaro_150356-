
# ICS3203-CAT2-Assembly Programming

## Overview

This repository contains solutions for the ICS3203 CAT2 assignments in Assembly Programming. Each task demonstrates different aspects of assembly language programming, including control flow, array manipulation, modular programming with subroutines, and data monitoring with control actions. Below is an overview of the individual tasks.

### 1. **Control Flow and Conditional Logic (Task 1)**

This program prompts the user for a number and classifies it as **"POSITIVE"**, **"NEGATIVE"**, or **"ZERO"** based on the value entered. The program uses both conditional and unconditional jumps to handle these cases effectively.

### 2. **Array Manipulation with Looping and Reversal (Task 2)**

This program accepts an array of integers from the user, reverses the array in place, and outputs the reversed array. It uses loops for the reversal process and avoids using additional memory to store the reversed array.

### 3. **Modular Program with Subroutines for Factorial Calculation (Task 3)**

This program computes the factorial of a number entered by the user. The factorial calculation is done using a subroutine, and the program demonstrates how the stack is used to preserve registers during function calls.

### 4. **Data Monitoring and Control Using Port-Based Simulation (Task 4)**

This program simulates a water level sensor. Based on the sensor value, it performs actions such as:
- Turning the motor **ON/OFF**
- Triggering an **alarm** if the water level is too high
- Stopping the motor if the water level is moderate

---

## Instructions for Compiling and Running the Code

### **Compiling the Code**

To compile the Assembly programs, you need to have **NASM** (Netwide Assembler) installed on your system.

1. **Install NASM**:
   - On Linux:
     ```bash
     sudo apt install nasm
     ```
   - On Windows: Download the NASM installer from [nasm.us](https://www.nasm.us/) and follow the installation instructions.

2. **Assemble the code using NASM**:
   ```bash
   nasm -f elf64 <filename>.asm -o <filename>.o
   ```

3. **Link the object file using LD**:
   ```bash
   ld <filename>.o -o <filename>
   ```

### **Running the Code**

To run the program, execute the generated binary:
```bash
./<filename>
```

For each program:
- **Task 1** will prompt you for a number, classify it, and display the result.
- **Task 2** will reverse the array and display the reversed values.
- **Task 3** will compute the factorial of the entered number and display the result.
- **Task 4** will simulate a sensor, control a motor, and trigger an alarm based on the sensor input.

---

## Insights and Challenges Encountered

### **Task 1: Control Flow and Conditional Logic**

- **Insights**: Reinforced understanding of conditional jumps (`je`, `jg`, `jge`) and unconditional jumps (`jmp`). These instructions are critical in assembly for making decisions and controlling program flow.
- **Challenges**: Managing multiple conditions required careful handling of registers. Debugging and testing each condition ensured accurate classification of the number.

### **Task 2: Array Manipulation with Looping and Reversal**

- **Insights**: Strengthened understanding of array manipulation in assembly and in-place memory operations.
- **Challenges**: Avoiding extra memory usage for storing the reversed array required precise pointer management and memory addressing.

### **Task 3: Factorial Calculation with Subroutines**

- **Insights**: Demonstrated modular programming through subroutines, showing how to preserve register states using the stack.
- **Challenges**: Ensuring proper stack management and register preservation (e.g., `ebx` and `eax`) during subroutine calls.

### **Task 4: Data Monitoring and Control Using Port-Based Simulation**

- **Insights**: Provided experience in simulating sensor data and implementing control actions (e.g., motor operations and alarms) based on input.
- **Challenges**: Properly interpreting sensor values and triggering the correct actions required meticulous memory and condition handling.

---
