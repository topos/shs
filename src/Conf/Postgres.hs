{-# LANGUAGE OverloadedStrings #-}
module Conf.Postgres where

import Data.Maybe
import Data.Map as Map
import Data.ByteString.Char8 (ByteString) 
import qualified Data.ByteString.Char8 as C8
import Data.Yaml.YamlLight

data PostgresConf = PostgresConf{user :: ByteString
                                ,password :: ByteString
                                ,database :: ByteString
                                ,host :: ByteString
                                ,port :: Int
                                ,poolsize :: Int
                                } deriving (Show)

yaml :: ByteString -> IO (Maybe YamlLight)
yaml env = do
  y <- parseYamlFile "/home/ml/proj/klas/config/postgresql.yml"
  return $ lookupYL (YStr env) y

conf :: YamlLight -> Maybe PostgresConf
conf yaml = do
  let m = unMap yaml
      user = Map.lookup (YStr "user") (fromJust m)
      password = toStr(lookupYL (YStr "password") yaml)
      host = toStr(lookupYL (YStr "host") yaml)
      db = toStr(lookupYL (YStr "database") yaml)
  -- return $ PostgresConf user password db host 5432 10
  return $ PostgresConf "" "" "" "" 1 2

extractMap :: Maybe YamlLight -> Map YamlLight YamlLight
extractMap yaml = do
  let y' = fromJust $ Map.lookup (YStr "<<") (fromJust (unMap $ fromJust yaml))
  fromJust $ unMap y'

toStr :: Maybe YamlLight -> ByteString
toStr s = fromJust $ unStr $ fromMaybe (YStr "-") s
