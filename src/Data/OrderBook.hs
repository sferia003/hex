module Data.OrderBook
  ( Bids,
    Offers,
    OrderBook,
    Data.OrderBook.empty,
    getTopOfBook,
    deleteTopOfBook,
    insertOrder,
  )
where

import Data.Order
import Data.PQueue.Max as MAPQ
import Data.PQueue.Min as MIPQ

type Bids = MaxQueue Order

type Offers = MinQueue Order

type OrderBook = (Bids, Offers)

empty :: OrderBook
empty = (MAPQ.empty, MIPQ.empty)

getTopOfBook :: OrderType -> OrderBook -> Maybe Order
getTopOfBook Buy (bidQueue, _) = MAPQ.getMax bidQueue
getTopOfBook Sell (_, offerQueue) = MIPQ.getMin offerQueue

deleteTopOfBook :: OrderType -> OrderBook -> OrderBook
deleteTopOfBook Buy (bidQueue, offerQueue) = (MAPQ.deleteMax bidQueue, offerQueue)
deleteTopOfBook Sell (bidQueue, offerQueue) = (bidQueue, MIPQ.deleteMin offerQueue)

insertOrder :: OrderType -> Order -> OrderBook -> OrderBook
insertOrder Buy ord (bidQueue, offerQueue) = (MAPQ.insert ord bidQueue, offerQueue)
insertOrder Sell ord (bidQueue, offerQueue) = (bidQueue, MIPQ.insert ord offerQueue)
