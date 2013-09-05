module Main where

import Text.HandsomeSoup
import Text.XML.HXT.Core
import qualified Network.HTTP.Conduit as C
import qualified Data.ByteString.Lazy as L
import qualified Wallbase as W
import qualified NyuScps as Nyu

main = Nyu.run
