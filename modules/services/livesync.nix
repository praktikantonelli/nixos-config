{ config, ... }:

let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
  syncHost = "obsidian-sync.example.com";
  couchdbAdmin = "obsidian";
in
{

  sops.secrets."obsidian-livesync-couchdb-password" = {
    restartUnits = [ "couchdb.service" ];
  };

  sops.templates."couchdb-livesync-local.ini" = {
    owner = "couchdb";
    group = "couchdb";
    mode = "0600";

    content = ''
      [admins]
      ${couchdbAdmin} = ${config.sops.placeholder."obsidian-livesync-couchdb-password"}
    '';
  };

  services.couchdb = {
    enable = true;

    # CouchDB itself is NOT reachable from the LAN or Internet.
    bindAddress = "127.0.0.1";
    port = 5984;

    configFile = config.sops.templates."couchdb-livesync-local.ini".path;

    extraConfig = {
      couchdb = {
        single_node = "true";
        max_document_size = "50000000";
      };

      chttpd = {
        require_valid_user = "true";
        max_http_request_size = "4294967296";
      };

      chttpd_auth = {
        require_valid_user = "true";
        authentication_redirect = "/e=_/_utils/session.html";
      };

      httpd = {
        "WWW-Authenticate" = ''Basic realm="couchdb"'';
        enable_cors = "true";
      };

      cors = {
        credentials = "true";

        origins = "app://obsidian.md,capacitor://localhost,http://localhost";

        headers = "accept, authorization, content-type, origin, referer";

        methods = "GET, PUT, POST, HEAD, DELETE";

        max_age = "3600";
      };
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts."${syncHost}" = {
      locations."/" = cloudflareProxy {
        proxyPass = "http://127.0.0.1:5984";

        extraConfig = ''
          # Required/recommended for CouchDB replication.
          proxy_buffering off;

          # Match LiveSync's recommended max document size.
          client_max_body_size 50M;

          proxy_read_timeout 120s;
          proxy_send_timeout 120s;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };

      # Fauxton is not needed remotely.
      locations."~ ^/_utils" = {
        return = "404";
      };
    };
  };
}
