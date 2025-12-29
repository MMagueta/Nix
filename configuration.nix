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

#  hardware.amdgpu.opencl.enable = true;
# boot.kernelPackages = pkgs.linuxPackages_latest; # Probably don't have to be on the latest kernel, but it doesn't hurt.
#services.xserver.videoDrivers = [ "amdgpu" ];
hardware.graphics = {
  enable = true;
};

#services.ollama = {
#  enable = true;
#  package = pkgs.ollama-rocm;
#  loadModels = [ "qwen3-coder:30b" ];
#  #rocmOverrideGfx = "10.3.0";
#};

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  time.timeZone = "America/Sao_Paulo";

  services.xserver.enable = true;

  virtualisation.docker.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
  '';

  # services.xserver.windowManager.stumpwm.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "ctrl:swapcaps";
  console.useXkbConfig = true;

  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      noto-fonts
      ubuntu-classic
      unifont
      noto-fonts-cjk-sans
    ];

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Ubuntu Source" ];
      };
    };
  };  

  system.copySystemConfiguration = false;

  system.stateVersion = "25.05";
}
