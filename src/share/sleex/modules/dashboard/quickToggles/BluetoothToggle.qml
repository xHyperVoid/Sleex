import "../"
<<<<<<< HEAD
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
=======
import "root:/services"
import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/modules/common/functions/string_utils.js" as StringUtils
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

QuickToggleButton {
    toggled: Bluetooth.bluetoothEnabled
    buttonIcon: Bluetooth.bluetoothConnected ? "bluetooth_connected" : Bluetooth.bluetoothEnabled ? "bluetooth" : "bluetooth_disabled"
    onClicked: {
        toggleBluetooth.running = true
    }
    altAction: () => {
<<<<<<< HEAD
        Hyprland.dispatch(`exec ${Config.options.apps.bluetooth}`)
=======
        Hyprland.dispatch(`exec ${ConfigOptions.apps.bluetooth}`)
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            Hyprland.dispatch("global quickshell:dashboardClose")
    }
    Process {
        id: toggleBluetooth
        command: ["bash", "-c", `bluetoothctl power ${Bluetooth.bluetoothEnabled ? "off" : "on"}`]
        onRunningChanged: {
            if(!running) {
                Bluetooth.update()
            }
        }
    }
    StyledToolTip {
        content: StringUtils.format(qsTr("{0} | Right-click to configure"), 
            (Bluetooth.bluetoothEnabled && Bluetooth.bluetoothDeviceName.length > 0) ? 
            Bluetooth.bluetoothDeviceName : qsTr("Bluetooth"))

    }
}
