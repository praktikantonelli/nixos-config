{ lib, ... }: {
  wayland.windowManager.hyprland = {
    configType = "lua";
    settings = {
      mod = { _var = "ALT"; };

      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("systemctl --user import-environment")
              hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null")
              hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
              hl.exec_cmd("nm-applet")
              hl.exec_cmd("wl-clip-persist --clipboard both")
              hl.exec_cmd("swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f)")
              hl.exec_cmd("hyprctl setcursor Nordzy-cursors 22")
              hl.exec_cmd("hyprctl dispatch workspace 1")
              hl.exec_cmd("poweralertd")
              hl.exec_cmd("waybar")
              hl.exec_cmd("swaync")
              hl.exec_cmd("wl-paste --watch cliphist store")
              hl.exec_cmd("owncloud")
            end
          '')
        ];
      };

      input = {
        kb_layout = "ch";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        follow_mouse = 1;
        touchpad = { natural_scroll = true; };
      };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgb(fe8019) rgb(458588) 45deg";
        "col.inactive_border" = "0x00000000";
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        enable_swallog = true;
        focus_on_activate = true;
      };

      dwindle = { preserve_split = true; };

      decoration = {
        blur = {
          size = 1;
          contrast = 1.4;
          noise = 0;
          xray = true;
        };
      };

      bind = [
        {
          _args = [
            "mainMod + D"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("fuzzel")'')
          ];
        }
        {
          _args = [
            "mainMod + Return"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("kitty")'')
          ];
        }
      ];

    };
  };
}
