def period(xs: list, window=1):
    """
    Detects the period of values repetitions in an array

    >>> period([0, 1, 0, 1, 0])
    2

    >>> period([0, 0, 1, 0, 0, 1])
    3

    >>> period([0, 0, 1, 0])
    -1
    """
    if window > len(xs) // 2:
        return -1

    for i in range(window, len(xs) - 1):
        if not all(a == b for a, b in zip(xs[i - window : i], xs[i : i + window])):
            return period(xs, window + 1)

    return window


def spiral():
    x, y = 0, 0
    layer = 1

    yield (x, y)
    while True:
        for i in range(layer):
            x += 1
            yield (x, y)

        for i in range(layer):
            y += 1
            yield (x, y)

        layer += 1

        for i in range(layer):
            x -= 1
            yield (x, y)

        for i in range(layer):
            y -= 1
            yield (x, y)

        layer += 1
