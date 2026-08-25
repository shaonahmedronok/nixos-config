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

    helium = {
  url = "github:oxcl/nix-flake-helium-browser";
  inputs.nixpkgs.follows = "nixpkgs";
};
  };
  outputs = { self, nixpkgs, home-manager, stylix, helium, ... }@inputs:
  let
    themeLib = import ./theme.nix;
  in {
    nixosConfigurations.shaonix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit (themeLib) theme themeNoHash;
      };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs       = true;
            useUserPackages     = true;
            users.shaonix            = import ./home-default.nix;
            backupFileExtension = "backup";
            extraSpecialArgs    = {
              inherit inputs;
              inherit (themeLib) theme themeNoHash;
            };
            sharedModules = [
              {
                options.stylix.targets.niri.enable =
                  nixpkgs.lib.mkOption { type = nixpkgs.lib.types.bool; default = false; };
              }
            ];
          };
        }
      ];
    };
  };
}
