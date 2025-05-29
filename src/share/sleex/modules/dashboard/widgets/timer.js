import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Label } = Widget;

export const timerWidget = () => {
    return Box({
        className: 'dash-widget timer-widget',
        vexpand: true,
        vertical: true,
        children: [
            Label({
                className: 'txt txt-small timer-title-label',
                label: "You've focused for"
            }),
            Label({
                className: 'txt txt-large txt-clock',
                label: '3h 45m'
            }),
            Label({
                className: 'txt txt-small timer-title-label',
                label: "today"
            })
        ]
    })
}