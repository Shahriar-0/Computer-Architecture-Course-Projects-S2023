# with assumption that A is an array of 32-bit integers and is stored in s0
# if not stored in s0 and is in storage we use lui and addi to store it in s0
add s1, zero, zero # i to iterare

add t0, zero, 1000 # loops condition

LOOP_I:
    bge s1, t0, END_LOOP_I # check condition 

    add s2, s1, zero # j to iterate

    LOOP_J:
        bge s2, t0, END_LOOP_J # check condition

        sli t0, s1, 2 # cause it's 32-bit which means 4-byte, so the address is changed 4 times of i
        add t0, t0, s0 # find address of A[i]

        sli t1, s2, 2 # same as above for j
        add t1, t1, s0 # find address of A[j]

        lw t2, 0(t0) # load A[i]
        lw t3, 0(t1) # load A[j]

        bge t2, t3, END_IF # check nested if condition

        SWAP:
            add t4, t2, zero # temp = A[i]
            add t2, t3, zero # A[i] = A[j]
            add t3, t4, zero # A[j] = temp
            sw t3, 0(t1) # store A[i]
            sw t4, 0(t2) # store A[j]

        END_IF:
            addi s2, s2, 1 # j++
            j LOOP_J

    END_LOOP_J:
        addi s1, s1, 1 # i++
        j LOOP_I

END_LOOP_I:
    # REST OF THE PROGRAM