{ config, lib, ... }: {
  services.swaync.enable = true;
  xdg.configFile."swaync/style.css".source = ./style.css;
  xdg.configFile."swaync/config.json".source = lib.mkForce ./config.json;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    extraConfig.SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
    setSessionVariables = false;
  };
}
