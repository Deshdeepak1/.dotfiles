#!/bin/bash
pkg update && pkg upgrade
pkg install -y fish neovim fzf fd ripgrep tmux bat dust
