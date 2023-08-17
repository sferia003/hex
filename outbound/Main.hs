module Main (main) where

import Control.Monad

main :: IO ()
main = do
  putStrLn "hello"
  forever $ return ()
