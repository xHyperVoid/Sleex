// Stolen from Pharmaracist (i love that name btw)
const { GLib } = imports.gi;
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import userOptions from "../.configuration/user_options.js";
const { Box, Label, EventBox, Scrollable, Button } = Widget;
import { fileExists } from "../.miscutils/files.js";

// Constants
const CONFIG_DIR = `/usr/share/sleex`;
const USER_WALL_DIR = GLib.get_home_dir() + "/.sleex/wallpapers";
const USER_THUMBNAIL_DIR = USER_WALL_DIR + "/thumbnails";

//if (!fileExists(USER_WALL_DIR)) createWallDir();

const createWallDir = () => {
  console.log(`creating ${USER_WALL_DIR}`);
  Utils.execAsync(["mkdir", "-p", USER_WALL_DIR]);
  Utils.execAsync(["mkdir", "-p", USER_THUMBNAIL_DIR]);
  Utils.execAsync([
    "cp",
    "-r",
    `${CONFIG_DIR}/wallpapers/`,
    `${GLib.get_home_dir()}/.sleex`,
  ]).catch(print);
};

if (!fileExists(USER_WALL_DIR)) createWallDir();

// Cached Variables
let cachedContent = null;

// Wallpaper Button
const WallpaperButton = (path) =>
  Widget.Button({
    child: Box({
      className: "preview-box",
      css: `background-image: url("${path}");`,
    }),
    onClicked: async () => {
      try {
        await Utils.execAsync([
          "sh",
          `${CONFIG_DIR}/scripts/color_generation/switchwall.sh`,
          path.replace("thumbnails", ""),
        ]);
        App.closeWindow("wallselect");
      } catch (error) {
        console.error("Error switching wallpaper:", error);
      }
    },
  });

// Get Wallpaper Paths
const getWallpaperPaths = () => {
  let wallpaperPathsPromise = Utils.execAsync(
    `find ${USER_THUMBNAIL_DIR} -type f`
  );
  console.log(wallpaperPathsPromise);
  return wallpaperPathsPromise;
};

// Create Content
const createContent = async () => {
  if (cachedContent) return cachedContent;

  try {
    const wallpaperPaths = (await getWallpaperPaths())
      .split("\n")
      .filter(Boolean);

    if (wallpaperPaths.length === 0) {
      return createPlaceholder();
    }

    cachedContent = EventBox({
      onPrimaryClick: () => App.closeWindow("wallselect"),
      onSecondaryClick: () => App.closeWindow("wallselect"),
      onMiddleClick: () => App.closeWindow("wallselect"),
      child: Scrollable({
        hexpand: true,
        vexpand: false,
        hscroll: "always",
        vscroll: "never",
        child: Box({
          className: "wallpaper-list",
          children: wallpaperPaths.map(WallpaperButton),
        }),
      }),
    });

    return cachedContent;
  } catch (error) {
    console.error("Error creating content:", error);
    return Box({
      className: "wallpaper-error",
      vexpand: true,
      hexpand: true,
      children: [
        Label({
          label: "Error loading wallpapers. Check the console for details.",
          className: "txt-large txt-error",
        }),
      ],
    });
  }
};

// Placeholder content when no wallpapers found
const createPlaceholder = () =>
  Box({
    className: "wallpaper-placeholder",
    vertical: true,
    vexpand: true,
    hexpand: true,
    spacing: 10,
    children: [
      Box({
        vertical: true,
        vpack: "center",
        hpack: "center",
        vexpand: true,
        children: [
          Label({
            label: "No wallpapers found.",
            className: "txt-large txt-bold",
          }),
          Label({
            label: "Generate thumbnails to get started.",
            className: "txt-norm txt-subtext",
          }),
        ],
      }),
    ],
  });

// Generate Thumbnails Button
const GenerateButton = () =>
  Widget.Button({
    className: "button-accent generate-thumbnails",
    child: Box({
      children: [
        Widget.Icon({ icon: "view-refresh-symbolic", size: 16 }),
        Widget.Label({ label: " Generate Thumbnails" }),
      ],
    }),
    tooltipText: "Regenerate all wallpaper thumbnails",
    onClicked: () => {
      Utils.execAsync([`bash`, `${CONFIG_DIR}/scripts/generate_thumbnails.sh`])
        .then(() => {
          cachedContent = null; // Invalidate cache
          App.closeWindow("wallselect");
          App.openWindow("wallselect");
        })
        .catch((error) => console.error("Error generating thumbnails:", error));
    },
  });
const openWallDirButton = () =>
  Widget.Button({
    className: "button-accent generate-thumbnails",
    child: Box({
      children: [
        Widget.Icon({ icon: "folder-symbolic", size: 16 }),
        Widget.Label({ label: " Open Wallpaper Directory" }),
      ],
    }),
    tooltipText: "Open wallpaper directory",
    onClicked: () => Utils.execAsync(["xdg-open", USER_WALL_DIR]),
  });

// Toggle Wallselect Window
const toggleWindow = () => {
  const win = App.getWindow("wallselect");
  if (!win) return;
  win.visible = !win.visible;
};
export { toggleWindow };

// Main Window
export default () =>
  Widget.Window({
    name: "wallselect",
    anchor: ["top", "bottom", "right", "left"],
    layer: "top",
    visible: false,
    child: Widget.Overlay({
      child: EventBox({
        onPrimaryClick: () => App.closeWindow("wallselect"),
        onSecondaryClick: () => App.closeWindow("wallselect"),
        onMiddleClick: () => App.closeWindow("wallselect"),
        child: Box({ css: "min-height: 1000px;" }),
      }),
      overlays: [
        Box({
          vertical: true,
          className: "dashboard spacing-v-15",
          vpack: userOptions.bar.position === "top" ? "start" : "end",
          children: [
            Box({
              className: "wallselect-header",
              children: [
                openWallDirButton(),
                Box({ hexpand: true }),
                GenerateButton(),
              ],
            }),
            Box({
              vertical: true,
              className: "sidebar-module",
              setup: (self) =>
                self.hook(
                  App,
                  async (_, name, visible) => {
                    if (name === "wallselect" && visible) {
                      const content = await createContent();
                      self.children = [content];
                    }
                  },
                  "window-toggled"
                ),
            }),
          ],
        }),
      ],
    }),
  });
