import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
const { execAsync, exec } = Utils;
const { Box, EventBox } = Widget;
import {
    ToggleIconBluetooth,
    ToggleIconWifi,
    ModuleNightLight,
    ModuleIdleInhibitor,
    ModuleReloadIcon,
    ModulePowerIcon,
} from "./widgets/quicktoggles.js";
import { getDistroIcon } from '../.miscutils/system.js';
import { TabContainer } from '../.commonwidgets/tabcontainer.js';
import home from './tabs/home.js'
import settings from './tabs/settings.js'
import todo from './tabs/todo.js'

const TABS = {
    'home': {
        name: 'home',
        content: home(),
        materialIcon: 'rocket_launch',
        friendlyName: 'Home',
    },
    'settings': {
        name: 'settings',
        content: settings(),
        materialIcon: 'settings',
        friendlyName: 'Settings',
    },
    'todo': {
        name: 'todo',
        content: todo(),
        materialIcon: 'checklist',
        friendlyName: 'Todo',
    },
    'calendar': {
        name: 'calendar',
        content: Widget.Box({}),
        materialIcon: 'event',
        friendlyName: 'Calendar',
    },
}

const CONTENTS = userOptions.dashboard.pages.order.map((tabName) => TABS[tabName])


const togglesBox = Widget.Box({
    hpack: 'center',
    className: 'sidebar-togglesbox spacing-h-5',
    children: [
        ToggleIconWifi(),
        ToggleIconBluetooth(),
        await ModuleNightLight(),
        ModuleIdleInhibitor(),
    ]
})

const timeRow = Box({
    className: 'spacing-h-10 sidebar-group-invisible-morehorizpad',
    children: [
        Widget.Icon({
            icon: getDistroIcon(),
            className: 'txt txt-larger',
        }),
        Widget.Label({
            hpack: 'center',
            className: 'txt-small txt',
            setup: (self) => {
            	const getUptime = async () => {
                	try {
                    	await execAsync(['bash', '-c', 'uptime -p']);
                        return execAsync(['bash', '-c', `uptime -p | sed -e 's/...//;s/ day\\| days/d/;s/ hour\\| hours/h/;s/ minute\\| minutes/m/;s/,[^,]*//2'`]);
                    } catch {
                        return execAsync(['bash', '-c', 'uptime']).then(output => {
                        	const uptimeRegex = /up\s+((\d+)\s+days?,\s+)?((\d+):(\d+)),/;
                        	const matches = uptimeRegex.exec(output);

                            if (matches) {
                            	const days = matches[2] ? parseInt(matches[2]) : 0;
                                const hours = matches[4] ? parseInt(matches[4]) : 0;
                                const minutes = matches[5] ? parseInt(matches[5]) : 0;

                                let formattedUptime = '';

                                if (days > 0) {
                                	formattedUptime += `${days} d `;
                                }
                                if (hours > 0) {
                                	formattedUptime += `${hours} h `;
                                }
                                formattedUptime += `${minutes} m`;

                                return formattedUptime;
                            } else {
                            	throw new Error('Failed to parse uptime output');
                            }
                        });
                    }
                };

                self.poll(5000, label => {
                	getUptime().then(upTimeString => {
                    	label.label = `Uptime: ${upTimeString}`;
                    }).catch(err => {
                    	console.error(`Failed to fetch uptime: ${err}`);
                    });
                });
            },
        }),
        Widget.Box({ hexpand: true }), 
        togglesBox,
        ModuleReloadIcon({ hpack: 'end' }),
        // ModuleSettingsIcon({ hpack: 'end' }), // Button does work, gnome-control-center is kinda broken
        ModulePowerIcon({ hpack: 'end' }),
    ]
});


const widgetContentDash = TabContainer({
    icons: CONTENTS.map((item) => item.materialIcon),
    names: CONTENTS.map((item) => item.friendlyName),
    children: CONTENTS.map((item) => item.content),
    className: 'spacing-v-10',
});


export default () => Box({
    vexpand: true,
    hexpand: true,
    children: [
        EventBox({
            onPrimaryClick: () => App.closeWindow('dashboard'),
            onSecondaryClick: () => App.closeWindow('dashboard'),
            onMiddleClick: () => App.closeWindow('dashboard'),
        }),
        Box({
            vertical: true,
            vexpand: true,
            hexpand: true,
            className: 'dashboard spacing-v-15',
            children: [
                // Top row
                Box({
                    vertical: true,
                    className: 'spacing-v-5',
                    children: [
                        timeRow,
                    ]
                }),
                widgetContentDash
            ]
        }),
    ]
});
