// This is for the right pills of the bar.
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
const { Box, Label, Button, Stack } = Widget;
const { execAsync } = Utils;
const { GLib } = imports.gi;
import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import { MaterialIcon } from "../../.commonwidgets/materialicon.js";
import { WWO_CODE, WEATHER_SYMBOL } from "../../.commondata/weather.js";
import { RoundedCorner } from "../../.commonwidgets/cairo_roundedcorner.js";

const WEATHER_CACHE_FOLDER = `${GLib.get_user_cache_dir()}/ags/weather`;
Utils.exec(`mkdir -p ${WEATHER_CACHE_FOLDER}`);

const BarGroup = ({ child }) =>
     Widget.Box({
          className: "bar-group-margin bar-sides",
          children: [
               Widget.Box({
                    className:
                         "bar-group bar-group-standalone bar-group-pad-system bar-group-right",
                    children: [child],
               }),
          ],
     });

const WeatherWidget = () =>
     Box({
          hexpand: true,
          hpack: "center",
          className: "spacing-h-4 txt-onSurfaceVariant",
          children: [
               MaterialIcon("device_thermostat", "small"),
               Label({
                    label: "Weather",
               }),
          ],
          setup: (self) =>
               self.poll(900000, async (self) => {
                    const WEATHER_CACHE_PATH =
                         WEATHER_CACHE_FOLDER + "/wttr.in.txt";
                    try {
                         // Read from cache
                         const weather = JSON.parse(
                              Utils.readFile(WEATHER_CACHE_PATH)
                         );
                         const weatherCode =
                              weather.current_condition[0].weatherCode;
                         const weatherDesc =
                              weather.current_condition[0].weatherDesc[0].value;
                         const temperature =
                              weather.current_condition[0][
                                   `temp_${userOptions.weather.preferredUnit}`
                              ];
                         const feelsLike =
                              weather.current_condition[0][
                                   `FeelsLike${userOptions.weather.preferredUnit}`
                              ];
                         const weatherSymbol =
                              WEATHER_SYMBOL[WWO_CODE[weatherCode]];
                         self.children[0].label = weatherSymbol;
                         self.children[1].label = `${temperature}°${userOptions.weather.preferredUnit} • Feels like ${feelsLike}°${userOptions.weather.preferredUnit}`;
                         self.tooltipText = weatherDesc;
                    } catch (err) {
                         print(err);
                    }
                    if (
                         userOptions.weather.city != "" &&
                         userOptions.weather.city != null
                    ) {
                         updateWeatherForCity(
                              userOptions.weather.city.replace(/ /g, "%20")
                         );
                    } else {
                         Utils.execAsync("curl ipinfo.io")
                              .then((output) => {
                                   return JSON.parse(output)[
                                        "city"
                                   ].toLowerCase();
                              })
                              .then(updateWeatherForCity)
                              .catch(print);
                    }
               }),
     });

// Bat or weather
const WeatherModule = () =>
     Stack({
          transition: "slide_up_down",
          transitionDuration: userOptions.animations.durationLarge,
          children: {
               laptop: Box({
                    className: "spacing-h-4",
                    children: [
                         // BarGroup({ child: Utilities() }),
                         BarGroup({ child: WeatherWidget() }),
                    ],
               }),
          },
          setup: (stack) =>
               Utils.timeout(10, () => {
                    if (!Battery.available) stack.shown = "desktop";
                    else stack.shown = "laptop";
               }),
     });

const switchToRelativeWorkspace = async (self, num) => {
     try {
          const Hyprland = (
               await import(
                    "resource:///com/github/Aylur/ags/service/hyprland.js"
               )
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

const ShowWeather = () => {
     const WEATHER_FILE_LOCATION = `${GLib.get_user_state_dir()}/ags/user/show_weather.txt`;
     const actual_show_weather = Utils.exec(`bash -c "cat ${WEATHER_FILE_LOCATION}"`);
     return actual_show_weather == "true" ? true : false;
};

export default () =>
     !ShowWeather()
          ? Widget.Box({})
          : Widget.EventBox({
                 onScrollUp: (self) => switchToRelativeWorkspace(self, -1),
                 onScrollDown: (self) => switchToRelativeWorkspace(self, +1),
                 onPrimaryClick: () => App.toggleWindow("dashboard"),
                 child: Widget.Box({
                      children: [
                           BarCornerBottomright(),
                           WeatherModule(),
                           BarCornerTopright(),
                      ],
                 }),
            });

const BarCornerBottomright = () =>
     Widget.Box({
          child: RoundedCorner("bottomright", { className: "corner" }),
     });
const BarCornerTopright = () =>
     Widget.Box({
          child: RoundedCorner("topright", { className: "corner" }),
     });
