module Engine.Match (match) where

import Data.Order as O
import Data.OrderBook as OB
import Data.Transaction as T
import Data.Util

match :: OrderType -> Order -> Order -> OrderBook -> (OrderBook, Transaction, Order)
match otype buyOrder sellOrder orderBook =
  let remainingBuyQty = O.quantity buyOrder
      remainingSellQty = O.quantity sellOrder
      matchedQty = min remainingBuyQty remainingSellQty
      updatedBuyQty = remainingBuyQty - matchedQty
      updatedSellQty = remainingSellQty - matchedQty
      priceOfTopOfBook = if otype == Buy then O.price sellOrder else O.price buyOrder
      matchedTransaction = Transaction priceOfTopOfBook matchedQty
      remainingBuyOrder = buyOrder {O.quantity = updatedBuyQty}
      remainingSellOrder = sellOrder {O.quantity = updatedSellQty}
      remainingOrder = (otype == Sell) ? (remainingSellOrder, remainingBuyOrder)
      updatedOrderBook =
        case otype of
          Buy ->
            if updatedSellQty > 0
              then insertOrder Sell remainingSellOrder (deleteTopOfBook Sell orderBook)
              else deleteTopOfBook Sell orderBook
          Sell ->
            if updatedBuyQty > 0
              then insertOrder Buy remainingBuyOrder (deleteTopOfBook Buy orderBook)
              else deleteTopOfBook Buy orderBook
   in (updatedOrderBook, matchedTransaction, remainingOrder)
