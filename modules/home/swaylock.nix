{ pkgs, ... }: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      datestr = "";
      screenshots = true;

      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;

      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      effect-pixelate = 5;

      color = "1e1e2e";
      bs-hl-color = "fbf1c7";
      key-hl-color = "8ec07c";
      caps-lock-bs-hl-color = "fbf1c7";
      caps-lock-key-hl-color = "8ec07c";
      ring-color = "458588";
      ring-clear-color = "fe8019";
      ring-caps-lock-color = "d65d0e";
      ring-ver-color = "83a598";
      ring-wrong-color = "d3869b";
      text-color = "928374";
      text-clear-color = "fbf1c7";
      text-caps-lock-color = "d65d0e";
      text-ver-color = "83a598";
      text-wrong-color = "d3869b";
      layout-text-color = "928374";

      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      separator-color = "00000000";
    };
  };
}
