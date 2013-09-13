{-# LANGUAGE OverloadedStrings #-}
module Model.Course where

import Prelude as P
import GHC.Int
import Control.Monad
import Control.Applicative
import Data.Text
import Database.PostgreSQL.Simple as Ps
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.ToField

data CourseMeta = CourseMeta{url :: Text,school :: Text} deriving (Show)
data CourseData = CourseData{json :: Text,courseMeta :: CourseMeta} deriving (Show)

instance FromRow CourseMeta where fromRow = CourseMeta <$> field <*> field
instance FromRow CourseData where fromRow = CourseData <$> field <*> liftM2 CourseMeta field field

instance ToRow CourseMeta where toRow (CourseMeta a b) = [toField a,toField b]
-- instance ToRow CourseData where toRow (CourseData a b) = [toField a,b]

addCourseMeta :: [CourseMeta] -> Connection -> IO Int64
addCourseMeta cms c = do
  r <- Ps.executeMany c "insert into course_meta (url,school) values (?,?)" $ P.map (\x -> (url x,school x)) cms
  return r

-- addCourseData :: [CourseData] -> Connection -> IO Int64
-- addCourseData cds c = do
--   r <- Ps.executeMany c "insert into course_data (json,courseMeta) values (?,?)" $ P.map (\x -> (json x,courseMeta x)) cds
--   return r

getCourseData :: Int64 -> Connection -> IO [CourseData]
getCourseData id c = do
  r <- Ps.query_ c "select json,courseMeta from course_data where"
  return r

connect :: IO Connection
connect = Ps.connect defaultConnectInfo{connectDatabase = "klas_development"
                                       ,connectUser = "klas"
                                       ,connectPassword = "mbp2ubun2"
                                       }

connectTest :: IO Connection
connectTest = Ps.connect defaultConnectInfo{connectDatabase = "klas_test"
                                       ,connectUser = "klas"
                                       ,connectPassword = "mbp2ubun2"
                                       }
