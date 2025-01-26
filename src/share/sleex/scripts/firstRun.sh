#!/bin/sh

# This script is run the first time the user logs in after installing Sleex.
# It sets up the user's environment to use Sleex.

echo 'Setting up Sleex environment...'
echo 'top' > ~/.local/state/ags/user/bar_position.txt
echo 'true' > ~/.local/state/ags/user/show_monitor.txt
echo 'true' > ~/.local/state/ags/user/show_sysicons.txt
echo 'true' > ~/.local/state/ags/user/show_systray.txt
echo 'true' > ~/.local/state/ags/user/show_timedate.txt
echo 'true' > ~/.local/state/ags/user/show_workspaces.txt
echo 'true' > ~/.local/state/ags/user/show_wintitle.txt
echo 'false' > ~/.local/state/ags/user/show_music.txt
echo 'false' > ~/.local/state/ags/user/show_weather.txt

echo 'Complete!'