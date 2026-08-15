{ inputs, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
  host = "127.0.0.1";
  port = 8004;
in
{
  services.audiobookshelf = {
    enable = true;
    inherit host port;
    group = "media";
  };

  services.nginx.virtualHosts."audiobookshelf.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://${host}:${toString port}";
    };
  };
}
