#!/usr/bin/env bash
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="/usr/share/sleex"
USER_WALLPAPER_DIR="$HOME/.sleex/wallpapers"
$CONFIG_DIR/scripts/color_generation/switchwall.sh "$USER_WALLPAPER_DIR -e .png -e .jpg -e .svg | xargs shuf -n1 -e)"
