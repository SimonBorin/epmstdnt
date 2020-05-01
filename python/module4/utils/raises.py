from functools import wraps


def raises(exception):
    def deco(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            try:
                return func(*args, **kwargs)
            except Exception:
                raise exception
        return wrapper
    return deco
