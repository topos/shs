{-# LANGUAGE OverloadedStrings #-}

import Test.Hspec
import Test.QuickCheck
import Control.Applicative
import Data.Map as Map
import Data.Maybe (fromJust)
import Data.Yaml.YamlLight
import Conf.Postgres as Postgres

main :: IO ()
main = do
  y <- Postgres.yaml "Development"
  let ymap = extractMap y
      host = fromJust $ unStr $ fromJust $ Map.lookup (YStr "host") ymap
  print host
