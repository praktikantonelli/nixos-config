{ pkgs, inputs, host, ... }: {
  # imports = [ inputs.nix-gaming.nixosModules.default ];
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 7d";
    # };
  };
  nixpkgs = { overlays = [ inputs.nur.overlays.default ]; };

  environment.systemPackages = with pkgs; [
    wget
    git
    nextcloud-client
    thunderbird
    # mcpelauncher-ui-qt
    calibre
  ];

  time.timeZone = "Europe/Zurich";
  time.hardwareClockInLocalTime = host == "desktop";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";

  fonts.fontDir.enable = true;
}
