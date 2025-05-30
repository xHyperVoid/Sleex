#!/bin/sh

# This script is run the first time the user logs in after installing Sleex.
# It sets up the user's environment to use Sleex.

echo 'Setting up Sleex environment...'
echo 'true' > ~/.local/state/ags/user/show_monitor.txt
echo 'true' > ~/.local/state/ags/user/show_timedate.txt
echo 'true' > ~/.local/state/ags/user/show_workspaces.txt
echo 'true' > ~/.local/state/ags/user/show_wintitle.txt


CONFIG_FILE="$HOME/.config/hypr/custom/general.conf"
KEYBINDS_DIR="$HOME/.config/hypr/hyprland"
VC_KEYMAP=$(grep -i KEYMAP /etc/vconsole.conf | cut -d= -f2 | tr -d '"')
LAYOUT=$(echo "$VC_KEYMAP" | awk '{print tolower($0)}')

echo "Setting keyboard layout to '$LAYOUT' in $CONFIG_FILE."

if grep -q "^input:kb_layout" "$CONFIG_FILE"; then
    sed -i "s/^input:kb_layout.*/input:kb_layout = $LAYOUT/" "$CONFIG_FILE"
else
    echo "input:kb_layout = $LAYOUT" >> "$CONFIG_FILE"
fi

echo "Applying keybinds configuration in $KEYBINDS_DIR."

if [[ "$LAYOUT" == "us" ]]; then
    mv -f "$KEYBINDS_DIR/keybinds_us.conf" "$KEYBINDS_DIR/keybinds.conf"
    echo "Switched to US keybinds."
elif [[ "$LAYOUT" == "fr" ]]; then
    mv -f "$KEYBINDS_DIR/keybinds_fr.conf" "$KEYBINDS_DIR/keybinds.conf"
    echo "Switched to FR keybinds."
else
    echo "Unknown layout: $LAYOUT – applying US keybinds."
    mv -f "$KEYBINDS_DIR/keybinds_us.conf" "$KEYBINDS_DIR/keybinds.conf"

fi

hyprctl reload

echo 'Complete!'