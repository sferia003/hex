module MessageBroker.RabbitMQ (connectToRabbitMQServer, MessageBroker.RabbitMQ.declareExchange, MessageBroker.RabbitMQ.newQueue) where

import Control.Monad (void)
import Data.Order
import Data.Text
import Network.AMQP as MQ

connectToRabbitMQServer :: IO Channel
connectToRabbitMQServer = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  openChannel conn

declareExchange :: Channel -> IO ()
declareExchange chan =
  MQ.declareExchange chan newExchange {exchangeName = "main", exchangeType = "fanout"}

newQueue :: Channel -> Symbol -> IO ()
newQueue chan symbolname = do
  void $ MQ.declareQueue chan MQ.newQueue {queueName = pack symbolname}
  MQ.bindQueue chan (pack symbolname) "main" (pack symbolname)
