from time import sleep
import os


class color:
    GREEN = "\033[92m"
    RED = "\033[91m"
    BASE = "\033[0m"


dick = {"up": [0, -1], "right": [1, 0], "left": [-1, 0], "down": [0, 1]}

sth = []
num = int(input("number of test: "))

maze = []
with open(f"../maps/maps with solution/map_{num}.txt") as file:
    for line in file:
        line = line.rstrip()
        maze.append(list(line))


def print_maze(maze):
    os.system("cls")
    for row in maze:
        print(
            (" ".join(row))
            .replace("x", color.GREEN + "◎" + color.BASE)
            .replace("M", color.RED + "●" + color.BASE)
        )


x, y = 0, 0
maze[0][0] = "x"
with open(f"../maps/maps with solution/result_{num}.txt") as file:
    for line in file:
        print_maze(maze)
        maze[y][x] = "M"
        line = line.rstrip()
        x += dick[line][0]
        y += dick[line][1]
        maze[y][x] = "x"
        sleep(1 / 3)

print_maze(maze)
