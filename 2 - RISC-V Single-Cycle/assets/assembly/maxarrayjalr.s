.global _boot

.text
_boot:

_boot:                   
    addi x8, x8, 1
    addi x8, x8, 1
    addi x8, x8, 1
    jalr x1, x8, 10
    lui x18, 1000
