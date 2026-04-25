#!/bin/bash
# Buat folder tujuannya
mkdir -p hypr waybar kitty mako wofi

# Copy file config utama
cp -r ~/.config/hypr/* ./hypr/
cp -r ~/.config/waybar/* ./waybar/
cp -r ~/.config/kitty/* ./kitty/
cp -r ~/.config/mako/* ./mako/
cp -r ~/.config/wofi/* ./wofi/

echo "✅ Dotfiles lokal sudah disinkronkan!"
