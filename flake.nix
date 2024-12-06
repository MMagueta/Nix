{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small"; #release-24.11"; #nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs
            , home-manager
            , ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem rec {
        # nixos is the hostname
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            # inputs.emacs-overlay.overlay
            (final: prev: {
              postman = prev.postman.overrideAttrs(old: rec {
                version = "20230716100528";
                src = final.fetchurl {
                  url = "https://web.archive.org/web/${version}/https://dl.pstmn.io/download/latest/linux_64";
                  sha256 = "sha256-svk60K4pZh0qRdx9+5OUTu0xgGXMhqvQTGTcmqBOMq8=";
                  
                  name = "${old.pname}-${version}.tar.gz";
                };
              });
            })
          ];
          config.allowUnfree = true;
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mmagueta = import ./home.nix;
            # home-manager.users.work = import ./work-home.nix;
          }
        ];
      };
    };
  };
}
