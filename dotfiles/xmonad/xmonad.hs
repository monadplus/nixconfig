module Main (main) where

import           System.Exit
import           XMonad
import           XMonad.Config.Desktop
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageHelpers
import           XMonad.Layout.BinarySpacePartition (emptyBSP)
import           XMonad.Layout.NoBorders            (noBorders)
import           XMonad.Layout.ResizableTile        (ResizableTall (..))
import           XMonad.Layout.ToggleLayouts        (ToggleLayout (..),
                                                     toggleLayouts)
import           XMonad.Prompt
import           XMonad.Prompt.ConfirmPrompt
import           XMonad.Prompt.Shell
import           XMonad.Util.EZConfig

--------------------------------------------------------------------------------

main = do
  spawn "xmobar"
  xmonad $ defaultConfig
     { borderWidth        = 2
     , terminal           = "konsole"
     , normalBorderColor  = "#cccccc"
     , focusedBorderColor = "#cd8b00"
     }
