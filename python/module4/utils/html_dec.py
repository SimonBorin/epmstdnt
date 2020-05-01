from functools import wraps


def italic(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        text = func(*args, **kwargs)
        return f'<i>{text}</i>'
    return wrapper


def bold(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        text = func(*args, **kwargs)
        return f'<b>{text}</b>'
    return wrapper


def underline(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        text = func(*args, **kwargs)
        return f'<u>{text}</u>'
    return wrapper

