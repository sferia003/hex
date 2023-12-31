module Router.SymbolQueues (SymbolQueue, SymbolQueues, empty, insert, get) where

import Control.Concurrent.Chan
import Control.Concurrent.STM
import Data.Map qualified as Map
import Data.Order

type SymbolQueue = Chan OrderWrapper

type SymbolQueues = TVar (Map.Map Symbol SymbolQueue)

empty :: IO SymbolQueues
empty = newTVarIO Map.empty

insert :: SymbolQueues -> Symbol -> IO ()
insert sq symbolname = do
  m <- readTVarIO sq
  c <- newChan
  atomically $ writeTVar sq (Map.insert symbolname c m)

get :: SymbolQueues -> Symbol -> IO (Maybe SymbolQueue)
get sq symbolname = do
  m <- readTVarIO sq
  return $ Map.lookup symbolname m
