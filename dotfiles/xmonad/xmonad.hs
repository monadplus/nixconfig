module Main (main) where

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

--------------------------------------------------------------------------------

-- TODO xmobar not showing when anything is open
-- TODO xmobar info sucks
main = do
    xmproc <- spawnPipe "xmobar" -- Launch an external application through the system shell and return a Handle to its standard input.

    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        -- xmonad calls the logHook with every internal state update, which is useful for (among other things) outputting status information to an external status bar program such as xmobar or dzen.
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask
        , terminal = "konsole"
        } `additionalKeys`

        [
        -- Clipboard manager
          ((controlMask .|. shiftMask, xK_v), spawn "clipmenu")
        -- Locking the screen: Shift + Meta + z
        , ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
        -- Print screen
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        -- Print screen
        , ((0, xK_Print), spawn "scrot")
        ]
