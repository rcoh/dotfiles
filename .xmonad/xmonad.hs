import XMonad
import XMonad.Hooks.UrgencyHook
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (checkDock, avoidStruts)
import qualified XMonad.StackSet as W
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Fullscreen
import System.IO
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ICCCMFocus
import qualified Data.Map as M
import XMonad.Hooks.FadeInactive

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/rcoh/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = composeOne
                    [ checkDock              -?> doIgnore -- equivalent to manageDocks
                    , isDialog               -?> doFloat
                    , className =? "Gimp"    -?> doFloat
                    , className =? "MPlayer" -?> doFloat
                    , className =? "HipChat" <&&> isInProperty "_NET_WM_STATE" "_NET_WM_STATE_SKIP_TASKBAR" -?> doFloat
                    , className =? "Vlc"     -?> doFullFloat
                    , return True -?> doF W.swapDown
                    ] 
        , layoutHook = fullscreenFocus $ avoidStruts $ smartBorders $ layoutHook defaultConfig
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        -- Rename so intellij doesn't die
        , startupHook = setWMName "LG3D"
        , handleEventHook = fullscreenEventHook
        , keys = myKeys
        -- Nice blue
        , focusedBorderColor = "#204aFF"
        -- Nice gray
        , normalBorderColor  = "#2e3436"
        , borderWidth        = 2
        -- takeTopFocus is for intellij
        , logHook = fadeInactive >> takeTopFocus <+> dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
        }      

fadeInactive = fadeInactiveLogHook 0.5
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

newKeys conf@(XConfig {XMonad.modMask = modm}) = [
   ((modm .|. controlMask, xK_p ), spawn "shutter -s") 
   -- pause the music before locking
 , ((modm .|. controlMask, xK_l), spawn "spotifyctl pause && slock")
 , ((0, xK_F5), spawn "spotifyctl playpause")
 , ((0, xK_F6), lowerVolume 4 >> return ())
 , ((0, xK_F7), raiseVolume 4 >> return ())
 , ((0, xK_F8), spawn "spotifyctl next")
 , ((modm, xK_BackSpace), focusUrgent)
 ]
