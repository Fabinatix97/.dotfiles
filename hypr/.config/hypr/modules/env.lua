-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/
-- https://wiki.hypr.land/Nvidia/#environment-variables
-- force_zero_scaling leaves XWayland apps at 1x physical pixels on a
-- scale-2 panel unless toolkits scale themselves.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

local dmi = io.open("/sys/class/dmi/id/product_name")
local surface = dmi:read("*l"):find("Surface Book 3")
dmi:close()

if surface then
    hl.env("GDK_SCALE", "2")
    hl.env("QT_SCALE_FACTOR", "2")
    hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "0")
else
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
end
