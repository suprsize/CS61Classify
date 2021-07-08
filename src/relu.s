.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# ==============================================================================
relu:
    # Prologue

    addi t0, x0, 0
    addi t1, x0, 0
loop_start:
	bge t0, a1, loop_end
	slli t2, t0, 2
	add  t3, a0, t2
    lw t4, 0(t3)
    bge t4, zero, loop_continue
	sw zero, 0(t3)
loop_continue:
	addi t0, t0, 1
	jal x0 loop_start
loop_end:


    # Epilogue

	ret
