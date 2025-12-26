{ pkgs, ... }: {
  programs.btop = {
    enable = true;

    package = pkgs.btop.override { cudaSupport = true; };

    settings = {
      color_theme = "gruvbox_dark";
      theme_background = false;
      update_ms = 500;
    };
  };

  home.packages = (with pkgs; [ nvtopPackages.intel ]);
}

