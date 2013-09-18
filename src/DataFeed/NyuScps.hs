{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}

module DataFeed.NyuScps where

import GHC.Generics
import Prelude as P
import Network.HTTP.Conduit (simpleHttp)
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy as L
import Data.Aeson
import Data.Text

data Courses = Courses {message :: Text
                       ,totalResults :: Int
                       ,resultList :: [Course]
                       } deriving (Show,Generic)
                                 
instance FromJSON Courses
instance ToJSON Courses

data Course = Course {courseId :: Maybe Int
                     ,sectionId :: Maybe Int
                     ,catalogId :: Maybe Int
                     ,catalogDesc :: Maybe Text
                     ,courseNo :: Maybe Text
                     ,sisSection :: Maybe Text
                     ,courseTitle :: Maybe Text
                     ,titleFirstLetter :: Maybe Text
                     ,courseDesc :: Maybe Text 
                     ,sisCredits :: Maybe Int
                     ,onlineCourse :: Maybe Int
                     ,topic :: Maybe Text
                     ,department :: Maybe Text
                     ,faculty :: Maybe Text
                     ,facultyUrl :: Maybe Text
                     ,degree :: Maybe Text
                     ,courseCost :: Maybe Int
                     ,status :: Maybe Text
                     ,sapsStatus :: Maybe Text
                     ,seatAvailable :: Maybe Int
                     ,displayStatus :: Maybe Text
                     ,sectionStartDate :: Maybe Text
                     ,sectionEndDate :: Maybe Text
                     ,weekDuration :: Maybe Int
                     ,siteCode :: Maybe Text
                     ,siteName :: Maybe Text
                     ,building :: Maybe Text
                     ,room :: Maybe Text
                     ,meetStartDate :: Maybe Text
                     ,mstartDate :: Maybe Text
                     ,mendDate :: Maybe Text
                     ,mstartDate1 :: Maybe Text
                     ,mendDate1 :: Maybe Text
                     ,meetEndDate :: Maybe Text
                     ,meetStartTime :: Maybe Text
                     ,meetEndTime :: Maybe Text
                     ,days :: Maybe Text
                     ,classDay :: Maybe Int
                     ,additionalInfo :: Maybe Text
                     ,certificate :: Maybe Text
                     ,certificateUrl :: Maybe Text
                     ,session :: Maybe Int
                     ,encodedId :: Maybe Text
                     ,newIndicator :: Maybe Int
                     ,searchKeywords :: Maybe Text
                     ,intensive :: Maybe Int
                     ,morningSec :: Maybe Int
                     ,eveningSec :: Maybe Int
                     ,weekendSec :: Maybe Int
                     ,asyncSec :: Maybe Int
                     ,vrrAvvail :: Maybe Int
                     ,advisorySigReq :: Maybe Int
                     ,webReg :: Maybe Int
                     ,regEndDate :: Maybe Text
                     ,sections :: Maybe [Text]
                     } deriving (Show,Generic)


instance FromJSON Course where
  parseJSON (Object v) = Course <$>
                         (v .:? "courseId") <*> 
                         (v .:? "sectionId") <*> 
                         (v .:? "catalogId") <*> 
                         (v .:? "catalogDesc") <*> 
                         (v .:? "courseNo") <*> 
                         (v .:? "sisSection") <*> 
                         (v .:? "courseTitle") <*> 
                         (v .:? "titleFirstLetter") <*> 
                         (v .:? "courseDesc") <*>  
                         (v .:? "sisCredits") <*> 
                         (v .:? "onlineCourse") <*> 
                         (v .:? "topic") <*> 
                         (v .:? "department") <*> 
                         (v .:? "faculty") <*> 
                         (v .:? "facultyUrl") <*> 
                         (v .:? "degree") <*> 
                         (v .:? "courseCost") <*> 
                         (v .:? "status") <*> 
                         (v .:? "sapsStatus") <*> 
                         (v .:? "seatAvailable") <*> 
                         (v .:? "displayStatus") <*> 
                         (v .:? "sectionStartDate") <*> 
                         (v .:? "sectionEndDate") <*> 
                         (v .:? "weekDuration") <*> 
                         (v .:? "siteCode") <*> 
                         (v .:? "siteName") <*> 
                         (v .:? "building") <*> 
                         (v .:? "room") <*>
                         (v .:? "meetStartDate") <*> 
                         (v .:? "mstartDate") <*> 
                         (v .:? "mendDate") <*> 
                         (v .:? "mstartDate1") <*> 
                         (v .:? "mendDate1") <*> 
                         (v .:? "meetEndDate") <*> 
                         (v .:? "meetStartTime") <*> 
                         (v .:? "meetEndTime") <*> 
                         (v .:? "days") <*> 
                         (v .:? "classDay") <*> 
                         (v .:? "additionalInfo") <*> 
                         (v .:? "certificate") <*> 
                         (v .:? "certificateUrl") <*> 
                         (v .:? "session") <*> 
                         (v .:? "encodedId") <*> 
                         (v .:? "newIndicator") <*> 
                         (v .:? "searchKeywords") <*> 
                         (v .:? "intensive") <*> 
                         (v .:? "morningSec") <*> 
                         (v .:? "eveningSec") <*> 
                         (v .:? "weekendSec") <*> 
                         (v .:? "asyncSec") <*> 
                         (v .:? "vrrAvvail") <*> 
                         (v .:? "advisorySigReq") <*> 
                         (v .:? "webReg") <*> 
                         (v .:? "regEndDate") <*> 
                         (v .:? "sections")
instance ToJSON Course

get :: String -> IO L.ByteString
get url = simpleHttp url

courseData :: IO (Maybe Courses)
courseData = do
  let res = get "http://www.scps.nyu.edu/webapps/ncCourseSearch.htm?action=searchAll"
  json <- (decode <$> res) :: IO (Maybe Courses)
  return json
