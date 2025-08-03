<<<<<<< Updated upstream
pragma Singleton

=======
// services/Battery.qml
pragma Singleton

import QtQuick
import qs.services
>>>>>>> Stashed changes
import qs.modules.common
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower

Singleton {
<<<<<<< Updated upstream
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
=======
    id: batteryService

    property int warningThreshold: Config.options.battery.low
    property int criticalThreshold: Config.options.battery.critical

    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState === UPowerDeviceState.Charging || chargeState === UPowerDeviceState.PendingCharge
    property bool isDischarging: chargeState === UPowerDeviceState.Discharging
    property bool isPluggedIn: isCharging || chargeState === UPowerDeviceState.FullyCharged

    property real percentage: UPower.displayDevice.percentage

    readonly property int percentageInt: Math.round(batteryService.percentage * 100)

    // Rewritten to provide raw minutes for the UI to format.
    readonly property int remainingTime: {
        const seconds = UPower.displayDevice.timeToFull;
        return (seconds > 0 && isFinite(seconds)) ? Math.floor(seconds / 60) : 0;
    }
    readonly property int timeToEmpty: {
        const seconds = UPower.displayDevice.timeToEmpty;
        return (seconds > 0 && isFinite(seconds)) ? Math.floor(seconds / 60) : 0;
    }

    property bool _wasLow: false
    property bool _wasCritical: false
    property bool _wasFull: false

    onIsPluggedInChanged: {
        if (!available) return;

        if (isPluggedIn) {
            Audio.playSound("assets/sounds/battery/02_plug.wav");
            _wasLow = false;
            _wasCritical = false;
        } else {
            Audio.playSound("assets/sounds/battery/02_unplug.wav");
            checkBatteryState();
        }
    }

    onPercentageChanged: {
        if (!available) return;
        checkBatteryState();
    }

    // Rewritten for stateful, more intelligent notifications.
    function checkBatteryState() {
        if (isDischarging) {
            _wasFull = false;

            if (batteryService.percentageInt <= criticalThreshold && !_wasCritical) {
                _wasCritical = true;
                _wasLow = true;
                Audio.playSound("assets/sounds/battery/05_critical.wav");
                sendNotification("Critical Battery Level", `Power level has reached ${batteryService.percentageInt}%. Please connect your charger immediately.`);
            }
            else if (batteryService.percentageInt <= warningThreshold && !_wasLow) {
                _wasLow = true;
                Audio.playSound("assets/sounds/battery/04_warn.wav");
                sendNotification("Low Battery Warning", `Power level has dropped to ${batteryService.percentageInt}%. Consider connecting your charger.`);
            }
        }

        if (isPluggedIn) {
            if (batteryService.percentageInt > warningThreshold) _wasLow = false;
            if (batteryService.percentageInt > criticalThreshold) _wasCritical = false;

            if (batteryService.percentageInt >= 100 && !_wasFull) {
                _wasFull = true;
                Audio.playSound("assets/sounds/battery/01_full.wav");
                sendNotification("Battery Full", "The battery is fully charged.");
            }
        }
    }

    function sendNotification(title, body) {
        Hyprland.dispatch(`exec notify-send "${title}" "${body}" -u critical -a "System"`);
>>>>>>> Stashed changes
    }
}
