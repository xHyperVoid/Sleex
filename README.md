# Sleex

Sleex is the third desktop environement of AxOS. It is based on Hyprland with Quickshell.

## Features
- Fast and lightweight
- AI chat integration with external providers (Gemini, OpenAI...)
- Smooth animations
- Tiling window management for seamless multitasking
- Adaptative color scheme based on the wallpaper

## Screenshots

| Description | Image |
|--------------------------|-----------------------------------------|
| Main desktop, adaptative colors according to wallpaper | ![Sleex 1](https://github.com/user-attachments/assets/1b02defa-ebb7-4303-8092-449cf57137b2) |
| Dashboard with numerous widgets | ![Sleex Dashboard](https://github.com/user-attachments/assets/60157f6d-5d90-4f24-8f25-520ea274116d) |
| Left panel with LLM APIs and Sleex update center | ![Sleex Side Left](https://github.com/user-attachments/assets/e70b36c0-56d0-43bc-b406-06c6c437524f) |
| Workspace overviews with search bar | ![Sleex Overview](https://github.com/user-attachments/assets/df850f3e-2103-4325-9047-398f0de8a2d9) |

## Installation

> [!IMPORTANT]
> THIS BRANCH IS VERY EXPERIMENTAL, BUG ARE TO BE EXPECTED

To try this branch of Sleex, here is what you should do:

- Build every sleex meta-packages in `sleex-packages` then install them
- Build the user configuration and copy the content from `/etc/skel/.config` to your own .config folder
- Build and install the main package

Then, you can start sleex by selecting the sleex session on your greeter

## License
Sleex is licensed under the GNU General Public License v3.0

## Special thanks
- [@end-4](https://github.com/end-4/): Great inspiration | Sleex is based on his work
