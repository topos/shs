{-# LANGUAGE TemplateHaskell #-}

module Arg where

import System.Console.GetOpt
import System.Environment (getArgs, getProgName)
import Control.Lens

data Options = Options{_xmid::Double,
                       _ymid::Double,
                       _threshold::Double,
                       _iterations::Int,
                       _zoom::Double,
                       _width::Int,
                       _height::Int,
                       _help::Bool
                      } deriving Show
makeLenses '' Options

defaultOptions = Options{_xmid=(-0.5),
                         _ymid=0,
                         _threshold=2,
                         _iterations=64,
                         _zoom=1.5,
                         _width=1024,
                         _height=768,
                         _help=False}

options::[OptDescr (Options -> Options)]
options = [Option ['x'] ["xmid"]
           (ReqArg (\x opts -> opts{_xmid=(read x)}) "xmid")
           "x midpoint"
          ,Option ['y'] ["ymid"]
           (ReqArg (\y opts -> opts{_ymid=(read y)}) "ymid")
           "y midpoint"
          ,Option ['t'] ["threshold"]
           (ReqArg (\t opts -> opts{_threshold=(read t)}) "threshold")
           "threshold"
          ,Option ['w'] ["width (pixels)"]
           (ReqArg (\w opts -> opts{_width=(read w)}) "width")
           "width"
          ,Option ['h'] ["height (pixels)"]
           (ReqArg (\h opts -> opts{_height=(read h)}) "height")
           "height"
          ,Option ['?'] ["help"]
           (NoArg (\opts -> opts{_help=True}))
           "help"]

getArg::IO Options
getArg = do
  argv <- getArgs
  help <- helpMsg
  case getOpt RequireOrder options argv of
    (opts, [], []) -> return (foldl (flip id) defaultOptions opts)
    (_, _, errs) -> ioError (userError (concat errs ++ help))

printHelp::IO ()
printHelp = do
  help <- helpMsg
  print help

helpMsg::IO String
helpMsg = do
  name <- getProgName
  let header = "usage: " ++ name ++ " [options...]"
  return $ usageInfo header options
