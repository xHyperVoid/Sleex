# Sleex QS

This branch is the testing branch of Sleex. Sleex is being completely rewritten with a new widget system (AGS -> Quickshell). 

**ESTIMATED RELEASE**: For the 25.08 release (early august)

|      |
|------|
| ![preview](preview.mp4) |

## Todo

- [x] Desktop widgets with movable clock + possibility to disable them in the settings
- [x] Fix workspace script
- [x] Move apps keybinds from the general hypr config to a dedicated file (to prevent overwriting)
- [x] Update axctl to exclude this new app file

## Todo (but after the release)
- [ ] Lockscreen
- [ ] Full screen music mode
- [ ] Plugin system for the dashboard
- [ ] Update the docs and READMEs
- [ ] Better looking weather widget
- [ ] Color scheme widget
- [ ] App launcher (?)
- [ ] Wallpaper selector in the settings app

## Installation

> [!IMPORTANT]
> THIS BRANCH IS VERY EXPERIMENTAL, BUG ARE TO BE EXPECTED

To try this branch of Sleex, here is what you should do:

Note: update `axos-hooks` and `axctl` before.

# From mirrors

- edit `/etc/pacman.conf` and add the following lines **above** the main axos repo:
  ```
  [axos-testing]
  Server = https://www.axos-project.com/AxMirrors/testing/$arch
  SigLevel = Optional TrustAll
  ```

- sync the repos with Epsilon: `epsi sync`
- Do a full update: `epsi`

# From source

- Clone this repo
- Build every sleex meta-packages in `sleex-packages` then install them
- Build the user configuration in the `sleex-user-config` and execute `sudo axctl load-sleex-user-config` (or if you don't have AxOS, `cp -r /etc/skel/.config/* ~/.config`)
- Build and install the main package

Then, you can start sleex by selecting the sleex session on your greeter

## License
Sleex is licensed under the GNU General Public License v3.0

## Special thanks
- [@end-4](https://github.com/end-4/): Great inspiration | Sleex is based on his work
