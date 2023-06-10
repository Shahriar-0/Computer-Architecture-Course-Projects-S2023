from sys import argv
from io_ import read_from_file, write_to_file

OUTPUT_FILE = "data.mem"
START_ADDRESS = 1000

def twos_complement(x: str):
    if x[0] != '-':
        return x
    index = x.rindex('1')
    x = list(x)
    x[0] = '0'
    for i in range(index):
        if x[i] == '1':
            x[i] = '0'
        else:
            x[i] = '1'
    x = ''.join(x)
    return x

def hex_address_generator(binary_numbers: tuple[str], start_address: int) -> str:
    res = ''
    for num in binary_numbers:
        res += f"@{start_address:03X}\n".lower()
        res += num[24:] + '\n'
        res += num[16:24] + '\n'
        res += num[8:16] + '\n'
        res += num[:8] + '\n'
        start_address += 4
    return res


def main() -> None:
    if len(argv) == 2:
        numbers = read_from_file(argv[1])
    else:
        print("Usage: python data_generator.py <file>")
        exit(1)
        
    nums = tuple((twos_complement(f"{int(num):032b}") for num in numbers))
    res = hex_address_generator(tuple(nums), START_ADDRESS)
    write_to_file(res, OUTPUT_FILE)


if __name__ == "__main__":
    main()
