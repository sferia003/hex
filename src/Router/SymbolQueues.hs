module Router.SymbolQueues (SymbolQueue, SymbolQueues) where

import Control.Concurrent.STM
import Data.Map qualified as Map
import Data.Model
import Data.Order

type SymbolQueue = TQueue Order

type SymbolQueues = TVar (Map.Map Symbol SymbolQueue)
