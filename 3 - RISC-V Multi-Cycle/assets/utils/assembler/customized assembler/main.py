from assembler import Assembler
from sys import argv


def main():
    if len(argv) == 3:
        assembler = Assembler(filename_destination=argv[2], filename_source=argv[1])
    elif len(argv) == 2:
        assembler = Assembler(filename_source=argv[1])
    else:
        print(f"Usage: <filename_source> <filename_destination>")
        print("or")
        print(f"Usage: <filename_source> and it will be stored in 'instructions.mem'")
        print(
            "now the program will use the first assembly file in this directory that ends with '.asm' or '.s'"
        )
        assembler = Assembler()

    assembler.assemble()


if __name__ == "__main__":
    main()
