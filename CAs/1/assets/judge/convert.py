dick = {"00": "up", "01": "right", "10": "left", "11": "down"}

sth = []
with open("../../code/result.txt") as file:
    for line in file:
        print(line)
        x = dick[line.rstrip()]
        sth.append(x)
        
with open("verilog_result.txt", "wb") as file2:
    for x in sth:
        file2.write(f"{x}\n".encode("utf-8"))
    