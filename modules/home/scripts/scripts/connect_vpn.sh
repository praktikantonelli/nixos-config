vpn_host="vpn.bernina.com:443"

openfortivpn-webview "$vpn_host" |
  sudo openfortivpn "$vpn_host" --cookie-on-stdin --pppd-accept-remote
