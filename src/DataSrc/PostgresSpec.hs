{-# LANGUAGE OverloadedStrings #-}

import Test.Hspec
import Test.QuickCheck

import Data.Maybe (fromMaybe)
import Data.Text
import Data.Map as Map
import Data.Yaml.Config as Config
import Data.Postgres as Postgres

main :: IO ()
main = hspec $ do
  describe "Data.Postgres" $ do
    it "returns a yaml object" $ do
      y <- Postgres.loadYaml "/home/ml/proj/klas/config/postgresql.yml" "Development"
      print y
    -- it "gets yaml config" $ do
    --   yaml <- Postgres.yaml
    --   let keys = Config.keys yaml
    --   keys `shouldBe` ["Staging","Testing","Production","Development","Default"]
    -- it "gets yaml subconfig" $ do
    --   yaml <- postgresYaml
    --   dev <- subconfig "Development" yaml
    --   let keys = Config.keys dev
    --   keys `shouldBe` ["user","password","poolsize","port","host","database"]
    -- it "gets value from yaml subconfig" $ do
    --   yaml <- postgresYaml
    --   dev <- Config.subconfig "Development" yaml
    --   v <- Config.lookup "user" dev
    --   mapM_ putStrLn [v]
