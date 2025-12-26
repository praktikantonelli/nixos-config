{ pkgs, ... }: {
  # Set up fail2ban jails and filters
  environment.etc = {
    "fail2ban/filter.d/molly.conf".text = ''
      [Definition]
      failregex = <HOST>\s+(31|40|51|53).*$
    '';

    "fail2ban/filter.d/nginx-bruteforce.conf".text = ''
      [Definition]
      failregex = ^<HOST>.*GET.*(matrix/server|\.php|admin|wp\-).* HTTP/\d.\d\" 404.*$
    '';

    "fail2ban/filter.d/postfix-bruteforce.conf".text = ''
      [Definition]
      failregex = warning: [\w\.\-]+\[<HOST>\]: SASL LOGIN authentication failed.*$
      journalmatch = _SYSTEMD_UNIT=postfix.service
    '';
  };

  # Enable fail2ban to prevent DDOS attacks
  services.fail2ban = {
    enable = true;
    extraPackages = [ pkgs.ipset ];
    banaction = "iptables-ipset-proto6-allports";
    jails = {
      # max 6 failures in 600 seconds
      "nginx-spam" = ''
        enabled  = true
        filter   = nginx-bruteforce
        logpath = /var/log/nginx/access.log
        backend = auto
        maxretry = 6
        findtime = 600
      '';

      # max 3 failures in 600 seconds
      "postfix-bruteforce" = ''
        enabled = true
        filter = postfix-bruteforce
        findtime = 600
        maxretry = 3
      '';

      # max 10 failures in 600 seconds
      # "molly" = ''
      #   enabled = true
      #   filter = molly
      #   findtime = 600
      #   maxretry = 10
      #   logpath = /var/log/molly-brown/access.log
      #   backend = auto
      # '';
    };

  };
}
