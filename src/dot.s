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
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0         # sum   
    li t1, 0         # counter
    li s0, 0
    li s1, 0
loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    add s0, s0, a3
    add s1, s1, a4

    ; add s3, x0, s0
    ; add s4, x0, s1

    slli s3, s0, 2
    slli s4, s1, 2

    add  s3, a0, s3
    add  s4, a1, s4
    
    lw   s3, 0(s3)
    lw   s4, 0(s4)

    jal  i_mul

    add t0, a0, t0
    addi t1, t1, 1
    j    loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit


i_mul:
    addi sp,sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    # do mul
    
    # do mul
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp,sp, 24

    jr ra