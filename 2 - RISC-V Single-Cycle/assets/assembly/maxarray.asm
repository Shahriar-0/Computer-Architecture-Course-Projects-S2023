jal X1, Main

FindMax:
    lw X8, 1000(X0)       # array address   
    add X9, X0, X0        # i             

    Loop:
        addi X9, X9, 4             

    EndLoop:
        sw X8, 2000(X0)        
        jalr X0, X1, Loop                


Main:
    jal X1, FindMax                
