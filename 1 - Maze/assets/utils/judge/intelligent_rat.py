# let's dance :)
import sys

sys.setrecursionlimit(20000)

moves = [(-1, 0), (0, 1), (0, -1), (1, 0)]
dick = {(-1, 0): "up", (0, 1): "right", (0, -1): "left", (1, 0): "down"}

ls: list[list[str]] = []
with open("map.txt") as map:
    for line in map:
        ls.append(list(line.rstrip()))

result = []


def backtrack(x=0, y=0) -> bool:
    if x < 0 or x > 15 or y < 0 or y > 15 or ls[x][y] == "1":
        return False

    if x == 15 and y == 15:
        return True

    for move in moves:
        ls[x][y] = "1"
        x += move[0]
        y += move[1]
        result.append(dick[move])
        if backtrack(x, y):
            return True

        x -= move[0]
        y -= move[1]
        ls[x][y] = "0"
        result.pop()

    return False


with open("result.txt", "wb") as result_file:
    if not backtrack():
        print("not found!")
        result_file.write("No solution".encode("utf-8"))
    else:
        print("found!")
        for i in result:
            result_file.write(f"{i}\n".encode("utf-8"))
