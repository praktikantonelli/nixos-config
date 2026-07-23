{ ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };
  # proton-ge-bin

  #   warning: The package proton-ge in nix-gaming has been deprecated as of 2024-03-17.

  # You should use proton-ge-bin from Nixpkgs, which conforms to
  # the new `extraCompatTools` module option under `programs.steam`
  # For details, see the relevant pull request:
}
