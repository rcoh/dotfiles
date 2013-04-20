import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (checkDock, avoidStruts)
import qualified XMonad.StackSet as W
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import qualified Data.Map as M

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
        , keys = myKeys
        , focusedBorderColor = "#0000FF"
        , normalBorderColor  = "#000000"
        , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
        }      

myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

newKeys conf@(XConfig {XMonad.modMask = modm}) = [
-- full screenshot
  ((modm , xK_Print ), spawn "scrot screen_%Y-%m-%d-%H-%M-%S.png -d 1")
-- focused screenshot
 , ((modm .|. controlMask, xK_Print ), spawn "scrot window_%Y-%m-%d-%H-%M-%S.png -d 1-u") 
 ]
