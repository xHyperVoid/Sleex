import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const clockWidget = () => {

    const date = new Date();
    const time = date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    return Widget.Box({
        vertical: true,
        className: 'clock-widget dash-widget spacing-v-5',
        children: [
            Widget.Label({
                className: 'txt txt-clock',
                hpack: 'center',
                label: time,
            }), 
            Widget.Label({
                className: 'txt txt-medium',
                hpack: 'center',
                label: date.toLocaleDateString([], { weekday: 'long', month: 'long', day: 'numeric' }),
            }),
        ],
    });
};