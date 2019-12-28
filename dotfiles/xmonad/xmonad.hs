module Main (main) where

-----------------------------------------------------------------

import           Data.Default              (def)
import           System.IO
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops (ewmh)
import           XMonad.Hooks.ManageDocks  (avoidStruts, docks, docksEventHook, manageDocks)
import           XMonad.Hooks.SetWMName    (setWMName)
import           XMonad.Layout.NoBorders   (smartBorders)
import qualified XMonad.StackSet           as W
import           XMonad.Util.EZConfig      (additionalKeys)
import           XMonad.Util.Run           (spawnPipe)
import           XMonad.Layout.Spacing     (spacingRaw, Border(..))

-----------------------------------------------------------------

myTerminal = "konsole hide-menubar"

myLauncher = "dmenu_run -fn 'Tamzen-10' -nf '#fff' -p ' Search '"

myStatusBar = "xmobar"

myWorkspaces =
  [ "Code"
  , "Browser"
  , "Chat"
  , "Mail"
  , "Media"
  ]

myManageHook = composeAll . concat $
    [ [ className =? c --> doFloat           | c <- myFloats] -- doRectFloat (W.RationalRect 0.3 0.3 0.4 0.4)
    , [ className =? c --> doShift "Browser" | c <- browsers]
    , [ className =? c --> doShift "Chat"    | c <- chats   ]
    , [ className =? c --> doShift "Mail"    | c <- mails   ]
    , [ className =? c --> doShift "Media"   | c <- media   ]
    ]
  where
    myFloats = ["Enpass", "gimp"]
    browsers = ["firefox", "chromium"]
    chats    = ["Discord", "slack"]
    mails    = ["thunderbird"]
    media    = ["vlc", "nomacs"]

gaps = spacingRaw
         True              -- smartBorder
         (Border 0 0 0 0)  -- screenBorder
         False             -- screenBorderEnabled
         (Border 8 8 8 8)  -- windowBorder (Border top bottom right left)
         True              -- windowBorderEnabled

myAdditionalKeys =
  [
  -- Clipboard manager
    ((controlMask .|. shiftMask, xK_v), spawn "clipmenu")
  -- Locking the screen: Shift + Meta + z
  , ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
  -- Sreenshot
  , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -q 100 ~/Screenshots/$(date +'%Y-%b-%d-%s').png")
  , ((0, xK_Print), spawn "scrot -q 100 ~/Screenshots/$(date +'%Y-%b-%d-%s').png")
  ]

defaults xmproc = def
  { borderWidth = 2
  , normalBorderColor  = "#BFBFBF"
  , focusedBorderColor = "#89DDFF"
  , modMask = mod4Mask
  , terminal = myTerminal
  , workspaces = myWorkspaces
  , manageHook = manageDocks <+> myManageHook <+> manageHook def
  , layoutHook = avoidStruts $ gaps $ smartBorders $ layoutHook def
  , handleEventHook = handleEventHook def <+> docksEventHook
  , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "darkgreen" "" . shorten 20
                , ppHiddenNoWindows = xmobarColor "grey" ""
                }
  , startupHook = setWMName "LG3D"
  }

main = do
    xmproc <- spawnPipe myStatusBar
    xmonad $ ewmh $ docks $ defaults xmproc `additionalKeys` myAdditionalKeys
