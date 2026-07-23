{ pkgs, username, ... }: {
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "media"
    ];
    shell = pkgs.nushell;
  };
  nix.settings.allowed-users = [ "${username}" ];
}
