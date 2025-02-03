#!/bin/bash

pkg update && pkg upgrade
pkg install -y fish neovim openssh fzf fd ripgrep tmux bat dust \
	jq ncdu
 
git config --global user.email "rkdeshdeepak1@gmail.com"
git config --global user.name "Deshdeepak"
git config --global credential.helper store

bat cache --build

dotfiles remote add origin https://github.com/deshdeepak1/.dotfiles
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local credential.helper store
dotfiles fetch --set-upstream origin termux
dotfiles reset --hard FETCH_HEAD
dotfiles remote set-url origin git@github.com:Deshdeepak1/.dotfiles.git
