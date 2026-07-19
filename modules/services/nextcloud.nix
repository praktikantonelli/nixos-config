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
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";
    https = true;
    extraAppsEnable = true;
    extraApps = { inherit (pkgs.nextcloud33Packages.apps) onlyoffice; };
  };
}
