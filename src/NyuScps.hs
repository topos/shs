module NyuScps where

import Data.ByteString
import Data.Maybe
import Network.HTTP
import Network.URI

get::String -> IO ByteString
get url = getResponseBody =<< simpleHTTP (mkRequest GET (fromJust $ parseURI url))

url::String
url = "https://www.scps.nyu.edu/webapps/ncCourseSearch.htm?action=searchAll"

run::IO ()
run = do
  r <- get url
  print r
