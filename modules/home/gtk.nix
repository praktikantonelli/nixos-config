{ pkgs, config, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.noto
    twemoji-color-font
    noto-fonts-color-emoji
    gruvbox-dark-icons-gtk
  ];

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 22;
  };

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
    font = {
      name = "SN Pro";
      size = 11;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
    cursorTheme = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 22;
    };
  };

}
