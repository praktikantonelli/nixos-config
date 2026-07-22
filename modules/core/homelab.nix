{
  pkgs,
  host,
  username,
  inputs,
  ...
}:
{
  imports = [
    ./sops.nix # secrets management
    ../services/homelab.nix # definitions of systemd services for homelab
    ./nix-helper.nix
    ./groups.nix # extra config for handling user access to folders
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Zurich";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keyFiles = [
      ../../hosts/desktop/ssh-key.pub
      ../../hosts/laptop/ssh-key.pub
    ];
    shell = pkgs.nushell;
  };

  environment.systemPackages = with pkgs; [
    tailscale
    jdk8
    nextcloud-client
    kitty.terminfo
  ];

  services = {
    tailscale.enable = true;
    # Enable automatic login for the user.
    getty.autologinUser = username;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
      allowSFTP = true;
    };
  };

  security = {
    acme = {
      defaults.email = inputs.secrets.email;
      acceptTerms = true;
    };
    sudo.extraRules = [
      {
        users = [ "luca" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    2283
    1234
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  nix.settings = {
    max-jobs = 1;
    cores = 1;
    auto-optimise-store = true;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
