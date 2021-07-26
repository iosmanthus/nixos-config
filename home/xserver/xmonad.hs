import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

main :: IO ()
main = do
  xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP {ppCurrent = xmobarColor "#429942" "" . wrap "<" ">"}

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Main configuration, override the defaults to your liking.
myConfig =
  ewmh
    def
      { terminal = "kitty",
        modMask = mod4Mask,
        borderWidth = 3,
        startupHook = customStartupHook,
        focusFollowsMouse = False
      }
    `additionalKeysP` [ ("M-p", spawn "rofi -show combi"),
                        ("M-s", spawn "flameshot gui"),
                        ("M-m", spawn "autorandr --force --change")
                      ]
  where
    customStartupHook = do
      spawnOnce "fcitx5 -d"