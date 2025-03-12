const { GLib } = imports.gi;
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
const { exec, execAsync } = Utils;
const { Box, Label, Button, Revealer } = Widget;

import { AnimatedCircProg } from "../.commonwidgets/cairo_circularprogress.js";
import { hasPlasmaIntegration } from '../.miscutils/system.js';

var lastCoverPath = '';

function isRealPlayer(player) {
    return (
        // Remove unecessary native buses from browsers if there's plasma integration
        !(hasPlasmaIntegration && player.busName.startsWith('org.mpris.MediaPlayer2.firefox')) &&
        //!(hasPlasmaIntegration && player.busName.startsWith('org.mpris.MediaPlayer2.chromium')) &&
        // playerctld just copies other buses and we don't need duplicates
        !player.busName.startsWith('org.mpris.MediaPlayer2.playerctld') &&
        // Non-instance mpd bus
        !(player.busName.endsWith('.mpd') && !player.busName.endsWith('MediaPlayer2.mpd'))
    );
}

export const getPlayer = (name = userOptions.music.preferredPlayer) => Mpris.getPlayer(name) || Mpris.players[0] || null;
function lengthStr(length) {
    const min = Math.floor(length / 60);
    const sec = Math.floor(length % 60);
    const sec0 = sec < 10 ? '0' : '';
    return `${min}:${sec0}${sec}`;
}


const DEFAULT_MUSIC_FONT = 'Gabarito, sans-serif';
function getTrackfont(player) {
    const title = player.trackTitle;
    const artists = player.trackArtists.join(' ');
    if (artists.includes('TANO*C') || artists.includes('USAO') || artists.includes('Kobaryo'))
        return 'Chakra Petch'; // Rigid square replacement
    if (title.includes('東方'))
        return 'Crimson Text, serif'; // Serif for Touhou stuff
    return DEFAULT_MUSIC_FONT;
}
function trimTrackTitle(title) {
    if (!title) return '';
    const cleanPatterns = [
        /【[^】]*】/,         // Touhou n weeb stuff
        " [FREE DOWNLOAD]", // F-777
    ];
    cleanPatterns.forEach((expr) => title = title.replace(expr, ''));
    return title;
}

const TrackProgress = ({ player, ...rest }) => {
    const _updateProgress = (circprog) => {
        // const player = Mpris.getPlayer();
        if (!player) return;
        // Set circular progress (see definition of AnimatedCircProg for explanation)
        circprog.css = `font-size: ${Math.max(player.position / player.length * 100, 0)}px;`
    }
    return AnimatedCircProg({
        ...rest,
        className: 'osd-music-circprog',
        vpack: 'center',
        extraSetup: (self) => self
            .hook(Mpris, _updateProgress)
            .poll(3000, _updateProgress)
        ,
    })
}

const TrackTitle = ({ player, ...rest }) => Label({
    ...rest,
    label: 'No music playing',
    wrap: true,
    className: 'osd-music-title',
    setup: (self) => self.hook(player, (self) => {
        // Player name
        self.label = player.trackTitle.length > 0 ? trimTrackTitle(player.trackTitle) : 'No media';
        // Font based on track/artist
        const fontForThisTrack = getTrackfont(player);
        self.css = `font-family: ${fontForThisTrack}, ${DEFAULT_MUSIC_FONT};`;
    }, 'notify::track-title'),
});

const TrackArtists = ({ player, ...rest }) => Label({
    ...rest,
    className: 'osd-music-artists',
    setup: (self) => self.hook(player, (self) => {
        self.label = player.trackArtists.length > 0 ? player.trackArtists.join(', ') : '';
    }, 'notify::track-artists'),
})

const CoverArt = ({ player, ...rest }) => {
    const fallbackCoverArt = Box({
        className: 'osd-music-cover-fallback',
        homogeneous: true,
        children: [Label({
            className: 'icon-material txt-gigantic txt-thin',
            label: 'music_note',
        })]
    });
    const realCoverArt = Box({
        className: 'osd-music-cover-art',
        homogeneous: true,
        attribute: {
            'pixbuf': null,
            'updateCover': (self) => {
                if (!player || player.trackTitle == "" || !player.coverPath) {
                    self.css = `background-image: none;`;
                    return;
                }

                const coverPath = player.coverPath;
                if (player.coverPath == lastCoverPath) {
                    Utils.timeout(200, () => {
                        self.css = `background-image: url('${coverPath}');`;
                    });
                }
                lastCoverPath = player.coverPath;

                self.css = `background-image: url('${coverPath}');`;
            },
        },
        setup: (self) => self
            .hook(player, (self) => {
                self.attribute.updateCover(self);
            }, 'notify::cover-path')
        ,
    });
    return Box({
        ...rest,
        className: 'osd-music-cover-dash',
        hpack: 'center',
        children: [
            Widget.Overlay({
                child: fallbackCoverArt,
                overlays: [realCoverArt],
            })
        ],
    })
}

