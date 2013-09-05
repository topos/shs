module Wallbase where

import Text.HandsomeSoup
import Text.XML.HXT.Core
import qualified Data.ByteString.Char8 as B
import Control.Monad.Maybe

explode :: Eq a => a -> [a] -> [[a]]
explode _ [] = []
explode x (x':xs) | x == x' = explode x xs
explode x xs = takeWhile (/=x) xs : explode x (dropWhile (/=x) xs)

download :: String -> IO ()
download url = do
  content <- runMaybeT $ openUrl url
  case content of
    Just content' -> do
      let name = last $ explode '/' url
      B.writeFile name (B.pack content')
    Nothing -> putStrLn $ "error: " ++ url

image::String -> IO String
image url = do
  let doc = fromUrl url
  urls <- runX $ doc >>> css "div" >>> hasAttrValue "class" (== "content clr") >>> getChildren >>> css "img" ! "src"
  return $ head urls

url::String
url = "https://www.scps.nyu.edu/webapps/ncCourseSearch.htm?action=searchAll"

run::IO ()
run = do
  let doc = fromUrl "http://wallbase.cc/toplist"
  urls <- runX $ doc >>> css "a" >>> hasAttrValue "target" (== "_blank") ! "href"
  mapM_ (\url -> image url >>= download) urls
  print urls

