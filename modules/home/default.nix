{ ... }: {
  imports = [
    ./bat.nix # better cat command
    ./btop.nix # resouces monitor
    ./discord.nix # discord with catppuccin theme
    ./floorp.nix # firefox based browser
    ./fuzzel.nix # launcher
    ./gaming.nix # packages related to gaming
    ./git.nix # version control
    ./gtk.nix # gtk theme
    ./hyprland # window manager
    ./kitty.nix # terminal
    ./swaync/swaync.nix # notification deamon
    ./nvim.nix # lazyvim config
    ./packages.nix # other packages
    ./scripts/scripts.nix # personal scripts
    ./spicetify.nix # spotify client
    ./starship.nix # shell prompt
    ./swaylock.nix # lock screen
    ./vscodium.nix # vscode forck
    ./tmux.nix # tmux
    ./waybar # status bar
    ./zsh.nix # shell
    ./nu.nix # nushell
    ./zen.nix # zen browser
  ];
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "luca";
    homeDirectory = "/home/luca";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
