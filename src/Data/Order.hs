module Data.Order (Symbol, OrderType (..), Order (..), LimitOrder (..), MarketOrder (..), OrderWrapper (..), owsymbol, IngressOrder (..), convertIngressToOrderWrapper) where

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

data IngressOrder = IngressOrder
  { iOrderType :: OrderType,
    iLimit :: Bool,
    iSymbol :: Symbol,
    iQuantity :: Int,
    iPrice :: Double
  }
  deriving (Show, Eq, Generic)

instance ToJSON IngressOrder

instance FromJSON IngressOrder

instance ToJSON Order

instance FromJSON Order

newtype LimitOrder = LimitOrder Order deriving (Generic)

instance ToJSON LimitOrder

instance FromJSON LimitOrder

newtype MarketOrder = MarketOrder Order deriving (Generic)

instance ToJSON MarketOrder

instance FromJSON MarketOrder

data OrderWrapper = LO LimitOrder | MO MarketOrder deriving (Generic)

convertIngressToOrderWrapper :: IngressOrder -> IO OrderWrapper
convertIngressToOrderWrapper io = do
  time <- getCurrentTime
  if iLimit io
    then return $ LO (LimitOrder (Order {orderType = iOrderType io, symbol = iSymbol io, quantity = iQuantity io, price = iPrice io, timestamp = time}))
    else return $ MO (MarketOrder (Order {orderType = iOrderType io, symbol = iSymbol io, quantity = iQuantity io, price = iPrice io, timestamp = time}))

owsymbol :: OrderWrapper -> Symbol
owsymbol (LO (LimitOrder o)) = symbol o
owsymbol (MO (MarketOrder o)) = symbol o

instance ToJSON OrderWrapper

instance FromJSON OrderWrapper

instance Ord Order where
  compare o1 o2 = case compare (price o1) (price o2) of
    EQ -> compare (timestamp o2) (timestamp o1)
    other -> other
