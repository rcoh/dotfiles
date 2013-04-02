import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (checkDock, avoidStruts)
import qualified XMonad.StackSet as W
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

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
        , layoutHook = avoidStruts $ smartBorders $  layoutHook defaultConfig
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
        }      
