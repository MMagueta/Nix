{
  description = "MMagueta's Macintosh Flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
    darwin.url = "github:lnl7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager/master";
    # home-manager.url = "github:nix-community/home-manager/release-25.11";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
  let 

    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;

    nixpkgsConfig = {
      config = { 
        allowUnfree = true;
        packageOverrides = pkgs: {
          nix = pkgs.nix.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
        };
      };
      overlays = /*attrValues self.overlays ++ []*/
        attrValues self.overlays
        ++ [] ++ singleton (
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86);
          })
        );
    }; 
  in
    {   
      darwinConfigurations = rec {
        MacBookPro = darwinSystem {
          system = "aarch64-darwin";
          modules = attrValues self.darwinModules ++ [ 
            ./configuration.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.mmagueta = import ./home.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                pkgs = import nixpkgs {
                  system = "aarch64-darwin";
                  inherit (nixpkgsConfig) config overlays;
                };
              };
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
