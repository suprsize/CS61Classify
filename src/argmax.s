.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# =================================================================
argmax:

    addi t0, zero, 0			# Initialize for-loop counter
    addi t1, zero, 0			# Initialize the index of max to zeroth element
    lw t5 0(a0)					# Initialize the max to be the zeroth element
    addi t6, zero, 1			# Get a one for comparison
    bge a1, t6, loop_start		# if(arrayLength < 1)	
    addi a1, zero, 32			# error code 32
    jal exit2					# exit
loop_start:
    bge t0, a1, loop_end		# while(counter < arrayLength)
    slli t2, t0, 2				# calculate the offset
    add  t3, a0, t2				# add the offset to the array head address
    lw t4, 0(t3)				# load the value
    bge t5, t4, loop_continue	# if(currentMax < loadedValue)
    mv t5, t4					# currentMax = loadedValue
    mv t1, t0					# maxIndex = currentIndex
loop_continue:
    addi t0, t0, 1				# increment counter
    jal x0 loop_start			# loop back
loop_end:
    # Epilogue
    mv a0, t1					# copy the maxIndex
    ret
