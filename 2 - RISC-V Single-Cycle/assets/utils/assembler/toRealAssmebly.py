import sys

input_file = sys.argv[1]
output_file = sys.argv[2]

registers = [
    "zero",
    "ra",
    "sp",
    "gp",
    "tp",
    "t0",
    "t1",
    "t2",
    "s0",
    "s1",
    "a0",
    "a1",
    "a2",
    "a3",
    "a4",
    "a5",
    "a6",
    "a7",
    "s2",
    "s3",
    "s4",
    "s5",
    "s6",
    "s7",
    "s8",
    "s9",
    "s10",
    "s11",
    "t3",
    "t4",
    "t5",
    "t6",
]

with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
    for line in f_in:
        parts = line.split("#", 1)
        for reg in registers:
            parts[0] = parts[0].replace(reg, "x" + str(registers.index(reg)))
        f_out.write("#".join(parts))
