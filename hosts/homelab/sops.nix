{ inputs, config, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops = {
    secrets = {
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
      paperless-admin-pass = {
        owner = "paperless";
        group = "paperless";
      };
      firefly-app-key = {
        # defaults
        owner = "firefly-iii";
        group = "nginx";
      };
    };

    templates = {
      "onlyoffice-nginx-nonce.conf" = {
        content = ''
          set $secure_link_secret "${config.sops.placeholder.onlyoffice-jwt-token}";
        '';
        owner = "onlyoffice";
        group = "onlyoffice";
        mode = "0440";
        restartUnits = [ "nginx.service" ];
      };
    };
  };
}
