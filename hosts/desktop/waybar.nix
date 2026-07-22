{ pkgs, ... }:
let
  gpuUsage = pkgs.writeShellScript "waybar-gpu-usage" ''
    for device in /sys/class/drm/card*/device; do
      if [[ ! -r "$device/boot_vga" || ! -r "$device/gpu_busy_percent" ]]; then
        continue
      fi

      read -r is_boot_gpu < "$device/boot_vga"
      if [[ "$is_boot_gpu" == "1" ]]; then
        read -r usage < "$device/gpu_busy_percent"
        printf '%s\n' "$usage"
        exit 0
      fi
    done

    printf '0\n'
  '';
in
{
  imports = [
    ../../modules/home/waybar
  ];

  programs.waybar.settings.mainBar = {
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

    "custom/gpu" = {
      exec = "${gpuUsage}";
      format = "󰾲  {}%";
      interval = 2;
      tooltip = false;
    };
  };
}
