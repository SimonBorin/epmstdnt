from collections.abc import Iterable


def search_in_dict(input_list, input_dict):
    if not all([isinstance(obj, Iterable) for obj in input_list]):
        raise TypeError
    print([key for key in input_list if key in input_dict])

    return set([key for key in input_list if key in input_dict])

