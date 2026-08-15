{ inputs, config, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
in
{
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };

  services.nginx.virtualHosts."bitwarden.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "https://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET-PORT}";
    };
  };

}
