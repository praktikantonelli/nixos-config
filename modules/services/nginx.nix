{ inputs, config, ... }: {
  services.nginx = {
    enable = true;

    virtualHosts = {
      "nextcloud.${inputs.secrets.domain}" = {
        listen = [{
          addr = "192.168.1.212";
          port = 8888;
        }];
      };
      "bitwarden.${inputs.secrets.domain}" = {
        # enableACME = true;
        # forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${
              toString config.services.vaultwarden.config.ROCKET_PORT
            }";
          proxyWebsockets = true;
        };
      };

      "immich.${inputs.secrets.domain}" = {
        enableACME = false;
        forceSSL = false;
        locations."/" = {
          proxyPass =
            "http://127.0.0.1:${toString config.services.immich.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