const BlankCoverArt = ({ ...rest }) => {
    const fallbackCoverArt = Box({
        className: 'osd-music-cover-fallback',
        homogeneous: true,
        children: [Label({
            className: 'icon-material txt-gigantic txt-thin',
            label: 'music_note',
        })]
    });
    return Box({
        ...rest,
        className: 'osd-music-cover-dash',
        hpack: 'center',
        children: [
            Box({
                child: fallbackCoverArt,
            })
        ],
    })
}

const TrackControls = ({ player, ...rest }) => Widget.Revealer({
    revealChild: false,
    transition: 'slide_right',
    transitionDuration: userOptions.animations.durationLarge,
    child: Widget.Box({
        ...rest,
        vpack: 'center',
        hpack: 'center',
        className: 'osd-music-controls spacing-h-3',
        children: [
            Button({
                className: 'osd-music-controlbtn',
                onClicked: () => player.previous(),
                child: Label({
                    className: 'icon-material osd-music-controlbtn-txt',
                    label: 'skip_previous',
                })
            }),
            PlayState({ player: player }),
            Button({
                className: 'osd-music-controlbtn',
                onClicked: () => player.next(),
                child: Label({
                    className: 'icon-material osd-music-controlbtn-txt',
                    label: 'skip_next',
                })
            }),
        ],
    }),
    setup: (self) => self.hook(Mpris, (self) => {
        // const player = Mpris.getPlayer();
        if (!player)
            self.revealChild = false;
        else
            self.revealChild = true;
    }, 'notify::play-back-status'),
});

// const TrackTime = ({ player, ...rest }) => {
//     return Widget.Revealer({
//         revealChild: false,
//         transition: 'slide_left',
//         transitionDuration: userOptions.animations.durationLarge,
//         child: Widget.Box({
//             ...rest,
//             vpack: 'center',
//             hpack: 'center',
//             className: 'osd-music-pill spacing-h-5',
//             children: [
//                 Label({
//                     setup: (self) => self.poll(1000, (self) => {
//                         // const player = Mpris.getPlayer();
//                         if (!player) return;
//                         self.label = lengthStr(player.position);
//                     }),
//                 }),
//                 Label({ label: '/' }),
//                 Label({
//                     setup: (self) => self.hook(Mpris, (self) => {
//                         // const player = Mpris.getPlayer();
//                         if (!player) return;
//                         self.label = lengthStr(player.length);
//                     }),
//                 }),
//             ],
//         }),
//         setup: (self) => self.hook(Mpris, (self) => {
//             if (!player) self.revealChild = false;
//             else self.revealChild = true;
//         }),
//     })
// }

const PlayState = ({ player }) => {
    var position = 0;
    const trackCircProg = TrackProgress({ player: player });
    return Widget.Button({
        className: 'osd-music-playstate',
        child: Widget.Overlay({
            child: trackCircProg,
            overlays: [
                Widget.Button({
                    className: 'osd-music-playstate-btn',
                    onClicked: () => player.playPause(),
                    child: Widget.Label({
                        justification: 'center',
                        hpack: 'fill',
                        vpack: 'center',
                        setup: (self) => self.hook(player, (label) => {
                            label.label = `${player.playBackStatus == 'Playing' ? 'pause' : 'play_arrow'}`;
                        }, 'notify::play-back-status'),
                    }),
                }),
            ],
            passThrough: true,
        })
    });
}

const MusicControlsWidget = (player) => Box({
    vertical: true,
    vexpand: true,
    hpack: 'center',
    vpack: 'center',
    className: 'spacing-h-20',
    children: [
        CoverArt({ player: player, vpack: 'center' }),
        Box({
            vertical: true,
            className: 'spacing-v-10 osd-music-info',
            child: Box({
                    vertical: true,
                    hexpand: true,
                    className: 'spacing-v-5',
                    children: [
                        TrackTitle({ player: player }),
                        TrackArtists({ player: player }),
                    ]
            }),
        }),
        Box({
            className: 'spacing-h-15', // increased horizontal spacing
            vertical: true,
            className: 'spacing-v-5', // added vertical spacing
            setup: (box) => {
                box.pack_start(TrackControls({ player: player }), false, false, 0);
                // if(hasPlasmaIntegration || player.busName.startsWith('org.mpris.MediaPlayer2.chromium')) box.pack_end(TrackTime({ player: player }), false, false, 0)
            }
        })
    ]
})

const BlankPlayer = () => Box({
    vertical: true,
    vexpand: true,
    hpack: 'center',
    vpack: 'center',
    className: 'spacing-h-20',
    children: [
        BlankCoverArt({ vpack: 'center' }),
        Box({
            vertical: true,
            className: 'spacing-v-10 osd-music-info',
            child: Box({
                    vertical: true,
                    hexpand: true,
                    className: 'spacing-v-5',
                    children: [
                        Label({ label: 'No music playing', className: 'osd-music-title' }),
                        Label({ label: 'No artist', className: 'osd-music-artists' }),
                    ]
            }),
        }),
    ]
})

export const MusicWidget = () => Box({
    className: 'music-widget',
    child: Box({
        setup: self => self.hook(Mpris, self => {
            const players = Mpris.players;
            if (players.length > 0) {
                self.children = players
                    .filter(isRealPlayer)
                    .map(player => MusicControlsWidget(player));
            } else {
                self.children = [BlankPlayer()];
            }
        }),
    })
});