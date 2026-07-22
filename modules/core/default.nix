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
    ./nix-helper.nix
    ./groups.nix
    ./hyprlogin.nix
  ];
}
