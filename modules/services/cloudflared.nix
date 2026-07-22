{ inputs, ... }: {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "mysecrettunnel" = {
        default = "http_status:404";
        ingress = {
          "*.${inputs.secrets.domain}" = { service = "http://127.0.0.1:80"; };
        };
        credentialsFile = "/var/lib/cloudflared/mysecrettunnel.json";
      };
    };
  };
}
