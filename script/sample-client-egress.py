import socket

def c():
    host = "127.0.0.1"
    port = 8003

    sym = input()
    client_socket = socket.create_connection((host, port))
    client_socket.setblocking(True)
    client_socket.send(sym.encode())

    while True:
        data = client_socket.recv(1024).decode()

        if (data == ""):
            break

        print('Received from server: ' + data)  # show in terminal
    
    print ("finished")

if __name__ == '__main__':
    c()
