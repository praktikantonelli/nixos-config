{ ... }: {
  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey = "ignore";
  };

  systemd.services.cache-regreet-user = {
    description = "Cache ${username} for ReGreet";
    wantedBy = [ "multi-user.target" ];
    after = [ "accounts-daemon.service" ];
    requires = [ "accounts-daemon.service" ];

    serviceConfig.Type = "oneshot";

    script = ''
      ${pkgs.systemd}/bin/busctl call --system \
        org.freedesktop.Accounts \
        /org/freedesktop/Accounts \
        org.freedesktop.Accounts \
        CacheUser \
        s \
        ${username} 
    '';
  };
}
