import Widget from "resource:///com/github/Aylur/ags/widget.js";
const { Box, Label, ProgressBar } = Widget;
import { MaterialIcon } from "../.commonwidgets/materialicon.js";

export const OsdValue = ({
     name,
     icon,
     nameSetup = undefined,
     labelSetup,
     progressSetup,
     extraClassName = "",
     extraProgressClassName = "",
     ...rest
}) => {
     const valueName = Label({
          xalign: 0,
          yalign: 0,
          hexpand: true,
          className: "osd-label",
          label: `${name}`,
          setup: nameSetup,
     });
     const valueNumber = Label({
          hexpand: false,
          className: "osd-value-txt",
          setup: labelSetup,
     });
     return Box({
          // Volume
          hexpand: true,
          className: `osd-bg osd-value ${extraClassName} spacing-h-5`,
          attribute: {
               disable: () => {
                    valueNumber.label = "󰖭";
               },
          },
          children: [
               MaterialIcon(icon, "hugeass", { vpack: "center" }),
               Box({
                    vertical: true,
                    className: "spacing-v-5",
                    vpack: "center",
                    children: [
                         Box({
                              children: [valueName, valueNumber],
                         }),
                         ProgressBar({
                              className: `osd-progress ${extraProgressClassName}`,
                              hexpand: true,
                              vertical: false,
                              setup: progressSetup,
                         }),
                    ],
               }),
          ],
          ...rest,
     });
};