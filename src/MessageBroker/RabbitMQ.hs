{-# LANGUAGE OverloadedStrings #-}

module MessageBroker.RabbitMQ (connectToRabbitMQServer, MessageBroker.RabbitMQ.declareExchange) where

import Data.Order
import Data.Text
import Network.AMQP as MQ

connectToRabbitMQServer :: IO Channel
connectToRabbitMQServer = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  openChannel conn

declareExchange :: Channel -> Symbol -> IO ()
declareExchange chan symbolname =
  MQ.declareExchange chan newExchange {exchangeName = pack symbolname, exchangeType = "fanout"}
