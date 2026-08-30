hl.config({
    -- https://wiki.hypr.land/Configuring/Basics/Variables/#general
    general = {
        gaps_in  = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#input
    input = {
        kb_layout  = "us",
        kb_variant = "altgr-intl",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
    decoration = {
        rounding       = 10,
        rounding_power = 2,
        shadow = {
            enabled      = true,
        },
        blur = {
            enabled   = true,
            size      = 3,
            vibrancy  = 0.1696,
        },
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
    animations = {
        enabled = true,
    },

    -- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
    dwindle = {
        preserve_split = true,
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true
    },

    -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/
    xwayland = {
        force_zero_scaling = true
    }
})
