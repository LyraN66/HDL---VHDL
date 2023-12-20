import random

def int32_to_hex(i):
    return format(i & 0xFFFFFFFF, '08x')

def int64_to_hex(i):
    return format(i & 0xFFFFFFFFFFFFFFFF, '016x')

def generate_divider_test_cases(num_cases):
    test_cases = []

    for _ in range(num_cases):
        rs1 = random.randint(0, 2**32 - 1)
        rs2 = random.randint(1, rs1 if rs1 > 0 else 1)
        return_remainder_or_quotient = random.randint(0, 1)

        quotient = rs1 // rs2
        remainder = rs1 % rs2

        if return_remainder_or_quotient:
            expected_output = remainder
        else:
            expected_output = quotient

        test_cases.append((
            int32_to_hex(rs1),
            int32_to_hex(rs2),
            return_remainder_or_quotient,
            int64_to_hex(expected_output)
        ))

    return test_cases

def write_to_separate_txt(test_cases):
    with open('rs1_divider.txt', 'w') as rs1_file, \
         open('rs2_divider.txt', 'w') as rs2_file, \
         open('return_remainder_or_quotient_divider.txt', 'w') as return_type_file, \
         open('expected_output_divider.txt', 'w') as output_file:

        for rs1_hex, rs2_hex, return_type, expected_output_hex in test_cases:
            rs1_file.write(rs1_hex + '\n')
            rs2_file.write(rs2_hex + '\n')
            return_type_file.write(str(return_type) + '\n')
            output_file.write(expected_output_hex + '\n')

# Generate and write test cases
num_cases = 1000000 
test_cases = generate_divider_test_cases(num_cases)
write_to_separate_txt(test_cases)
