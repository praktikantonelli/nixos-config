{ inputs, config, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
in
{
  services.navidrome = {
    enable = true;
    group = "media";
    settings = {
      Address = "127.0.0.1";
      MusicFolder = "/srv/music";
      Scanner.Schedule = "@every 1h";
    };
  };

  services.nginx.virtualHosts."navidrome.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "https://${config.services.navidrome.settings.Address}:${toString config.services.navidrome.settings.Port}";
    };
  };
}
