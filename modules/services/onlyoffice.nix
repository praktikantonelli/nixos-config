{
  inputs,
  config,
  lib,
  ...
}:
let
  domain = inputs.secrets.domain;
in
{
  services.onlyoffice = {
    enable = true;
    hostname = "onlyoffice.${domain}";
    jwtSecretFile = config.sops.secrets.onlyoffice-jwt-token.path;
    securityNonceFile = config.sops.templates."onlyoffice-nginx-nonce.conf".path;
    allowLocalConnections = true;
  };

  # cloudflared reaches nginx over HTTP, but browser-facing OnlyOffice URLs must
  # stay HTTPS for the editor iframe and cache/download links.
  services.nginx.virtualHosts."onlyoffice.${domain}".extraConfig = lib.mkForce ''
    rewrite ^/$ /welcome/ redirect;
    rewrite ^\/OfficeWeb(\/apps\/.*)$ /${config.services.onlyoffice.package.version}/web-apps$1 redirect;
    rewrite ^(\/web-apps\/apps\/(?!api\/).*)$ /${config.services.onlyoffice.package.version}$1 redirect;

    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-Ssl on;
    proxy_set_header X-Forwarded-Port 443;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
  '';
}
