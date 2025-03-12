// This is for the right pills of the bar.
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
const { execAsync } = Utils;
const { GLib } = imports.gi;

const WEATHER_CACHE_FOLDER = `${GLib.get_user_cache_dir()}/ags/weather`;
Utils.exec(`mkdir -p ${WEATHER_CACHE_FOLDER}`);

Utils.interval(900000, async () => {
    const WEATHER_CACHE_PATH = WEATHER_CACHE_FOLDER + "/wttr.in.txt";
    const updateWeatherForCity = (city) =>
        execAsync(`curl https://wttr.in/${city.replace(/ /g, "%20")}?format=j1`)
            .then((output) => {
                const weather = JSON.parse(output);
                Utils.writeFile(JSON.stringify(weather),WEATHER_CACHE_PATH).catch(print);
            }).catch(print);

    if (userOptions.weather.city != "" && userOptions.weather.city != null) {
        updateWeatherForCity(userOptions.weather.city.replace(/ /g, "%20"));
    } else {
        Utils.execAsync("curl ipinfo.io")
            .then((output) => {
            return JSON.parse(output)["city"].toLowerCase();
        })
        .then(updateWeatherForCity)
        .catch(print);
    }
});