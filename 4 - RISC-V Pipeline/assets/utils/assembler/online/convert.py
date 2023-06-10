with open('../memory/instructions.hex', 'r') as input_file:
    with open('../memory/instructions.mem', 'w') as output_file:
        for line in input_file:
            hex_num = line.strip()
            num = int(hex_num, 16)

            msb = (num >> 24) & 0xff
            next_8 = (num >> 16) & 0xff
            next_8_2 = (num >> 8) & 0xff
            lsb = num & 0xff

            msb_bin = format(msb, '08b')
            next_8_bin = format(next_8, '08b')
            next_8_2_bin = format(next_8_2, '08b')
            lsb_bin = format(lsb, '08b')

            result = f"{msb_bin}\n{next_8_bin}\n{next_8_2_bin}\n{lsb_bin}\n"
            output_file.write(result)

