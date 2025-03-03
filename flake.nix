{
  description = "3random Home Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    nixosConfig = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./system/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.brandonb = import ./users/brandon/home.nix;
        }
      ];
    };
  in {
    nixosConfigurations.nixos = nixosConfig;

    # Add a default package
    packages.${system}.default = nixosConfig.config.system.build.toplevel;
  };
}
