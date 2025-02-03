#!/bin/bash
pkg update && pkg upgrade
pkg install -y fish neovim openssh fzf fd ripgrep tmux bat dust \
	jq ncdu

bat cache --build
