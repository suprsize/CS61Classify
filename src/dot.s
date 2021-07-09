.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 33
# =======================================================
dot:

    bge zero, a2, length_error  # if(0 < arrayLength)
    bge zero, a3, stride_error  # if(0 < array0Stride)
    bge zero, a4, stride_error  # if(0 < array1Stride)
    jal x0, start
length_error:  
    addi a1, zero, 32           # error code 32
    jal exit2                   # exit
stride_error:
    addi a1, zero, 33           # error code 33
    jal exit2                   # exit


start:
    # Prologue
    addi sp, sp, -8             
    sw s0, 0(sp)
    sw s1, 4(sp)
    # End Prologue
    addi t0, zero, 0            # Initialize for-loop counter
    addi t1, zero, 0            # Initialize the sum to zero
    addi t2, zero, 4            # Loading a 4 for multiplying
    mul a3, a3, t2              # Increasing the stride by 4 for offset
    mul a4, a4, t2              # Increasing the stride by 4 for offset
loop_start:
    bge t0, a2, loop_end        # while(counter < arrayLength)
    mul t2, t0, a3              # offset0 = i * stride0
    mul t3, t0, a4              # offset1 = i * stride1
    add t4, a0, t2              # Calculate the address of first array value
    add t5, a1, t3              # Calculate the address of second array value
    lw s0, 0(t4)                # Loading the value of first array
    lw s1, 0(t5)                # Loading the value of second array
    mul t6, s0, s1              # Calculating the product of two values
    add t1, t1, t6              # Adding the product of the total sum 
    addi t0, t0, 1              # Increment counter
    jal x0, loop_start          # Loop back
loop_end:   
    mv a0, t1                   # Return total sum by moving it to a0
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    # End Epilogue

    ret
