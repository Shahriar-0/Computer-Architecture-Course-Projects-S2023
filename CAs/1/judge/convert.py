with open("../code/result.txt") as file:
    dick = {"00": "up", "01": "right", "10": "left", "11": "down"}
    results = [dick[x] for x in file.readlines()]

with open("converted_result.txt", "wb") as result_file:
    for line in results:
        result_file.write(f"{line}\n".encode("utf-8"))