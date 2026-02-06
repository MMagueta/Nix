{ pkgs, lib, ... }:
{

  nix.settings = {
    trusted-users = [
      "@admin"
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };


  environment.variables = {
    DOTNET_ROOT="${pkgs.dotnet-sdk_10}/share/dotnet";
    PATH="$PATH:/Users/mmagueta/.dotnet/tools/";
  };

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    system = aarch64-darwin
    extra-platforms = x86_64-darwin
  '';

  system.primaryUser = "mmagueta";

  programs.zsh.enable = true;

  environment.shellAliases = {};
  
  services.nix-daemon.enableSocketListener = true;
  environment.systemPackages = with pkgs; [];

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  system.stateVersion = 5;
}
