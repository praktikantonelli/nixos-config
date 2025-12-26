{ ... }: {
  imports = [
    ./bootloader.nix
    ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./audio.nix
    ./program.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
    ./wayland.nix
    ./fonts.nix
    ./steam.nix
    ./nix-helper.nix
    ./tailscale-client.nix
    ./sops.nix
    ../services
  ];
}
