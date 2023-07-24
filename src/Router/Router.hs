module Router.Router (empty, registerNewSymbolQueue, routeOrderToQueue) where

import Control.Concurrent.STM
import Data.Map qualified as Map
import Data.Maybe
import Data.Model
import Data.Order
import Router.SymbolQueues

empty :: IO SymbolQueues
empty =
  do newTVarIO Map.empty

registerNewSymbolQueue :: SymbolQueues -> Symbol -> IO ()
registerNewSymbolQueue symbolqueues symbol = do
  queue <- newTQueueIO
  atomically $ modifyTVar' symbolqueues (Map.insert symbol queue)

routeOrderToQueue :: SymbolQueues -> Order -> IO ()
routeOrderToQueue symbolqueues order = do
  queues <- readTVarIO symbolqueues
  atomically $ writeTQueue (fromJust $ Map.lookup (symbol order) queues) order
