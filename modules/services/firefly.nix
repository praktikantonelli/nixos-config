{ inputs, ... }:
let
  fireflyHost = "firefly.${inputs.secrets.domain}";
  importerHost = "firefly-import.${inputs.secrets.domain}";
in
{
  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    virtualHost = fireflyHost;

    settings = {
      TZ = "Europe/Zurich";

      COOKIE_SECURE = true;
    };
  };

  services.firefly-iii-data-importer = {
    enable = true;
    enableNginx = true;
    virtualHost = importerHost;

    settings = {
      FIREFLY_III_URL = "https://${fireflyHost}";

      TZ = "Europe/Zurich";
    };
  };
}
