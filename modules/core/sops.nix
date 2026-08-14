{
  inputs,
  pkgs,
  host,
  config,
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
    secrets =
      if host == "homelab" then
        {
          nextcloud-admin-pass = {
            owner = "nextcloud";
            group = "nextcloud";
          };
          # cloudflared does not access the file directly, goes through root
          cloudflared-credentials = { };
          onlyoffice-jwt-token = {
            owner = "onlyoffice";
            group = "onlyoffice";
            restartUnits = [
              "onlyoffice-docservice.service"
              "onlyoffice-converter.service"
              "nextcloud-onlyoffice-config.service"
            ];
          };
        }
      else
        { };

    templates =
      if host == "homelab" then
        {
          "onlyoffice-nginx-nonce.conf" = {
            content = ''
              set $secure_link_secret "${config.sops.placeholder.onlyoffice-jwt-token}";
            '';
            owner = "onlyoffice";
            group = "onlyoffice";
            mode = "0440";
            restartUnits = [ "nginx.service" ];
          };
        }
      else
        { };
  };

  environment.systemPackages = [ pkgs.sops ];
}
