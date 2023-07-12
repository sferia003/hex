module Lib
  ( rabbit,
  )
where

import Broker.RabbitMQ
import Control.Concurrent
import Data.Text
import Network.AMQP
import Prelude

rabbit :: IO ()
rabbit = do
  conn <- openConnection "127.0.0.1" (pack "/") (pack "guest") (pack "guest")
  chan <- openChannel conn
  setupNExchanges 5 chan
  putStrLn "Blocking"
  threadDelay 15000000
  putStrLn "Publishing"
  publishMessageToExchangeNum 2 "hello" chan
  closeConnection conn
  putStrLn "Closed"
