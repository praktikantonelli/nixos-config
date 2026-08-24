{ inputs, pkgs, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
in
{
  environment.systemPackages = [
    inputs.zennotes.packages.${pkgs.system}.zennotes-server
  ];

  services.nginx.virtualHosts."zennotes.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://127.0.0.1:7878";
    };
  };
}
