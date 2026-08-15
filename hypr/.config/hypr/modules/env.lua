-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/
-- force_zero_scaling leaves XWayland apps at 1x physical pixels on a
-- scale-2 panel unless toolkits scale themselves.
hl.env("GDK_SCALE", "2")
hl.env("QT_SCALE_FACTOR", "2")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "0")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
