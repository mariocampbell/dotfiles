-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.Exit

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders

import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Actions.SpawnOn

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "tilix -e tmux"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = map show [1..12]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0088CC"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- muted microphone
    , ((controlMask .|. shiftMask, xK_m), spawn "mic-control toggle")

    -- launch powermenu
    , ((modm,               xK_x     ), spawn "powermenu")

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "rofi -show drun -modi drun -show-icons")

    -- launch change keyboard languaje
    , ((controlMask .|. shiftMask, xK_i), spawn "changekeyboard")

    -- launch xscreensaver
    , ((modm .|. controlMask, xK_l), spawn "betterlockscreen -l")

    -- launch calculator
    , ((modm .|. shiftMask, xK_p     ), spawn "rofi -show calc")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0,xK_minus,xK_equal]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = 
    spacingRaw False (Border 5 5 5 5) True (Border 5 5 5 5) True (tiled ||| Mirror tiled) ||| fullscreen

  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- default Full tiling
     fullscreen    = noBorders Full
     
     -- default tiling algorithm partitions the screen into three panes
     threeColumns   = ThreeColMid nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 2/3

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "discord"        --> doShift ( myWorkspaces !! 9 )
    , className =? "Google-chrome"        --> doShift ( myWorkspaces !! 1 )
    , className =? "crx_agimnkijcaahngcdmfeangaknmldooml"        --> doShift ( myWorkspaces !! 11 )
    , className =? "Zoho Mail - Desktop"  --> doShift ( myWorkspaces !! 4 )
    , className =? "Whatsapp-for-linux"  --> doShift ( myWorkspaces !! 10 )
    , className =? "Slack"  --> doShift ( myWorkspaces !! 10 )
    , className =? "TelegramDesktop"  --> doShift ( myWorkspaces !! 10 )
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawnOnce "xmobar &"
    spawnOnce "xrandr --output eDP1 --mode 1600x900 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI2 --off --output VIRTUAL1 --off"
    -- spawnOnce "xrandr --output eDP-1 --mode 1600x900 --pos 0x0 --rotate normal --output HDMI-1 --off --output HDMI-2 --off --output VIRTUAL1 --off"
    spawnOnce "xautolock -time 5 -locker \"betterlockscreen -l\" -detectsleep -corners --00"
    spawnOnce "picom -b --experimental-backends &"
    spawnOnce "feh --bg-fill ~/ninja-wallpaper-2.jpg"
    spawnOnce "xsetroot -cursor_name left_ptr"

------------------------------------------------------------------------
-- Command to launch the bar
myBar = "LANG=es_AR.utf-8 xmobar" 

-- Custom PP, configure it as you like. It determines what is being written to the bar
myPP = xmobarPP { 
                    ppCurrent = xmobarColor "#0088CC" "" . wrap "[" "]" 
                  , ppVisible = xmobarColor "#ffffff" "" . wrap "(" ")" 
                  , ppTitle = xmobarColor "#abb2bf" "" . shorten 30
                  -- , ppLayout = xmobarColor "#abb2bf" ""
                   , ppLayout = (\layout -> case layout of
                                   "Spacing Tall"        -> "Vertical"
                                   "Spacing Mirror Tall" -> "Horizontal"
                                   "Spacing ThreeCol"    -> "ThreeCol"
                                   "Full"      -> "Full"
                                )
                  , ppHidden = xmobarColor "#5c6370" ""
                }

-- Key binding to the gap for the bar
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
               }
    -- para conocer el nombre de la tecla multimedia "xev"
    `additionalKeys` [
                ((0                     , 0x1008FF11), spawn "volume-control down")
              , ((0                     , 0x1008FF13), spawn "volume-control up")
              , ((0                     , 0x1008FF12), spawn "volume-control toggle")
              , ((0                     , 0x1008FF31), spawn "mic-control toggle")
              , ((0                     , 0x1008FF02), spawn "xbacklight -inc 10")
              , ((0                     , 0x1008FF03), spawn "xbacklight -dec 10")
            -- ((0, xF86XK_AudioMute        ), spawn ("pkill -u $USER osd_cat; amixer -D pulse set Master toggle | awk '/Front Right:/ { print $6; }' | " ++ osd_cat_command ))
            -- ((0, xF86XK_AudioLowerVolume ), spawn ("amixer -D pulse -q set Master 2%-; " ++ osd_cat_bar_command ++ "`amixer -D pulse get Master | awk '/Front Right:/ { print $5;}' | tr -d '[]'`")),
            -- ((0, xF86XK_AudioRaiseVolume ), spawn ("amixer -D pulse -q set Master 2%+; " ++ osd_cat_bar_command ++ "`amixer -D pulse get Master | awk '/Front Right:/ { print $5;}' | tr -d '[]'`")),
            -- ((0, xF86XK_AudioMicMute     ), spawn "amixer -D pulse -q set Capture toggle"),
            -- ((0, xF86XK_MonBrightnessDown), spawn ("xbacklight -5; " ++ osd_cat_bar_command ++ "`xbacklight`")),
            -- ((0, xF86XK_MonBrightnessUp  ), spawn ("xbacklight +5; " ++ osd_cat_bar_command ++ "`xbacklight`")),
            -- ((0, xF86XK_Display          ), spawn ""),
            -- ((0, xF86XK_WLAN             ), spawn "STATE=\"un`rfkill -no soft list wlan`\"; rkill ${STATE#unun} wlan"),
            -- ((0, xF86XK_Tools            ), spawn "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center"),
            -- ((0, xF86XK_Bluetooth        ), spawn "STATE=\"un`rfkill -no soft list bluetooth`\"; rkill ${STATE#unun} bluetooth")
            ]

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
