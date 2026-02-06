#!/bin/sh

set -eux
sudo launchctl start org.nixos.nix-daemon
nix build .#darwinConfigurations.MacBookPro.system -L
sudo ./result/sw/bin/darwin-rebuild switch --flake .
