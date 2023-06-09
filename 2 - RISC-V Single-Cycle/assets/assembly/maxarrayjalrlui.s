.global _boot
.text

_boot:  
    add x8, x0, x0                 
    addi x8, x8, 1
    addi x8, x8, 1
    addi x8, x8, 1
    addi x8, x8, 1
    lui x18, 1000
    jalr x1, x8, 12
