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
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Fullscreen as F
import System.IO
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ICCCMFocus
import qualified Data.Map as M
import XMonad.Hooks.FadeInactive

main = do
    xmproc <- spawnPipe "/home/russell/.cabal/bin/xmobar /home/russell/.xmobarrc"
    xmonad $ ewmh defaultConfig
        { manageHook = composeOne
                    [checkDock              -?> doIgnore -- equivalent to manageDocks
                     ,isDialog               -?> doFloat
                    , className =? "Gimp"    -?> doFloat
                    , className =? "MPlayer" -?> doFloat
                    , className =? "Vlc"     -?> doFullFloat
                    , return True -?> doF W.swapDown
                    ] 
        , layoutHook = F.fullscreenFocus $ avoidStruts $ smartBorders $ layoutHook defaultConfig
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        -- Rename so intellij doesn't die
        , startupHook = do
		setWMName "LG3D"
		spawn "~/.xmonad/startup-hook"
        , handleEventHook =  F.fullscreenEventHook  <+> ewmhDesktopsEventHook
        , keys = myKeys
        -- Nice blue
        , focusedBorderColor = "#204aFF"
        -- Nice gray
        , normalBorderColor  = "#000000"
        , borderWidth        = 0
        -- takeTopFocus is for intellij
        , logHook = noFadeVlc >> takeTopFocus <+> dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
        }      

fadeInactive = fadeInactiveLogHook 0.90
noFadeVlc = fadeOutLogHook $ fadeIf ((isUnfocused <&&> (className =? "vlc") =? False)) 0.93 

myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

newKeys conf@(XConfig {XMonad.modMask = modm}) = [
   ((modm .|. controlMask, xK_p ), spawn "shutter -s") 
   -- pause the music before locking
 , ((modm .|. controlMask, xK_l), spawn "spotifyctl pause && slock")
 , ((0, 0x1008FF14), spawn "spotifyctl playpause")
 , ((0, 0x1008FF17), spawn "spotifyctl next")
 , ((0, 0x1008FF12), toggleMute    >> return ())
 , ((0, 0x1008FF11), lowerVolume 4 >> return ())
 , ((0, 0x1008FF13), raiseVolume 4 >> return ())
 , ((0, 0x1008FF03), spawn "xbacklight -dec 10")
 , ((0, 0x1008FF02), spawn "xbacklight -inc 10")
 , ((modm, xK_BackSpace), focusUrgent)
 ]
