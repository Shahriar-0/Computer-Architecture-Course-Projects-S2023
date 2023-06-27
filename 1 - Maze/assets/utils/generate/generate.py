import random

lst = ["%04x" % random.randrange(16**4) for _ in range(16)]

while lst[0][0] in ["8", "9", "a", "b", "c", "d", "e", "f"]:
    lst[0] = "%04x" % random.randrange(16**4)

while lst[-1][-1] in ["1", "3", "5", "7", "9", "b", "d", "f"]:
    lst[-1] = "%04x" % random.randrange(16**4)

with open("../../code/maze.dat", "wb") as result_file:
    for line in lst:
        result_file.write(f"{line}\n".encode("utf-8"))


ls = [["0" for _ in range(16)] for i in range(16)]
with open("../../code/maze.dat") as input_file:
    done = 0
    for line in input_file:
        x = bin(int(line.rstrip(), 16))[2:]
        ls[done][-len(x) :] = x
        done += 1

with open("map.txt", "wb") as map:
    for line in ls:
        map.write(f"{''.join(line)}\n".encode("utf-8"))
