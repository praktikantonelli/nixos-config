{ inputs, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
  host = "127.0.0.1";
  port = 9000;
in
{
  services.mealie = {
    enable = true;
    listenAddress = host;
    inherit port;

  };

  services.nginx.virtualHosts."mealie.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://${host}:${toString port}";
    };
  };
}
