module Lib (ingress) where

import Control.Concurrent.Chan
import Control.Concurrent.STM
import Data.Aeson as A
import Data.ByteString.Char8 as BS
import Data.Order
import Network.Simple.TCP
import Router.SymbolQueues as SQ

-- Function to handle a client in a separate thread
handleClient :: SymbolQueues -> (Socket, SockAddr) -> IO ()
handleClient sq (sock, _) = do
  loop
  where
    loop = do
      msg <- recv sock 4096
      case msg of
        Nothing -> return ()
        Just order -> do
          case (decode (fromStrict order) :: Maybe OrderWrapper) of
            Nothing -> send sock $ pack "An error occurred while decoding"
            Just lo@(LO (LimitOrder o)) -> do
              queue <- SQ.get sq (symbol o)
              case queue of
                Nothing -> send sock $ pack "hello"
                Just q -> writeChan q lo
            Just mo@(MO (MarketOrder o)) -> do
              queue <- SQ.get sq (symbol o)
              case queue of
                Nothing -> send sock $ pack "hello"
                Just q -> writeChan q mo
          loop

-- Main server loop
ingress :: IO ()
ingress = do
  print "Starting Ingress Interface"
  symbolQueues <- SQ.empty
  serve (Host "127.0.0.1") "8000" $ handleClient symbolQueues
