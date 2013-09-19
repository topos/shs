{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}
module Config.Postgres where

import GHC.Generics (Generic)
import Control.Monad.IO.Class (MonadIO)
import Data.Maybe (fromJust)
import Data.Text as T (Text,unpack,pack)
import Data.Map as Map (Map,lookup)
import Data.ByteString.Char8 as B (unpack,pack)
import Data.Yaml
import Data.Aeson (FromJSON,ToJSON)
import Database.Persist.Postgresql (ConnectionString)

data PostgresSection = PostgresSection {user :: Text
                                       ,password :: Text
                                       ,database :: Text
                                       ,host :: Text
                                       ,port :: Int
                                       ,poolsize :: Int
                                       } deriving (Show,Eq,Generic) 
instance FromJSON PostgresSection
-- instance ToJSON PostgresSection

data PostgresConfig = PostgresConfig (Map Text PostgresSection) deriving (Show,Eq,Generic) 
instance FromJSON PostgresConfig
-- instance ToJSON PostgresConfig

section :: Text -> PostgresConfig -> Maybe PostgresSection
section env (PostgresConfig m) = Map.lookup env m

config :: IO (Maybe PostgresConfig)
config = do
  c <- either (error . show) id `fmap` decodeFileEither "/home/ml/proj/klas/config/postgresql.yml"
  return c

connection :: String -> IO ConnectionString
connection env = do
  c <- config
  let c' = fromJust c
  let sec = fromJust $ section (T.pack env) c'
      host' = "host=" ++ (T.unpack $ host sec)
      db' = " dbname=" ++ (T.unpack $ database sec)
      user' = " user=" ++ (T.unpack $ user sec)
      password' = " password=" ++ (T.unpack $ password sec)
      port' = " port=" ++ (show $ port sec)
      cs = host' ++ db' ++ user' ++ password' ++ port'
  return $ B.pack cs
