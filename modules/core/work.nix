{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    freerdp
    openfortivpn
    openfortivpn-webview
  ];
}
