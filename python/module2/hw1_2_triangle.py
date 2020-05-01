#!/usr/bin/env python3
from sys import argv
from math import sqrt

def heron(a, b, c):
    p = (a+b+c)/2
    S = sqrt(p*(p-a)*(p-b)*(p-c))
    if (((a+b>c) and (a+c>b)) and b+c>a):
        return f"Surface area of the triangle = {S}"
    else:
        return 'Invalid arguments'

if __name__ == '__main__':
    if len(argv) > 3:
        try:
            a = (int(argv[1]))
            b = (int(argv[2]))
            c = (int(argv[3]))
        except ValueError as e:
            print("Error! couldn't convert arguments to int\n",e)
    else:
        print('Error! script has no arguments.')

    try:
        print(heron(a, b, c))
    except ValueError as e:
        print("Error! couldn't calculate this\n", e)