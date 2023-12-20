.section ".text.Mtest"
	.globl Mtest
	Mtest:

    # a0 = int a[]
    # a1 = int size
    # t0 = ret
    # t1 = i
    li    t0, 0        # ret = 0
    li    t1, 0        # i = 0
    li    a0, 0x80010000
    li    a2, 0x80010000
    li    a1, 8
    
data:  # For loop
    bge   t1, a1, reset   # if i >= size, break
    slli  t2, t1, 3    # Multiply i by 4 (1 << 2 = 4)
    add   t2, a0, t2   # Update memory address
    sw    a2, 0(t2)    # Dereference address to get integer
    sub   a2, a2, a0
    addi  t1, t1, 1    # Increment the 
    j data
reset:
    li    t0, 0        # ret = 0
    li    t1, 0        # i = 0
    li    a0, 0x80010000
    

bubsort:
    # a0 = long *list
    # a1 = size
    # t0 = swapped
    # t1 = i
start: # do loop
    li t0, 0          # swapped = false
    li t1, 1          # i = 1
loop: # for loop
    bge t1, a1, return   # break if i >= size
    slli t3, t1, 3    # scale i by 8 (for long)
    add t3, a0, t3    # new scaled memory address
    lw  t4, -8(t3)    # load list[i-1] into t4
    lw  t5, 0(t3)     # load list[i] into t5
    ble t4, t5, loop_return    # if list[i-1] < list[i], it's in position
    # if we get here, we need to swap
    li  t0, 1         # swapped = true
    sw  t4, 0(t3)     # list[i] = list[i-1]
    sw  t5, -8(t3)    # list[i-1] = list[i]
loop_return: # bottom of for loop body
    addi t1, t1, 1    # i++
    j    loop           # loop again
return: # bottom of do loop body
    bnez t0, start       # loop if swapped = true
    addi s11, x0, 17

	j infiniiity_loooop
