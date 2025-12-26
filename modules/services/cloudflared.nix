{ inputs, ... }: {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "mysecrettunnel" = {
        default = "http_status:404";
        ingress = {
          "${inputs.secrets.domain}" = { service = "http://localhost:8080"; };
        };
        credentialsFile = "/var/lib/cloudflared/mysecrettunnel.json";
      };
    };
  };
}
