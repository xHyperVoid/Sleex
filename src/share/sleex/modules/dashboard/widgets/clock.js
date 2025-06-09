import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { GLib } = imports.gi;

export const clockWidget = () => {

    const time = Variable("", {
    poll: [
        userOptions.time.interval,
        () => GLib.DateTime.new_now_local().format(userOptions.time.format),
    ],
    });

    const rawDate = new Date();
    const date = Variable("", {
    poll: [
        userOptions.time.dateInterval,
        () => rawDate.toLocaleDateString([], { weekday: 'long', month: 'long', day: 'numeric' }),
    ],
    });

    return Widget.Box({
        vertical: true,
        className: 'clock-widget dash-widget spacing-v-5',
        children: [
            Widget.Label({
                className: 'txt txt-clock',
                hpack: 'center',
                label: time.bind(),
            }), 
            Widget.Label({
                className: 'txt txt-medium',
                hpack: 'center',
                label: date.bind(),
            }),
        ],
    });
};