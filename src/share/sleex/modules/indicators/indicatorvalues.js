import Widget from "resource:///com/github/Aylur/ags/widget.js";
const { Box, Label, ProgressBar, Revealer } = Widget;
import { MaterialIcon } from "../.commonwidgets/materialicon.js";
import Brightness from "../../services/brightness.js";
import Indicator from "../../services/indicator.js";
import { RoundedCorner } from "../.commonwidgets/cairo_roundedcorner.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";

export const OsdValue = ({
     icon,
     nameSetup = undefined,
     labelSetup,
     progressSetup,
     extraClassName = "",
     extraProgressClassName = "",
     ...rest
}) => {
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
                         ProgressBar({
                              className: `osd-progress ${extraProgressClassName}`,
                              hexpand: true,
                              vertical: false,
                              setup: progressSetup,
                         }),
                    ],
               }),
               Box({
                    children: [valueNumber],
               }),

          ],
          ...rest,
     });
};

const BrightnessOsd = (monitor = 0) => {
     const brightnessIndicator = OsdValue({
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

     return brightnessIndicator;
};

const audioOsd = () => {
     const volumeIndicator = OsdValue({
          icon: "volume_up",
          extraClassName: "osd-volume",
          extraProgressClassName: "osd-volume-progress",
          attribute: { headphones: undefined, device: undefined },
          nameSetup: (self) =>
               Utils.timeout(1, () => {
                    const updateAudioDevice = (self) => {
                         const usingHeadphones = Audio.speaker?.stream?.port
                              ?.toLowerCase()
                              .includes("headphone");
                         if (
                              volumeIndicator.attribute.headphones ===
                                   undefined ||
                              volumeIndicator.attribute.headphones !==
                                   usingHeadphones
                         ) {
                              volumeIndicator.attribute.headphones =
                                   usingHeadphones;
                              self.label = usingHeadphones
                                   ? "Headphones"
                                   : "Speakers";
                              // Indicator.popup(1);
                         }
                    };
                    self.hook(Audio, updateAudioDevice);
                    Utils.timeout(1000, updateAudioDevice);
               }),
          labelSetup: (self) =>
               self.hook(Audio, (label) => {
                    const newDevice = Audio.speaker?.name;
                    const updateValue = Math.round(Audio.speaker?.volume * 100);
                    if (!isNaN(updateValue)) {
                         if (
                              newDevice === volumeIndicator.attribute.device &&
                              updateValue != label.label
                         ) {
                              Indicator.popup(1);
                         }
                    }
                    volumeIndicator.attribute.device = newDevice;
                    label.label = `${updateValue}`;
               }),
          progressSetup: (self) =>
               self.hook(Audio, (progress) => {
                    const updateValue = Audio.speaker?.volume;
                    if (!isNaN(updateValue)) {
                         if (updateValue > 1) progress.value = 1;
                         else progress.value = updateValue;
                    }
               }),
     });

     return volumeIndicator;
};


export default (monitor = 0) => Widget.Window({
     name: `indicatorOsd${monitor}`,
     monitor,
     className: 'indicator',
     exclusivity: "ignore",
     layer: 'overlay',
     visible: true,
     anchor: ['top', 'left'],
     child: Widget.Box({
          vertical: true,
          className: 'osd-window',
          css: 'min-height: 2px;',
          child: Revealer({
               transition: "slide_down",
               transitionDuration: userOptions.animations.durationLarge,
               revealChild: false,
               setup: (self) =>
                    self.hook(Indicator, (revealer, value) => {
                              if (value > -1) self.revealChild = true;
                              else self.revealChild = false;
                         },
                         'popup',
                    ),
               child: Box({
                    hpack: "center",
                    vertical: false,
                    className: "spacing-h--10",
                    children: [
                         Box({
                              vertical: true,
                              children: [
                                   BrightnessOsd(monitor),
                                   audioOsd(),
                              ],
                         }),
                         RoundedCorner('topright', { className: 'corner'}),
                    ],
               }),
          }),
     })
});
