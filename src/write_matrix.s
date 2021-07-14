
#define c_int_size 4

.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 64
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 67
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 65
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24             
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    # End Prologue

    # Copy
    mv s0, a0               # Take a copy of file name
    mv s1, a1               # Take a copy of start of the matrix in memory
    mv s2, a2               # Take a copy of number of rows
    mv s3, a3               # Take a copy of number of columns
    mul s4, s2, s3          # Calculate Number of elements in the matrix
    # End of Copy

    mv a1, s0               # Copy address of pointer to the name of file
    li a2, 1                # Write only permission 
    jal ra, fopen           # Open the file
    li t0, -1               # Error code of fopen
    beq t0, a0, file_open_error
    mv s0, a0               # Stores the file identifier number into s0
    mv a1, s0               # File identifier number into a1
    addi sp, sp, -4         # Increment stack pointer
    sw s2, 0(sp)            # Save number of rows in stack
    mv a2, sp               # Pass stack which points to number of rows
    li a3, 1                # Write only 1 time
    li a4, c_int_size       # Each element is size of one an int
    jal ra, fwrite          # Write to the file
    addi sp, sp, 4          # Put back stack pointer where it was
    li t0, 1                # Was suppose to write only 1 time
    bne t0, a0, file_write_error
    mv a1, s0               # File identifier number into a1
    addi sp, sp, -4         # Increment stack pointer
    sw s3, 0(sp)            # Save number of rows in stack
    mv a2, sp               # Pass stack which points to number of rows
    li a3, 1                # Write only 1 time
    li a4, c_int_size       # Each element is size of one an int
    jal ra, fwrite          # Write to the file
    addi sp, sp, 4          # Put back stack pointer where it was
    li t0, 1                # Was suppose to write only 1 time
    bne t0, a0, file_write_error
    mv a1, s0               # File identifier number into a1
    mv a2, s1               # Read from matrix address
    mv a3, s4               # Read all element of matrix at once
    li a4, c_int_size       # Each element is size of an int
    jal ra, fwrite          # Write to the file
    bne s4, a0, file_write_error

    mv a1, s0               # Move the file identifier into a1 for fclose
    jal ra, fclose          # Close the opened file
    bnez a0, file_close_error
j finish
file_open_error:
    li a1, 64               # error code 64
    jal exit2               # exit
file_write_error:
    li a1, 67               # error code 67
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
    lw ra, 20(sp)
    addi sp, sp, 24
    # End of Epilogue  

    ret
