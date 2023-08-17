module Data.Transaction (Transaction (..)) where

import Data.Aeson
import Data.Order
import GHC.Generics

data Transaction = Transaction
  { price :: Double,
    quantity :: Int,
    fromTraderId :: Int,
    toTraderId :: Int,
    symbol :: Symbol
  }
  deriving (Show, Generic)

instance ToJSON Transaction

instance FromJSON Transaction
