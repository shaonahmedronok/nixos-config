{
  description = "shaon's NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }:
  let
    themeLib = import ./theme.nix;
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit (themeLib) theme themeNoHash; };
      modules = [
        ./hardware-configuration.nix
        ./modules/nixos/hosts/az-pc/configuration.nix
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs    = true;
            useUserPackages  = true;
            users.az         = import ./modules/home;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit (themeLib) theme themeNoHash; };
            sharedModules = [
              ({ lib, ... }: {
                options.stylix.targets.niri.enable = lib.mkOption {
                  type    = lib.types.bool;
                  default = false;
                };
              })
            ];
          };
        }
      ];
    };
  };
}
