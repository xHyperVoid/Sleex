const { GLib } = imports.gi;
import Widget from "resource:///com/github/Aylur/ags/widget.js";
const { Box, Label, Overlay } = Widget;
import { AnimatedCircProg } from "../.commonwidgets/cairo_circularprogress.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
const { exec } = Utils;

const TimeAndDate = () =>
  Box({
    vertical: true,
    hpack: "center",
    className: "spacing-v-5",
    children: [
      Label({
        className: "bg-time-clock",
        label: GLib.DateTime.new_now_local().format(userOptions.time.format),
        setup: (self) =>
          self.poll(userOptions.time.interval, (label) => {
            label.label = GLib.DateTime.new_now_local().format(
              userOptions.time.format
            );
          }),
      }),
      Label({
        className: "bg-time-date",
        hpack: "center",
        label: GLib.DateTime.new_now_local().format(
          userOptions.time.dateFormatLong
        ),
        setup: (self) =>
          self.poll(userOptions.time.dateInterval, (label) => {
            label.label = GLib.DateTime.new_now_local().format(
              userOptions.time.dateFormatLong
            );
          }),
      }),
    ],
  });

const analogClock = () => {
  const HourProgress = () => {
    const _updateProgress = (circprog) => {
      // Set circular progress value
      const hour = (exec("date '+%I'") / 12) * 100;
      circprog.css = `font-size: ${hour}px;`;
    };
    return AnimatedCircProg({
      className: "hours-circprog",
      vpack: "center",
      hpack: "center",
      extraSetup: (self) => self.poll(1000, _updateProgress),
    });
  };
  const MinuteProgress = () => {
    const _updateProgress = (circprog) => {
      // Set circular progress value
      const minute = (exec("date '+%M'") / 60) * 100;
      circprog.css = `font-size: ${minute}px;`;
    };
    return AnimatedCircProg({
      className: "minutes-circprog",
      vpack: "center",
      hpack: "center",
      extraSetup: (self) => self.poll(1000, _updateProgress),
    });
  };
  return Overlay({
    child: Box({
      vpack: "center",
      hpack: "center",
      child: HourProgress(),
    }),
    overlays: [MinuteProgress()],
  });
};

// const showAnalog = () => {
//   const ANALOGCLOCK_FILE_LOCATION = `${GLib.get_user_state_dir()}/ags/user/show_analogclock.txt`;
//   const show_analogclock = Utils.readFile(ANALOGCLOCK_FILE_LOCATION);
//   show_analogclock == null ? show_analogclock = userOptions.appearance.showAnalogClock : show_analogclock;
//   return show_analogclock == 'true' ? true : false;
// }

export default () => {
  // if (showAnalog()) return Box({
  //   hpack: "center",
  //   vpack: "center",
  //   vertical: true,
  //   className: "bg-time-box",
  //   children: [
  //     analogClock(),
  //   ],
  // });
  return Box({
    hpack: "center",
    vpack: "center",
    vertical: true,
    className: "bg-time-box",
    children: [
      TimeAndDate(),
    ],
  });
};