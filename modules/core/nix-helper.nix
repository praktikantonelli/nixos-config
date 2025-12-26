{ pkgs, username, ... }: {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 2";
    };
    flake = "/home/${username}/nixos-config";
  };

  environment.systemPackages = with pkgs; [ nix-output-monitor nvd ];
}
