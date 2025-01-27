#!/usr/bin/env bash
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="/usr/share/sleex"
$CONFIG_DIR/scripts/color_generation/switchwall.sh "$CONFIG_DIR/wallpapers/ -e .png -e .jpg -e .svg | xargs shuf -n1 -e)"
