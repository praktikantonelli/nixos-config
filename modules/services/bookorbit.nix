{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  appImage = "ghcr.io/bookorbit/bookorbit:2.6.0";
  postgresImage = "pgvector/pgvector:pg16";

  contentRoot = "/srv/bookorbit";
  booksDir = "${contentRoot}/books";
  incomingDir = "${contentRoot}/incoming";

  stateRoot = "/var/lib/bookorbit";
  appDataDir = "${stateRoot}/app";
  postgresDataDir = "${stateRoot}/postgres";

  networkName = "bookorbit_default";
  networkService = "docker-network-${networkName}.service";

  bookorbitUid = 971;
  bookorbitGid = 971;

  mediaGid = config.users.groups.media.gid;

  inherit (import ./nginx-proxy.nix) cloudflareProxy;

  host = "127.0.0.1";
  port = "3000";
in
{
  users.groups.bookorbit = {
    gid = bookorbitGid;
  };

  users.users.bookorbit = {
    isSystemUser = true;
    uid = bookorbitUid;
    group = "bookorbit";
    extraGroups = [ "media" ];
    home = stateRoot;
    createHome = false;
  };

  systemd.tmpfiles.rules = [
    "d ${contentRoot} 0755 syncthing media -"
    "d ${booksDir} 2775 syncthing media -"
    "d ${incomingDir} 2775 syncthing media -"

    "d ${stateRoot} 0750 bookorbit media -"
    "d ${appDataDir} 0770 bookorbit media -"

    "d ${postgresDataDir} 0700 999 999 -"
  ];

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };

    oci-containers = {
      backend = "docker";

      containers = {
        bookorbit-db = {
          image = postgresImage;
          autoStart = true;

          environment = {
            PGDATA = "/var/lib/postgresql/data/pgdata";
            POSTGRES_DB = "bookorbit";
            POSTGRES_USER = "bookorbit";
            POSTGRES_PASSWORD = inputs.secrets.bookorbit.postgres_password;
          };

          volumes = [
            "${postgresDataDir}:/var/lib/postgresql/data:rw"
          ];

          log-driver = "journald";

          extraOptions = [
            "--network=${networkName}"
            "--network-alias=postgres"

            "--memory=768m"
            "--memory-swap=1g"
            "--cpus=0.75"
            "--pids-limit=256"

            "--health-cmd=pg_isready -U bookorbit -d bookorbit"
            "--health-interval=10s"
            "--health-retries=10"
            "--health-start-period=20s"
            "--health-timeout=5s"
          ];
        };

        bookorbit-app = {
          image = appImage;
          autoStart = true;

          dependsOn = [ "bookorbit-db" ];

          environment = {
            APP_IMAGE = appImage;

            NODE_ENV = "production";
            NODE_MAX_OLD_SPACE_SIZE = "1024";

            APP_URL = "https://bookorbit.lucaantonelli.xyz";
            CLIENT_URL = "https://bookorbit.lucaantonelli.xyz";

            APP_PORT = port;
            PORT = port;

            DATABASE_URL = "";
            POSTGRES_HOST = "postgres";
            POSTGRES_PORT = "5432";
            POSTGRES_DB = "bookorbit";
            POSTGRES_USER = "bookorbit";
            POSTGRES_PASSWORD = inputs.secrets.bookorbit.postgres_password;

            JWT_SECRET = inputs.secrets.bookorbit.jwt_token;
            SETUP_BOOTSTRAP_TOKEN = inputs.secrets.bookorbit.bootstrap_token;

            PUID = toString bookorbitUid;
            PGID = toString mediaGid;

            BOOK_DOCK_PATH = "/data/book-dock";
            LIBRARY_BROWSE_ROOT = "/books";
          };

          volumes = [
            "${booksDir}:/books:rw"
            "${incomingDir}:/data/book-dock:rw"
            "${appDataDir}:/data:rw"
          ];

          ports = [
            "${host}:${port}:3000/tcp"
          ];

          log-driver = "journald";

          extraOptions = [
            "--network=${networkName}"
            "--network-alias=app"

            "--memory=1536m"
            "--memory-swap=2g"
            "--cpus=1.0"
            "--pids-limit=512"

            "--init"

            "--cap-drop=ALL"
            "--cap-add=CHOWN"
            "--cap-add=DAC_OVERRIDE"
            "--cap-add=FOWNER"
            "--cap-add=SETGID"
            "--cap-add=SETUID"

            "--security-opt=no-new-privileges:true"

            ''--health-cmd=node -e "const p=process.env.PORT||3000;fetch('http://127.0.0.1:'+p+'/api/v1/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"''
            "--health-interval=30s"
            "--health-retries=3"
            "--health-start-period=30s"
            "--health-timeout=5s"

            "--stop-timeout=30"
          ];
        };
      };
    };
  };

  systemd = {

    services = {
      "docker-network-${networkName}" = {
        path = [ pkgs.docker ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "-${pkgs.docker}/bin/docker network rm ${networkName}";
        };

        script = "docker network inspect ${networkName} >/dev/null 2>&1 || docker network create ${networkName}";
      };

      docker-bookorbit-db = {
        after = [ networkService ];
        requires = [ networkService ];

        serviceConfig = {
          Restart = lib.mkOverride 90 "on-failure";
          RestartSec = lib.mkOverride 90 "10s";
        };
      };

      docker-bookorbit-app = {
        after = [
          networkService
          "docker-bookorbit-db.service"
        ];

        requires = [
          networkService
          "docker-bookorbit-db.service"
        ];

        serviceConfig = {
          Restart = lib.mkOverride 90 "on-failure";
          RestartSec = lib.mkOverride 90 "10s";
        };
      };
    };
  };

  services.nginx.virtualHosts."bookorbit.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://${host}:${port}";
    };
  };
}
