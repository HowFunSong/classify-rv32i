.globl argmax
.globl utils
.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1
loop_start:
    # TODO: Add your own implementation
    beq  t2, a1, done  
    slli t3, t2, 2
    add  t3, a0, t3
    lw   t3, 0(t3)

    addi t2, t2, 1
    slt  t4, t0, t3 
    beq  t4,  x0, loop_start
    add  t0,  x0, t3
    addi  t1,  t2, -1
    j    loop_start

done:
    # Epilogue
    add  a0, x0, t1 
    jr ra

handle_error:
    li a0, 36
    j exit