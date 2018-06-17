from subprocess import check_call, check_output


def sh(command, capture=False, lines=True):
    if capture:
        result = check_output(command, shell=True)
        
        if lines:
            result = result.decode('utf-8').split('\n')

        return result

    check_call(command, shell=True)
