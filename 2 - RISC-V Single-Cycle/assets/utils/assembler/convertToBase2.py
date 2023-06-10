def twos_complement(decimal_number: int, n: int) -> str:
    if decimal_number >= 0:
        binary_number = bin(decimal_number)[2:]
        return binary_number.zfill(n)
    else:
        binary_number = bin(2**n + decimal_number)[2:]
        return binary_number
