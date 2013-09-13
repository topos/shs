{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}
module Main where

import qualified DataFeed.NyuScps as N
import qualified Model.Course as MC
import qualified Database.PostgreSQL.Simple as Ps

main = do
  courses <- N.courseData
  case courses of
    Just courses -> do
      if "Success" == N.message courses then do
        update $ N.resultList courses
        print "ok"
      else 
        print "error: failure"
    Nothing -> print "error: nothing"

update :: [N.Course] -> IO ()
update courses = do
  save courses
  index courses
  print "ok: update"

save :: [N.Course] -> IO ()
save courses = do
  print "ok: courses"

index :: [N.Course] -> IO ()
index courses = do
  print "ok: index"

