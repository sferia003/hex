module Data.Order (Symbol, OrderType (..), Order (..), LimitOrder (..), MarketOrder (..)) where

import Data.Time.Clock

type Symbol = String

data OrderType = Buy | Sell deriving (Show, Eq)

data Order = Order
  { orderType :: OrderType,
    symbol :: Symbol,
    quantity :: Int,
    price :: Double,
    timestamp :: UTCTime
  }
  deriving (Show, Eq)

newtype LimitOrder = LimitOrder Order

newtype MarketOrder = MarketOrder Order

instance Ord Order where
  compare o1 o2 = case compare (price o1) (price o2) of
    EQ -> compare (timestamp o2) (timestamp o1)
    other -> other
