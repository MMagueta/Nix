#!/bin/sh

set -eux
sudo nix build .#darwinConfigurations.MacMini.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .
