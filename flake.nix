{
  description = "Luca Antonelli's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hypr-contrib.url = "github:hyprwm/contrib";

    nordzy-cursors = {
      url = "github:guillaumeboehm/Nordzy-cursors";
      flake = false;
    };

    mms.url = "github:mkaito/nixos-modded-minecraft-servers";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Evaluate the flake as the normal user so this private input can use the
    # user's SSH credentials. Elevate only the NixOS activation step.
    secrets = {
      url = "git+ssh://git@github.com/praktikantonelli/nix-secrets.git?ref=main";
      inputs = { };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nix-hyprlogin = {
      url = "github:sashisashi569/nix-hyprlogin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      self,
      home-manager,
      ...
    }@inputs:
    let
      username = "luca";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/desktop) ];
          specialArgs = {
            host = "desktop";
            inherit self inputs username;
          };
        };
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/laptop) ];
          specialArgs = {
            host = "laptop";
            inherit self inputs username;
          };
        };
        homelab = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/homelab) ];
          specialArgs = {
            host = "homelab";
            inherit self inputs username;
          };
        };
      };

      homeConfigurations = {
        "${username}@laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/laptop/home.nix ];
          extraSpecialArgs = {
            host = "laptop";
            inherit self inputs username;
          };
        };

        "${username}@desktop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/desktop/home.nix ];
          extraSpecialArgs = {
            host = "desktop";
            inherit self inputs username;
          };
        };
        "${username}@homelab" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./modules/home/homelab.nix ];
          extraSpecialArgs = {
            host = "homelab";
            inherit self inputs username;
          };
        };
      };
    };
}
