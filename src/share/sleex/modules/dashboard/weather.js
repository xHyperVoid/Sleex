// This is for the right pills of the bar.
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import App from "resource:///com/github/Aylur/ags/app.js";
const { Box, Label } = Widget;
const { GLib } = imports.gi;

const WEATHER_CACHE_FOLDER = `${GLib.get_user_cache_dir()}/ags/weather`;
Utils.exec(`mkdir -p ${WEATHER_CACHE_FOLDER}`);

const weatherIcons = {
    clear: { day: "weather-clear-sky.svg", night: "weather-clear-night.svg" },
    partlyCloudy: { day: "weather-few-clouds.svg", night: "weather-few-clouds-night.svg" },
    cloudy: "weather-clouds.svg",
    overcast: "weather-overcast.svg",
    mist: "weather-fog.svg",
    rain: { day: "weather-showers.svg", night: "weather-showers-scattered.svg" },
    heavyRain: "weather-snow-rain.svg",
    storm: "weather-storm.svg",
    snow: "weather-snow.svg",
    lightSnow: "weather-snow-scattered.svg",
    windy: "weather-windy.svg"
};

const weatherCodeMap = {
    113: "clear",
    116: "partlyCloudy",
    119: "cloudy",
    122: "overcast",
    143: "mist",
    176: "rain",
    200: "storm",
    248: "mist",
    260: "mist",
    266: "rain",
    302: "heavyRain",
    308: "heavyRain",
    338: "snow",
    368: "lightSnow",
    371: "snow",
    389: "storm",
    395: "snow"
};

const iconPath = (icon) => `${App.configDir}/assets/icons/weather/` + icon;


export const WeatherWidget = () =>
    Box({
        className: "weather-widget",
        children: [
            Box({
                className: "weather-image-box",
            }),
            Box({
                vertical: true,
                vpack: "center",
                children: [
                    Label({ label: "Loading...", className: "txt txt-title", xalign: 0 }),
                    Label({ label: "Loading...", className: "txt txt-large", xalign: 0 }),
                ],
            }),
        ],
        setup: (self) =>
            self.poll(900000, async (self) => {
                const WEATHER_CACHE_PATH = WEATHER_CACHE_FOLDER + "/wttr.in.txt";
                try {
                    // Read from cache
                    const weather = JSON.parse(Utils.readFile(WEATHER_CACHE_PATH));
                    const weatherCode = weather.current_condition[0].weatherCode;
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
                    const weatherType = weatherCodeMap[weatherCode] || 'clear';
                    const isNight = new Date().getHours() > 18 || new Date().getHours() < 6;
                    const icon = typeof weatherIcons[weatherType] === 'object' 
                        ? weatherIcons[weatherType][isNight ? 'night' : 'day']
                        : weatherIcons[weatherType];
                    const weatherSymbol = iconPath(icon);
                    self.children[0].css = `background-image: url("${weatherSymbol}");`;
                    self.children[1].children[0].label = `${temperature}°${userOptions.weather.preferredUnit}`;
                    self.children[1].children[1].label = weatherDesc;
                    self.tooltipText = `Feels like ${feelsLike}°${userOptions.weather.preferredUnit}`;
                } catch (err) {
                    print(err);
                    self.children[0].label = "none";
                    self.children[1].children[0].label = "N/A";
                    self.children[1].children[1].label = "Weather unavailable";
                }
            }),
    });
