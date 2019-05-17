#!/bin/bash

files="
  .bashrc
  .bash_profile
  .hyper.js
  .zshrc
  .gitconfig
  .gitignore_global
"

for file in $files; do
  cp $file ~
done

cp ./init.vim ~/.config/nvim/
