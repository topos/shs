{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}
module Main where

import qualified DataFeed.NyuScps as N

index :: [N.Course] -> IO ()
index courses = do
  print "ok"

main = do
  courses <- N.courseData
  case courses of
    Just courses -> do
      if "Success" == N.message courses then do
        index $ N.resultList courses
        print "ok"
      else 
        print "error: failure"
    Nothing -> print "error: nothing"
