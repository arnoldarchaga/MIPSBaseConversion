.data
promptN:       .asciiz "Enter number of digits (n): "
promptB:       .asciiz "Enter base b (2..10): "
promptDigit:   .asciiz "Enter digit Xi: "
errorDigit:    .asciiz "ERROR: Digit >= base.\n"
resultMsg:     .asciiz "Decimal result = "
newline:       .asciiz "\n"

.text
.globl main

# MAIN PROGRAM:
# 1) Prompts for n, b
# 2) Loops n times to read each digit Xi
# 3) For each digit, compute b^i by repeated multiplication
# 4) Accumulate Xi * (b^i) into decimalResult
# 5) Print final decimalResult

main:
    # Prompt user for n (number of digits)
    la   $a0, promptN         # address of promptN string
    li   $v0, 4               # syscall: print string
    syscall

    li   $v0, 5               # syscall: read int
    syscall
    move $t0, $v0             # t0 = n

    # Prompt user for base b
    la   $a0, promptB
    li   $v0, 4
    syscall

    li   $v0, 5
    syscall
    move $t1, $v0             # t1 = b  (2..10)

    # decimalResult in t2
    li   $t2, 0               # decimalResult = 0

    # i will track the exponent from 0..(n-1)
    li   $s0, 0               # i = 0

loop_read_digit:
    bge  $s0, $t0, done       # if i >= n => done

    # Prompt for the digit Xi
    la   $a0, promptDigit
    li   $v0, 4
    syscall

    li   $v0, 5               # read int
    syscall
    move $t3, $v0             # t3 = digit Xi

    # Check if Xi >= b => error
    blt  $t3, $t1, valid_digit   # if t3 < b => valid
    # else print error
    la   $a0, errorDigit
    li   $v0, 4
    syscall
    j    loop_read_digit       # go back to read digit again

valid_digit:
    # Compute b^i => store in t4
    li   $t4, 1            # power = 1
    li   $t5, 0            # counter = 0
power_loop:
    bge  $t5, $s0, power_done   # if t5 >= i => done
    mul  $t4, $t4, $t1          # power *= b
    addi $t5, $t5, 1            # counter++
    j    power_loop
power_done:

    # partial_result = Xi * power
    mul  $t6, $t3, $t4

    # decimalResult += partial_result
    add  $t2, $t2, $t6

    # i++
    addi $s0, $s0, 1
    j    loop_read_digit

done:
    # Print final result
    la   $a0, resultMsg
    li   $v0, 4
    syscall

    move $a0, $t2        # decimalResult
    li   $v0, 1          # print int
    syscall

    la   $a0, newline
    li   $v0, 4
    syscall

    # Exit
    li   $v0, 10
    syscall
