.global _boot

.text
_boot:
    jal FindMax

    FindMax:
        lw   s0, 1000(zero)         # maxElement = mem[1000]
        add  s1, zero, zero         # i

        Loop:
            addi s1, s1, 4          # i += 4
            slti t1, s1, 40         # check if 10 elements are traversed (40 = 4 * 10)
            beq  t1, zero, EndLoop  # if 10 elements are traversed, jump to EndLoop
            lw   s2, 1000(s1)       # element = mem[i]
            slt  t1, s0, s2         # check if element is greater than maxElement
            beq  t1, zero, Loop     # if element is not greater than maxElement, jump to Loop
            add  s0, s2, zero       # maxElement = element
            jal  Loop               # jump to Loop

        EndLoop:
            sw s0, 2000(zero)       # mem[2000] = maxElement
            jal End                 # return

    End:
        
