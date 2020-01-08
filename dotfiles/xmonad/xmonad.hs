module Main (main) where

-----------------------------------------------------------------

import           Data.Default                 (def)
import qualified Data.Map.Strict              as M

import           System.Exit                  (ExitCode (..), exitWith)
import           System.IO

import           Data.Bool
import qualified Graphics.X11.ExtraTypes.XF86 as XF86
import           XMonad
import           XMonad.Actions.CycleWS       (nextWS, prevWS)
import           XMonad.Actions.FloatKeys     (keysMoveWindow, keysResizeWindow)
import           XMonad.Actions.Volume
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops    (ewmh)
import           XMonad.Hooks.FloatNext       (floatNextHook, toggleFloatAllNew, toggleFloatNext)
import           XMonad.Hooks.ManageDocks     (ToggleStruts (..), avoidStruts, docks, docksEventHook, manageDocks)
import           XMonad.Hooks.SetWMName       (setWMName)
import           XMonad.Layout.Maximize       (maximize)
import           XMonad.Layout.Maximize       (maximizeRestore)
import           XMonad.Layout.NoBorders      (smartBorders)
import           XMonad.Layout.ResizableTile  (MirrorResize (..), ResizableTall (..))
import           XMonad.Layout.Spacing        (Border (..), spacingRaw, toggleWindowSpacingEnabled)
import qualified XMonad.StackSet              as W
import           XMonad.Util.Dzen
import           XMonad.Util.EZConfig         (additionalKeys)
import           XMonad.Util.Run              (spawnPipe)

-----------------------------------------------------------------

myTerminal workspace = "konsole hide-menubar --workdir " <> workspace

myLauncher = "dmenu_run -fn 'Tamzen-10' -nf '#fff' -p ' Search '"

myStatusBar = "xmobar"

modm = mod4Mask -- Windows key

data Workspace = Main | Code | Browser | Chat | Mail | Media | Swap
  deriving Show

myWorkspaces :: [Workspace]
myWorkspaces =
  [ Main
  , Code
  , Browser
  , Chat
  , Mail
  , Media
  , Swap
  ]

