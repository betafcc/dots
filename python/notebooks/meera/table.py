def table(f, *args):
    import sympy as sp

    if isinstance(f, sp.Basic):
        x, *xargs = args[0]
        y, *yargs = args[1]
        f = sp.lambdify((x, y), f)
        data = [[f(x, y) for x in range(*xargs)] for y in range(*yargs)]
    elif callable(f):
        xargs = args[0]
        yargs = args[1]
        data = [[f(x, y) for x in range(*xargs)] for y in range(*yargs)]
    else:
        data = f

    return data


def tplot(*args, cmap="gray_r", **kwargs):
    import matplotlib.figure
    import matplotlib.pyplot

    fig = matplotlib.figure.Figure(
        **{k: kwargs[k] for k in filter(figure_keys.__contains__, kwargs)}
    )

    if kwargs.get("pos") is not None:
        ax = fig.add_axes(kwargs["pos"])
    else:
        ax = fig.add_subplot()

    ax.axes.get_xaxis().set_visible(False)
    ax.axes.get_yaxis().set_visible(False)
    im = ax.matshow(table(*args), cmap=cmap)

    return im.figure


figure_keys = {"figsize"}
