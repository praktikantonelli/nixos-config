{ pkgs, ... }: {
  imports = [
    ../../modules/home/btop.nix
  ];

  programs.btop.package = pkgs.btop.override {
    rocmSupport = true;
  };

  home.packages = [ pkgs.nvtopPackages.amd ];
}
