const { GLib } = imports.gi;
import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import Mpris from "resource:///com/github/Aylur/ags/service/mpris.js";
const { exec, execAsync } = Utils;
const { Box, Label, Button, Revealer } = Widget;

import { AnimatedCircProg } from "../../.commonwidgets/cairo_circularprogress.js";
import { hasPlasmaIntegration } from "../../.miscutils/system.js";

var lastCoverPath = "";

function isRealPlayer(player) {
     return (
          !(
               hasPlasmaIntegration &&
               player.busName.startsWith("org.mpris.MediaPlayer2.firefox")
          ) &&
          !(hasPlasmaIntegration && player.busName.startsWith('org.mpris.MediaPlayer2.chromium')) &&
          // playerctld just copies other buses and we don't need duplicates
          !player.busName.startsWith("org.mpris.MediaPlayer2.playerctld") &&
          // Non-instance mpd bus
          !(
               player.busName.endsWith(".mpd") &&
               !player.busName.endsWith("MediaPlayer2.mpd")
          )
     );
}

export const getPlayer = (name = userOptions.music.preferredPlayer) =>
     Mpris.getPlayer(name) || Mpris.players[0] || null;


const DEFAULT_MUSIC_FONT = "Gabarito, sans-serif";

function getTrackfont(player) {
     const title = player.trackTitle;
     const artists = player.trackArtists.join(" ");
     if (
          artists.includes("TANO*C") ||
          artists.includes("USAO") ||
          artists.includes("Kobaryo")
     )
          return "Chakra Petch"; // Rigid square replacement
     if (title.includes("東方")) return "Crimson Text, serif"; // Serif for Touhou stuff
     return DEFAULT_MUSIC_FONT;
}

function trimTrackTitle(title) {
     if (!title) return "";
     const cleanPatterns = [
          /【[^】]*】/, // Touhou n weeb stuff
          " [FREE DOWNLOAD]", // F-777
     ];
     cleanPatterns.forEach((expr) => (title = title.replace(expr, "")));
     return title;
}

const TrackProgress = ({ player, ...rest }) => {
     const _updateProgress = (circprog) => {
          // const player = Mpris.getPlayer();
          if (!player) return;
          // Set circular progress (see definition of AnimatedCircProg for explanation)
          circprog.css = `font-size: ${Math.max(
               (player.position / player.length) * 100,
               0
          )}px;`;
     };
     return AnimatedCircProg({
          ...rest,
          className: "osd-music-circprog",
          vpack: "center",
          extraSetup: (self) =>
               self.hook(Mpris, _updateProgress).poll(3000, _updateProgress),
     });
};

const TrackTitle = ({ player, ...rest }) =>
     Label({
          ...rest,
          xalign: 0,
          label: "No music playing",
          wrap: true,
          className: "txt txt-large",
          setup: (self) =>
               self.hook(
                    player,
                    (self) => {
                         // Player name
                         self.label =
                              player.trackTitle.length > 0
                                   ? trimTrackTitle(player.trackTitle)
                                   : "No media";
                         // Font based on track/artist
                         const fontForThisTrack = getTrackfont(player);
                         self.css = `font-family: ${fontForThisTrack}, ${DEFAULT_MUSIC_FONT};`;
                    },
                    "notify::track-title"
               ),
     });

const TrackArtists = ({ player, ...rest }) =>
     Label({
          ...rest,
          xalign: 0,
          className: "osd-music-artists",
          setup: (self) =>
               self.hook(
                    player,
                    (self) => {
                         self.label =
                              player.trackArtists.length > 0
                                   ? player.trackArtists.join(", ")
                                   : "";
                    },
                    "notify::track-artists"
               ),
     });

const TrackControls = ({ player, ...rest }) =>
     Widget.Revealer({
          revealChild: false,
          transition: "slide_right",
          transitionDuration: userOptions.animations.durationLarge,
          child: Widget.Box({
               ...rest,
               vpack: "center",
               hpack: "center",
               className: "spacing-h-3",
               children: [
                    Button({
                         onClicked: () => player.previous(),
                         child: Label({
                              className:
                                   "icon-material osd-music-controlbtn-txt",
                              label: "skip_previous",
                         }),
                    }),
                    PlayState({ player: player }),
                    Button({
                         className: "",
                         onClicked: () => player.next(),
                         child: Label({
                              className:
                                   "icon-material osd-music-controlbtn-txt",
                              label: "skip_next",
                         }),
                    }),
               ],
          }),
          setup: (self) =>
               self.hook(
                    Mpris,
                    (self) => {
                         // const player = Mpris.getPlayer();
                         if (!player) self.revealChild = false;
                         else self.revealChild = true;
                    },
                    "notify::play-back-status"
               ),
     });
const PlayState = ({ player }) => {
     var position = 0;
     const trackCircProg = TrackProgress({ player: player });
     return Widget.Button({
          className: "",
          child: Widget.Overlay({
               child: trackCircProg,
               overlays: [
                    Widget.Button({
                         className: "osd-music-playstate-btn",
                         onClicked: () => player.playPause(),
                         child: Widget.Label({
                              justification: "center",
                              hpack: "fill",
                              vpack: "center",
                              setup: (self) =>
                                   self.hook(
                                        player,
                                        (label) => {
                                             label.label = `${
                                                  player.playBackStatus ==
                                                  "Playing"
                                                       ? "pause"
                                                       : "play_arrow"
                                             }`;
                                        },
                                        "notify::play-back-status"
                                   ),
                         }),
                    }),
               ],
               passThrough: true,
          }),
     });
};

export const MusicWidget = () => {
     return Box({
          className: "music-widget dash-widget",
          css: ``,
          setup: (self) =>
               self.hook(Mpris, (self) => {
                    const player = getPlayer();
                    if (player && isRealPlayer(player)) {
                          self.css = `
                                background: linear-gradient(to right, rgba(24,24,24,0.85) 0%, rgba(24,24,24,0.0) 80%), url('${player.coverPath}');
                                background-size: cover;
                                background-position: center;
                                `
                         self.children = [
                              Box({
                                   vertical: true,
                                   children: [
                                        Box({
                                             hpack: 'start',
                                             vertical: true,
                                             hexpand: true,
                                             className: "spacing-v-5",
                                             children: [
                                                  TrackTitle({ player }),
                                                  TrackArtists({ player }),
                                             ],
                                        }),
                                        Box({
                                             hpack: 'end',
                                             className: "spacing-h-15 spacing-v-5 track-control-box",
                                             vertical: true,
                                             children: [
                                                  TrackControls({ player }),
                                             ],
                                        }),
                                   ],
                              }),
                         ];
                    } else {
                         self.children = [
                              Box({
                                   hpack: 'start',
                                   vertical: true,
                                   hexpand: true,
                                   className: "spacing-v-5",
                                   children: [
                                        Label({
                                             xalign: 0,
                                             className: 'txt txt-large',
                                             label: "Nothing playing"
                                        }),
                                        Label({
                                             xalign: 0,
                                             className: 'osd-music-artists',
                                             label: "Nobody"
                                        }),
                                        Box({
                                             hpack: 'end',
                                             className: "spacing-h-15 spacing-v-5 track-control-box",
                                             vertical: true,
                                             children: [
                                                  TrackControls({ player }),
                                             ],
                                        }),
                                   ],
                              }),
                         ];
                         self.css = `background: ''`
                    }
               }),
     })
}
