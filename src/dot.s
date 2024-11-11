.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    addi sp, sp, -24         # Allocate space on the stack
    sw ra, 0(sp)             # Save return address
    sw s0, 4(sp)             # Save s0
    sw s1, 8(sp)             # Save s1
    sw s2, 12(sp)            # Save s2
    sw s3, 16(sp)
    sw s4, 20(sp)

    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  
    
    # 現在會修改到a0 -> error!!!
    li t0, 0                # Initialize sum
    li t1, 0                # Initialize counter
    li s0, 0                # Offset for arr0
    li s1, 0                # Offset for arr1
    li s2, 0                # Initialize result accumulator (sum)
    mv s3, a0
    mv s4, a1

loop_start:
    bge t1, a2, loop_end    # If counter >= element count, exit loop


    slli t2, s0, 2          # Convert offset to byte offset for arr0
    slli t3, s1, 2          # Convert offset to byte offset for arr1

    add t2, s3, t2          # Calculate effective address for arr0[i * stride0]
    add t3, s4, t3          # Calculate effective address for arr1[i * stride1]
    
    lw t2, 0(t2)            # Load value from arr0[i * stride0]
    lw t3, 0(t3)            # Load value from arr1[i * stride1]
    
    mv a0, t2               # 將 pass t2 -> a0
    mv a1, t3               # 將 pass t3 -> a1
    
    jal ra, i_mul           # Call i_mul to multiply a0 and a1
    add s2, a0, s2          # Accumulate result

    addi t1, t1, 1          # Increment loop counter
    add s0, s0, a3          # Update offset for arr0
    add s1, s1, a4          # Update offset for arr1
    
    j loop_start            # Repeat loop

loop_end:
    mv a0, s2               # Store final sum in a0

    # Restore saved registers before return
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)

    addi sp, sp, 24         # Deallocate stack space
    jr ra                   # Return from function

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit

exit:
    mv a1, a0
    li a0, 17
    ecall

# Multiplication
i_mul:
    addi sp,sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    
    mv s0, a0            # s0 = multiplicand (value of a0)
    mv s1, a1            # s1 = multiplier (value of a1)
    addi a0, x0, 0             # Initialize result to 0

multiply_loop:
    andi t0, s1, 1       # Check if the least significant bit of s1 is 1
    beq t0, x0, skip_add # If LSB is 0, skip addition
    add a0, a0, s0      # Add s2 to result if LSB is 1

skip_add:
    slli s0, s0, 1       # left shift s0 (multiplicand) by 1 (x2) 
    srli s1, s1, 1       # right shift s1 (multiplier) by 1 (>>1)
    bnez s1, multiply_loop  # Repeat loop if s is not zero

end_mul:
    # Restore registers in i_mul
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp,sp, 12

    jr ra
