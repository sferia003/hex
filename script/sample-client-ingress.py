import socket

firstBatch = "{\r\n\"iOrderType\": \"Sell\",\r\n  \"iLimit\": true,\r\n  \"iSymbol\": \"Hello\",\r\n  \"iQuantity\": 2,\r\n  \"iPrice\": 2\r\n}"
secondBatch = "{\r\n  \"iOrderType\": \"Buy\",\r\n  \"iLimit\": true,\r\n  \"iSymbol\": \"Hello\",\r\n  \"iQuantity\": 2,\r\n  \"iPrice\": 2\r\n}"

def client_program():
    host = "127.0.0.1"
    port = 8000 

    input()
    client_socket = socket.create_connection((host, port))
    client_socket.send(firstBatch.encode())
    input()
    client_socket.send(secondBatch.encode())

    client_socket.close()  # close the connection


if __name__ == '__main__':
    client_program()
