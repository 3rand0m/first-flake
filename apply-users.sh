#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/brandon/home.nix
popd

