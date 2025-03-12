import PopupWindow from '../.widgethacks/popupwindow.js';
import SidebarRight from "./dashboard.js";
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box } = Widget;
import clickCloseRegion from '../.commonwidgets/clickcloseregion.js';

export default () => PopupWindow({
    keymode: 'on-demand',
    name: 'dashboard',
    child: Box({
        children: [
            clickCloseRegion({ name: 'dashboard', multimonitor: false }),
            SidebarRight(),
        ]
    })
});
