-- imports {{{
-- vim:foldmethod=marker

-- base {{{
import XMonad
import XMonad.Actions.Commands
import Data.Monoid
import System.Exit
import qualified XMonad.StackSet as W
-- }}}

-- Data {{{
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8
import qualified Data.Map        as M
-- }}}

import Graphics.X11.ExtraTypes.XF86

-- Hooks {{{
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ServerMode
-- }}}

-- Layout {{{
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
-- }}}

-- Util {{{
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce
-- }}}

-- }}}
-- variables {{{
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.

myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use.
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
myWorkspaces    = [" 1 "," 2 "," 3 "," 4 "," 5 "," 6 "," 7 "," 8 "," 9 ", " 10 "]

myNormalBorderColor  = "#2e2e2e"
myFocusedBorderColor = "#ebdbb2"

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm]
    where
        spawnTerm  = myTerminal ++ " -t scratchpad -e tmux attach"
        findTerm   = title =? "scratchpad"
        manageTerm = customFloating $ W.RationalRect l t w h
            where
                h = 0.9
                w = 0.9
                t = 0.95 -h
                l = 0.95 -w
-- }}}
-- keybinds {{{
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
-- terminal, launcher, and misc {{{
    [
      ((modm,               xK_Return), spawn $ XMonad.terminal conf) -- start $term
    , ((modm,               xK_a     ), namedScratchpadAction myScratchPads "terminal")
    , ((modm,               xK_d     ), spawn "rofi -show run -lines 3 -eh 2") -- launcher
    , ((modm .|. shiftMask, xK_d     ), spawn "dmenu_run")
    , ((controlMask .|. shiftMask, xK_c), spawn "sharenix-section -n -c") -- screenshot section
    , ((controlMask .|. shiftMask, xK_x), spawn "xfce4-screenshooter -w -o 'sharenix -n -c'")
    , ((modm              , xK_q     ), kill)
    , ((modm .|. shiftMask, xK_c     ), spawn "toggleprogram 'picom' '-b'")
-- }}}
-- layout, focus and swap {{{
    , ((modm,               xK_r     ), sequence_ [sendMessage $ Toggle FULL, sendMessage ToggleStruts])
    , ((modm,               xK_space ), sendMessage NextLayout) -- Rotate through the available layout algorithms
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) --  Reset the layouts on the current workspace to default
    , ((modm,               xK_n     ), refresh) -- Resize viewed windows to the correct size
    , ((modm,               xK_Tab   ), windows W.focusDown) -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp  ) -- Move focus to the previous window
    , ((modm,               xK_Up    ), windows W.focusUp    )
    , ((modm,               xK_Down  ), windows W.focusDown  )
    , ((modm,               xK_m     ), windows W.focusMaster  ) -- Move focus to the master window
    -- Swap the focused window and the master window
--    , ((modm,               xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  ) -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_Down  ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    ) -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_Up    ), windows W.swapUp    )
-- }}}
-- resizing {{{
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
-- }}}
-- media keys {{{
    , ((0, xF86XK_AudioPlay          ), spawn "playerctl play-pause") -- play/pause audio
    , ((0, xF86XK_AudioPause         ), spawn "playerctl play-pause") -- play/pause audio
    , ((0, xF86XK_AudioNext          ), spawn "playerctl next") -- next song
    , ((0, xF86XK_AudioPrev          ), spawn "playerctl previous") -- previous song
    , ((0, xF86XK_AudioLowerVolume   ), spawn "pactl set-sink-volume 2 -5%") -- previous song
    , ((0, xF86XK_AudioRaiseVolume   ), spawn "pactl set-sink-volume 2 +5%") -- previous song
-- }}}
-- quit reload and ToggleStruts {{{
    , ((modm              , xK_b     ), sendMessage ToggleStruts) -- Toggle the status bar gap
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess)) -- Quit xmonad
    , ((modm .|. mod1Mask , xK_r     ), spawn "xmonad --recompile; xmonad --restart") -- Restart/reload xmonad
    ]
    ++
-- }}}
-- workspace switching {{{
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_f, xK_p, xK_w] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
-- }}}
-- Mouse bindings: default actions bound to mouse events {{{
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
    -- }}}
-- }}}
-- layouts and window rules {{{
-- Layouts:
myLayout
    = mySpacing
    $ avoidStruts
    $ mkToggle (NOBORDERS ?? FULL ?? EOT)
    (tiled |||
    Grid |||
    Mirror tiled |||
    Full |||
    emptyBSP)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

mySpacing = spacingRaw True (Border 0 10 10 10) True (Border 5 5 5 5) True
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
    [ className =? "discord"        --> doShift (myWorkspaces !! 1)
    , className =? "Steam"          --> doShift (myWorkspaces !! 4)
    , className =? "Pavucontrol"    --> doCenterFloat
    , className =? "Sxiv"           --> doFloat
    , className =? "Spotify"        --> doShift (myWorkspaces !! 8)
    , title     =? "scratchpad"     --> doCenterFloat
    , resource  =? "desktop_window" --> doIgnore
    , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat
    ] <+> namedScratchpadManageHook myScratchPads
-- }}}
-- hooks {{{
------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = serverModeEventHookCmd <+> serverModeEventHook <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook :: D.Client -> PP
myLogHook dbus = def
        { ppOutput = dbusOutput dbus
        , ppCurrent = wrap ("%{B" ++ "#846DCF" ++ "} ") " %{B-}"
        , ppVisible = wrap ("%{B" ++ "#3c3836" ++ "} ") " %{B-}"
        , ppUrgent = wrap ("%{F" ++ "#fb4934" ++ "} ") " %{F-}"
        , ppHidden = wrap " " " "
        , ppWsSep = ""
        , ppSep = " | "
        , ppTitle = const ""
        , ppLayout = (\x -> case x of
            -- Icons found on https://nerdfonts.net/cheat-sheet
            "Spacing Tall"        -> "\xfb3f  "
            "Spacing Mirror Tall" -> "\xfcf6  "
            "Spacing Full"        -> "\xf2d0  "
            "Spacing Grid"        -> "\xfa6f  "
            "Spacing BSP"         -> "\xfa6d  "
            _             -> " " ++ x ++ " "
        )
        }

myAddSpaces :: Int -> String -> String
myAddSpaces len str = sstr ++ replicate (len - length sstr) ' '
  where
    sstr = shorten len str

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"
------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
        spawnOnce "feh --bg-scale $HOME/.config/wall.png &"
        spawnOnce "autorandr --change"
        spawnOnce "picom -b &"
        spawnOnce "xrdb $HOME/.Xresources"
        spawnOnce "$HOME/.xmonad/panel.sh"
        spawnOnce "xsetroot -cursor_name left_ptr"
        setWMName "LG3D"
--}}}
-- main and defaults {{{
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
    dbus <- D.connectSession
        -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad
        $ docks
        $ ewmh
        $ defaults { logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP (myLogHook dbus)}

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
        -- logHook            = myLogHook,
        startupHook        = myStartupHook
    }
-- }}}
