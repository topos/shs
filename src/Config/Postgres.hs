{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}
module Config.Postgres where

import GHC.Generics (Generic)
import Data.Text (Text)
import Data.Map as Map (Map,lookup)
import Data.Yaml
import Data.Aeson (FromJSON,ToJSON)

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
  
