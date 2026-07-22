{ host, lib, ... }: {
  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "top";
    height = 5;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [ "custom/launcher" "hyprland/workspaces" "tray" ];
    modules-center = [ "clock" ];
    modules-right = [
      "bluetooth"
      "cpu"
      "custom/gpu"
      "memory"
      "disk"
      "pulseaudio"
      "battery"
      "network"
      "custom/notification"
    ];
    bluetooth = {
      format-on = "󰂯";
      format-off = "󰂲";
      format-connected = "󰂱";
      tooltip-format-on = "Not Connected";
      tooltip-format-off = "Disabled";
      tooltip-format-connected = "{device_enumerate}";
      on-click =
        "sh -c 'if bluetoothctl show | grep -q \"Powered: yes\"; then bluetoothctl power off; else bluetoothctl power on; fi'";
      tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
    };
    clock = {
      calendar = {
        format = { today = "<span color='#b4befe'><b><u>{}</u></b></span>"; };
      };
      format = " {:%H:%M}";
      tooltip = true;
      tooltip-format = ''
        <big>{:%Y %B}</big>
        <tt><small>{calendar}</small></tt>'';
      format-alt = " {:%d/%m}";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      sort-by-number = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "I";
        "2" = "II";
        "3" = "III";
        "4" = "IV";
        "5" = "V";
        "6" = "VI";
        "7" = "VII";
        "8" = "VIII";
        "9" = "IX";
        "10" = "X";
        urgent = "";
        default = "";
      };
      persistent-workspaces = lib.mkMerge [
        { "1" = [ ]; }
        (lib.optionalAttrs (host == "desktop") { "6" = [ ]; })
      ];
    };
    memory = {
      format = "󰟜 {:2}%";
      format-alt = "󰟜 {used} GiB"; # 
      interval = 2;
    };
    cpu = {
      format = "  {usage:2}%";
      format-alt = "  {avg_frequency} GHz";
      interval = 2;
    };
    disk = {
      # path = "/";
      format = "󰋊 {percentage_used:2}%";
      interval = 60;
    };
    network = {
      format-wifi = " ";
      format-ethernet = "󰀂 ";
      tooltip-format-disconnected = "Disconnected";
      tooltip-format = "Connected to {essid}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 ";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume:2}%";
      format-muted = "  {volume:2}%";
      format-icons = { default = [ " " ]; };
      scroll-step = 5;
      on-click = "pamixer -t";
    };
    battery = {
      format = "{icon} {capacity:2}%";
      format-icons = [ " " " " " " " " " " ];
      format-charging = " {capacity:2}%";
      format-full = " {capacity:2}%";
      format-warning = " {capacity:2}%";
      interval = 5;
      states = { warning = 20; };
      format-time = "{H}h{M}m";
      tooltip = true;
      tooltip-format = "{time}";
    };
    "custom/launcher" = {
      format = "";
      on-click = "fuzzel";
      on-click-right = "wallpaper-picker";
      tooltip = "false";
    };
    "custom/notification" = {
      tooltip = false;
      format = "{icon} ";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>   ";
        none = "   ";
        dnd-notification = "<span foreground='red'><sup></sup></span>   ";
        dnd-none = "   ";
        inhibited-notification =
          "<span foreground='red'><sup></sup></span>   ";
        inhibited-none = "   ";
        dnd-inhibited-notification =
          "<span foreground='red'><sup></sup></span>   ";
        dnd-inhibited-none = "   ";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
  };
}
