import socket
import json
import time 

def dataf(t):
    return {
            "iOrderType": t[0],
            "iLimit": t[1],
            "iSymbol": t[2],
            "iTraderId": t[3],
            "iQuantity": t[4],
            "iPrice": t[5]
        }

def format(t):
    return json.dumps(dataf(t)).encode()

def c():
    host = "127.0.0.1"
    port = 8000 

    symbols = ["a", "b", "c"]

    input()
    id = 0

    client_socket = socket.create_connection((host, port))

    # Make buy orders
    for symbol in symbols:
        client_socket.sendall(format(("Buy", True, symbol, id, 2, 2)))
        id = id + 1
        time.sleep(1)

    print("Finished Buy Orders")

    input()

    # Make sell orders
    for symbol in symbols:
        client_socket.sendall(format(("Sell", True, symbol, id, 2, 2)))
        id = id + 1
        time.sleep(1)

    client_socket.close()  # close the connection


if __name__ == '__main__':
    c()
