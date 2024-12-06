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
    username = "mmagueta";
    homeDirectory = "/home/mmagueta";
    sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
      # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  services.udiskie = {
    enable = true;
    automount = true;
  };
  
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # abcl
    meslo-lgs-nf
    # nyxt
    # rebar3
    # erlang
    # erlang-ls
    # lfe
    # ecl
    # nodejs
    zip
    # libreoffice
    # ocaml
    # ocamlformat
    # ocamlPackages.dune_3
    # ocamlPackages.odoc
    # opam
    # ocamlPackages.ocaml-lsp
    # ocamlPackages.menhir
    # ocamlPackages.utop
    # OpenGL
    # libGL libGLU glew freeglut glxinfo
    # postman
    ispell
    # racket-minimal
    # jdk16
    # clojure
    # clojure-lsp
    obs-studio
    # spotify
    signal-desktop
    # fstar
    # z3
    gcc
    # libc
    # stdenv.cc.cc
    gnumake
    # qemu
    # nasm
    # clang-tools
    # llvmPackages_latest.libstdcxxClang
    # llvmPackages_latest.libcxx
    # swiProlog
    # feh
    htop
    # ocaml
    # opam
    # ocamlPackages.ocaml-lsp
    # dune_3
    discord
    # insomnia
    docker-compose
    firefox
    git-crypt
    gnupg
    # stack
    # ghc
    # cabal-install
    # haskell-language-server
    # hlint
    wget
    # plantuml
    gnutls
    fastfetch
    netcoredbg
    dotnet-sdk_8
    icu # FSAutocomplete dependency
    # magemacs
    emacs
    emacs-all-the-icons-fonts
    git
    jetbrains.rider
    jetbrains.clion
    terminator
    # sqls
    # postgresql
    # rosegarden
    # jack2
    # qjackctl
    nil # Nix LSP
    thunderbird
    zulip
    monaspace
  ];

  # programs.waybar.enable = true;

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
    pinentryPackage = pkgs.pinentry-gnome3;
    sshKeys = [ "9AA3054F8732794A8B33510B5B9E5F9D7211E7B1" ];
  };
}
