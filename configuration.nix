{ pkgs, lib, ... }:
{

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  # nix.binaryCachePublicKeys = [
  #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  # ];
  nix.settings.trusted-users = [
    "@admin"
  ];
  nix.configureBuildUsers = true;

  environment.variables = {
    DOTNET_ROOT="${pkgs.dotnet-sdk_8}";
    LD_LIBRARY_PATH="${lib.makeLibraryPath [pkgs.glfw pkgs.vulkan-headers pkgs.glm pkgs.llvmPackages_latest.libstdcxxClang]}";
  };

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    system = aarch64-darwin
    extra-platforms = x86_64-darwin
  '';

  programs.zsh.enable = true;

  environment.shellAliases = {
  };
  
  services.nix-daemon.enable = true;
  services.nix-daemon.enableSocketListener = true;
  environment.systemPackages = with pkgs; [];

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  programs.nix-index.enable = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
}
