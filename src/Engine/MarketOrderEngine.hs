module Engine.MarketOrderEngine (processMarketOrder) where

import Data.Order as O
import Data.OrderBook as OB
import Data.Transaction as T
import Engine.Match

processMarketBuyOrder :: MarketOrder -> OrderBook -> (OrderBook, [Transaction])
processMarketBuyOrder (MarketOrder ord) orderBook
  | O.quantity ord == 0 = (orderBook, [])
  | otherwise =
      case getTopOfBook Sell orderBook of
        Just ord' ->
          let (updatedOrderBook, matchedTransaction, remainingOrder) = match Buy ord ord' orderBook
              (finalOrderBook, transactions) = processMarketBuyOrder (MarketOrder remainingOrder) updatedOrderBook
           in (finalOrderBook, matchedTransaction : transactions)
        Nothing -> (orderBook, [])

processMarketSellOrder :: MarketOrder -> OrderBook -> (OrderBook, [Transaction])
processMarketSellOrder (MarketOrder ord) orderBook
  | O.quantity ord == 0 = (orderBook, [])
  | otherwise =
      case getTopOfBook Buy orderBook of
        Just ord' ->
          let (updatedOrderBook, matchedTransaction, remainingOrder) = match Sell ord' ord orderBook
              (finalOrderBook, transactions) = processMarketBuyOrder (MarketOrder remainingOrder) updatedOrderBook
           in (finalOrderBook, matchedTransaction : transactions)
        Nothing -> (orderBook, [])

processMarketOrder :: MarketOrder -> OrderBook -> (OrderBook, [Transaction])
processMarketOrder mo@(MarketOrder ord) ob
  | orderType ord == Buy = processMarketBuyOrder mo ob
  | otherwise = processMarketSellOrder mo ob
