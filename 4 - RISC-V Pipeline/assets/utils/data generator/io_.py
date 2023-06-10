def read_from_file(filename: str) -> list[str]:
    with open(filename, "r", encoding="utf-8") as file:
        return file.read().splitlines()

def write_to_file(data: str, filename: str) -> None:
    with open(filename, "w", encoding="utf-8") as file:
        file.write(data)