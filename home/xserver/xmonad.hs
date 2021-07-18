import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

main :: IO ()
main = do
  xmonad $
    ewmh
      def
        { terminal = "kitty",
          modMask = mod4Mask,
          borderWidth = 3,
          startupHook = customStartupHook,
          focusFollowsMouse = False
        }
      `additionalKeysP` [ ("M-p", spawn "rofi -show combi"),
                          ("M-s", spawn "flameshot gui")
                        ]
  where
    customStartupHook = do
      spawnOnce "fcitx5 -d"
