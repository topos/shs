{-# LANGUAGE FlexibleContexts,GADTs,OverloadedStrings,QuasiQuotes,TemplateHaskell,TypeFamilies,DeriveDataTypeable #-}
module Model.Model where

import Control.Monad.IO.Class (liftIO)
import Data.Text (Text)
import Data.Typeable (Typeable)
import Database.Persist
import Database.Persist.TH
import Database.Persist.Quasi
import Database.Persist.Postgresql

share [mkPersist sqlOnlySettings,mkMigrate "migrateAll"]
  $(persistFileWith lowerCaseSettings "/home/ml/proj/klas/config/models")

