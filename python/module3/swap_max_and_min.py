def swap_max_and_min(list):
    if len(list) != len(set(list)):
        raise ValueError("list has non unique items")
    elif not all([isinstance(number, int) for number in list]):
        raise TypeError("Some of items are not int")
    else:
        list[list.index(max(list))], list[list.index(min(list))] = min(list), max(list)
        return list


