module Data.Util ((?)) where

(?) :: Bool -> (a, a) -> a
c ? (a, b) = if c then a else b
