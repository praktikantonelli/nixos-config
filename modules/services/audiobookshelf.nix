{ inputs, config, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
in
{
  services.audiobookshelf = {
    enable = true;
    host = "127.0.0.1";
    port = 8084;
    group = "media";
  };

  services.nginx.virtualHosts."audiobookshelf.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "https://${config.services.audioobookshelf.host}:${toString config.services.audiobookshelf.port}";
    };
  };
}
