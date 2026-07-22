{ pkgs, ... }: {
  programs.btop.package = pkgs.btop.override {
    cudaSupport = true;
  };

  home.packages = [ pkgs.nvtopPackages.intel ];
}
