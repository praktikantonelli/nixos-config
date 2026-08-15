{ inputs, config, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
in
{
  services.immich = {
    enable = true;
    port = 2283;
    host = "192.168.1.243";
    mediaLocation = "/srv/immich";
  };

  # immich does not create this directory automatically
  systemd.tmpfiles.rules = [
    # create the directory and grant the immich user read, write and execute permissions
    "d /srv/immich 0700 immich immich -"
  ];

  services.nginx.virtualHosts."immich.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "https://${config.services.immich.host}:${toString config.services.immich.port}";
    };
  };

}
