import random
lst = ['%04x' % random.randrange(16**4) for _ in range(16)]
with open("../code/maze.dat", "wb") as result_file:
    for line in lst:
        result_file.write(f"{line}\n".encode("utf-8")) 