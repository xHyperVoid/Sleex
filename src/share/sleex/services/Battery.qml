pragma Singleton

import qs.modules.common
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage
    property string remainingTime: `${Math.floor(UPower.displayDevice.timeToFull / 60)} min`
    property string timeToEmpty: `${Math.floor(UPower.displayDevice.timeToEmpty / 60)} min`

    property bool isLow: percentage <= Config.options.battery.low / 100
    property bool isCritical: percentage <= Config.options.battery.critical / 100
    property bool isSuspending: percentage <= Config.options.battery.suspend / 100

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging

    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging) Hyprland.dispatch(`exec notify-send "Low battery" "Consider plugging in your device" -u critical -a "Shell"`)
    }

    onIsCriticalAndNotChargingChanged: {
        if (available && isCriticalAndNotCharging) Hyprland.dispatch(`exec notify-send "Critically low battery" "🙏 I beg for pleas charg\nAutomatic suspend triggers at ${Config.options.battery.suspend}%" -u critical -a "Shell"`)
    }

    function formatTime(seconds) {
        if (seconds <= 0 || isNaN(seconds)) return "--:--";
        const mins = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return `${mins}m ${secs}s`;
    }
}
