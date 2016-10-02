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

    mySocket = socket.socket()
    mySocket.bind((host, port))

    mySocket.listen(1)
    
    while True:
        conn, addr = mySocket.accept()

        while True:
            data = conn.recv(512)
            if not data:
                break

            print("Received length: {}".format(len(data)))

            printer = epson_printer.Usb(config.ID_VENDOR, config.ID_PRODUCT)

            printer._raw(data)
            del printer

        conn.close()

if __name__ == '__main__':
    print("Starting POS Print Server")
    main()
