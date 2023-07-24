module Engine.LimitOrderEngine (processLimitOrder) where

import Data.Order as O
import Data.OrderBook as OB
import Data.Transaction as T
import Engine.Match

processLimitBuyOrder :: LimitOrder -> OrderBook -> (OrderBook, [Transaction])
processLimitBuyOrder (LimitOrder ord) orderBook
  | O.quantity ord == 0 = (orderBook, [])
  | otherwise =
      case getTopOfBook Sell orderBook of
        Just ord' ->
          if O.price ord' > O.price ord
            then (insertOrder Buy ord orderBook, [])
            else
              let (updatedOrderBook, matchedTransaction, remainingOrder) = match Buy ord ord' orderBook
                  (finalOrderBook, transactions) = processLimitBuyOrder (LimitOrder remainingOrder) updatedOrderBook
               in (finalOrderBook, matchedTransaction : transactions)
        Nothing -> (insertOrder Buy ord orderBook, [])

processLimitSellOrder :: LimitOrder -> OrderBook -> (OrderBook, [Transaction])
processLimitSellOrder (LimitOrder ord) orderBook
  | O.quantity ord == 0 = (orderBook, [])
  | otherwise =
      case getTopOfBook Buy orderBook of
        Just ord' ->
          if O.price ord' > O.price ord
            then (insertOrder Sell ord orderBook, [])
            else
              let (updatedOrderBook, matchedTransaction, remainingOrder) = match Sell ord' ord orderBook
                  (finalOrderBook, transactions) = processLimitBuyOrder (LimitOrder remainingOrder) updatedOrderBook
               in (finalOrderBook, matchedTransaction : transactions)
        Nothing -> (insertOrder Sell ord orderBook, [])

processLimitOrder :: LimitOrder -> OrderBook -> (OrderBook, [Transaction])
processLimitOrder mo@(LimitOrder ord) ob
  | orderType ord == Buy = processLimitBuyOrder mo ob
  | otherwise = processLimitSellOrder mo ob
