import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box } = Widget;
import ModuleAudioControls from "../centermodules/audiocontrols.js";
import ModuleWifiNetworks from "../centermodules/wifinetworks.js";
import ModuleBluetooth from "../centermodules/bluetooth.js";
import ModuleConfigure from "../centermodules/configure.js";


export default () => Box({
    children: [
        ModuleConfigure(),
        Box({
            vexpand: true,
            vertical: true,
            className: 'spacing-v-15',
            children: [
                ModuleBluetooth(),
                ModuleAudioControls()
            ]
        }),
        ModuleWifiNetworks(),
    ]
});