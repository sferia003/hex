module Egress (egress) where

import Control.Concurrent
import Control.Monad
import Data.ByteString.Lazy.Char8 qualified as BL
import Data.Text.Encoding as DE
import Network.AMQP
import Network.Simple.TCP

client :: Connection -> (Socket, SockAddr) -> IO ()
client conn (sck, _) = do
  chan <- openChannel conn
  msg <- recv sck 4096
  case msg of
    Nothing -> return ()
    Just sym -> do
      _ <- consumeMsgs chan (DE.decodeUtf8Lenient sym) Ack (callback sck)
      forever $ threadDelay maxBound

callback :: Socket -> (Message, Envelope) -> IO ()
callback sock (msg, env) = do
  send sock $ BL.toStrict $ msgBody msg
  ackEnv env

egress :: IO ()
egress = do
  print ("Starting Egress Interface" :: String)
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  serve (Host "127.0.0.1") "8003" $ client conn
