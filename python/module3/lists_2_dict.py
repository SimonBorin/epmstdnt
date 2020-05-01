from collections.abc import Iterable


def lists_2_dict(key,value):
    if not all([isinstance(obj, Iterable) for obj in key]):
        raise TypeError
    if len(key) != len(value):
        key, value = get_same_len(key, value)
    return dict(zip(key, value))


def get_same_len(key, value):
    len_diff = len(key) - len(value)

    if len(key) > len(value):
        for i in range(len_diff):
            value.append("")
    else:
        subvalue = value[-len_diff+1:]
        value = value[:len_diff-1]
        value.append(subvalue)
    return key, value
