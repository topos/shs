{-# LANGUAGE OverloadedStrings #-}
import Test.Hspec
import Test.QuickCheck

import GHC.Int
import Control.Monad
import Control.Applicative
import Database.PostgreSQL.Simple as Ps
import Data.Text as T
import Model.Course as C

-- @todo: create a unit-test scaffold to handle a test DB

main :: IO ()
main = hspec $ do
  describe "Model.Course" $ do
    it "adds a single pair (url,school) to course_meta" $ do
      let cm = CourseMeta "foo" "bar"
      c <- C.connect
      rows <- C.addCourseMeta [cm] c
      rows `shouldBe` 1
    it "adds pairs (url,school) to course_meta" $ do
      let cms = [CourseMeta "http://foo" "school:foo", CourseMeta "http://bar" "school:bar"]
      c <- C.connect
      rows <- C.addCourseMeta cms c
      rows `shouldBe` 2
    it "adds 3 pairs (url,school) to course_meta" $ do
      let cms = [CourseMeta "http://foo" "school:foo",CourseMeta "http://bar" "school:bar",CourseMeta "http://baz" "school:baz"]
      c <- C.connect
      rows <- C.addCourseMeta cms c
      rows `shouldBe` 3
  describe "Model.Course: addCourseData" $ do
    it "associates course_meta to course_data" $ do
      let cm = CourseMeta "foo" "bar"
      c <- C.connect
      rows <- C.addCourseMeta [cm] c
      rows `shouldBe` 1
      let cd = CourseData "foo.json" cm
      rows <- C.addCourseData [cd] c
      rows `shouldBe` 1
