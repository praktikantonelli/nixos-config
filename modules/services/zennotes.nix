{ inputs, pkgs, ... }:
let
  inherit (import ./nginx-proxy.nix) cloudflareProxy;
  zennotesUser = "zennotes";
  zennotesGroup = "zennotes";
  vaultRoot = "/srv/zennotes";
  defaultVault = "${vaultRoot}/default";
  stateDir = "/var/lib/zennotes";
  workVault = "${vaultRoot}/Work";
  notesVault = "${vaultRoot}/Notes";
  zennotesServer = inputs.zennotes.packages.${pkgs.stdenv.hostPlatform.system}.zennotes-server;
in
{
  users.groups.${zennotesGroup} = { };

  users.users.${zennotesUser} = {
    isSystemUser = true;
    group = zennotesGroup;

    # in case zennotes needs a state/config directory
    home = "/var/lib/zennotes";
    createHome = true;
  };

  systemd.tmpfiles.rules = [
    "d ${vaultRoot} 0750 ${zennotesUser} ${zennotesGroup} -"
    "d ${stateDir} 0750 ${zennotesUser} ${zennotesGroup} -"
    "d ${defaultVault} 0750 ${zennotesUser} ${zennotesGroup} -"
    "d ${workVault} 0750 ${zennotesUser} ${zennotesGroup} -"
    "d ${notesVault} 0750 ${zennotesUser} ${zennotesGroup} -"
  ];

  environment.systemPackages = [
    zennotesServer
  ];

  systemd.services.zennotes-server = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    description = "zennotes self-hosted server";
    serviceConfig = {
      Type = "simple";
      User = zennotesUser;
      Group = zennotesGroup;

      ExecStart = "${zennotesServer}/bin/zennotes-server";
      Restart = "on-failure";
      RestartSec = "5s";

    };
    environment = {
      ZENNOTES_BROWSE_ROOTS = vaultRoot;
      ZENNOTES_DEFAULT_VAULT_PATH = defaultVault;
      ZENNOTES_CONFIG_PATH = "${stateDir}/server.json";
    };
  };

  services.nginx.virtualHosts."zennotes.${inputs.secrets.domain}" = {
    locations."/" = cloudflareProxy {
      proxyPass = "http://127.0.0.1:7878";
    };
  };
}
