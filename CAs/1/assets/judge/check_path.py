
class color:
   GREEN = '\033[92m'
   BASE = '\033[0m'

dick = {"up": [0,-1], "right": [1,0], "left": [-1,0], "down": [0, 1]}

sth = []
num = int(input("number of test: "))

def print_maze(maze):
    for row in maze:
        print ((" ".join(row)).replace('M', color.GREEN + 'M' + color.BASE))


maze = []
with open(f"../maps/maps with solution/map_{num}.txt") as file:
    for line in file:
        line = line.rstrip()
        maze.append(list(line))


x , y = 0 ,0
maze[0][0] = 'M'
with open(f"../maps/maps with solution/result_{num}.txt") as file:
    for line in file:
        line = line.rstrip()
        x += dick[line][0]
        y += dick[line][1]
        maze[y][x] = 'M'
        
print_maze(maze)