{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, caelestia-shell, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix 
        home-manager.nixosModules.home-manager
        
        {
	  home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

	  home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.xkraty = import ./home.nix;
        }
      ];
    };
  };
}
