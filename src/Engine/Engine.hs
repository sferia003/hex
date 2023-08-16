module Engine.Engine (spinUpEngineWorker) where

import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad (forever, void)
import Data.Aeson
import Data.IORef
import Data.Map as Map
import Data.Maybe
import Data.Order as O
import Data.OrderBook as OB
import Engine.LimitOrderEngine
import Network.AMQP
import Router.SymbolQueues

spinUpEngineWorker :: Channel -> Symbol -> SymbolQueues -> IO ()
spinUpEngineWorker chan sym sq = do
  ob <- newIORef OB.empty
  symbolqueues <- readTVarIO sq
  void $ forkIO (engineWorker chan ob (fromJust (Map.lookup sym symbolqueues)))

engineWorker :: Channel -> IORef OrderBook -> SymbolQueue -> IO ()
engineWorker chan ob sq = forever $ do
  orderBook <- readIORef ob
  item <- readChan sq
  let order = case item of
        LO o -> Just o
        _ -> Nothing
      (nob, transactions) = processLimitOrder (fromJust order) orderBook
   in mapM_ (\m -> publishMsg chan "main" "" (newMsg {msgBody = encode m, msgDeliveryMode = Just Persistent})) transactions
        >> writeIORef ob nob
