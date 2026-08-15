{ inputs, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
  host = "127.0.0.1";
  port = 8222;
in
{
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = host;
      ROCKET_PORT = port;
    };
  };

  services.nginx.virtualHosts."bitwarden.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://${host}:${toString port}";
    };
  };

}
