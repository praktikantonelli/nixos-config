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

      APP_KEY_FILE = config.sops.secrets.firefly-app-key.path;

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
