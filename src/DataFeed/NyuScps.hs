{-# LANGUAGE OverloadedStrings,DeriveGeneric #-}
module DataFeed.NyuScps where

import Prelude as P
import Network.HTTP.Conduit (simpleHttp)
import Control.Applicative
import Control.Monad
import GHC.Generics
import qualified Data.ByteString.Lazy as L
import Data.Aeson
import Data.Text

data Courses = Courses{message :: Text
                      ,totalResults :: Int
                      ,resultList :: [Course]
                      } deriving (Show,Generic)
                                 
instance FromJSON Courses
instance ToJSON Courses

data Course = Course{courseId :: Int
                    ,sectionId :: Int
                    ,catalogId :: Int
                    ,catalogDesc :: Text
                    ,courseNo :: Text
                    ,sisSection :: Text
                    ,courseTitle :: Text
                    ,titleFirstLetter :: Text
                    ,courseDesc :: Text 
                    ,sisCredits :: Int
                    ,onlineCourse :: Int
                    ,topic :: Maybe Text
                    ,department :: Text
                    ,faculty :: Text
                    ,facultyUrl :: Text
                    ,degree :: Text
                    ,courseCost :: Int
                    ,status :: Text
                    ,sapsStatus :: Text
                    ,seatAvailable :: Int
                    ,displayStatus :: Text
                    ,sectionStartDate :: Text
                    ,sectionEndDate :: Text
                    ,weekDuration :: Int
                    ,siteCode :: Text
                    ,siteName :: Text
                    ,building :: Text
                    ,room :: Maybe Text
                    ,meetStartDate :: Text
                    ,mstartDate :: Text
                    ,mendDate :: Text
                    ,mstartDate1 :: Text
                    ,mendDate1 :: Text
                    ,meetEndDate :: Text
                    ,meetStartTime :: Maybe Text
                    ,meetEndTime :: Maybe Text
                    ,days :: Text
                    ,classDay :: Int
                    ,additionalInfo :: Text
                    ,certificate :: Text
                    ,certificateUrl :: Text
                    ,session :: Int
                    ,encodedId :: Text
                    ,newIndicator :: Int
                    ,searchKeywords :: Text
                    ,intensive :: Int
                    ,morningSec :: Int
                    ,eveningSec :: Int
                    ,weekendSec :: Int
                    ,asyncSec :: Int
                    ,vrrAvvail :: Int
                    ,advisorySigReq :: Int
                    ,webReg :: Int
                    ,regEndDate :: Text
                    ,sections :: [Text]
                    } deriving (Show,Generic)

instance FromJSON Course where
  parseJSON (Object v) = Course <$>
                         (v .: "courseId") <*> 
                         (v .: "sectionId") <*> 
                         (v .: "catalogId") <*> 
                         (v .: "catalogDesc") <*> 
                         (v .: "courseNo") <*> 
                         (v .: "sisSection") <*> 
                         (v .: "courseTitle") <*> 
                         (v .: "titleFirstLetter") <*> 
                         (v .: "courseDesc") <*>  
                         (v .: "sisCredits") <*> 
                         (v .: "onlineCourse") <*> 
                         (v .:? "topic") <*> 
                         (v .: "department") <*> 
                         (v .: "faculty") <*> 
                         (v .: "facultyUrl") <*> 
                         (v .: "degree") <*> 
                         (v .: "courseCost") <*> 
                         (v .: "status") <*> 
                         (v .: "sapsStatus") <*> 
                         (v .: "seatAvailable") <*> 
                         (v .: "displayStatus") <*> 
                         (v .: "sectionStartDate") <*> 
                         (v .: "sectionEndDate") <*> 
                         (v .: "weekDuration") <*> 
                         (v .: "siteCode") <*> 
                         (v .: "siteName") <*> 
                         (v .: "building") <*> 
                         (v .:? "room") <*>
                         (v .: "meetStartDate") <*> 
                         (v .: "mstartDate") <*> 
                         (v .: "mendDate") <*> 
                         (v .: "mstartDate1") <*> 
                         (v .: "mendDate1") <*> 
                         (v .: "meetEndDate") <*> 
                         (v .:? "meetStartTime") <*> 
                         (v .:? "meetEndTime") <*> 
                         (v .: "days") <*> 
                         (v .: "classDay") <*> 
                         (v .: "additionalInfo") <*> 
                         (v .: "certificate") <*> 
                         (v .: "certificateUrl") <*> 
                         (v .: "session") <*> 
                         (v .: "encodedId") <*> 
                         (v .: "newIndicator") <*> 
                         (v .: "searchKeywords") <*> 
                         (v .: "intensive") <*> 
                         (v .: "morningSec") <*> 
                         (v .: "eveningSec") <*> 
                         (v .: "weekendSec") <*> 
                         (v .: "asyncSec") <*> 
                         (v .: "vrrAvvail") <*> 
                         (v .: "advisorySigReq") <*> 
                         (v .: "webReg") <*> 
                         (v .: "regEndDate") <*> 
                         (v .: "sections")
instance ToJSON Course

get :: String -> IO L.ByteString
get url = simpleHttp url

url :: String
url = "http://www.scps.nyu.edu/webapps/ncCourseSearch.htm?action=searchAll"

courseData :: IO (Maybe Courses)
courseData = do
  let res = get url
  json <- (decode <$> res) :: IO (Maybe Courses)
  return json
