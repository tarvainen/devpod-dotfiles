#!/bin/bash

export XDG_CONFIG_HOME="$HOME"/.config

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CONFIG_HOME"/nixpkgs

# Create symlinks for existing configurations
ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME"/nvim
ln -sf "$PWD/config.nix" "$XDG_CONFIG_HOME"/nixpkgs/config.nix

nix-env -iA nixpkgs.myPackages
