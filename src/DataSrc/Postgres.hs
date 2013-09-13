{-# LANGUAGE OverloadedStrings,TemplateHaskell #-}
module DataSrc.Postgres where

import GHC.Generics
import Control.Applicative
import Control.Monad
import Data.Aeson.TH
import Data.Text
import qualified Data.HashMap.Strict as M
import Data.Yaml as Y

data PostgresConf = PostgresConf{conf :: M.HashMap Text Text} deriving (Show,Eq)
deriveJSON defaultOptions ''PostgresConf

loadYaml :: String -> String -> IO (Maybe PostgresConf)
loadYaml env filename = do
  y <- Y.decodeFile filename
  let p = M.lookup env y
  return p
