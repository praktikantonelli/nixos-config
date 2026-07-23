{ pkgs, ... }: {
  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavor = "";
    };
    ssh = {
      extraConfig = ''
        Host github.com
        User git
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
      '';
    };
    nix-ld.enable = true;
    kdeconnect.enable = true;
    gamescope = {
      enable = true;
      capSysNice = false;
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
