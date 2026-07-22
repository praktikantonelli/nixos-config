{ inputs, config, ... }:
let
  cloudflareProxyHeaders = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $hostname;
  '';
in
{
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
          recommendedProxySettings = false;
          extraConfig = cloudflareProxyHeaders;
        };
      };

      "immich.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.immich.host}:${
              toString config.services.immich.port
          }";
          proxyWebsockets = true;
          recommendedProxySettings = false;
          extraConfig = cloudflareProxyHeaders;
        };
      };

      "calibre.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.calibre-web.listen.ip}:${
              toString config.services.calibre-web.listen.port
          }";
          proxyWebsockets = true;
          recommendedProxySettings = false;
          extraConfig = cloudflareProxyHeaders;
        };
      };

      "audiobookshelf.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.audiobookshelf.host}:${
              toString config.services.audiobookshelf.port
          }";
          proxyWebsockets = true;
          recommendedProxySettings = false;
          extraConfig = cloudflareProxyHeaders;
        };
      };

      "navidrome.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://${config.services.navidrome.settings.Address}:${
              toString config.services.navidrome.settings.Port
          }";
          proxyWebsockets = true;
          recommendedProxySettings = false;
          extraConfig = cloudflareProxyHeaders;
        };
      };

      "onlyoffice.${inputs.secrets.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:180";
          proxyWebsockets = true;
          recommendedProxySettings = false;
          extraConfig = cloudflareProxyHeaders;
        };
      };
    };
  };
}
