{
  description = "MMagueta's Macintosh Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
  let 

    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

    nixpkgsConfig = {
      config = { allowUnfree = false; };
      overlays = attrValues self.overlays ++ singleton (
        final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          inherit (final.pkgs-x86)
            polyml
            mlton
            smlfmt
            dotnet-sdk_8
          ;
        })
      );
    }; 
  in
  {   
    darwinConfigurations = rec {
      MacMini = darwinSystem {
        system = "aarch64-darwin";
        modules = attrValues self.darwinModules ++ [ 
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mmagueta = import ./home.nix;            
          }
        ];
      };
    };
    
    overlays = {
      apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        # Add access to x86 packages system is running Apple Silicon
        pkgs-x86 = import inputs.nixpkgs-unstable {
          system = "x86_64-darwin";
          inherit (nixpkgsConfig) config;
        };
      }; 
    };
    
    darwinModules = {
      programs-nix-index = 
        { config, lib, pkgs, ... }:
        {};
    };
  };
}
