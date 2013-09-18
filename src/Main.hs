{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}
module Main where

import Data.Maybe (fromJust)
import DataFeed.NyuScps (Course,courseData,message,resultList)
import Config.Postgres as Postgres

main = do
  courses <- courseData
  case courses of
    Just courses -> do
      if "Success" == message courses then do
        update $ resultList courses
        print "ok"
      else 
        print "error: failure"
    Nothing -> print "error: nothing"

update :: [Course] -> IO ()
update courses = do
  print courses
  save courses
  index courses
  print "ok: update"

save :: [Course] -> IO ()
save courses = do
  print "ok: save"

index :: [Course] -> IO ()
index courses = do
  print "ok: index"

postgresConf :: IO (Maybe PostgresSection)
postgresConf = do
  c <- Postgres.config
  let c' = fromJust c
  return $ section "Development" c'
