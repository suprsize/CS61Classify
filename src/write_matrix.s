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
    mv s0, a0               # Take a copy of file name
    mv s1, a1               # Take a copy of start of the matrix in memory
    mv s2, a2               # Take a copy of number of rows
    mv s3, a3               # Take a copy of number of columns
    # End of Copy

    mv a1, s0               # Copy address of pointer to the name of file
    li a2, 1                # Write only permission 
    jal ra, fopen           # Open the file
    li t0, -1               # Error code of fopen
    beq t0, a0, file_open_error
    mv s0, a0               # Stores the file identifier number into s0






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
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw ra, 44(sp)
    addi sp, sp, 48
    # End of Epilogue  

    ret
