import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Indicator from "../../services/indicator.js";
import ColorScheme from "./colorscheme.js";
import NotificationPopups from "./notificationpopups.js";

export default (monitor = 0) =>
     Widget.Window({
          name: `indicator${monitor}`,
          monitor,
          className: "indicator",
          layer: "overlay",
          visible: true,
          anchor: ["top"],
          child: Widget.EventBox({
               onHover: () => {
                    Indicator.popup(-1);
               },
               child: Widget.Box({
                    vertical: true,
                    className: "osd-window",
                    css: "min-height: 2px;",
                    children: [NotificationPopups(), ColorScheme()],
               }),
          }),
     });