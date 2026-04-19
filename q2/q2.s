.section .note.GNU-stack,"",@progbits

.section .data
fmt_d:   .string "%d"
space:   .string " "
newline: .string "\n"

.section .text
.globl main

main:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %r15
    pushq   %r14
    pushq   %r13
    pushq   %r12
    pushq   %rbx
    subq    $24, %rsp

    movq    %rdi, %r12          # argc
    movq    %rsi, %r13          # argv
    subq    $1,   %r12          # n = argc - 1

    testq   %r12, %r12
    jz      .Lexit

    # allocate arr
    movq    %r12, %rdi
    shlq    $3,   %rdi
    call    malloc
    movq    %rax, %r14

    # allocate result
    movq    %r12, %rdi
    shlq    $3,   %rdi
    call    malloc
    movq    %rax, %r15

    # init result with -1
    xorq    %rbx, %rbx
.Linit:
    cmpq    %r12, %rbx
    jge     .Linit_done
    movq    $-1, (%r15, %rbx, 8)
    incq    %rbx
    jmp     .Linit
.Linit_done:

    # stack array
    movq    %r12, %rdi
    shlq    $3,   %rdi
    call    malloc
    movq    %rax, -56(%rbp)
    movq    $-1,  -64(%rbp)

    # parse input
    xorq    %rbx, %rbx
.Lparse:
    cmpq    %r12, %rbx
    jge     .Lparse_done
    movq    8(%r13, %rbx, 8), %rdi
    call    atoi
    cltq
    movq    %rax, (%r14, %rbx, 8)
    incq    %rbx
    jmp     .Lparse
.Lparse_done:

    # main logic (right to left)
    movq    %r12, %rbx
    decq    %rbx
.Lmain_loop:
    cmpq    $0, %rbx
    jl      .Lmain_done

.Lwhile:
    cmpq    $-1, -64(%rbp)
    je      .Lwhile_done
    movq    -64(%rbp), %rax
    movq    -56(%rbp), %rcx
    movq    (%rcx, %rax, 8), %rax
    movq    (%r14, %rax, 8), %rax
    movq    (%r14, %rbx, 8), %rcx
    cmpq    %rcx, %rax
    jg      .Lwhile_done
    decq    -64(%rbp)
    jmp     .Lwhile
.Lwhile_done:

    cmpq    $-1, -64(%rbp)
    je      .Lpush
    movq    -64(%rbp), %rax
    movq    -56(%rbp), %rcx
    movq    (%rcx, %rax, 8), %rax
    movq    %rax, (%r15, %rbx, 8)
    #movq (%r14, %rax, 8), %rax   # get value from arr[index] index->value
    #movq %rax, (%r15, %rbx, 8)
.Lpush:
    incq    -64(%rbp)
    movq    -64(%rbp), %rax
    movq    -56(%rbp), %rcx
    movq    %rbx, (%rcx, %rax, 8)

    decq    %rbx
    jmp     .Lmain_loop
.Lmain_done:

    # print output
    xorq    %rbx, %rbx
.Lprint:
    cmpq    %r12, %rbx
    jge     .Lprint_done

    testq   %rbx, %rbx
    jz      .Lno_space
    leaq    space(%rip), %rdi
    xorl    %eax, %eax
    call    printf
.Lno_space:

    movq    (%r15, %rbx, 8), %rsi
    leaq    fmt_d(%rip), %rdi
    xorl    %eax, %eax
    call    printf

    incq    %rbx
    jmp     .Lprint
.Lprint_done:
    leaq    newline(%rip), %rdi
    xorl    %eax, %eax
    call    printf

.Lexit:
    xorl    %eax, %eax
    addq    $24, %rsp
    popq    %rbx
    popq    %r12
    popq    %r13
    popq    %r14
    popq    %r15
    popq    %rbp
    ret 
