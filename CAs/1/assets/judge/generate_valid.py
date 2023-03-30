import subprocess

while True:
    subprocess.run(['python', '.\generate.py'])
    subprocess.run(['python', '.\intelligent_rat.py'])
    
    with open("result.txt") as file:
        line = file.readline()
        if line != "No solution":
            break
                
    
    

    