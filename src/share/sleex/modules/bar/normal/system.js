// This is for the right pills of the bar.
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
const { execAsync } = Utils;
const { GLib } = imports.gi;
import { RoundedCorner } from "../../.commonwidgets/cairo_roundedcorner.js";

const time = Variable("", {
  poll: [
    userOptions.time.interval,
    () => GLib.DateTime.new_now_local().format(userOptions.time.format),
  ],
});

const date = Variable("", {
  poll: [
    userOptions.time.dateInterval,
    () => GLib.DateTime.new_now_local().format(userOptions.time.dateFormatLong),
  ],
});

const showTimeDate = () => {
    const TIMEDATE_FILE_LOCATION = `${GLib.get_user_state_dir()}/ags/user/show_timedate.txt`;
    const actual_show_timedate = Utils.exec(`bash -c "cat ${TIMEDATE_FILE_LOCATION}"`);
    actual_show_timedate == null ? actual_show_timedate = userOptions.appearance.showTimeDate : actual_show_timedate;
    return actual_show_timedate == 'true' ? true : false;
}
const BarClock = () => {
  if (!showTimeDate()) return null;
  else return Widget.Box({
    vpack: "center",
    className: "spacing-h-4 bar-clock-box",
    children: [
      Widget.Label({
        className: "bar-time",
        label: time.bind(),
      }),
      Widget.Label({
        className: "txt-norm txt-onLayer1",
        label: "•",
      }),
      Widget.Label({
        className: "txt-smallie bar-date",
        label: date.bind(),
      }),
    ],
  });
};

const BarGroup = ({ child }) =>
  Widget.Box({
    className: "bar-group-margin bar-sides",
    children: [
      Widget.Box({
        className: "bar-group bar-group-standalone bar-group-pad-system bar-group-right",
        children: [child],
      }),
    ],
  });

const switchToRelativeWorkspace = async (self, num) => {
  try {
    const Hyprland = (
      await import("resource:///com/github/Aylur/ags/service/hyprland.js")
    ).default;
    Hyprland.messageAsync(
      `dispatch workspace ${num > 0 ? "+" : ""}${num}`
    ).catch(print);
  } catch {
    execAsync([
      `${App.configDir}/scripts/sway/swayToRelativeWs.sh`,
      `${num}`,
    ]).catch(print);
  }
};

export default () =>
  !showTimeDate() ? Widget.Box({}) : Widget.EventBox({
    onScrollUp: (self) => switchToRelativeWorkspace(self, -1),
    onScrollDown: (self) => switchToRelativeWorkspace(self, +1),
    onPrimaryClick: () => App.toggleWindow("dashboard"),
    child: Widget.Box({
      children: [
        BarCornerBottomright(),
        BarGroup({ child: BarClock() }),
        BarCornerTopright(),
      ],
    }),
  });

const BarCornerBottomright = () => Widget.Box({
    child: RoundedCorner('bottomright', { className: 'corner', }),
});
const BarCornerTopright = () => Widget.Box({
    child: RoundedCorner('topright', { className: 'corner', }),
});