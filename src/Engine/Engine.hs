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
import Data.Text as TE
import Data.Transaction as T
import Engine.LimitOrderEngine
import Engine.MarketOrderEngine
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
  let (nob, transactions) = case item of
        LO o -> processLimitOrder o orderBook
        MO o -> processMarketOrder o orderBook
   in mapM_ (\m -> publishMsg chan "main" (TE.pack (T.symbol m)) (newMsg {msgBody = encode m, msgDeliveryMode = Just Persistent})) transactions
        >> writeIORef ob nob
