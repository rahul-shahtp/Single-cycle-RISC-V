# RISC-V Assembly Code demonstrating all instruction types
.data
    array: .word 10, 20, 30, 40
    result: .word 0

.text
.globl main

main:
    # Initialize registers
    li x5, 7            
    li x6, 9
    li x7, 10
    
    # R-Type Instructions (Register-Register operations)
    add x8, x5, x6      #x8 = x5 + x6 = 7 + 9 = 16
    sub x9, x5, x7      #x9 = x5 - x7 = 7 - 10 = -3
    and x10, x5, x6     #x10 = x5 & x6 (bitwise AND)
    or x11, x5, x6      #x11 = x5 | x6 (bitwise OR)
    xor x12, x5, x6     #x12 = x5 ^ x6 (bitwise XOR)
    slt x13, x7, x5     #x13 = 1 if x7 < x5, else 0 (10 < 7 = false, so 0)
    
    # I-Type Instructions (Immediate operations)
    addi x14, x5, 20    # x14 = x5 + 20 = 7 + 20 = 27
    andi x15, x5, 7     # x15 = x5 & 7 (bitwise AND with immediate)
    ori x16, x5, 8      # x16 = x5 | 8 (bitwise OR with immediate)
    xori x17, x5, 3     # x17 = x5 ^ 3 (bitwise XOR with immediate)
    slti x18, x5, 20    # x18 = 1 if x5 < 20, else 0 (7 < 20 = true, so 1)
    
    # Load/Store Instructions
    la x19, array       # Load address of array
    lw x20, 0(x19)      # I-Type: Load word from array[0]
    lw x21, 4(x19)      # Load word from array[1]
    
    # S-Type Instruction (Store)
    la x22, result
    sw x20, 0(x22)      # Store x20 to result address
    
    # B-Type Instructions (Conditional branches)
    beq x5, x5, equal_label    # Branch if x5 == x5 (always true)
    
equal_label:
    bne x5, x6, not_equal      # Branch if x5 != x6 (7 != 9, true)
    
not_equal:
    blt x7, x5, less_than      # Branch if x7 < x5 (10 < 7, false - skip)
    bge x5, x7, greater_equal  # This executes (7 >= 10, false - skip)
    
less_than:
    # U-Type Instruction (Upper immediate)
    lui x23, 0x12345    # Load upper immediate: x23 = 0x12345000
    
    # J-Type Instruction (Jump)
    jal x24, function   # Jump and link to function
    
after_function:
    # JALR - I-Type jump instruction
    la x25, end_program
    jalr x26, 0(x25)    # Jump to address in x25
    
function:
    addi x27, x0, 100   # Do some work in function
    jalr x0, 0(x24)     # Return using JALR (jump to address in x24)
    
greater_equal:
    # U-Type Instruction (Upper immediate)
    lui x23, 0x12345    # Load upper immediate: x23 = 0x12345000
    
    # J-Type Instruction (Jump)
    jal x24, function   # Jump and link to function
    
end_program:
    # Exit program
    li a7, 10           # syscall for exit
    ecall