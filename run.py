import socket
from escpos import printer as epson_printer

import config


def main():
    """
    Listens on port 9100 like a standard raw print server.
    Takes whatever data it gets and sends to escpos print library.
    """
    host = ''
    port = 9100

    while True:
        mySocket = socket.socket()
        mySocket.bind((host, port))

        mySocket.listen(1)
        conn, addr = mySocket.accept()
        while True:
            data = conn.recv(1024).decode()
            if not data:
                break

            printer = epson_printer.Usb(config.ID_VENDOR, config.ID_PRODUCT)

            printer._raw(data)

        conn.close()

if __name__ == '__main__':
    main()
