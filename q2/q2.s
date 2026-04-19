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
    movq    %rax, -56(%rbp)     # stack base pointer
    movq    $-1,  -64(%rbp)     # stack top index (starts at -1)

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

    # main logic (right to left) [cite: 84]
    movq    %r12, %rbx
    decq    %rbx                # i = len(arr) - 1
.Lmain_loop:
    cmpq    $0, %rbx
    jl      .Lmain_done

.Lwhile:
    # while (!stack.empty() && arr[stack.top()] <= arr[i]) 
    movq    -64(%rbp), %rax     # load stack top index
    cmpq    $-1, %rax           # check if stack is empty
    je      .Lwhile_done
    
    movq    -56(%rbp), %rcx     # stack base
    movq    (%rcx, %rax, 8), %rdx # rdx = stack.top() (the index)
    movq    (%r14, %rdx, 8), %rax # rax = arr[stack.top()] (the value)
    movq    (%r14, %rbx, 8), %rcx # rcx = arr[i] (current value)
    
    cmpq    %rcx, %rax          # compare arr[stack.top()] with arr[i]
    jg      .Lwhile_done        # if arr[stack.top()] > arr[i], stop popping
    
    decq    -64(%rbp)           # stack.pop()
    jmp     .Lwhile
.Lwhile_done:

    # if (!stack.empty()) result[i] = stack.top() [cite: 85]
    movq    -64(%rbp), %rax
    cmpq    $-1, %rax
    je      .Lpush
    
    movq    -56(%rbp), %rcx
    movq    (%rcx, %rax, 8), %rdx # get the index stored at stack top
    movq    %rdx, (%r15, %rbx, 8) # result[i] = index

.Lpush:
    # stack.push(i) [cite: 85]
    incq    -64(%rbp)
    movq    -64(%rbp), %rax
    movq    -56(%rbp), %rcx
    movq    %rbx, (%rcx, %rax, 8)

    decq    %rbx
    jmp     .Lmain_loop
.Lmain_done:

    # print output [cite: 75]
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
    