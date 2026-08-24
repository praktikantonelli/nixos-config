{ inputs, pkgs, ... }: {
  environment.systemPackages = [
    inputs.zennotes.packages.${pkgs.system}.zennotes-server
  ];
}
