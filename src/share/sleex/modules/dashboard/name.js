import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import { setupCursorHover } from '../.widgetutils/cursorhover.js';
const { execAsync } = Utils;
const { Box, Button, Icon, Label } = Widget;

export default () => Box({
    className: 'name techfont',
    children: [
        Label({
            label: 'Sleex'
        }),
        Box({ hexpand: true }),
        Button({
            className: 'sidebar-module-btn-arrow',
            onClicked: () => execAsync(['xdg-open', 'https://github.com/axos-project/sleex']).catch(print),
            child: Icon({
                className: 'txt txt-norm',
                icon: 'github-symbolic',
            }),
            setup: setupCursorHover,
        })
    ]
})
