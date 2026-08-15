{
  cloudflareProxy =
    {
      proxyPass,
      websockets ? true,
      extraConfig ? "",
    }:
    {
      inherit proxyPass;

      proxyWebsockets = websockets;
      recommendedProxySettings = false;

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $hostname;

        ${extraConfig}
      '';
    };
}
