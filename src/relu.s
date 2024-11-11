.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    beq  t1, a1, done  # if t1 to end, done
    slli t2, t1, 2   # index offset -> byte offset

    add  t2, a0, t2  # t2 = address of a[i+idx]
    lw   t3, 0(t2)   # value of a[i+idx]
    
    bge  t3, x0, skip_relu

relu_start:
    sw   x0, 0(t2)     

skip_relu:
    addi t1, t1, 1
    j loop_start


done:
    jr ra

error:
    li a0, 36          
    j exit          
