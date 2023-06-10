from convertToBase2 import twos_complement
from typing import Any
from copy import deepcopy
import re

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
            imm = twos_complement(int(self.args[1]), 12)
        else:
            rs1 = str(bin(int(self.args[1][1:]))[2:].zfill(5))
            imm = twos_complement(int(self.args[2]), 12)
        return imm + rs1 + func3 + rd + opcode


class S_Type(Type):
    map = {"sw": ("0100011", "010")}

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode, func3 = self.map[self.command]
        rs2 = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        rs1 = str(bin(int(self.args[2][1:]))[2:].zfill(5))
        imm = twos_complement(int(self.args[1]), 12)[::-1]
        return imm[5:][::-1] + rs2 + rs1 + func3 + imm[:5][::-1] + opcode


class J_Type(Type):
    map = {"jal": "1101111"}

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode = self.map[self.command]
        rd = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        imm = twos_complement(int(self.args[1]), 21)[::-1]
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
        rs1 = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        rs2 = str(bin(int(self.args[1][1:]))[2:].zfill(5))
        imm = twos_complement(int(self.args[2]), 13)[::-1]
        return (
            imm[12]
            + imm[5:11][::-1]
            + rs2
            + rs1
            + func3
            + imm[1:5][::-1]
            + imm[11]
            + opcode
        )


class U_Type(Type):
    map = {"lui": "0110111"}

    def __init__(self) -> None:
        pass

    def _assemble(self) -> str:
        opcode = self.map[self.command]
        rd = str(bin(int(self.args[0][1:]))[2:].zfill(5))
        imm = twos_complement(int(self.args[1]), 21)
        return imm + rd + opcode