from collections.abc import Iterable


def serch_dict_val_from_list_key(input_list, input_dict):
    if not all([isinstance(obj, Iterable) for obj in input_list]):
        raise TypeError
    return [input_dict[key] for key in input_list if key in input_dict]

