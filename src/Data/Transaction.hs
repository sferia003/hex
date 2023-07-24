module Data.Transaction (Transaction (..)) where

data Transaction = Transaction
  { price :: Double,
    quantity :: Int
  }
  deriving (Show)
