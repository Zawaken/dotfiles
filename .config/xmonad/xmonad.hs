-- imports {{{

--{{{actions
import XMonad.Actions.CycleWS as CWS
import XMonad.Actions.CopyWindow
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.FloatKeys
import XMonad.Actions.MouseResize
--}}}

-- base {{{
import XMonad
import XMonad.Actions.Commands
import Data.Monoid
import System.Exit
import XMonad.Prompt
import XMonad.Prompt.Shell
import qualified XMonad.StackSet as W
-- }}}

-- Data {{{
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8
import qualified Data.Map        as M
import Data.Ratio
-- }}}

-- {{{ Graphics
import Graphics.X11.ExtraTypes.XF86
-- }}}

-- Hooks {{{
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ServerMode
import XMonad.Hooks.TaffybarPagerHints (pagerHints)
import XMonad.Hooks.WindowSwallowing
-- }}}

-- Layout {{{
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import qualified XMonad.Layout.WindowNavigation as WN
-- }}}

-- Util {{{
import XMonad.Util.Loggers
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce
import XMonad.Util.WorkspaceCompare
import XMonad.Util.EZConfig
import XMonad (title, appName, doShift)
-- }}}

-- }}}
-- main {{{
------------------------------------------------------------------------
main :: IO ()
main = do
    dbus <- D.connectSession
        -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad
        $ docks
        -- . setEwmhWorkspaceSort mySort
        . ewmhFullscreen
        . ewmh
        . pagerHints
        $ myConfig { logHook = dynamicLogWithPP $ filterOutWsPP ["NSP"] (myLogHook dbus)}
-- }}}
myConfig = def  -- {{{
        { terminal           = myTerminal
        , focusFollowsMouse  = True
        , clickJustFocuses   = False
        , borderWidth        = 2
        , modMask            = mod4Mask
        , workspaces         = myWorkspaces
        , normalBorderColor  = "#262643"
        , focusedBorderColor = "#876A97"
        -- , normalBorderColor  = "2e2e2e"
        -- , focusedBorderColor = "ebdbb2"
        -- , keys               = myKeys
        , mouseBindings      = myMouseBindings
        , layoutHook         = myLayout
        , manageHook         = myManageHook
        , handleEventHook    = myEventHook
        -- , logHook            = myLogHook
        , startupHook        = myStartupHook
    } `additionalKeysP` myKeys
-- }}}
-- variables {{{
myTerminal      :: String
myTerminal      = "alacritty"

-- Width of the window border in pixels.
myBorderWidth   = 1

myWorkspaces = ["1","2","3","4","5","6","7","8","9","X"]

-- Get the name of the active layout.
getActiveLayoutDescription :: X String
getActiveLayoutDescription = do
    workspaces <- gets windowset
    return $ description . W.layout . W.workspace . W.current $ workspaces

myPrompt = def
        {
            font = "xft:Termsyn:size=9"
          , bgColor = "#292d3e"
          , fgColor = "#d0d0d0"
          , bgHLight = "#c792ea"
          , fgHLight = "#000000"
          , borderColor = "#535974"
          , promptBorderWidth = 1
          , position = Top
          , height = 30
          , historySize = 256
          , historyFilter = id
          , defaultText = []
          , autoComplete = Just 100000
          , showCompletionOnTab = True
          -- , searchPredicate = isPrefixOf
          , alwaysHighlight = True
          , maxComplRows = Just 3
        }

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal"
        (myTerminal ++ " --class scratchpad -t scratchpad -e tmux attach") -- command to run
        (appName =? "scratchpad") -- set appname
        (customFloating $ W.RationalRect 0.3 0.3 0.4 0.4) -- x y width height
      ]
-- }}}
-- {{{ floating toggle

-- If the window is floating then (f), if tiled then (n)
floatOrNot f n = withFocused $ \windowId -> do
    floats <- gets (W.floating . windowset)
    if windowId `M.member` floats -- if the current window is floating...
       then f
       else n

-- Centre and float a window (retain size)
centreFloat win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

-- Float a window in the centre
centreFloat' w = windows $ W.float w (W.RationalRect 0.25 0.25 0.5 0.5)

-- Make a window my 'standard size' (half of the screen) keeping the centre of the window fixed
standardSize win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect x y 0.5 0.5)
    return ()


-- Float and centre a tiled window, sink a floating window
toggleFloat = floatOrNot (withFocused $ windows . W.sink) (withFocused centreFloat')
--}}}
-- keybinds {{{
-- myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList $
myKeys :: [(String, X ())]
myKeys =
-- terminal, launcher, and misc {{{
    [
      ("M-<Return>",  spawn myTerminal) -- start $term
    , ("M-a",         namedScratchpadAction myScratchPads "terminal")
    , ("M-e",         dynamicNSPAction "dyn1")
    , ("M-S-e",       withFocused $ toggleDynamicNSP "dyn1")
    , ("M-d",         spawn "rofi -show") -- launcher
    -- , ("M-S-d",       shellPrompt myPrompt) -- xmonad prompt
    , ("C-S-c",       spawn "screenshot -m region --open 'sharenix -n -c'")
    , ("C-S-x",       spawn "screenshot -m window --open 'sharenix -n -c'")
    , ("M-q",         kill)
    , ("M-i",         spawn "slock")
    , ("M-S-c",       spawn "toggleprogram 'picom' '-b'")
    , ("M-S-v",       spawn "xclip -selection clipboard -out | xdotool selectwindow windowfocus type --clearmodifiers --delay 25 --window %@ --file -")-- }}}
-- DynamicWorkspaces {{{
    , ("M-S-d", removeWorkspace)
    , ("M-æ", selectWorkspace def)
    , ("M-S-a", addWorkspacePrompt def)
--  }}}
-- layout, focus and swap {{{
    , ("M-r",         sequence_ [sendMessage $ Toggle FULL, sendMessage ToggleStruts])
    , ("M-s",         toggleFloat)
    , ("M-<Space>",   sendMessage NextLayout) -- Rotate through the available layout algorithms
    , ("M-S-<Space>", sendMessage FirstLayout) --  Reset the layouts on the current workspace to default
    , ("M-n",         refresh) -- Resize viewed windows to the correct size
    , ("M-<Tab>",     windows W.focusDown) -- Move focus to the next window
    , ("M-j",         windows W.focusDown)
    , ("M-k",         windows W.focusUp  ) -- Move focus to the previous window
    , ("M-m",         windows W.focusMaster  ) -- Move focus to the master window
    -- Swap the focused window and the master window
--    , ((modm,               xK_Return), windows W.swapMaster)
    , ("M-<Right>",   sendMessage $ WN.Go WN.R)
    , ("M-<Left>",    sendMessage $ WN.Go WN.L)
    , ("M-<Up>",    do
      layout <- getActiveLayoutDescription
      case layout of
        x | x `elem` ["Spacing Full","Full"] -> windows W.focusUp
        _                                  -> sendMessage $ WN.Go WN.U)
    , ("M-<Down>",  do
      layout <- getActiveLayoutDescription
      case layout of
        x | x `elem` ["Spacing Full","Full"] -> windows W.focusDown
        _                                  -> sendMessage $ WN.Go WN.D)
    , ("M-S-<Right>", floatOrNot (withFocused (keysMoveWindow   ( 20, 0)))  (sendMessage $ WN.Swap WN.R))
    , ("M-S-<Left>",  floatOrNot (withFocused (keysMoveWindow   ( -20, 0))) (sendMessage $ WN.Swap WN.L))
    , ("M-S-<Up>",    floatOrNot (withFocused (keysMoveWindow   ( 0, -20))) (sendMessage $ WN.Swap WN.U))
    , ("M-S-<Down>",  floatOrNot (withFocused (keysMoveWindow   ( 0, 20)))  (sendMessage $ WN.Swap WN.D))
    , ("M-C-<Right>", floatOrNot (withFocused (keysResizeWindow ( 20, 0) (0,0))) (sendMessage Expand))
    , ("M-C-<Left>",  floatOrNot (withFocused (keysResizeWindow ( -20,0) (0,0))) (sendMessage Shrink))
    , ("M-C-<Up>",    floatOrNot (withFocused (keysResizeWindow ( 0,-20) (0,0))) (sendMessage Expand))
    , ("M-C-<Down>",  floatOrNot (withFocused (keysResizeWindow ( 0,20)  (0,0))) (sendMessage Shrink))
    , ("M-S-k",       windows W.swapUp    ) -- Swap the focused window with the previous window
    , ("M-S-j",       windows W.swapDown  ) -- Swap the focused window with the next window
-- }}}
-- resizing {{{
    , ("M-h",         sendMessage Shrink)-- Shrink the master area
    , ("M-l",         sendMessage Expand)-- Expand the master area
    -- , ("M-t",       withFocused $ windows . W.sink)-- Push window back into tiling
    , ("M-,",         sendMessage (IncMasterN 1))-- Increment the number of windows in the master area
    , ("M-.",         sendMessage (IncMasterN (-1)))-- Deincrement the number of windows in the master area
-- }}}
-- media keys {{{
    , ("<XF86AudioPlay>",         spawn "playerctl play-pause") -- play/pause audio
    , ("<XF86AudioPause>",        spawn "playerctl play-pause") -- play/pause audio
    , ("<XF86AudioNext>",         spawn "playerctl next") -- next song
    , ("<XF86AudioPrev>",         spawn "playerctl previous") -- previous song
    , ("<XF86AudioLowerVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%") -- volume down
    , ("<XF86AudioRaiseVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%") -- volume up
-- }}}
-- quit reload and ToggleStruts {{{
    , ("M-b",       sendMessage ToggleStruts) -- Toggle the status bar gap
    , ("M-S-M1-q",  io exitSuccess) -- Quit xmonad
    , ("M-S-r",     spawn "xmonad --recompile; xmonad --restart") -- Restart/reload xmonad
    ]
    ++
-- }}}
-- workspace switching {{{
    [(mask ++ "M-" ++ [key], action tag)
        | (tag, key) <- zip (workspaces myConfig) "1234567890"                                     -- mod-[1..9], Switch to workspace N
        -- , (mask, action) <- [ ("", windows . W.greedyView), ("S-", windows . W.shift) ]]  -- mod-shift-[1..9], Move client to workspace N
        , (mask, action) <- [ ("", windows . W.greedyView), ("S-", windows . W.shift) ]]  -- mod-shift-[1..9], Move client to workspace N
    ++
    [(mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
        | (key, scr) <- zip "wfp" [2,0,1]                                                 -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
        , (action, mask) <- [(W.view, ""), (W.shift, "S-")]]                              -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
-- }}}
-- }}}
-- Mouse bindings: default actions bound to mouse events {{{
myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList

    -- mod-button1, Set the window to floating mode and move by dragging
    [
    ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)
    ]
-- }}}
-- Layouts: {{{
myLayout
    = mySpacing
    . avoidStruts
    . mouseResize
    . smartBorders
    . mkToggle (NOBORDERS ?? FULL ?? EOT)
    $ WN.windowNavigation
    (tiled |||
    ThreeColMid 1 (3/100) (1/2) |||
    Full)
  where
     mySpacing = spacingRaw True (Border 0 10 10 10) True (Border 5 5 5 5) True
     tiled   = Tall nmaster delta ratio -- default tiling algorithm partitions the screen into two panes
     nmaster = 1 -- The default number of windows in the master pane
     ratio   = 1/2 -- Default proportion of screen occupied by master pane
     delta   = 3/100 -- Percent of screen to increment by when resizing panes

------------------------------------------------------------------------ }}}
-- Window rules: {{{

-- Execute arbitrary actions and WindowSet manipulations when managing a new window.
-- Title    = title
-- class    = className
-- instance = appName
isPopupMenu :: Query Bool
isPopupMenu = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_POPUP_MENU"
myManageHook = let ws = workspaces myConfig in composeAll
    [ fmap not willFloat            --> insertPosition Below Newer
    , className =? "Pavucontrol"    --> doRectFloat(W.RationalRect (1/4) (1/4) (50/100) (50/100))
    , className =? "mpv"            --> doRectFloat(W.RationalRect 0.15 0.15 0.9 0.9)
    , resource  =? "desktop_window" --> doIgnore
    , className ~? "eww-bar"        --> doLower
    , (className =? "firefox" <&&>
    resource =? "Dialog")           --> doFloat
    , (className =? "steamwebhelper" <&&>
    isPopupMenu)                    --> doIgnore
    , isDialog                      --> doFloat
    , title =? "Picture-in-Picture" --> doFloat
    ]
    <+> (composeAll . concat $
    [ [ className =? n --> doCenterFloat    | n <- myFloats  ]
    , [ className =? n --> doIgnore         | n <- myIgnores       ]
    , [ className =? n --> doLower          | n <- myLowers        ]
    , [ className =? n --> doShift (head ws) | n <- ws1             ]
    , [ className =? n --> doShift (ws !! 1) | n <- ws2             ]
    , [ className =? n --> doShift (ws !! 2) | n <- ws3             ]
    , [ className =? n --> doShift (ws !! 3) | n <- ws4             ]
    , [ className =? n --> doShift (ws !! 4) | n <- ws5             ]
    , [ className =? n --> doShift (ws !! 5) | n <- ws6             ]
    , [ className =? n --> doShift (ws !! 6) | n <- ws7             ]
    , [ className =? n --> doShift (ws !! 7) | n <- ws8             ]
    , [ className =? n --> doShift (ws !! 8) | n <- ws9             ]
    , [ className =? n --> doShift (ws !! 9) | n <- ws0             ]
    ])
    <+> namedScratchpadManageHook myScratchPads
    where
      myFloats  = [ "Sxiv" ]
      myIgnores = []
      myLowers  = [ "Trayer" ]
      ws1       = []
      ws2       = [ "discord", "Slack" ]
      ws3       = []
      ws4       = [ "Spotify" ]
      ws5       = [ "Steam" ]
      ws6       = []
      ws7       = []
      ws8       = []
      ws9       = []
      ws0       = [ "org.remmina.Remmina" ]
------------------------------------------------------------------------ }}}
-- Event handling {{{

-- myEventHook = serverModeEventHookCmd <+> serverModeEventHook <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn) <+> swallowEventHook (className =? "Alacritty") (return True)
myEventHook =
  swallowEventHook (className =? "Alacritty") (return True)

------------------------------------------------------------------------ }}}
-- Status bars and logging {{{

-- Perform an arbitrary action on each internal state change or X event.
mySort = getSortByXineramaRule
myLogHook :: D.Client -> PP
myLogHook dbus = def
        { ppOutput = dbusOutput dbus
        , ppCurrent = wrap ("%{B" ++ purple ++ "}  ") "  %{B-}"
        , ppVisible = wrap ("%{B" ++ gray ++ "}  ") "  %{B-}"
        , ppUrgent = wrap ("%{F" ++ red ++ "} ") " %{F-}"
        , ppHidden = wrap "  " "  "

        , ppSep = " | "
        , ppTitle = const ""
        , ppOrder = \(ws:l:t:_) -> [t,ws,l]
        , ppLayout = \x -> case x of
           -- Icons found on https://nerdfonts.net/cheat-sheet
           "Spacing Tall"        -> "\n[|]" -- "\xfb3f  "
           "Spacing Mirror Tall" -> "\n[-]" -- "\xfcf6  "
           "Spacing Full"        -> "\n[M]" -- "\xf2d0  "
           "Spacing Grid"        -> "\n[+]" -- "\xfa6f  "
           "Spacing ThreeCol"    -> "\n[||]"
        }
        where
            purple  = "#846DCF"
            gray    = "#3c3836"
            red     = "#fb4934"

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
------------------------------------------------------------------------ }}}
-- Startup hook {{{

-- Perform an arbitrary action each time xmonad starts or is restarted
myStartupHook = do
        spawnOnce "picom -b &"
        spawnOnce "xrdb $HOME/.Xresources"
        -- spawnOnce "$HOME/.xmonad/panel.sh"
        spawnOnce "eww open-many bar_0 bar_1 bar_2"
        setWMName "LG3D"
--}}}
