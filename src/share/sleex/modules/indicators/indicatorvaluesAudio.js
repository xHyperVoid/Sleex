// This file is for brightness/volume indicators
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
const { Box, Revealer } = Widget;
import Indicator from "../../services/indicator.js";
import { OsdValue } from "./indicatorvalues.js";
import { RoundedCorner } from "../.commonwidgets/cairo_roundedcorner.js";

const audioOsd = () => {
     const volumeIndicator = OsdValue({
          name: "Volume",
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

     return Revealer({
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
               children: [RoundedCorner('topleft', { className: 'corner'}), volumeIndicator],
          }),
     });
};


export default (monitor = 0) => 
     Widget.Window({
     name: `indicatorAudio${monitor}`,
     monitor,
     className: 'indicator',
     layer: 'overlay',
     visible: true,
     anchor: ['top', 'right'],
     child: Widget.Box({
          vertical: true,
          className: 'osd-window',
          css: 'min-height: 2px;',
          children: [audioOsd()],
     })
});
