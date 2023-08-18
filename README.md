# Haskell EXchange (HEX)
Welcome to the Haskell Exchange (HEX), a trading platform built using Haskell and powered by RabbitMQ. This documentation will guide you through the setup, usage, and development of HEX, providing you with a comprehensive understanding of its features and capabilities.

## Setup

To run the exchange, follow these steps:

- Run the RabbitMQ server.
- Run the ingress server.
- Run the egress server.
  
### Ingress

This is the server that will ingest trades. The binary provided runs the server on localhost with port 8000. 

Send in trades using the following example as a format.

```
{
  "iOrderType": "Sell",
  "iLimit": true,
  "iSymbol": "Hello",
  "iQuantity": 2,
  "iPrice": 2,
  "iTraderId": 1
}
```

For more details on how to interact with the ingress server, consult this [example script](https://github.com/sferia003/hex/blob/main/script/sample-client-ingress.py).
    
### Egress

This is the server that sends out transactions to trader.

- Run the provided binary to start the server on localhost with port 8003.
- Begin by sending the symbol you want to subscribe to.
- The server will then continuously provide transaction updates.
- Consult this [example script](https://github.com/sferia003/hex/blob/main/script/sample-client-egress.py) for interaction details.
### RabbitMQ Server

We use the community docker image to run the server. Run the following docker command to start up the rabbitmq server.

`docker run -it --rm --name exchange -p 5672:5672 -p 15672:15672 rabbitmq:3.12-management`

Check the [official website](https://www.rabbitmq.com/download.html) for more information.


## Development
For contributing to HEX and developing new features, follow these steps:

- Clone this repository.
- `stack clean`
- `stack build`
- Run the RabbitMQ server.
- `stack run ingress-exe`
- `stack run egress-exe`

### System Design
![Design](https://github.com/sferia003/hex/blob/main/doc/sysdesign.drawio.png?raw=true)

### TODO
- FAST Protocol Integration: Transition from JSON to the FAST Protocol for enhanced communication efficiency and compliance with industry standards.
- Trader Registration: Implement a secure and reliable trader registration system, preventing unauthorized trades on behalf of others.
- Access Control: Strengthen access control mechanisms to ensure that traders can only execute trades for themselves.
- Expanded Order Types: Introduce support for a variety of order types, including stop orders, fill or kill orders, and day orders.
- Order Lifecycle Management: Develop a robust order lifecycle system with order IDs and states for improved tracking and transparency.
- Configuration Management: Implement a configuration file system to streamline changes to the exchange's behavior without requiring extensive recompilation.
- Comprehensive Testing: Develop automated tests to validate the behavior of HEX and ensure reliability and stability.
