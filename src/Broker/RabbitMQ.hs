module Broker.RabbitMQ
  ( setupNExchanges,
    publishMessageToExchangeNum,
    Broker.RabbitMQ.Message,
  )
where

import Control.Monad
import Data.ByteString.Lazy.Char8 qualified as BL
import Data.Text
import Network.AMQP
import Text.Printf

type Message = String

setupNExchanges :: Integer -> Channel -> IO ()
setupNExchanges 1 chan =
  declareExchange
    chan
    newExchange
      { exchangeName = pack $ printf "stock-%d" (1 :: Integer),
        exchangeType = pack "fanout"
      }
setupNExchanges n chan =
  declareExchange
    chan
    newExchange
      { exchangeName = pack $ printf "stock-%d" n,
        exchangeType = pack "fanout"
      }
    >> setupNExchanges (n - 1) chan

publishMessageToExchangeNum :: Integer -> Broker.RabbitMQ.Message -> Channel -> IO ()
publishMessageToExchangeNum n msg chan =
  void $
    publishMsg
      chan
      (pack (printf "stock-%d" n))
      (pack "")
      newMsg {msgBody = BL.pack msg, msgDeliveryMode = Just Persistent}
