# Author:  Winston Troughton <winston@wlt.dev>
# URL:     https://github.com/wtroughton/nixos

{
  description = "System and user configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs { inherit system; };

    in {
      nixosModules = {
        sway = import ./modules/desktop/sway.nix;
      };
      nixosConfigurations = {
        HAL = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alice = import ./users/alice.nix;
            }
          ];
        };
      };
    };
}
