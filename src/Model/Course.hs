{-# LANGUAGE OverloadedStrings #-}
module Model.Course where

import Control.Monad (forM_)
import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH
import Data.Aeson (encode)
import qualified Data.List as List (concat)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.ByteString.Lazy as BL
import qualified DataFeed.NyuScps as Nyu
import Model.Model

save :: [Nyu.Course] -> ConnectionString -> IO ()
save courses connection = withPostgresqlPool connection 16 $ \pool -> do
  flip runSqlPersistMPool pool $ do
    runMigration migrateAll
    metaId <- insert $ CourseMeta Nyu.url Nyu.school
    forM_ courses $ \c -> do
      let json = BL.toChunks $ encode c
      insert $ CourseData (T.intercalate "" (map T.decodeUtf8 json)) metaId

