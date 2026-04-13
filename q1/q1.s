.text

.globl makenode
makenode:
    # Creates a new BST node with the given value

    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    mv s0, a0
    li a0, 24
    call malloc
    sw s0, 0(a0)
    sd zero, 8(a0)
    sd zero, 16(a0)
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    ret

.globl insert
insert:
    # Inserts a value into the BST recursively.or new node or no chagne

    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    mv s0, a0
    mv s1, a1          # value to insert
    bne s0, zero, 1f
    mv a0, s1
    call make_node
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    addi sp, sp, 48
    ret
1:
    lw t0, 0(s0)       # current node value
    beq s1, t0, 3f
    blt s1, t0, 2f
    ld a0, 16(s0)
    mv a1, s1
    call insert
    sd a0, 16(s0)
    j 3f
2:
    ld a0, 8(s0)
    mv a1, s1
    call insert
    sd a0, 8(s0)
3:
    mv a0, s0
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    addi sp, sp, 48
    ret

.globl get
get:
    # Searches for a value in the BST.
   
    beq a0, zero, 1f
    lw t0, 0(a0)       # current node value
    beq a1, t0, 1f
    blt a1, t0, 2f
    ld a0, 16(a0)
    j get
2:
    ld a0, 8(a0)
    j get
1:
    ret

.globl getAtMost
getAtMost:
    # Finds the greatest value in the BST that is less than or equal to the target.
   #best,target,current
    li t2, -1         
    mv t1, a0        
    mv t0, a1          
1:
    beq t0, zero, 2f
    lw t3, 0(t0)
    beq t3, t1, 3f
    blt t3, t1, 4f
    ld t0, 8(t0)
    j 1b
4:
    mv t2, t3
    ld t0, 16(t0)
    j 1b
3:
    mv t2, t3
2:
    mv a0, t2
    ret