{ inputs, ... }: {
  imports = [ inputs.comin.nixosModules.comin ];

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/praktikantonelli/nixos-config.git";
        branches.main.name = "main";
      }
    ];
  };
}
