
#define c_int_size 4

.data
.align 2

matrix_ptr: .word -1


.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 48
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 64
# - If you receive an fread error or eof,
#   this function terminates the program with error code 66
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 65
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28             
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    # End Prologue

    # Copy
    mv s0, a0               # Take a copy of file name
    mv s1, a1               # Take a copy of row pointer
    mv s2, a2               # Take a copy of column pointer
    # End of Copy

    mv a1, s0               # Copy address of pointer to the name of file
    li a2, 0                # Make the fiile Read only permission 
    jal ra, fopen           # Open the file
    li t0, -1               # Error code of fopen
    beq t0, a0, file_open_error
    mv s0, a0               # Stores the file identifier number into s0
    mv a1, s0               # File identifier number into a1
    mv a2, s1               # Pointer to row integer into a2
    li a3, c_int_size       # c_int_size number of bytes to read
    jal ra, fread           # Read from file
    li t0, c_int_size       # c_int_size number of bytes that must have been read
    bne t0, a0, file_read_error
    mv a1, s0               # File identifier number into a1
    mv a2, s2               # Pointer to column integer into a2
    li a3, c_int_size       # c_int_size number of bytes to read
    jal ra, fread           # Read from file
    li t0, c_int_size       # c_int_size number of bytes that must have been read
    bne t0, a0, file_read_error
    lw t0, 0(s1)            # Get the number of rows
    lw t1, 0(s2)            # Get the number of columns
    mul s3, t0, t1          # Calculate number of elements in the matrix
    li t0, c_int_size       # c_int_size number of bytes for each number in the matrix
    mul a0, s3, t0          # Calculate total number of bytes that the matrix needs
    jal ra, malloc          # Malloc a space for the matrix in the heap
    beqz a0, malloc_error   # if(malloc return == NULL)
    mv s4, a0               # Copy the address of pointer to the matrix in the heap
    li s5, 0                # Initialize for-loop counter
loop_start:
    bge s5, s3, loop_end    # while(counter < size of the matrix in number integers) 
    slli t0, s5, 2          # calculate the offset
    add a2, s4, t0          # add the offset to the address and store the address in a2 for fread
    mv a1, s0               # File identifier number into a1
    li a3, c_int_size       # c_int_size number of bytes to read
    jal ra, fread           # Read from file
    li t0, c_int_size       # c_int_size number of bytes that must have been read
    bne t0, a0, file_read_error
    addi s5, s5, 1          # increment counter
    j loop_start            # loop back
loop_end:
    mv a1, s0               # Move the file identifier into a1 for fclose
    jal ra, fclose          # Close the opened file
    bnez a0, file_close_error
    mv a0, s4               # Return a pointer to the matrix


j finish
malloc_error:
    li a1, 48               # error code 48
    jal exit2               # exit
file_open_error:
    li a1, 64               # error code 64
    jal exit2               # exit
file_read_error:
    li a1, 66               # error code 66
    jal exit2               # exit
file_close_error:
    li a1, 65               # error code 65
    jal exit2               # exit

finish:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    # End of Epilogue 

    ret
