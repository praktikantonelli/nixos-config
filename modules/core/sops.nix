{
  inputs,
  pkgs,
  host,
  ...
}:
let
  secretspath = builtins.toString inputs.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };
    secrets =
      if host == "homelab" then
        {
          nextcloud-admin-pass = {
            owner = "nextcloud";
            group = "nextcloud";
          };
          # cloudflared does not access the file directly, goes through root
          cloudflared-credentials = { };
        }
      else
        { };
  };

  environment.systemPackages = [ pkgs.sops ];
}