myManageHook = composeAll . concat $
    [ [ check c --> doFloat          | c <- myFloats] -- doRectFloat (W.RationalRect 0.3 0.3 0.4 0.4)
    , [ check c --> doShift' Browser | c <- browsers]
    , [ check c --> doShift' Chat    | c <- chats   ]
    , [ check c --> doShift' Mail    | c <- mails   ]
    , [ check c --> doShift' Media   | c <- media   ]
    ]
  where
    -- className: `$ xprop | grep WM_CLASS`
    myFloats = ["Enpass", "Gimp", "zoom", "zoom-us"]
    browsers = ["Firefox", "Chromium-browser"]
    chats    = ["Discord", "Slack"]
    mails    = ["Mail", "thunderbird"]
    media    = ["vlc", "nomacs", "transgui", "Image Lounge"]
    doShift' workspace =  doShift (show workspace)
    check x = className =? x <||> title =? x <||> resource =? x

gaps = spacingRaw
         True              -- smartBorder
         (Border 0 0 0 0)  -- screenBorder
         False             -- screenBorderEnabled
         (Border 4 4 4 4)  -- windowBorder (Border top bottom right left)
         True              -- windowBorderEnabled

myLayout = maximize (ResizableTall 1 (3 / 100) (1 / 2) [] ||| Full)

-- TODO doesn't work
alert :: String -> X ()
alert = dzenConfig centered
  where
    centered = onCurr (center 150 66)
                >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
                >=> addArgs ["-fg", "#80c0ff"]
                >=> addArgs ["-bg", "#000040"]

alertDouble :: Double -> X ()
alertDouble = alert . show . round

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig { XMonad.modMask = modMask }) =
  M.fromList
    $  [ ( (modm, xK_Return)                , spawn (myTerminal "/etc/nixos"))
       , ( (modm .|. shiftMask, xK_Return)  , spawn (myTerminal "~/haskell"))
       , ( (modm .|. controlMask, xK_Return), spawn (myTerminal "~/haskell/coinweb/on-server"))
       , ( (modm, xK_p)                   , spawn myLauncher)
       , ( (modm, xK_Tab)                 , nextWS)
       , ( (modm .|. shiftMask, xK_Tab)   , prevWS)
       , ( (modm, xK_j), windows W.focusDown)
       , ( (modm, xK_k), windows W.focusUp)
       , ( (modm, xK_comma) , sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
       , ( (modm, xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area
       , ( (modm, xK_space), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
       , ( (modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default
       , ( (modm, xK_t), withFocused $ windows . W.sink) -- %! Push window back into tiling
       , ( (modm, xK_h), sendMessage Shrink) -- %! Shrink the master area
       , ( (modm, xK_l), sendMessage Expand) -- %! Expand the master area
        -- , ((mod4Mask              , xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window
       , ( (modm, xK_m), windows W.swapMaster) -- %! Swap the focused window and the master window
       , ( (modm .|. shiftMask, xK_j), windows W.swapDown) -- %! Swap the focused window with the next window
       , ( (modm .|. shiftMask, xK_k), windows W.swapUp) -- %! Swap the focused window with the previous window
       , ( (modm .|. shiftMask, xK_c), kill) -- %! Close the focused window
       -- nb. Both exits are commented to avoid undesirable misclicks
       --, ( (modm, xK_q), broadcastMessage ReleaseResources >> restart "xmonad" True) -- %! Restart xmonad
       --, ( (modm .|. shiftMask, xK_q), io (exitWith ExitSuccess)) -- Quit xmonad.
       , ( (modm .|. shiftMask, xK_x), spawn "kill $(pidof xmobar); xmobar") -- %! Kill & restart statusbar
       , ( (modm, xK_f), withFocused (sendMessage . maximizeRestore))
       , ( (modm, xK_z), sendMessage MirrorShrink)
       , ( (modm, xK_a), sendMessage MirrorExpand)
       , ( (modm, xK_e), toggleFloatNext)
       , ( (modm .|. shiftMask, xK_e), toggleFloatAllNew) -- toggle fullscreen (really just lower status bar below everything)
       , ( (modm, xK_b), sendMessage ToggleStruts)
       , ( (modm , xK_g), toggleWindowSpacingEnabled)-- floating window keys
       , ( (modm, xK_equal), withFocused (keysMoveWindow (-1, -30)))
       , ( (modm, xK_apostrophe), withFocused (keysMoveWindow (0, 30)))
       , ( (modm, xK_bracketright), withFocused (keysMoveWindow (30, 0)))
       , ( (modm, xK_bracketleft), withFocused (keysMoveWindow (-30, 0)))
       , ( (controlMask .|. shiftMask, xK_m), withFocused $ keysResizeWindow (0, -15) (0, 0))
       , ( (controlMask .|. shiftMask, xK_comma), withFocused $ keysResizeWindow (0, 15) (0, 0))
       -- Volumne
       , ( (0, XF86.xF86XK_AudioMute)       , toggleMute    >> return ())
       , ( (0, XF86.xF86XK_AudioLowerVolume), lowerVolume 5 >> return ())
       , ( (0, XF86.xF86XK_AudioRaiseVolume), raiseVolume 5 >> return ())
       -- Screen brightness
       , ( (0, XF86.xF86XK_MonBrightnessUp)  , spawn "brightnessctl set +10%")
       , ( (0, XF86.xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")
       -- TODO toogle micro
       -- Workspace management
       ] ++ [ ((m .|. modMask, k), windows $ f i) -- mod-[1..9], Switch to workspace N
            | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9] -- mod-shift-[1..9], Move client to workspace N
            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
            ]

myAdditionalKeys =
  [
  -- Clipboard manager
    ((controlMask .|. shiftMask, xK_v), spawn "clipmenu")
  -- Locking the screen: Shift + Meta + z
  , ((modm .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
  -- Sreenshot
  , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -q 100 ~/Screenshots/$(date +'%Y-%b-%d-%s').png")
  , ((0, xK_Print), spawn "scrot -q 100 ~/Screenshots/$(date +'%Y-%b-%d-%s').png")
  ]

defaults xmproc = def
  { borderWidth = 2
  , normalBorderColor  = "#BFBFBF"
  , focusedBorderColor = "#89DDFF"
  , keys       = myKeys
  , modMask    = modm
  , terminal   = myTerminal "/etc/nixos"
  , workspaces = show <$> myWorkspaces
  , manageHook = manageDocks <+> floatNextHook <+> myManageHook <+> manageHook def
  , layoutHook = avoidStruts $ gaps $ smartBorders $ myLayout
  , handleEventHook = handleEventHook def <+> docksEventHook
  , logHook = dynamicLogWithPP def
                { ppOutput = hPutStrLn xmproc
                , ppCurrent = xmobarColor "darkorange" ""
                , ppHidden = xmobarColor "white" ""
                , ppHiddenNoWindows = xmobarColor "grey" ""
                , ppUrgent  = xmobarColor "red" ""
                , ppSep = " | "
                , ppWsSep = " "
                , ppTitle = xmobarColor "darkgreen" "" . shorten 40
                }
  }

main = do
    xmproc <- spawnPipe myStatusBar
    xmonad $ ewmh $ docks $ defaults xmproc `additionalKeys` myAdditionalKeys
