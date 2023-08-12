{-# LANGUAGE OverloadedStrings #-}

module MessageBroker.RabbitMQ where

import Data.Order
import Network.AMQP as MQ
import Text.Printf

connectToRabbitMQServer :: IO (Channel)
connectToRabbitMQServer = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  openChannel conn

declareExchange :: Channel -> Symbol -> IO ()
declareExchange chan symbol =
  MQ.declareExchange chan newExchange {exchangeName = symbol, exchangeType = "fanout"}
