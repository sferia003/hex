module Data.Order (Symbol, OrderType (..), Order (..), LimitOrder (..), MarketOrder (..), OrderWrapper (..)) where

import Data.Aeson
import Data.Time.Clock
import GHC.Generics

type Symbol = String

data OrderType = Buy | Sell deriving (Show, Eq, Generic)

instance ToJSON OrderType

instance FromJSON OrderType

data Order = Order
  { orderType :: OrderType,
    symbol :: Symbol,
    quantity :: Int,
    price :: Double,
    timestamp :: UTCTime
  }
  deriving (Show, Eq, Generic)

instance ToJSON Order

instance FromJSON Order

newtype LimitOrder = LimitOrder Order deriving (Generic)

instance ToJSON LimitOrder

instance FromJSON LimitOrder

newtype MarketOrder = MarketOrder Order deriving (Generic)

instance ToJSON MarketOrder

instance FromJSON MarketOrder

data OrderWrapper = LO LimitOrder | MO MarketOrder deriving (Generic)

instance ToJSON OrderWrapper

instance FromJSON OrderWrapper

instance Ord Order where
  compare o1 o2 = case compare (price o1) (price o2) of
    EQ -> compare (timestamp o2) (timestamp o1)
    other -> other
