-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function () 
  hl.exec_cmd("hyprpaper & waybar & swaync & hypridle")
  hl.exec_cmd("cliphist wipe")
  hl.exec_cmd("wl-paste --watch cliphist store")
end)
