module Router.Router (Router.Router.empty, registerNewSymbolQueue, routeOrderToQueue) where

import Control.Concurrent.Chan
import Control.Concurrent.STM
import Data.Map qualified as Map
import Data.Maybe
import Data.Order
import Router.SymbolQueues

empty :: IO SymbolQueues
empty =
  do newTVarIO Map.empty

registerNewSymbolQueue :: SymbolQueues -> Symbol -> IO ()
registerNewSymbolQueue symbolqueues symbol = do
  queue <- newChan
  atomically $ modifyTVar' symbolqueues (Map.insert symbol queue)

routeOrderToQueue :: SymbolQueues -> OrderWrapper -> IO ()
routeOrderToQueue symbolqueues order = do
  queues <- readTVarIO symbolqueues
  writeChan (fromJust $ Map.lookup ("a") queues) order
