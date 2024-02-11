{ config, pkgs, lib, ... }:
{
  home.stateVersion = "23.05";
  
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  nixpkgs.overlays = [];

  home.packages = with pkgs; [
    wabt
    sbcl
    netcoredbg
    nodejs
    purescript
    rebar3
    lfe
    erlang
    erlang-ls
    just
    racket
    ocaml
    ocamlformat
    ocamlPackages.dune_3
    opam
    ocamlPackages.ocaml-lsp
    coreutils
    ispell
    gnumake
    htop
    cask
    wget
    gnupg
    gnutls
    # dotnet-sdk
    dotnet-sdk_8
    mono
    git-crypt
    rnix-lsp
    neofetch
    millet
    polyml
    gnumake
    buf
    # dotnetCorePackages
    protobuf
    vault
    # C/C++
    # clang
    # clang-tools
    ## LSP std
    # llvmPackages_latest.libstdcxxClang
    ## stdlib for cpp
    # llvmPackages_latest.libcxx
    # Vulkan
    #vulkan-headers
    #vulkan-loader
    #glm
    #glslang
    #glfw
    #SML
    millet
    polyml
    mlton # required by smlfmt
    smlfmt
    # pkgs.gcc
    # pkgs.glibc
  ] ++ lib.optionals stdenv.isDarwin [
  ];

  programs.git = {
    enable = true;
    userName = "Marcos Magueta";
    delta.enable = true;
    lfs.enable = true;
    userEmail = "maguetamarcos@gmail.com";
    signing = {
       key = "CE25E21959B460A84BDFB93F0AD3A1263F9DE73E";
       signByDefault = true;
    };
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
       export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
       gpgconf --launch gpg-agent
    '';
  };

}
