def apt_key_add(server):
    return [
        f'wget -q0 - {server} | sudo apt-key add -',
    ]
