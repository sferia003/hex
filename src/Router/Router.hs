module Router.Router (Router.Router.empty, registerNewSymbolQueue, routeOrderToQueue) where

import Control.Concurrent.Chan
import Control.Concurrent.STM
import Data.Map qualified as Map
import Data.Order
import Engine.Engine
import MessageBroker.RabbitMQ as MQ
import Network.AMQP
import Router.SymbolQueues as SQ

empty :: IO SymbolQueues
empty =
  do newTVarIO Map.empty

registerNewSymbolQueue :: SymbolQueues -> Symbol -> IO ()
registerNewSymbolQueue symbolqueues symbol = do
  queue <- newChan
  atomically $ modifyTVar' symbolqueues (Map.insert symbol queue)

routeOrderToQueue :: Channel -> SymbolQueues -> OrderWrapper -> IO ()
routeOrderToQueue chan symbolqueues order = do
  sq <- SQ.get symbolqueues sym
  case sq of
    Just queue -> writeChan queue order
    Nothing -> do
      SQ.insert symbolqueues sym
      MQ.declareExchange chan sym
  where
    sym = owsymbol order
