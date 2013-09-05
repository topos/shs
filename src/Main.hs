module Main where

import qualified NyuScps as N

main = do
  courses <- N.courseData
  case courses of
    Nothing -> print "error"
    Just courses -> do
      print $ N.message courses
      print $ N.totalResults courses
      print $ N.resultList courses

