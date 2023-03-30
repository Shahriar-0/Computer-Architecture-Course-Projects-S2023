# let's danceeeeeeeeeeeeeeeeeeeeeeeeee
import sys
sys.setrecursionlimit(20000)

moves = [(0, -1), (1, 0), (-1, 0), (0, 1)]
dick = {(0, -1): "up", (1, 0): "right", (-1, 0): "left", (0, 1): "down"}

# ls = [['0' for _ in range(16)] for i in range(16)]

# with open("../../code/maze.dat") as input_file:
#     done = 0
#     for line in input_file:
#         x = bin(int(line.rstrip(), 16))[2:]
#         ls[done][-len(x):] = x 
#         done += 1

ls: list[list[str]] = []
with open("map.txt") as map:
    for line in map:
        ls.append(list(line.rstrip()))


result = []

def backtrack(x = 0, y = 0) -> bool:
    if x < 0 or x > 15 or y < 0 or y > 15 or ls[x][y] == '1':
        return False
    
    # print(f"x is: {x}, y is: {y}")
    
    if x == 15 and y == 15:
        return True
    
    for move in moves:
        ls[x][y] = '1'
        x += move[0]
        y += move[1]
        result.append(dick[move])
        if backtrack(x, y):
            return True
        
        x -= move[0]
        y -= move[1]
        ls[x][y] = '0'
        result.pop()
        
    return False

with open("result.txt", "wb") as result_file:
    if not backtrack():
        print("not found!")
        result_file.write(f"No solution".encode("utf-8"))
    else:
        print("found!")
        for x in result:
            result_file.write(f"{x}\n".encode("utf-8"))
            