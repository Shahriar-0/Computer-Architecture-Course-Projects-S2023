andi 0           # R0 = 0
mvto R7          # R7 = 0 (const)
addi 1024        # R0 = 1024
add R0           # R0 = 2048
add R0           # R0 = 4096
add R0           # R0 = 8192
add R0           # R0 = 16384
add R0           # R0 = 32768
mvto R6          # R6 = 0x8000 (const)

load 300         # R0 = M[300]
mvto R1          # R1 = M[300] (max)
andi 0           # R0 = 0
mvto R2          # R2 = 0 (maxIdx)


load 301         # R0 = M[301]
mvto R4          # R4 = M[301] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt01  # R0 == 0
jump end01

gt01:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 01      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end01:


load 302         # R0 = M[302]
mvto R4          # R4 = M[302] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt02  # R0 == 0
jump end02

gt02:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 02      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end02:


load 303         # R0 = M[303]
mvto R4          # R4 = M[303] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt03  # R0 == 0
jump end03

gt03:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 03      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end03:


load 304         # R0 = M[304]
mvto R4          # R4 = M[304] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt04  # R0 == 0
jump end04

gt04:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 04      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end04:


load 305         # R0 = M[305]
mvto R4          # R4 = M[305] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt05  # R0 == 0
jump end05

gt05:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 05      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end05:


load 306         # R0 = M[306]
mvto R4          # R4 = M[306] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt06  # R0 == 0
jump end06

gt06:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 06      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end06:


load 307         # R0 = M[307]
mvto R4          # R4 = M[307] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt07  # R0 == 0
jump end07

gt07:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 07      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end07:


load 308         # R0 = M[308]
mvto R4          # R4 = M[308] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt08  # R0 == 0
jump end08

gt08:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 08      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end08:


load 309         # R0 = M[309]
mvto R4          # R4 = M[309] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt09  # R0 == 0
jump end09

gt09:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 09      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end09:


load 310         # R0 = M[310]
mvto R4          # R4 = M[310] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt10  # R0 == 0
jump end10

gt10:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 10      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end10:


load 311         # R0 = M[311]
mvto R4          # R4 = M[311] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt11  # R0 == 0
jump end11

gt11:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 11      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end11:


load 312         # R0 = M[312]
mvto R4          # R4 = M[312] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt12  # R0 == 0
jump end12

gt12:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 12      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end12:


load 313         # R0 = M[313]
mvto R4          # R4 = M[313] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt13  # R0 == 0
jump end13

gt13:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 13      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end13:


load 314         # R0 = M[314]
mvto R4          # R4 = M[314] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt14  # R0 == 0
jump end14

gt14:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 14      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end14:


load 315         # R0 = M[315]
mvto R4          # R4 = M[315] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt15  # R0 == 0
jump end15

gt15:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 15      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end15:


load 316         # R0 = M[316]
mvto R4          # R4 = M[316] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt16  # R0 == 0
jump end16

gt16:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 16      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end16:


load 317         # R0 = M[317]
mvto R4          # R4 = M[317] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt17  # R0 == 0
jump end17

gt17:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 17      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end17:


load 318         # R0 = M[318]
mvto R4          # R4 = M[318] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt18  # R0 == 0
jump end18

gt18:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 18      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end18:


load 319         # R0 = M[319]
mvto R4          # R4 = M[319] (temp)
sub R1           # R0 = temp - max
and R6           # R0 & 0x8000 (keep MSB)
branch R7, gt19  # R0 == 0
jump end19

gt19:
    mvfrom R4    # R0 = temp
    mvto R1      # max = temp
    andi 0       # R0 = 0
    addi 19      # R0 = 1
    mvto R2      # R2 = 1 (maxIdx)

end19:


mvfrom R1        # R0 = max
store 400        # M[400] = max
mvfrom R2        # R0 = maxIdx
store 404        # M[404] = maxIdx
