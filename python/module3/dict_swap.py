def dict_swap(input_dict):
    try:
        return {y: x for (x, y) in input_dict.items()}
    except TypeError as e:
        raise TypeError
