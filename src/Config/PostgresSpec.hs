{-# LANGUAGE OverloadedStrings #-}

import Test.Hspec
import Test.QuickCheck

import Data.Maybe (fromJust)
import Config.Postgres as Postgres

main :: IO ()
main = hspec $ do
  describe "Conf.Postgres" $ do
    it "gets Development section from postgres.yml" $ do
      c <- Postgres.config
      let c' = fromJust c
      let s = fromJust $ section "Development" c'
      (Postgres.database s) `shouldBe` "klas_development"
    it "gets Staging section postgres.yml" $ do
      c <- Postgres.config
      let c' = fromJust c
      let s = fromJust $ section "Staging" c'
      (Postgres.database s) `shouldBe` "klas_staging"
    it "gets Production section postgres.yml" $ do
      c <- Postgres.config
      let c' = fromJust c
      let s = fromJust $ section "Production" c'
      (Postgres.database s) `shouldBe` "klas_production"
    it "gets Testing section postgres.yml" $ do
      c <- Postgres.config
      let c' = fromJust c
      let s = fromJust $ section "Testing" c'
      (Postgres.database s) `shouldBe` "klas_testing"
