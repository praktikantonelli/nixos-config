{
  pkgs,
  username,
  inputs,
  config,
  ...
}:
let
  domain = inputs.secrets.domain;
  onlyofficeUrl = "https://onlyoffice.${domain}/";
  nextcloudInternalUrl = "http://nextcloud.${domain}/";
  onlyofficeJwtFile = config.sops.secrets.onlyoffice-jwt-token.path;
in
{
  networking.hosts."127.0.0.1" = [ "nextcloud.${domain}" ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud34;
    hostName = "nextcloud.${inputs.secrets.domain}";
    config = {
      adminuser = username;
      adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;
      dbtype = "mysql";
    };
    settings = {
      "files.chunked_upload.max_size" = 50000000;
    };
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";
    https = true;
    extraAppsEnable = true;
    datadir = "/srv/nextcloud";
    extraApps = { inherit (pkgs.nextcloud34Packages.apps) onlyoffice; };
  };

  systemd.services.nextcloud-onlyoffice-config = {
    description = "Configure the Nextcloud OnlyOffice integration";
    after = [
      "nextcloud-setup.service"
      "onlyoffice-docservice.service"
    ];
    wants = [ "onlyoffice-docservice.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [
      config.services.nextcloud.occ
      pkgs.coreutils
    ];
    script = ''
      set -eu

      jwt_secret="$(tr -d '\n' < ${onlyofficeJwtFile})"
      nextcloud-occ app:enable onlyoffice
      nextcloud-occ config:app:set onlyoffice DocumentServerUrl --value="${onlyofficeUrl}"
      nextcloud-occ config:app:set onlyoffice DocumentServerInternalUrl --value="${onlyofficeUrl}"
      nextcloud-occ config:app:set onlyoffice StorageUrl --value="${nextcloudInternalUrl}"
      nextcloud-occ config:app:set onlyoffice jwt_secret --value="$jwt_secret"
      nextcloud-occ config:app:set onlyoffice jwt_header --value="Authorization"
      nextcloud-occ config:app:delete onlyoffice settings_error || true
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
