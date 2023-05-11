#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os

def Mem2Coe(txt_file):
    file_name = os.path.splitext(txt_file)[0]  # 获取输入文件名的前缀部分
    coe_file = '{}.coe'.format(file_name)  # 构造输出文件名

    with open(txt_file, 'r') as txt:
        lines = txt.readlines()

    num_instructions = len(lines)
    padding_instructions = 1024 - num_instructions

    with open(coe_file, 'w') as coe:
        coe.write('memory_initialization_radix=16;\n')
        coe.write('memory_initialization_vector=\n')

        for line in lines:
            instruction = line.strip()
            coe.write(instruction + ',\n')

        for _ in range(padding_instructions):
            coe.write('00000000,\n')

        coe.write(';\n')

    print('Conversion completed. COE file "{}" is generated.'.format(coe_file))


# 示例用法
if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Usage: python Mem2Coe.py input_file.txt')
    else:
        txt_file = sys.argv[1]
        Mem2Coe(txt_file)
