module Ingress (ingress) where

import Control.Concurrent.Chan
import Data.Aeson as A
import Data.ByteString.Char8 as BS
import Data.Maybe
import Data.Order
import Engine.Engine
import MessageBroker.RabbitMQ as RAB
import Network.AMQP
import Network.Simple.TCP
import Router.SymbolQueues as SQ

-- Function to handle a client in a separate thread
handleClient :: SymbolQueues -> Channel -> (Socket, SockAddr) -> IO ()
handleClient sq rabbitmq (sock, _) = do
  loop
  where
    loop = do
      msg <- recv sock 4096
      case msg of
        Nothing -> return ()
        Just order -> do
          case (decode (fromStrict order) :: Maybe IngressOrder) of
            Nothing -> send sock $ pack "An error occurred while decoding"
            Just io -> do
              o <- convertIngressToOrderWrapper io
              queue <- SQ.get sq (owsymbol o)
              case queue of
                Nothing -> do
                  insert sq (owsymbol o)
                  spinUpEngineWorker (owsymbol o) sq
                  q <- SQ.get sq (owsymbol o)
                  writeChan (fromJust q) o
                Just q -> writeChan q o
          loop

ingress :: IO ()
ingress = do
  print ("Starting Ingress Interface" :: String)
  symbolQueues <- SQ.empty
  rabbitMQConnection <- RAB.connectToRabbitMQServer
  exchange <- RAB.declareExchange rabbitMQConnection
  serve (Host "127.0.0.1") "8000" $ handleClient symbolQueues rabbitMQConnection
