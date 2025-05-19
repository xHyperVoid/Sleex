// This file is for brightness/volume indicators
// noinspection JSFileReferences
import Widget from "resource:///com/github/Aylur/ags/widget.js";
const { Box, Revealer } = Widget;
import Brightness from "../../services/brightness.js";
import Indicator from "../../services/indicator.js";
import { OsdValue } from "./indicatorvalues.js";
import { RoundedCorner } from "../.commonwidgets/cairo_roundedcorner.js";

const BrightnessOsd = (monitor = 0) => {
     const brightnessIndicator = OsdValue({
          name: "Brightness",
          icon: "light_mode",
          extraClassName: "osd-brightness",
          extraProgressClassName: "osd-brightness-progress",
          labelSetup: (self) =>
               self.hook(
                    Brightness[monitor],
                    (self) => {
                         self.label = `${Math.round(
                              Brightness[monitor].screen_value * 100
                         )}`;
                    },
                    "notify::screen-value"
               ),
          progressSetup: (self) =>
               self.hook(
                    Brightness[monitor],
                    (progress) => {
                         const updateValue = Brightness[monitor].screen_value;
                         if (updateValue !== progress.value) Indicator.popup(1);
                         progress.value = updateValue;
                    },
                    "notify::screen-value"
               ),
     });

     return Revealer({
          transition: "slide_down",
          transitionDuration: userOptions.animations.durationLarge,
          revealChild: false,
          setup: (self) =>
               self.hook(
                    Indicator,
                    (revealer, value) => {
                         if (value > -1) self.revealChild = true;
                         else self.revealChild = false;
                    },
                    "popup"
               ),
          child: Box({
               hpack: "center",
               vertical: false,
               className: "spacing-h--10",
               children: [brightnessIndicator, RoundedCorner('topright', { className: 'corner'})],
          }),
     });
};

export default (monitor = 0) => Widget.Window({
     name: `indicatorBrightness${monitor}`,
     monitor,
     className: 'indicator',
     layer: 'overlay',
     visible: true,
     anchor: ['top', 'left'],
     child: Widget.Box({
          vertical: true,
          className: 'osd-window',
          css: 'min-height: 2px;',
          children: [BrightnessOsd(monitor)]
     })
});
