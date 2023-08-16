module Engine.Engine (spinUpEngineWorker) where

import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad (forever, void)
import Data.IORef
import Data.Map as Map
import Data.Maybe
import Data.Order as O
import Data.OrderBook as OB
import Engine.LimitOrderEngine
import MessageBroker.RabbitMQ
import Router.SymbolQueues

spinUpEngineWorker :: Symbol -> SymbolQueues -> IO ()
spinUpEngineWorker sym sq = do
  ob <- newIORef OB.empty
  symbolqueues <- readTVarIO sq
  void $ forkIO (engineWorker ob (fromJust (Map.lookup sym symbolqueues)))

engineWorker :: IORef OrderBook -> SymbolQueue -> IO ()
engineWorker ob sq = forever $ do
  orderBook <- readIORef ob
  item <- readChan sq
  let order = case item of
        LO o -> Just o
        _ -> Nothing
      (nob, transactions) = processLimitOrder (fromJust order) orderBook
   in mapM_ print transactions
        >> writeIORef ob nob
        >> print nob
