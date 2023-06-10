import os
import io
import type
from tqdm import tqdm

class Assembler:
    types = {
        **{k: type.R_Type() for k in type.R_Type.map.keys()},
        **{k: type.I_Type() for k in type.I_Type.map.keys()},
        **{k: type.S_Type() for k in type.S_Type.map.keys()},
        **{k: type.J_Type() for k in type.J_Type.map.keys()},
        **{k: type.B_Type() for k in type.B_Type.map.keys()},
        **{k: type.U_Type() for k in type.U_Type.map.keys()},
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
                    assembly_lines.append(line.split("#", 1)[0])
            except Exception as e:
                pass

        return assembly_lines

    def __find_line_of_label(
        self, lines: list[str], label: str, calling_line: int
    ) -> int:
        minus = 0
        for i, line in enumerate(lines):
            if label + ":" in line:
                return i - minus - calling_line
            if ":" in line:
                minus += 1

        return None

    def assemble(self):
        assembly_lines = self.__find_assembly_lines()
        machine_code_lines = []

        for assembly_line in tqdm(assembly_lines, desc="Assembling lines"):
            try:
                command, *args = assembly_line.split()
                if command in self.types:
                    if command in self.labeled:
                        label = assembly_line.rstrip().rsplit(" ", 1)[1].rstrip()
                        label_line = self.__find_line_of_label(
                            assembly_lines, label, len(machine_code_lines)
                        )
                        if label_line is None:
                            raise Exception("label doesn't exist")
                        assembly_line = assembly_line.replace(
                            label, str(label_line << 2)
                        )
                    machine_code_line = self.types[command](assembly_line)
                    machine_code_lines.append(machine_code_line)
            except Exception as e:
                pass

        with open(self.filename_destination, "w") as f:  # type: io.TextIOWrapper
            waiting_chars = ['|', '/', '-', '\\']
            for i, line in enumerate(machine_code_lines):
                bytes = [line[i : i + 8] for i in range(0, len(line), 8)]
                start_address = 0
                f.write(f"@{start_address:03X}\n".lower())
                for byte in reversed(bytes):
                    f.write(byte + "\n")
                start_address += 4
                if i % 10 == 0:
                    tqdm.write(f"\rWriting to file {waiting_chars[i % len(waiting_chars)]}", end='')
        tqdm.write("\nDone writing to file.")
