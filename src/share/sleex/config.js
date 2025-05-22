"use strict";
// Import
const { GLib } = imports.gi;
import Gdk from 'gi://Gdk';
import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
const { execAsync } = Utils;
// Stuff
import userOptions from './modules/.configuration/user_options.js'; // Not unused, careful
import { firstRunWelcome, startBatteryWarningService } from './services/messages.js';
import { startAutoDarkModeService } from './services/darkmode.js';
import './services/weather.js'; // service that updates weather every 15 minutes
// Widgets
import { Bar } from './modules/bar/main.js';
import Cheatsheet from './modules/cheatsheet/main.js';
import DesktopBackground from './modules/desktopbackground/main.js';
import Indicator from './modules/indicators/main.js';
import Overview from './modules/overview/main.js';
import Session from './modules/session/main.js';
import SideLeft from './modules/sideleft/main.js';
import Dashboard from './modules/dashboard/main.js';
import { COMPILED_STYLE_DIR } from './init.js';
import Wallselect from './modules/wallselect/main.js';
import indicatorvalues from './modules/indicators/indicatorvalues.js';

const range = (length, start = 1) => Array.from({ length }, (_, i) => i + start);
function forMonitors(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
    return range(n, 0).map(widget).flat(1);
}
function forMonitorsAsync(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
    return range(n, 0).forEach((n) => widget(n).catch(print))
}

const FirstRunScript = () => {
    if (!GLib.file_test(`${GLib.get_user_state_dir()}/ags/user/firstrun.txt`, GLib.FileTest.EXISTS)) {
        const firstRunScript = `${App.configDir}/scripts/firstRun.sh`;
        if (GLib.file_test(firstRunScript, GLib.FileTest.EXISTS)) {
            execAsync([firstRunScript]).catch(print);
        }
    }
}

// Start stuff
FirstRunScript();
handleStyles(true);
startAutoDarkModeService().catch(print);
firstRunWelcome().catch(print);

startBatteryWarningService().catch(print);

const Windows = () => [
    forMonitors(DesktopBackground), 
    Overview(),
    forMonitors(Indicator),
    forMonitors(Cheatsheet),
    SideLeft(),
    Dashboard(),
    forMonitors(Session),
    Wallselect(),
    forMonitors(indicatorvalues),

];

const CLOSE_ANIM_TIME = 210; // Longer than actual anim time to make sure widgets animate fully
const closeWindowDelays = {}; // For animations
for (let i = 0; i < (Gdk.Display.get_default()?.get_n_monitors() || 1); i++) {
}

App.config({
    css: `${COMPILED_STYLE_DIR}/style.css`,
    stackTraceOnError: true,
    closeWindowDelay: closeWindowDelays,
    windows: Windows().flat(1),
});

// Stuff that don't need to be toggled. And they're async so ugh...
forMonitorsAsync(Bar);
// Bar().catch(print); // Use this to debug the bar. Single monitor only.