
#define c_int_size 4
#define c_expected_argc 5

.data
.align 2

m0_row: .word -1
m0_col: .word -1
m1_row: .word -1
m1_col: .word -1
input_row: .word -1
input_col: .word -1

.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 35
    # - If malloc fails, this function terminates the program with exit code 48
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


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

    li t0, c_expected_argc
    bne a0, t0, incorrect_argc_error

    # Copy
    mv s0, a2
    lw s1, 4(a1)    # m0 path
    lw s2, 8(a1)    # m1 path
    lw s3, 12(a1)   # input path
    lw s4, 16(a1)   # output path
    # End of Copy



	# =====================================
    # LOAD MATRICES
    # =====================================







    # Load pretrained m0

    mv a0, s1
    la a1, m0_row
    la a2, m0_col
    jal ra, read_matrix
    mv s1, a0



    # Load pretrained m1

    mv a0, s2
    la a1, m1_row
    la a2, m1_col
    jal ra, read_matrix
    mv s2, a0



    # Load input matrix


    mv a0, s3
    la a1, input_row
    la a2, input_col
    jal ra, read_matrix
    mv s3, a0

    la t6, m0_row
    lw t0, 0(t6)
    la t6, m0_col
    lw t1, 0(t6)
    la t6, m1_row
    lw t2, 0(t6)
    la t6, m1_col
    lw t3, 0(t6)
    la t6, input_row
    lw t4, 0(t6)
    la t6, input_col
    lw t5, 0(t6)
    ebreak

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)













    


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax




    # Print classification
    



    # Print newline afterwards for clarity


j finish
incorrect_argc_error:
    li a1, 35               # error code 35
    jal exit2               # exit
malloc_error:
    li a1, 48               # error code 48
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
