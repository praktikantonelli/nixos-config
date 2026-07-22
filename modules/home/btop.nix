{ ... }: {
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "gruvbox_dark";
      theme_background = false;
      update_ms = 500;
    };
  };
}
