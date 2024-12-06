{ config, pkgs, ... }:
{

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
    extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
    ];
  };
  
  manual.manpages.enable = false;

  home = {
    stateVersion = "23.05";
    username = "work";
    homeDirectory = "/home/work";
    sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnet-sdk}";
      # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  services.udiskie = {
    enable = true;
    automount = true;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # drawio
    # insomnia
    unzip
    zip
    buf
    jq
    # vault
    gnumake
    sqls
    spotify
    chromium
    signal-desktop
    gcc
    htop
    discord
    docker-compose
    firefox
    git-crypt
    gnupg
    wget
    plantuml
    graphviz
    gnutls
    fastfetch
    # netcoredbg
    dotnet-sdk_8
    icu # FSAutocomplete dependency
    postman
    emacs
    emacs-all-the-icons-fonts
    git
    terminator
    jetbrains.rider
    # jetbrains.idea-community
    # jdk11
    # kubectl
    # awscli2
    nil # Nix LSP
  ];

  programs.zsh = {
    enable = true;
    initExtra = ''
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "dotnet" ];
      theme = "robbyrussell";
    };
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Marcos Magueta";
    userEmail = "maguetamarcos@gmail.com";
    ignores = [ "result" ];
    delta = {
      enable = true;
      options = {
        features = "side-by-side line-numbers decorations";
        delta = {
          navigate = true;
        };
        line-numbers = {
          line-numbers-minus-style = 124;
          line-numbers-plus-style = 28;
        };
      };
    };
    extraConfig = {
      rerere.enabled = true;
      merge = {
        conflictstyle = "diff3";
      };
    };
    lfs = {
      enable = true;
    };
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
    pinentryPackage = pkgs.pinentry-curses;
    sshKeys = [ "9AA3054F8732794A8B33510B5B9E5F9D7211E7B1" ];
  };
}
