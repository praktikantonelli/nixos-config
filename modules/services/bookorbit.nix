{ inputs, config, pkgs, lib, ... }:

let
  appImage = "ghcr.io/bookorbit/bookorbit:sha-54e228eb2a79";
  postgresImage =
    "pgvector/pgvector:pg16@sha256:7d400e340efb42f4d8c9c12c6427adb253f726881a9985d2a471bf0eed824dff";

  serviceRoot = "/srv/bookorbit";
  booksDir = "${serviceRoot}/books";
  incomingDir = "${serviceRoot}/incoming";
  appDataDir = "${serviceRoot}/data/app";
  postgresDataDir = "${serviceRoot}/data/postgres";

  networkName = "bookorbit_default";
  networkService = "docker-network-${networkName}.service";

  bookorbitUid = 971;
  bookorbitGid = 971;

  mediaGid = config.users.groups.media.gid;

  waitForDb = pkgs.writeShellApplication {
    name = "wait-for-bookorbit-db";
    runtimeInputs = [ pkgs.docker ];
    text = ''
      for i in $(seq 1 60); do
        status="$(docker inspect -f '{{.State.Health.Status}}' bookorbit-db 2>/dev/null || true)"

        if [ "$status" = "healthy" ]; then
          exit 0
        fi

        sleep 1
      done

      echo "bookorbit-db did not become healthy in time" >&2
      exit 1
    '';
  };

  removeNetwork = pkgs.writeShellScript "remove-bookorbit-network" ''
    ${pkgs.docker}/bin/docker network rm ${networkName} >/dev/null 2>&1 || true
  '';
