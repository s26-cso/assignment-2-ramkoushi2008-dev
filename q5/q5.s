startnge:
    li      s2, -1
    la      s3, inputarr
    la      s4, answer
    la      t6, stackarr
    addi    t3, s0, -1

outerloop:
    bltz    t3, printstart

    # current value
    slli    t0, t3, 2
    add     t0, s3, t0
    lw      t4, 0(t0)

poploop:
    bltz    s2, assign

    slli    t0, s2, 2
    add     t0, t6, t0
    lw      t1, 0(t0)

    slli    t0, t1, 2
    add     t0, s3, t0
    lw      t5, 0(t0)

    ble     t5, t4, pop
    j       assign

pop:
    addi    s2, s2, -1
    j       poploop

assign:
    bltz    s2, push

    slli    t0, s2, 2
    add     t0, t6, t0
    lw      t1, 0(t0)

    slli    t0, t3, 2
    add     t0, s4, t0
    sw      t1, 0(t0)

push:
    addi    s2, s2, 1
    slli    t0, s2, 2
    add     t0, t6, t0
    sw      t3, 0(t0)

    addi    t3, t3, -1
    j       outerloop