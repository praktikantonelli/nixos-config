{ ... }: {
  services.swaync.enable = true;
  xdg.configFile."swaync/style.css".source = ./style.css;
  xdg.configFile."swaync/config.json".source = ./config.json;
}