in {
  users.groups.bookorbit = { gid = bookorbitGid; };

  users.users.bookorbit = {
    isSystemUser = true;
    uid = bookorbitUid;
    group = "bookorbit";
    extraGroups = [ "media" ];
    home = serviceRoot;
    createHome = false;
  };

  systemd.tmpfiles.rules = [
    # Service root
    "d ${serviceRoot} 0755 bookorbit bookorbit -"

    # Syncthing-managed content.
    #
    # These are owned by syncthing, inherit group media via setgid,
    # and are writable by BookOrbit through PGID=mediaGid.
    "d ${booksDir} 2775 syncthing media -"
    "d ${incomingDir} 2775 syncthing media -"

    # BookOrbit-managed app state.
    #
    # Group is media because the container runs with PGID=mediaGid.
    # This keeps /data writable without making your personal user the owner.
    "d ${serviceRoot}/data 0750 bookorbit media -"
    "d ${appDataDir} 0770 bookorbit media -"

    # Postgres-managed state. Do not sync this.
    #
    # The pgvector/postgres image normally runs postgres as uid/gid 999.
    "d ${postgresDataDir} 0700 999 999 -"
  ];

  virtualisation = {
    docker = {
      enable = true;

      autoPrune = { enable = true; };
    };

    oci-containers = {
      backend = "docker";

      containers = {
        bookorbit-db = {
          image = postgresImage;
          autoStart = false;

          environment = {
            PGDATA = "/var/lib/postgresql/data/pgdata";
            POSTGRES_DB = "bookorbit";
            POSTGRES_USER = "bookorbit";
            POSTGRES_PASSWORD = inputs.secrets.postgres_password;
          };

          volumes = [ "${postgresDataDir}:/var/lib/postgresql/data:rw" ];

          networks = [ networkName ];

          log-driver = "journald";

          extraOptions = [
            ''
              --health-cmd=pg_isready -U "''${POSTGRES_USER}" -d "''${POSTGRES_DB}"''
            "--health-interval=10s"
            "--health-retries=10"
            "--health-start-period=20s"
            "--health-timeout=5s"
            "--network-alias=postgres"
          ];
        };

        bookorbit-app = {
          image = appImage;
          autoStart = false;

          dependsOn = [ "bookorbit-db" ];

          environment = {
            APP_IMAGE = appImage;

            NODE_ENV = "production";
            NODE_MAX_OLD_SPACE_SIZE = "2048";

            APP_URL = "https://bookorbit.lucaantonelli.xyz";
            CLIENT_URL = "https://bookorbit.lucaantonelli.xyz";

            APP_PORT = "3000";
            PORT = "3000";

            DATABASE_URL = "";
            POSTGRES_HOST = "postgres";
            POSTGRES_PORT = "5432";
            POSTGRES_DB = "bookorbit";
            POSTGRES_USER = "bookorbit";
            POSTGRES_PASSWORD = inputs.secrets.postgres_password;

            JWT_SECRET = inputs.secrets.jwt_token;
            SETUP_BOOTSTRAP_TOKEN = inputs.secrets.bootstrap_token;

            # BookOrbit's container-side runtime identity.
            #
            # bookorbitUid owns app state.
            # mediaGid gives write access to Syncthing-managed folders.
            PUID = toString bookorbitUid;
            PGID = toString mediaGid;

            # Host /srv/bookorbit/incoming is mounted here.
            BOOK_DOCK_PATH = "/data/book-dock";
          };

          volumes = [
            "${booksDir}:/books:rw"
            "${appDataDir}:/data:rw"
            "${incomingDir}:/data/book-dock:rw"
          ];

          # Keep this localhost-only if a reverse proxy terminates HTTPS.
          # Change to "3000:3000/tcp" only if you intentionally want direct LAN exposure.
          ports = [ "127.0.0.1:3000:3000/tcp" ];

          networks = [ networkName ];

          log-driver = "journald";

          extraOptions = [
            "--init"

            "--read-only"
            "--tmpfs=/tmp:rw,noexec,nosuid,size=256m"

            "--cap-drop=ALL"
            "--cap-add=CHOWN"
            "--cap-add=DAC_OVERRIDE"
            "--cap-add=FOWNER"
            "--cap-add=SETGID"
            "--cap-add=SETUID"

            "--security-opt=no-new-privileges:true"

            ''
              --health-cmd=node -e "const p=process.env.PORT||3000;fetch('http://127.0.0.1:'+p+'/api/v1/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"''
            "--health-interval=30s"
            "--health-retries=3"
            "--health-start-period=20s"
            "--health-timeout=5s"

            "--stop-timeout=30"

            "--network-alias=app"
          ];
        };
      };
    };
  };

  systemd = {
    # Keep this if your Syncthing service is the system-level NixOS
    # service named syncthing.service. It makes newly created files
    # group-writable, which is important for the media shared-group model.
    services.syncthing.serviceConfig.UMask = lib.mkDefault "0002";

    services = {
      docker-bookorbit-db = {
        after = [ networkService ];
        requires = [ networkService ];

        partOf = [ "docker-compose-bookorbit-root.target" ];
        wantedBy = [ "docker-compose-bookorbit-root.target" ];

        serviceConfig = {
          Restart = lib.mkOverride 90 "always";
          RestartSec = lib.mkOverride 90 "5s";
        };
      };

      docker-bookorbit-app = {
        after = [ networkService "docker-bookorbit-db.service" ];

        requires = [ networkService "docker-bookorbit-db.service" ];

        partOf = [ "docker-compose-bookorbit-root.target" ];
        wantedBy = [ "docker-compose-bookorbit-root.target" ];

        serviceConfig = {
          ExecStartPre =
            lib.mkAfter [ "${waitForDb}/bin/wait-for-bookorbit-db" ];

          Restart = lib.mkOverride 90 "always";
          RestartSec = lib.mkOverride 90 "5s";
        };
      };

      "docker-network-${networkName}" = {
        path = [ pkgs.docker ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "${removeNetwork}";
        };

        script = ''
          docker network inspect ${networkName} >/dev/null 2>&1 \
            || docker network create ${networkName}
        '';

        partOf = [ "docker-compose-bookorbit-root.target" ];
        wantedBy = [ "docker-compose-bookorbit-root.target" ];
      };
    };

    targets.docker-compose-bookorbit-root = {
      unitConfig = { Description = "BookOrbit Docker stack."; };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
