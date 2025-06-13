import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Window } = Widget;
import clickCloseRegion from '../.commonwidgets/clickcloseregion.js';
import applauncher from './applauncher.js';


export default () => Window({
    keymode: 'on-demand',
    anchor: ['left', 'top', 'bottom'],
    name: 'applauncher',
    layer: 'top',
    visible: false,
    child: Box({
        children: [
            applauncher(),
            clickCloseRegion({ name: 'applauncher', multimonitor: false, fillMonitor: 'horizontal' }),
        ]
    })
});