{ config, inputs, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
  host = "127.0.0.1";
  port = 28981;
in
{
  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets.paperless-admin-pass.path;
    address = host;
    inherit port;
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_URL = "https://paperless.${inputs.secrets.domain}";
    };
  };

  services.nginx.virtualHosts."paperless.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://${host}:${toString port}";
    };
  };
}
