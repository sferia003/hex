import pika

def callback(ch, method, properties, body):
        print(f" [x] Received {body}")

def client_program():
    input()
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.basic_consume(queue='Hello', on_message_callback=callback, auto_ack=False)

    channel.start_consuming()

if __name__ == '__main__':
    client_program()
