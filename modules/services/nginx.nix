{ inputs, config, ... }:
let
  cloudflareProxyHeaders = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $hostname;
  '';
in
{
  services.nginx = {
    enable = true;
    defaultListen = [
      {
        addr = "127.0.0.1";
        port = 80;
      }
    ];
    recommendedProxySettings = true;
    clientMaxBodySize = "70M";

    virtualHosts = {
      "_" = {
        default = true;
        locations."/".return = "404";
      };
    };
  };
}
