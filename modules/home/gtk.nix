{ pkgs, config, inputs, ... }:
let
  nordzy-cursors = pkgs.stdenvNoCC.mkDerivation {
    pname = "nordzy-cursors";
    version = "git";
    src = inputs.nordzy-cursors;

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/icons"
      cp -r xcursors/Nordzy-cursors "$out/share/icons/"
      cp -r hyprcursors/themes/Nordzy-hyprcursors "$out/share/icons/"

      runHook postInstall
    '';
  };
in
{
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
    package = nordzy-cursors;
    name = "Nordzy-cursors";
    size = 22;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
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
      package = nordzy-cursors;
      size = 22;
    };
  };

}
