#!/bin/bash

dotfiles=~/dotfiles
files="
  .bashrc
  .bash_profile
  .hyper.js
  .zshrc
  .gitconfig
  .gitignore_global
  .config/nvim/init.vim
"

for file in $files; do
  cp ~/$file $dotfiles
done
