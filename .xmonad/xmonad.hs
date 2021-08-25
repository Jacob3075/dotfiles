import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers(doCenterFloat, isDialog)
import XMonad.Config.Desktop
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle.Instances
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import qualified DBus as D
import qualified DBus.Client as D


myStartupHook = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    setWMName "LG3D"

-- colours
normBord = "#4c566a"
focdBord = "#5e81ac"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myModMask = mod4Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = False
myBorderWidth = 2
myWorkspaces    = ["\61612","\61899","\61947","\61635","\61502","\61501","\61705","\61564","\62150","\61872"]
--myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]
--myWorkspaces    = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]

myBaseConfig = desktopConfig

-- window manipulations
myManageHook = composeAll . concat $
    [ [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61899" | x <- my2Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61947" | x <- my3Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61635" | x <- my4Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61502" | x <- my5Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61501" | x <- my6Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61705" | x <- my7Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61564" | x <- my8Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\62150" | x <- my9Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61872" | x <- my10Shifts]
    ]
    where
    -- doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = ["Arandr", "Arcolinux-calamares-tool.py", "Arcolinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal", "megasync"]
    myTFloats = ["Downloads", "Save As..."]
    myRFloats = []
    myIgnores = ["desktop_window"]
    -- my1Shifts = ["Chromium", "Vivaldi-stable", "Firefox"]
    -- my2Shifts = []
    -- my3Shifts = ["Inkscape"]
    -- my4Shifts = []
    -- my5Shifts = ["Gimp", "feh"]
    -- my6Shifts = ["vlc", "mpv"]
    -- my7Shifts = ["Virtualbox"]
    -- my8Shifts = ["Thunar"]
    -- my9Shifts = []
    -- my10Shifts = ["discord"]




myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True $ avoidStruts
  $ tiled
  ||| Full
  ||| Mirror tiled
  ||| spiral (6/7)
  ||| ThreeColMid 1 (3/100) (1/2)
    where
        tiled = Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]


-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS

  [ ((modMask, xK_e), spawn $ "thunar" )
  , ((modMask, xK_w), spawn $ "firefox" )
  , ((modMask, xK_q), kill )
  , ((modMask, xK_v), spawn $ "pavucontrol" )
  , ((modMask, xK_y), spawn $ "polybar-msg cmd toggle" )
  , ((modMask, xK_x), spawn $ "arcolinux-logout" )
  , ((modMask, xK_Escape), spawn $ "xkill" )
  , ((modMask, xK_r), spawn $ "xmonad --restart" )
  , ((modMask, xK_Return), spawn $ "alacritty" )

  -- FUNCTION KEYS
  , ((0, xK_F12), spawn $ "xfce4-terminal --drop-down" )

  -- SUPER KEYS

  , ((modMask .|. shiftMask , xK_Return ), spawn $ "/home/jacob/.config/rofi/launchers/launcher.sh")
  , ((modMask .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")
  , ((modMask .|. shiftMask , xK_q ), kill)
  -- , ((modMask .|. shiftMask , xK_x ), io (exitWith ExitSuccess))
  , ((modMask .|. mod1Mask , xK_p ), spawn $ "$HOME/.xmonad/scripts/picom-toggle.sh")

  , ((modMask .|. shiftMask , xK_x ), spawn $ "xfce4-taskmanager")

  --SCREENSHOTS

  , ((0, xK_Print), spawn $ "flameshot full -p /home/jacob/Pictures/Screenshots/")
  , ((controlMask, xK_Print), spawn $ "flameshot gui -p /home/jacob/Pictures/Screenshots/" )

  --MULTIMEDIA KEYS

  -- Mute volume
  , ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle")
  -- Decrease volume
  , ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 5%-")
  -- Increase volume
  , ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 5%+")
  -- Increase brightness
  , ((0, xF86XK_MonBrightnessUp),  spawn $ "xbacklight -inc 5")
  -- Decrease brightness
  , ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 5")

  , ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause")
  , ((0, xF86XK_AudioNext), spawn $ "playerctl next")
  , ((0, xF86XK_AudioPrev), spawn $ "playerctl previous")
  , ((0, xF86XK_AudioStop), spawn $ "playerctl stop")


  --------------------------------------------------------------------
  --  XMONAD LAYOUT KEYS

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)
  , ((modMask .|. controlMask, xK_f), sendMessage $ MT.Toggle NBFULL)
  --Focus selected desktop
  , ((modMask, xK_Tab), nextWS)
  , ((modMask , xK_Left ), prevWS)
  , ((modMask , xK_Right ), nextWS)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window.
  , ((modMask, xK_j), windows W.focusDown)
  , ((mod1Mask, xK_Tab), windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k), windows W.focusUp  )
  , ((mod1Mask .|. shiftMask, xK_Tab), windows W.focusUp)

  -- Move focus to the master window.
  , ((modMask .|. shiftMask, xK_m), windows W.focusMaster  )

  , ((modMask .|. shiftMask, xK_j), windows W.swapDown  )
  , ((modMask .|. shiftMask, xK_k), windows W.swapUp    )
  , ((modMask .|. shiftMask, xK_h), sendMessage Shrink)
  , ((modMask .|. shiftMask, xK_l), sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t), withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask .|. controlMask, xK_Left), sendMessage (IncMasterN (-1)))

  -- Decrement the number of windows in the master area.
  , ((modMask .|. controlMask, xK_Right), sendMessage (IncMasterN 1))

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Keyboard layouts
  --qwerty users use this line
  | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
     , (\i -> W.greedyView i . W.shift i, shiftMask)]]

main :: IO ()
main = do

    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]


    xmonad.ewmh $
      myBaseConfig
      {startupHook = myStartupHook
    , layoutHook = gaps [(U,35), (D,5), (R,5), (L,5)] $ myLayout ||| layoutHook myBaseConfig
    , manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig
    , modMask = myModMask
    , borderWidth = myBorderWidth
    , handleEventHook    = handleEventHook myBaseConfig <+> fullscreenEventHook
    , focusFollowsMouse = myFocusFollowsMouse
    , workspaces = myWorkspaces
    , focusedBorderColor = focdBord
    , normalBorderColor = normBord
    , keys = myKeys
    , mouseBindings = myMouseBindings
}
