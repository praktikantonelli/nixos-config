{
  lib,
  pkgs,
  username,
  ...
}:
{
  systemd.user.services.zellij-web = {
    Unit = {
      Description = "Zellij web server";
      After = [ "Network-online.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.zellij} web";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

  };

  users.users.${username}.linger = true;
}
