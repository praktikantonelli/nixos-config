{ pkgs, username, ... }: {
  imports = [
    ./bat.nix
    ./nvim.nix
    ./tmux.nix
    ./starship.nix
    ./zsh.nix
    ./git.nix
    ./nu.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
    packages = (with pkgs; [ fzf direnv fd ]);
  };
  programs.home-manager.enable = true;
}
