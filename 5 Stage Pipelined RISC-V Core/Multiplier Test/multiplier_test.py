import random

def int32_to_hex(i):
    return format(i & 0xFFFFFFFF, '08x')

def int64_to_hex(i):
    return format(i & 0xFFFFFFFFFFFFFFFF, '016x')

def generate_test_cases(num_cases):
    test_cases = []

    for _ in range(num_cases):
        rs1 = random.randint(0, 2**32 - 1)
        rs2 = random.randint(0, 2**32 - 1)

        result = rs1 * rs2

        result = result & 0xFFFFFFFFFFFFFFFF

        test_cases.append((
            int32_to_hex(rs1),
            int32_to_hex(rs2),
            int64_to_hex(result)
        ))

    return test_cases

def write_to_separate_txt(test_cases):
    with open('rs1.txt', 'w') as rs1_file, \
         open('rs2.txt', 'w') as rs2_file, \
         open('results.txt', 'w') as results_file:

        for rs1_hex, rs2_hex, result_hex in test_cases:
            rs1_file.write(rs1_hex + '\n')
            rs2_file.write(rs2_hex + '\n')
            results_file.write(result_hex + '\n')

# Generate and write test cases
num_cases = 1000000  
test_cases = generate_test_cases(num_cases)
write_to_separate_txt(test_cases)