{ inputs, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
  host = "192.168.1.243";
  port = 2283;
in
{
  services.immich = {
    enable = true;
    inherit host port;
    mediaLocation = "/srv/immich";
  };

  # immich does not create this directory automatically
  systemd.tmpfiles.rules = [
    # create the directory and grant the immich user read, write and execute permissions
    "d /srv/immich 0700 immich immich -"
  ];

  services.nginx.virtualHosts."immich.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://${host}:${toString port}";
    };
  };

}
