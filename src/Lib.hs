module Lib
  ( rabbit,
  )
where

import Data.Order as O
import Data.OrderBook as OB
import Data.Time
import Engine.LimitOrderEngine
import Prelude

rabbit :: IO ()
rabbit = do
  putStrLn "Testing"
  timestamp <- getCurrentTime
  let ob = OB.empty
      o = O.LimitOrder (O.Order Sell "MSFT" 5 1.5 timestamp)
      o2 = O.LimitOrder (O.Order Sell "MSFT" 10 2 (addUTCTime 1 timestamp))
      o3 = O.LimitOrder (O.Order Sell "MSFT" 10 1.5 (addUTCTime 2 timestamp))
      o4 = O.LimitOrder (O.Order Buy "MSFT" 30 5 (addUTCTime 3 timestamp))
      (nob, t) = processLimitOrder o ob
      (nob2, t2) = processLimitOrder o2 nob
      (nob3, t3) = processLimitOrder o3 nob2
      (nob4, t4) = processLimitOrder o4 nob3

  print nob3
  print t3
  print nob4
  print t4
