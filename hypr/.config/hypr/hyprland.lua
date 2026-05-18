-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@360",
    position = "1920x0",
    scale    = "1",
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@74.97",
    position = "0x180",
    scale    = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "kitty"
local fileManager = terminal .. " -e " .. "yazi"
local menu = "rofi -show-icons -icon-theme Papirus -show drun"
local window = "rofi -show-icons -show window"
local screenshot = "slurp | grim -g - - | wl-copy"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function ()
    hl.exec_cmd("xrandr --output DP-1 --primary")
    hl.exec_cmd("eww open bar")
end)

hl.on("config.reloaded", function ()
    hl.exec_cmd("eww reload")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'")
    hl.exec_cmd("gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus'")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
----- PERMISSIONS -----
------ -------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 0,
        gaps_out = 0,

        border_size = 1,

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types for info about colors
        col = {
            active_border   = "rgba(595959ff)",
            inactive_border = "rgba(000000ff)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "master",
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
    decoration = {
        rounding = 0,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})


-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper    = 0,     -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo      = true,  -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering   = true,
        background_color           = "#000000",
        initial_workspace_tracking = 2,
        enable_swallow             = true,
        swallow_regex              = "^(kitty)$",
    },
})



---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return",  hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exit())
-- hl.bind(mainMod .. " + E",   hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Tab",    hl.dsp.exec_cmd(window))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J",   hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd("eww reload"))
hl.bind(mainMod .. " + g",      hl.dsp.group.toggle())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

-- Move focus with mainMod + h,j,k,l
hl.bind(mainMod .. " + h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
hl.bind(mainMod .. " + j", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + k", hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Monitor controls
-- hl.bind(mainMod .. " + SHIFT + H", hl.dsp.workspace.move_to_monitor(0))
-- hl.bind(mainMod .. " + SHIFT + L", hl.dsp.workspace.move_to_monitor(1))

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + D", hl.dsp.workspace.toggle_special("magic2"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("set-volume @DEFAULT_AUDIO_SINK@ 5%+ 100%"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("set-volume @DEFAULT_AUDIO_SINK@ 5%- 100%"),   { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Show widget on press
-- hl.bind("SUPER_L", hl.dsp.exec_cmd("eww open menu --screen $(hyprctl activeworkspace -j | jq -r '.monitorID')"))
-- Hide widget on release
-- hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("eww close menu"), { release = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})


hl.layer_rule({
    name  = "layerrule-rofiBlur",
    match = { namespace = "rofi" },
    blur  = true,
})

-- Ignore maximize requests from apps.
hl.window_rule({
    name           = "windowrule-ignoreMaximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "windowrule-Xwayland",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Matlab
hl.window_rule({
    name  = "windowrule-MATLAB",
    match = { title = "^(MATLAB)$" },
    tile  = true,
})

-- Steam
hl.window_rule({
    name  = "windowrule-SteamDefault",
    match = { class = "steam" },
    float = true,
})

hl.window_rule({
    name  = "windowrule-SteamFriends",
    match = { class = "steam", title = "Friends List" },
    tile  = true,
})

hl.window_rule({
    name  = "windowrule-SteamMain",
    match = { class = "steam", title = "Steam" },
    tile  = true,
})

-- File chooser
hl.window_rule({
    name  = "windowrule-termfilechooser",
    match = { class = "kitty", title = "termfilechooser" },
    float           = true,
    center          = true,
    size            = "1280 720",
    persistent_size = true,
})

hl.window_rule({
    name  = "windowrule-firefoxExtension",
    match = { class = "firefox", title = "^Extension.*" },
    float = true,
})

hl.window_rule({
    name  = "windowrule-OpenSCAD",
    match = { class = "OpenSCAD", title = "^Preferences.*" },
    float = true,
})

-- Fix some dragging issues with JavaFX applications
hl.window_rule({
    name  = "windowrule-javafx",
    match = { title = "java" },
    no_focus = true,
})

hl.window_rule({
    name  = "windowrule-Simulation",
    match = { title = "Simulation" },
    float = true,
})

-- JetBrains: Fix splash screen showing in weird places and prevent annoying focus takeovers
hl.window_rule({
    name  = "jetbrains-splash-tag",
    match = { class = "^(jetbrains-.*)$", title = "^(splash)$", float = true },
    tag   = "+jetbrains-splash",
})
hl.window_rule({
    name  = "jetbrains-splash-center",
    match = { tag = "jetbrains-splash" },
    center = true,
})
hl.window_rule({
    name  = "jetbrains-splash-nofocus",
    match = { tag = "jetbrains-splash" },
    no_focus = true,
})
hl.window_rule({
    name  = "jetbrains-splash-noborder",
    match = { tag = "jetbrains-splash" },
    border_size = 0,
})

-- JetBrains: Center popups/find windows
hl.window_rule({
    name  = "jetbrains-popup-tag",
    match = { class = "^(jetbrains-.*)", title = "^()$", float = true },
    tag   = "+jetbrains",
})
hl.window_rule({
    name  = "jetbrains-popup-center",
    match = { tag = "jetbrains" },
    center = true,
})

-- Enabling this makes it possible to provide input in popup dialogs
hl.window_rule({
    name  = "jetbrains-popup-stayfocused",
    match = { tag = "jetbrains" },
    stay_focused = true,
})
hl.window_rule({
    name  = "jetbrains-popup-noborder",
    match = { tag = "jetbrains" },
    border_size = 0,
})

-- For some reason tag:jetbrains does not work for size rule
hl.window_rule({
    name  = "jetbrains-popup-minsize",
    match = { class = "^(jetbrains-.*)", title = "^()$", float = true },
    min_size = "(monitor_w*0.5) (monitor_h*0.5)",
})

-- Disable window flicker when autocomplete or tooltips appear
hl.window_rule({
    name  = "jetbrains-win-noinitalfocus",
    match = { class = "^(jetbrains-.*)$", title = "^(win.*)$", float = true },
    no_initial_focus = true,
})

-- Disable mouse focus
hl.window_rule({
    name  = "jetbrains-nofollowmouse",
    match = { class = "^(jetbrains-.*)$" },
    no_follow_mouse = true,
})

hl.window_rule({
    name  = "windowrule-jetbrains-float",
    match = { class = "^(jetbrains-.*)", title = "^(win.*)" },
    float = true,
})

hl.window_rule({
    name  = "windowrule-jetbrains2",
    match = { class = "^(jetbrains-.*)" },
    no_initial_focus = true,
})

-- Schedule 1
hl.window_rule({
    name  = "windowrule-schedule1",
    match = { class = "steam_app_3164500" },
    fullscreen   = true,
    maximize     = true,
    stay_focused = true,
})

-- Godot
hl.window_rule({
    name  = "Godot Float Internal Windows",
    match = { class = "^Godot$" },
    float = true,
    tile  = false,
})

hl.window_rule({
    name  = "Godot Tile Main Window",
    match = { class = "^Godot$", initial_title = "^Godot$" },
    float = false,
    tile  = true,
})
