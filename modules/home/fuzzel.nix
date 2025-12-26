{ ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "SN-Pro:weight=bold:size=14";
        line-height = 25;
        fields = "name,generic,comment,categories,filename,keywords";
        terminal = "kitty";
        prompt = "' ➜  '";
        icon-theme = "oomox-gruvbox-dark";
        layer = "top";
        lines = 10;
        width = 20;
        horizontal-pad = 25;
        inner-pad = 5;
      };
      colors = {
        background = "#282828cc";
        text = "#ddc7a1cc";
        match = "#fe8019cc";
        selection = "#665c54cc";
        selection-match = "#d65d0ecc";
        selection-text = "#fbf1c7cc";
        border = "#83a598cc";
      };
      border = {
        radius = 15;
        width = 3;
      };
    };
  };
}

