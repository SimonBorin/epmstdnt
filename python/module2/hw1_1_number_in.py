#!/usr/bin/env python3
from sys import argv

def int_check (argument):
    print(
        -15 < argument <= 12 or
        14 < argument < 17 or
        19 <= argument
        )

if __name__ == '__main__':
    if len(argv) > 1:
        try:
            int_check(int(argv[1]))
        except ValueError as e:
            print("Error! couldn't convert argument to int\n",e)
    else:
        print('Error! script has no argument.')
