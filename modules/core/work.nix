{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    remmina
    freerdp
    openfortivpn
    openfortivpn-webview
  ];
}
