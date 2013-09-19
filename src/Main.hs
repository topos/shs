{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}
module Main where

import Control.Monad (forM_)
import Data.Maybe (fromJust)
import Database.Persist.Postgresql (withPostgresqlPool,runMigration,runSqlPersistMPool,insert)
import qualified DataFeed.NyuScps as Nyu
import Model.Course as Course
import Config.Postgres as Postgres
import Model.Model

main = do
  courses <- Nyu.courseData
  case courses of
    Just courses -> do
      if "Success" == Nyu.message courses then
        update $ Nyu.resultList courses
      else 
        print "error: failure"
    Nothing -> print "error: nothing"

update :: [Nyu.Course] -> IO ()
update courses = do
  connectionStr <- Postgres.connection "Testing"
  Course.save courses connectionStr
  index courses
  putStrLn "update: finished"

index :: [Nyu.Course] -> IO ()
index courses = do
  putStrLn "index: finished"
