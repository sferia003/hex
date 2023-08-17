import socket

def client_program():
    host = "127.0.0.1"
    port = 8003

    input()
    client_socket = socket.create_connection((host, port))
    client_socket.setblocking(True)
    client_socket.send("Hello".encode())

    while True:
        data = client_socket.recv(1024).decode()

        print('Received from server: ' + data)  # show in terminal
    

if __name__ == '__main__':
    client_program()
