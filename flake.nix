{
  description = "shaon's NixOS config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
 {
    nixosConfigurations.shaonix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs       = true;
            useUserPackages     = true;
            users.shaonix            = import ./home-default.nix;
            backupFileExtension = "backup";
            extraSpecialArgs    = {
              inherit inputs;
            };
          };
        }
      ];
    };
  };
}
