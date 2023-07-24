module Router.Router () where

import Control.Concurrent.STM
import Control.Monad
import Data.Map qualified as Map
import Data.Maybe
import Data.Model
import Data.Order
import Router.SymbolQueues

newSymbolQueues :: IO SymbolQueues
newSymbolQueues = do
  queues <- newTVarIO Map.empty
  return queues

registerNewSymbolQueue :: SymbolQueues -> Symbol -> IO ()
registerNewSymbolQueue symbolqueues symbol = do
  queue <- newTQueueIO
  atomically $ modifyTVar' symbolqueues (Map.insert symbol queue)

routeTradeToQueue :: SymbolQueues -> Order -> IO ()
routeTradeToQueue symbolqueues trade = do
  queues <- readTVarIO symbolqueues
  when (Map.notMember (symbol trade) queues) $ registerNewSymbolQueue symbolqueues (symbol trade)
  atomically $ writeTQueue (fromJust $ Map.lookup (symbol trade) queues) trade
