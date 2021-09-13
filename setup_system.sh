#!/bin/sh

# === Gruvbox theme ===

sudo apt-get install dconf-cli uuid-runtime
echo "Installing gruvbox theme for gnome terminal ..."
mkdir -p "$HOME/gruvbox_theme"
cd "$HOME/gruvbox_theme"
git clone https://github.com/Mayccoll/Gogh.git gogh
cd gogh/themes

# necessary on ubuntu
export TERMINAL=gnome-terminal

# install themes
./gruvbox-dark/sh

cd ~
rm -rf "$HOME/gruvbox_theme"



