{
  pkgs,
  username,
  inputs,
  config,
  ...
}:
{
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
}
