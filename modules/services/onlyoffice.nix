# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, inputs, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."onlyoffice-documentserver" = {
    image = "onlyoffice/documentserver";
    environment = {
      "AMQP_URI" = "amqp://guest:guest@onlyoffice-rabbitmq";
      "DB_HOST" = "onlyoffice-postgresql";
      "DB_NAME" = "onlyoffice";
      "DB_PORT" = "5432";
      "DB_TYPE" = "postgres";
      "DB_USER" = "onlyoffice";
      "JWT_SECRET" = inputs.secrets.onlyoffice-jwt-token;
      "PLUGINS_ENABLED" = "false";
    };
    volumes = [
      "/var/www/onlyoffice/Data"
      "/var/log/onlyoffice"
      "/var/lib/onlyoffice/documentserver/App_Data/cache/files"
      "/var/www/onlyoffice/documentserver-example/public/files"
      "/usr/share/fonts"
    ];
    ports = [ "127.0.0.1:180:80/tcp" "127.0.0.1:1443:443/tcp" ];
    dependsOn = [ "onlyoffice-postgresql" "onlyoffice-rabbitmq" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=onlyoffice-documentserver"
      "--network=onlyoffice_default"
    ];
  };
  systemd.services."docker-onlyoffice-documentserver" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-onlyoffice_default.service" ];
    requires = [ "docker-network-onlyoffice_default.service" ];
    partOf = [ "docker-compose-onlyoffice-root.target" ];
    wantedBy = [ "docker-compose-onlyoffice-root.target" ];
  };
  virtualisation.oci-containers.containers."onlyoffice-postgresql" = {
    image = "postgres:12";
    environment = {
      "POSTGRES_DB" = "onlyoffice";
      "POSTGRES_HOST_AUTH_METHOD" = "trust";
      "POSTGRES_USER" = "onlyoffice";
    };
    volumes = [ "onlyoffice_postgresql_data:/var/lib/postgresql:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=onlyoffice-postgresql"
      "--network=onlyoffice_default"
    ];
  };
  systemd.services."docker-onlyoffice-postgresql" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-onlyoffice_default.service"
      "docker-volume-onlyoffice_postgresql_data.service"
    ];
    requires = [
      "docker-network-onlyoffice_default.service"
      "docker-volume-onlyoffice_postgresql_data.service"
    ];
    partOf = [ "docker-compose-onlyoffice-root.target" ];
    wantedBy = [ "docker-compose-onlyoffice-root.target" ];
  };
  virtualisation.oci-containers.containers."onlyoffice-rabbitmq" = {
    image = "rabbitmq";
    log-driver = "journald";
    extraOptions =
      [ "--network-alias=onlyoffice-rabbitmq" "--network=onlyoffice_default" ];
  };
  systemd.services."docker-onlyoffice-rabbitmq" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-onlyoffice_default.service" ];
    requires = [ "docker-network-onlyoffice_default.service" ];
    partOf = [ "docker-compose-onlyoffice-root.target" ];
    wantedBy = [ "docker-compose-onlyoffice-root.target" ];
  };

  # Networks
  systemd.services."docker-network-onlyoffice_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f onlyoffice_default";
    };
    script = ''
      docker network inspect onlyoffice_default || docker network create onlyoffice_default
    '';
    partOf = [ "docker-compose-onlyoffice-root.target" ];
    wantedBy = [ "docker-compose-onlyoffice-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-onlyoffice_postgresql_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect onlyoffice_postgresql_data || docker volume create onlyoffice_postgresql_data
    '';
    partOf = [ "docker-compose-onlyoffice-root.target" ];
    wantedBy = [ "docker-compose-onlyoffice-root.target" ];
  };

  # Builds
  systemd.services."docker-build-onlyoffice-documentserver" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd /home/luca/Docker-DocumentServer
      docker build -t compose2nix/onlyoffice-documentserver .
    '';
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-onlyoffice-root" = {
    unitConfig = { Description = "Root target generated by compose2nix."; };
    wantedBy = [ "multi-user.target" ];
  };
}
