{ inputs, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
  host = "127.0.0.1";
  port = 4533;
in
{
  services.navidrome = {
    enable = true;
    group = "media";
    settings = {
      Address = host;
      Port = port;
      MusicFolder = "/srv/music";
      Scanner.Schedule = "@every 1h";
    };
  };

  services.nginx.virtualHosts."navidrome.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://${host}:${toString port}";
    };
  };
}
