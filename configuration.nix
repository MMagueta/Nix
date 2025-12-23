{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  #boot.initrd.secrets = {
  #  "/crypto_keyfile.bin" = null;
  #};

  programs.mosh.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    extraHosts = ''
    '';
  };

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  time.timeZone = "America/Sao_Paulo";

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  # hardware.graphics.enable = true; # Mesa OpenGL
  # hardware.opengl.driSupport = true; # Vulkan

  virtualisation.docker.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  
  # services.xserver.windowManager.stumpwm.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "ctrl:swapcaps";
  console.useXkbConfig = true;

  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.ollama = {
    enable = true;
    loadModels = [ "sqlcoder:7b" ];
  };

  programs.zsh.enable = true;

  users.users.mmagueta = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  users.users.work = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    cascadia-code
  ];

  environment.systemPackages = with pkgs; [
  	gnomeExtensions.dash-to-dock
  	gnome-tweaks
  ];

  system.copySystemConfiguration = false;

  system.stateVersion = "25.05";
}
