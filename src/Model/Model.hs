{-# LANGUAGE FlexibleContexts,GADTs,OverloadedStrings,QuasiQuotes,TemplateHaskell,TypeFamilies,DeriveDataTypeable #-}
module Model.Model where

import Prelude
import Yesod
import Control.Monad.IO.Class (liftIO)
import Data.Text (Text)
import Data.Typeable (Typeable)
import Database.Persist
import Database.Persist.Quasi
import Database.Persist.Postgresql
import Database.Persist.TH

share [mkPersist sqlOnlySettings, mkMigrate "migrateAll"]
  $ (persistFileWith lowerCaseSettings "config/models")

