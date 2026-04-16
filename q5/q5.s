.text
.globl main
.extern fopen
.extern fseek
.extern ftell
.extern fgetc
.extern fclose
.extern printf

.data
fname: .string "input.txt"
mode:  .string "r"
yes:   .string "Yes\n"
no:    .string "No\n"

.text

main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)
    sd s4, 0(sp)

    la a0, fname
    la a1, mode
    call fopen
    mv s0, a0

    beqz s0, print_no

    mv a0, s0
    li a1, 0
    li a2, 2
    call fseek

    mv a0, s0
    call ftell
    mv s2, a0

    addi s2, s2, -1

check:
    bltz s2, print_yes

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc

    li t0, 10
    beq a0, t0, skip
    j start

skip:
    addi s2, s2, -1
    j check

start:
    li s1, 0

loop:
    bge s1, s2, print_yes

    mv a0, s0
    mv a1, s1
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv s3, a0

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv s4, a0

    bne s3, s4, print_no

    addi s1, s1, 1
    addi s2, s2, -1
    j loop

print_yes:
    la a0, yes
    call printf
    j end

print_no:
    la a0, no
    call printf

end:
    mv a0, s0
    call fclose

    li a0, 0

    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    addi sp, sp, 48
    ret
