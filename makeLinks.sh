#!/bin/bash

# synbolic links
DOTFILES_DIR=$(dirname "$0")

cd $DOTFILES_DIR

ln -sf $DOTFILES_DIR/.bashrc $HOME/.bashrc
ln -sf $DOTFILES_DIR/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES_DIR/.zshrc $HOME/.zshrc
ln -sf $DOTFILES_DIR/.wezterm.lua $HOME/.wezterm.lua
ln -sf $DOTFILES_DIR/.config $HOME/.config

echo "Dotfiles have been symlinked."
