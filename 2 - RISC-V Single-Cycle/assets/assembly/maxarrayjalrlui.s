.global _boot
.text

_boot:                   
    addi x8, x8, 1
    addi x8, x8, 1
    addi x8, x8, 1
    lui x18, 1000
    jalr x1, x8, 12
