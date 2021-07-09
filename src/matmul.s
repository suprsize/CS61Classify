.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 34
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 34
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 34
# =======================================================
matmul:

    # Error checks
    bge zero, a1, error  # if(0 < m0Row)
    bge zero, a2, error  # if(0 < m0Col)
    bge zero, a4, error  # if(0 < m1Row)
    bge zero, a5, error  # if(0 < m1Col)
    bne a2, a4, error    # if(m0Col == m1Row)
    jal x0, start
error:  
    addi a1, zero, 34           # error code 34
    jal exit2                   # exit

start:
    # Prologue
    addi sp, sp, -48             
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw ra, 44(sp)
    # End Prologue

    # Copy
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    # End of Copy

    addi s7, zero, 0            # Initialize outer_loop counter
    addi s9, zero, 0            # Initialize output array indexer
outer_loop_start:
    bge s7, s1, outer_loop_end  # while(outerCounter < rows of m0)
    addi t1, zero, 4            # Get a 4 for mul
    mul t0, s2, t1              # Calculate the Stride of m0 for each call to dot
    mul t0, t0, s7              # Calculate the offset
    add s10, s0, t0             # Set the begining of array0 for dot
    addi s8, zero, 0            # Initialize inner_loop counter
inner_loop_start:
    bge s8, s5, inner_loop_end  # while(innerCounter < cols of m1)
    slli t3, s8, 2              # Calculate the offset for m1
    add a1, s3, t3              # Set the address of array1 of m1 (dot arg)
    mv a0, s10                  # Set the begining of array0 (dot arg)
    mv a2, s2                   # Set the length of arrays passed  (dot arg)
    addi a3, zero, 1            # Set the stride of array0 from m0 (dot arg)
    add a4, zero, s5            # set the stride of array1 from m1 (dot arg)
    jal ra, dot                 # call dot
    slli t4, s9, 2              # Calculate offset for array output
    add t4, t4, s6              # Getting element address of array output
    sw a0, 0(t4)                # Saving to array output result of dot product
    addi s8, s8, 1              # Increment inner counter
    addi s9, s9, 1              # Increment output array indexer 
    jal x0, inner_loop_start    # loop back to inner_loop
inner_loop_end:
    addi s7, s7, 1              # Increment outer counter
    jal x0, outer_loop_start    # loop back to outer_loop
outer_loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw ra, 44(sp)
    addi sp, sp, 48
    # End of Epilogue           

    ret
