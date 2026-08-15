{
  inputs,
  pkgs,
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
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };
  };

  environment.systemPackages = [ pkgs.sops ];
}
