{ ... }: {
  imports = [
    ../../modules/home/bat.nix # better cat command
    ./btop.nix # resouces monitor
    ../../modules/home/discord.nix # discord with catppuccin theme
    ../../modules/home/fuzzel.nix # launcher
    ../../modules/home/git.nix # version control
    ../../modules/home/gtk.nix # gtk theme
    ./hyprland.nix # window manager
    ../../modules/home/kitty.nix # terminal
    ../../modules/home/swaync/swaync.nix # notification deamon
    ../../modules/home/nvim.nix # lazyvim config
    ../../modules/home/packages.nix # other packages
    ../../modules/home/scripts/scripts.nix # personal scripts
    ../../modules/home/spicetify.nix # spotify client
    ../../modules/home/starship.nix # shell prompt
    ../../modules/home/swaylock.nix # lock screen
    ../../modules/home/vscodium.nix # vscode forck
    ../../modules/home/zellij.nix
    ../../modules/home/waybar # status bar
    ../../modules/home/nu.nix # nushell
    ../../modules/home/zen.nix # zen browser
    ../../modules/home/direnv.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "luca";
    homeDirectory = "/home/luca";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
