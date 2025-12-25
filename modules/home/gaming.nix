{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      ## Utils
      gamemode
    ];
}
