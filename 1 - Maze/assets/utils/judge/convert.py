dick = {
    "00": "up", 
    "01": "right", 
    "10": "left", 
    "11": "down"
}

sth = []
with_solution, num = map(
    int, input("1 for with solution otherwise 0, number of test: ").split()
)
directory_name = "maps with solution" if with_solution else "maps without solution"


with open(f"../maps/{directory_name}/code_result_{num}.txt") as file:
    for line in file:
        line = line.rstrip()
        if not line in dick:
            continue
        x = dick[line]
        sth.append(x)

with open("verilog_result_converted.txt", "wb") as file2:
    for x in sth:
        file2.write(f"{x}\n".encode("utf-8"))
