const { GLib } = imports.gi;
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
const { exec } = Utils;
import WindowTitle from "./normal/spaceleft.js";
import Indicators from "./normal/spaceright.js";
import Monitor from "./normal/monitor.js";
import System from "./normal/system.js";
import { currentShellMode } from '../../variables.js';
import { RoundedCorner } from "../.commonwidgets/cairo_roundedcorner.js";

const ShowWorkspaces = () => {
    const WORKSPACE_FILE_LOCATION = `${GLib.get_user_state_dir()}/ags/user/show_workspaces.txt`;
    const actual_show_workspaces = exec(`bash -c "cat ${WORKSPACE_FILE_LOCATION}"`);
    actual_show_workspaces == null ? actual_show_workspaces = userOptions.appearance.showWorkspace : actual_show_workspaces;
    return actual_show_workspaces == 'true' ? true : false;
}


const NormalOptionalWorkspaces = async () => {
    try {
        if (!ShowWorkspaces()) return null;
        return (await import('./normal/workspaces_hyprland.js')).default();
    } catch {
        try {
            if (!ShowWorkspaces()) return null;
            return (await import('./normal/workspaces_sway.js')).default();
        } catch {
            return null;
        }
    }
};

const FocusOptionalWorkspaces = async () => {
    try {
        return (await import('./focus/workspaces_hyprland.js')).default();
    } catch {
        try {
            return (await import('./focus/workspaces_sway.js')).default();
        } catch {
            return null;
        }
    }
};

export const Bar = async (monitor = 0) => {
    
    const normalBarContent = Widget.CenterBox({
        className: 'bar-normal',
        startWidget: (await WindowTitle(monitor)),
        centerWidget: Widget.Box({
            children: [
                BarCornerTopleft(),
                    Widget.Box({
                        className: 'bar-center', // Center bar
                        children: [
                        Monitor(),
                        BarCornerTopleftWs(),
                        await NormalOptionalWorkspaces(),
                        BarCornerToprightWs(),
                        System(),
                    ],
                }),
                BarCornerTopright(),
            ]
        }),
        endWidget: Indicators(monitor),
    });
    const focusedBarContent = Widget.CenterBox({
        className: 'bar-bg-focus',
        startWidget: Widget.Box({}),
        centerWidget: Widget.Box({
            className: 'spacing-h-4',
            children: [
                Widget.Box({
                    homogeneous: true,
                    children: [await FocusOptionalWorkspaces()],
                }),
            ]
        }),
        endWidget: Widget.Box({}),
        setup: (self) => {
            self.hook(Battery, (self) => {
                if (!Battery.available) return;
                self.toggleClassName('bar-bg-focus-batterylow', Battery.percent <= userOptions.battery.low);
            })
        }
    });
    const nothingContent = Widget.Box({
        className: 'bar-bg-nothing',
    })
    return Widget.Window({
        monitor,
        className: 'bar-bg', // Full bar
        name: `bar${monitor}`,
        anchor: ['top', 'left', 'right'],
        exclusivity: 'exclusive',
        visible: true,
        child: Widget.Stack({
            homogeneous: false,
            transition: "slide_down",
            transitionDuration: userOptions.animations.durationLarge,
            children: {
                'normal': normalBarContent,
                'focus': focusedBarContent,
                'nothing': nothingContent,
            },
            setup: (self) => self.hook(currentShellMode, (self) => {
                self.shown = currentShellMode.value[monitor];
            })
        }),
    });
}

const BarCornerTopleftWs = () => Widget.Box({
    child: RoundedCorner('topleft', { className: 'corner-light', }),
    setup: (self) => {
        if (!ShowWorkspaces()) {
            self.child = Widget.Box({});
        }
    }
});
const BarCornerToprightWs = () => Widget.Box({
    child: RoundedCorner('topright', { className: 'corner-light', }),
    setup: (self) => {
        if (!ShowWorkspaces()) {
            self.child = Widget.Box({});
        }
    }
});

const BarCornerTopleft = () => Widget.Box({
    child: RoundedCorner('topleft', { className: 'corner', }),
    setup: (self) => {
        if (!ShowWorkspaces()) {
            self.child = Widget.Box({});
        }
    }
});
const BarCornerTopright = () => Widget.Box({
    child: RoundedCorner('topright', { className: 'corner', }),
    setup: (self) => {
        if (!ShowWorkspaces()) {
            self.child = Widget.Box({});
        }
    }
});