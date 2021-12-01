def __rc():
    from IPython import get_ipython
    from IPython.core.magic import needs_local_scope, register_line_magic, register_cell_magic
    from IPython.terminal.prompts import Prompts, Token
    from prompt_toolkit.enums import DEFAULT_BUFFER
    from prompt_toolkit.filters import (
        HasFocus,
        HasSelection,
        EmacsInsertMode,
    )

    ip = get_ipython()
    insert_mode = EmacsInsertMode()

    # Register the shortcut if IPython is using prompt_toolkit
    if getattr(ip, "pt_app", None):
        registry = ip.pt_app.key_bindings

        @registry.add_binding(
            "escape",
            u"m",
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
        
        match sympy.symbols(line):
            case (*xs,):
                for x in xs:
                    local_ns[x.name] = x
                return sympy.Matrix([xs])
            case x:
                local_ns[x.name] = x
                return x

    def sympy_parse(line, local_ns, *args, **kwargs):
        import sympy
        try:
            return sympy.S(line, *args, **kwargs)
        except ValueError as err:
            if ':=' in line:
                name, expr = line.split(':=')
                result = sympy_parse(expr, local_ns, *args, **kwargs)
                local_ns[name.strip()] = result
                return result
            elif '=' in line:
                return sympy.S('Eq(' + ','.join(line.split('='))  + ')', *args, **kwargs)
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
            'ipywidgets.interact(' + line + ')',
            globals(),
            { **local_ns, 'ipywidgets': ipywidgets }
        )
        lines = cell.strip().split('\n')
        last = 'return ' + lines[-1]
        src = (
            '\n@__interact_decorator'
            '\ndef __interact_f(' + ', '.join(decorator.kwargs) + '):'
            + '\n    ' + '\n    '.join([*lines, last])
        )

        exec(src, globals(), { **local_ns, '__interact_decorator': decorator })

    ip = get_ipython()
    ip.prompts = MyPrompt(ip)


__rc()
del __rc
