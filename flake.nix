{
  description = "nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, catppuccin, musnix, ... } @ inputs: 
  {
    # desktop configuration
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/desktop/configuration.nix
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        musnix.nixosModules.musnix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "back";
          home-manager.users.ethan = import ./home.nix;
          home-manager.extraSpecialArgs = { 
            inherit inputs; 
            pkgs-unstable = import nixpkgs-unstable {
              config = { allowUnfree = true; };
              system = "x86_64-linux";
            };
          };
        }
      ];
    };

    # laptop
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/laptop/configuration.nix
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        musnix.nixosModules.musnix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "back";
          home-manager.users.ethan = import ./home.nix;
          home-manager.extraSpecialArgs = { 
            inherit inputs; 
            pkgs-unstable = import nixpkgs-unstable {
              config = { allowUnfree = true; };
              system = "x86_64-linux";
            };
          };
        }
      ];
    };
    
  };
}
