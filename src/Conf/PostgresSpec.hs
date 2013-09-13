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
  let y' = fromJust $ Map.lookup (YStr "<<") (fromJust (unMap $ fromJust y))
      host = Map.lookup (YStr "host") (fromJust (unMap y'))
  print $ fromJust (unStr (fromJust host))
