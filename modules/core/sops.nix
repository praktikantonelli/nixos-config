{ inputs, username, pkgs, host, ... }:
let secretspath = builtins.toString inputs.secrets;
in {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = if host == "homelab" then {
      nextcloud-admin-pass = {
        owner = "nextcloud";
        group = "nextcloud";
      };
    } else
      { };
  };

  environment.systemPackages = [ pkgs.sops ];
}
