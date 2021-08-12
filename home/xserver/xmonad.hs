import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.TwoPane (TwoPane (..))
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main = do
  xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP {ppCurrent = xmobarColor "#c792ea" "" . wrap "<" ">"}

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myWorkspaces = ["1:work", "2:vbox", "3:chat", "4:mail"]

myLayoutHook =
  smartBorders $
    noBorders Full
      ||| Tall 1 (10 / 100) (60 / 100)
      ||| TwoPane (15 / 100) (55 / 100)

-- Main configuration, override the defaults to your liking.
myConfig =
  ewmh
    def
      { terminal = "kitty tmux",
        modMask = mod4Mask,
        borderWidth = 3,
        startupHook = customStartupHook,
        workspaces = myWorkspaces,
        layoutHook = myLayoutHook
      }
    `additionalKeysP` [ ("M-p", spawn "rofi -show combi"),
                        ("M-s", spawn "flameshot gui"),
                        ("M-m", spawn "autorandr --force --change")
                      ]
  where
    customStartupHook = do
      spawnOnce "fcitx5 -d"