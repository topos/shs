{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}
module Main where

import Data.Maybe (fromJust)
import DataFeed.NyuScps (Course,courseData,message,resultList)
import Config.Postgres (PostgresConfig)

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
  save courses
  index courses
  print "ok: update"

save :: [Course] -> IO ()
save courses = do
  print "ok: courses"

index :: [Course] -> IO ()
index courses = do
  print "ok: index"

-- postgresConf :: IO (Maybe PostgresConf)
-- postgresConf = P.conf (fromJust $ P.yaml "Development")

