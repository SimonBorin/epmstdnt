def multiple_in_range(start, end):
    if isinstance(start, int) and isinstance(end, int):
        return (
            [number for number in range(start, end+1) if (number % 7 == 0) and (number % 5 != 0)]
        )
    else:
        raise TypeError
