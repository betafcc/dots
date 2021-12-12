from dataclasses import dataclass

import ipywidgets as widgets
import matplotlib as mpl
import matplotlib.pyplot as plt
import sympy as sp
from ipywidgets import interact

x, y, z = sp.symbols("x, y, z")


def __rc():
    import sys
    from pathlib import Path

    from IPython import get_ipython
    from IPython.core.magic import (
        needs_local_scope,
        register_cell_magic,
        register_line_magic,
    )
    from IPython.display import HTML, display
    from IPython.terminal.prompts import Prompts, Token
    from prompt_toolkit.enums import DEFAULT_BUFFER
    from prompt_toolkit.filters import EmacsInsertMode, HasFocus, HasSelection

    sys.path.append(str(Path(__file__).parents[3]))

    ip = get_ipython()
    insert_mode = EmacsInsertMode()

    # Register the shortcut if IPython is using prompt_toolkit
    if getattr(ip, "pt_app", None):
        registry = ip.pt_app.key_bindings

        @registry.add_binding(
            "escape",
            "m",
            filter=(HasFocus(DEFAULT_BUFFER) & ~HasSelection() & insert_mode),
        )
        def _(event):
            event.current_buffer.validate_and_handle()

    class MyPrompt(Prompts):
        def in_prompt_tokens(self, cli=None):
            return [(Token.Prompt, "❱ ")]

        def continuation_prompt_tokens(self, width=None):
            if width is None:
                width = self._width()
            return [
                (Token.Prompt, (" " * (width - 2)) + "| "),
            ]

        def out_prompt_tokens(self):
            return [
                (Token.OutPrompt, "❰ "),
            ]

    @register_line_magic
    @needs_local_scope
    def var(line, local_ns):
        import sympy

        result = sympy.symbols(line)
        try:
            for x in result:
                local_ns[x.name] = x
            return sympy.Matrix([result])
        except TypeError:
            local_ns[x.name] = x
            return x

    def sympy_parse(line, local_ns, *args, **kwargs):
        import sympy

        try:
            return sympy.S(line, *args, **kwargs)
        except ValueError as err:
            if ":=" in line:
                name, expr = line.split(":=")
                result = sympy_parse(expr, local_ns, *args, **kwargs)
                local_ns[name.strip()] = result
                return result
            elif "=" in line:
                return sympy.S("Eq(" + ",".join(line.split("=")) + ")", *args, **kwargs)
            else:
                raise err

    @register_line_magic
    @needs_local_scope
    def s(line, local_ns):
        return sympy_parse(line, local_ns)

    @register_line_magic
    @needs_local_scope
    def sp(line, local_ns):
        return sympy_parse(line, local_ns, locals=local_ns)

    @register_cell_magic
    @needs_local_scope
    def interact(line, cell, local_ns):
        import ipywidgets

        decorator = eval(
            "ipywidgets.interact(" + line + ")",
            globals(),
            {**local_ns, "ipywidgets": ipywidgets},
        )
        lines = cell.strip().split("\n")
        last = "_result = " + lines[-1]

        local_ns["__interact_decorator"] = decorator
        src = (
            "\n@__interact_decorator"
            "\ndef __interact_f("
            + ", ".join(decorator.kwargs)
            + "):"
            + "\n    "
            + "\n    ".join([*lines, last])
            + "\n    return _result"
        )

        ip.run_cell(src, store_history=False)

    def pre_run_cell(info):
        display(
            HTML(
                f"""
            <script
                id="output-{id(info)}"
            >pre_run_cell && pre_run_cell('{id(info)}')</script>
        """
            )
        )

    def post_run_cell(result):
        display(
            HTML(
                f"""
            <script>post_run_cell && post_run_cell('{id(result.info)}', '{result.success}')</script>
        """
            )
        )

    def clear():
        display(
            HTML(
                f"""
            <script>shell_initialized(); console.log('called')</script>
        """
            )
        )

    ip = get_ipython()
    ip.prompts = MyPrompt(ip)
    ip.events.register("pre_run_cell", pre_run_cell)
    ip.events.register("post_run_cell", post_run_cell)

    # matplotlib doesn't get my custom rc file if I don't run this
    # https://github.com/jupyter/notebook/issues/3385
    ip.run_line_magic("matplotlib", "notebook")
    # ip.events.register('shell_initialized', shell_initialized)


__rc()
del __rc
