import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Label } = Widget;
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
const { exec } = Utils;

export const userWidget = () => {

    const userName = `${exec('whoami')}`;
    const userNameCapitalized = userName.charAt(0).toUpperCase() + userName.slice(1);

    const avatar = Widget.Box({
        className: 'avatar-widget',
        css: `
            background-image: url('file:///var/lib/AccountsService/icons/${userName}');
            background-size: cover;
            background-position: center;
        `,
    });

    return Widget.Box({
        vexpand: true,
        vertical: true,
        className: 'user-widget dash-widget spacing-v-5',
        children: [
            Widget.Box({
                hexpand: false,
                hpack: 'center',
                child: avatar,
            }),
            Widget.Label({
                className: 'txt txt-title',
                hpack: 'center',
                label: "Welcome back, " + userNameCapitalized,
            }), 
            Widget.Label({
                className: 'txt txt-medium',
                hpack: 'center',
                label: "Today is a good day to have a good day.",
            }),
        ],
    });
};