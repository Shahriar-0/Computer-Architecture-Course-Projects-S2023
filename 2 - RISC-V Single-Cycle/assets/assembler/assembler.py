from typing import Any
from copy import deepcopy
import re
from sys import argv
import os
import io


class Type:
    def __init__(self) -> None:
        pass

    def __call__(self, input: str, *args: Any, **kwds: Any) -> Any:
        self.__prepare_str(input)
        return self._assemble()

    def _assemble(self) -> str:
        print("here")
        pass

    def __prepare_str(self, input: str) -> str:
        no_comma_text = deepcopy(input).replace(",", "")
        no_extra_space = (
            re.sub(r"\s+", " ", no_comma_text).split("#")[0].rstrip().lstrip()
        )
        self.input = no_extra_space.replace("(", " ").replace(")", "")
        self.parsed = self.__parse()

    def __parse(self) -> list[str]:
        self.command, *self.args = self.input.split(" ")


class R_Type(Type):
    map = {
        "add": ("0110011", "000", "0000000"),
        "sub": ("0110011", "000", "0100000"),
        "and": ("0110011", "111", "0000000"),
        "or": ("0110011", "110", "0000000"),
        "slt": ("0110011", "010", "0000000"),
    }

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode, func3, func7 = self.map[self.command]
        rd = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        rs1 = str(bin(int(self.args[1][1:]))[2:].zfill(5))
        rs2 = str(bin(int(self.args[2][1:]))[2:].zfill(5))
        return func7 + rs2 + rs1 + func3 + rd + opcode


class I_Type(Type):
    map = {
        "lw": ("0000011", "010"),
        "addi": ("0010011", "000"),
        "xori": ("0010011", "100"),
        "ori": ("0010011", "110"),
        "slti": ("0010011", "010"),
        "jalr": ("1100111", "000"),
    }

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode, func3 = self.map[self.command]
        rd = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        if self.command == "lw":
            rs1 = str(bin(int(self.args[2][1:]))[2:].zfill(5))
            imm = str(bin(int(self.args[1]))[2:].zfill(12))
        else:
            rs1 = str(bin(int(self.args[1][1:]))[2:].zfill(5))
            imm = str(bin(int(self.args[2]))[2:].zfill(12))
        return imm + rs1 + func3 + rd + opcode


class S_Type(Type):
    map = {"sw": ("0100011", "010")}

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode, func3 = self.map[self.command]
        rs2 = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        rs1 = str(bin(int(self.args[2][1:]))[2:].zfill(5))
        imm = str(bin(int(self.args[1]))[2:].zfill(12))[::-1]
        return imm[5:][::-1] + rs2 + rs1 + func3 + imm[:5][::-1] + opcode


class J_Type(Type):
    map = {"jal": "1101111"}

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode = self.map[self.command]
        rd = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        imm = str(bin(int(self.args[1]))[2:].zfill(21))[::-1]
        return imm[20] + imm[1:11][::-1] + imm[11] + imm[12:20][::-1] + rd + opcode


class B_Type(Type):
    map = {
        "beq": ("1100011", "000"),
        "bne": ("1100011", "001"),
        "blt": ("1100011", "100"),
        "bge": ("1100011", "101"),
    }

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode, func3 = self.map[self.command]
        rs2 = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        rs1 = str(bin(int(self.args[1][1:]))[2:].zfill(5))
        imm = str(bin(int(self.args[2]))[2:].zfill(13))[::-1]
        return imm[12] + imm[5:11][::-1] + rs2 + rs1 + func3 + imm[1:5][::-1] + imm[11] + opcode


class U_Type(Type):
    map = {"lui": "0110111"}

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode = self.map[self.command]
        rd = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        imm = str(bin(int(self.args[1]))[2:].zfill(21))
        return imm + rd + opcode


class Assembler:
    types = {
        **{k: R_Type() for k in R_Type.map.keys()},
        **{k: I_Type() for k in I_Type.map.keys()},
        **{k: S_Type() for k in S_Type.map.keys()},
        **{k: J_Type() for k in J_Type.map.keys()},
        **{k: B_Type() for k in B_Type.map.keys()},
        **{k: U_Type() for k in U_Type.map.keys()},
    }

    labeled = ["beq", "bne", "blt", "bge", "jal"]

    def __init__(
        self,
        filename_destination: str = "instructions.mem",
        directory: str = None,
        filename_source: str = None,
    ) -> None:
        self.directory = directory or os.getcwd()
        self.filename_destination = filename_destination
        if filename_source is None:
            self.filename_source = self.__find_first_assembly_file()
        else:
            self.filename_source = filename_source

    def __find_first_assembly_file(self):
        for root, dirs, files in os.walk(self.directory):
            for file in files:
                if file.endswith(".asm") or file.endswith(".s"):
                    return os.path.join(root, file)
        return None

    def __find_assembly_lines(self) -> list[str]:
        if self.filename_source is None:
            print(f"No assembly file found in directory '{self.directory}'")
            exit(1)

        with open(self.filename_source, "r") as f:  # type: io.TextIOWrapper
            lines = f.readlines()

        assembly_lines = []
        for i, line in enumerate(lines):
            if line.lstrip() == "\n":
                continue
            try:
                command, *args = line.split()
                if command in self.types or ":" in line:
                    assembly_lines.append(line)
            except Exception as e:
                pass

        return assembly_lines

    def __find_line_of_label(self, lines: list[str], label: str) -> int:
        for i, line in enumerate(lines):
            if label + ":" in line:
                return i

        return None

    def assemble(self):
        assembly_lines = self.__find_assembly_lines()[1:]
        machine_code_lines = []

        for assembly_line in assembly_lines:
            try:
                command, *args = assembly_line.split()
                if command in self.types:
                    if command in self.labeled:
                        label = assembly_line.rsplit(" ", 1)[1].rstrip()
                        label_line = self.__find_line_of_label(assembly_lines, label)
                        if label_line is None:
                            raise Exception("label doesn't exist")
                        assembly_line = assembly_line.replace(label, str(label_line << 2))
                    machine_code_line = self.types[command](assembly_line)
                    machine_code_lines.append(machine_code_line)
            except Exception as e:
                pass

        with open(self.filename_destination, "w") as f:  # type: io.TextIOWrapper
            for line in machine_code_lines:
                bytes = [line[i:i+8] for i in range(0, len(line), 8)]
                for byte in bytes:
                    f.write(byte + "\n")


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
