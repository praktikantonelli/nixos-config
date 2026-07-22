{ inputs, config, ... }: {
  services.nginx = {
    enable = true;
    defaultListen = [
      {
        addr = "127.0.0.1";
        port = 80;
      }
    ];
    recommendedProxySettings = true;

    virtualHosts = {
      "_" = {
        default = true;
        locations."/".return = "404";
      };

      "nextcloud.${inputs.secrets.domain}" = { };

      "bitwarden.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${
              toString config.services.vaultwarden.config.ROCKET_PORT
            }";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto https;
          '';
        };
      };

      "immich.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.immich.host}:${
              toString config.services.immich.port
            }";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto https;
          '';
        };
      };

      "calibre.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.calibre-web.listen.ip}:${
              toString config.services.calibre-web.listen.port
            }";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto https;
          '';
        };
      };

      "audiobookshelf.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.audiobookshelf.host}:${
              toString config.services.audiobookshelf.port
            }";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto https;
          '';
        };
      };

      "navidrome.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.navidrome.settings.Address}:${
              toString config.services.navidrome.settings.Port
            }";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto https;
          '';
        };
      };

      "onlyoffice.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:180";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto https;
          '';
        };
      };
    };
  };
}
