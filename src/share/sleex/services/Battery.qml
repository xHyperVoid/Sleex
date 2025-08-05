pragma Singleton

<<<<<<< HEAD
import QtQuick
import qs.services
import qs.modules.common
=======
import "root:/modules/common"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower

Singleton {
<<<<<<< HEAD
    id: batteryService

    property int warningThreshold: Config.options.battery.low
    property int criticalThreshold: Config.options.battery.critical
    property int suspendThreshold: Config.options.battery.suspend

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
    property bool _wasSuspendWarned: false
    property bool _wasFull: false

    onIsPluggedInChanged: {
        if (!available) return;

        if (Config.options.battery.sound) {
            if (isPluggedIn) {
                Audio.playSound("assets/sounds/battery/02_plug.wav");
            } else {
                Audio.playSound("assets/sounds/battery/02_unplug.wav");
            }
        }

        if (isPluggedIn) {
            _wasLow = false;
            _wasCritical = false;
            _wasSuspendWarned = false;
        } else {
            checkBatteryState();
        }
    }

    onPercentageChanged: {
        if (!available) return;
        checkBatteryState();
    }

    Component.onCompleted: {
        if (Config.options) { // Ensure config is somewhat ready
            checkBatteryState()
        }
        Config.loaded.connect(checkBatteryState)
    }

    // Rewritten for stateful, more intelligent notifications.
    function checkBatteryState() {
        const soundEnabled = Config.options.battery.sound;

        if (isDischarging) {
            _wasFull = false;

            if (batteryService.percentageInt <= suspendThreshold + 1 && !_wasSuspendWarned) {
                _wasSuspendWarned = true;
                if (soundEnabled) {
                    Audio.playSound("assets/sounds/battery/05_critical.wav");
                    soundDelayTimer.start();
                }
                sendNotification("Critical Battery Level", "Suspending system soon. Please connect to a power source.");
            }
            else if (batteryService.percentageInt <= criticalThreshold && !_wasCritical) {
                _wasCritical = true;
                _wasLow = true;
                if (soundEnabled) {
                    Audio.playSound("assets/sounds/battery/05_critical.wav");
                }
                sendNotification("Critical Battery Level", `Power level has reached ${batteryService.percentageInt}%. Please connect your charger immediately.`);
            }
            else if (batteryService.percentageInt <= warningThreshold && !_wasLow) {
                _wasLow = true;
                if (soundEnabled) {
                    Audio.playSound("assets/sounds/battery/04_warn.wav");
                }
                sendNotification("Low Battery Warning", `Power level has dropped to ${batteryService.percentageInt}%. Consider connecting your charger.`);
            }
        }

        if (isPluggedIn) {
            if (batteryService.percentageInt > warningThreshold) _wasLow = false;
            if (batteryService.percentageInt > criticalThreshold) {
                _wasCritical = false;
                _wasSuspendWarned = false;
            }

            if (batteryService.percentageInt >= 100 && !_wasFull) {
                _wasFull = true;
                if (soundEnabled) {
                    Audio.playSound("assets/sounds/battery/01_full.wav");
                }
                sendNotification("Battery Full", "The battery is fully charged.");
            }
        }
    }

    function sendNotification(title, body) {
        Hyprland.dispatch(`exec notify-send "${title}" "${body}" -u critical -a "System"`);
    }

    Timer {
        id: soundDelayTimer
        interval: 850 // Add delay
        repeat: false
        onTriggered: Audio.playSound("assets/sounds/battery/04_warn.wav")
=======
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage

    property bool isLow: percentage <= ConfigOptions.battery.low / 100
    property bool isCritical: percentage <= ConfigOptions.battery.critical / 100
    property bool isSuspending: percentage <= ConfigOptions.battery.suspend / 100

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging

    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging) Hyprland.dispatch(`exec notify-send "Low battery" "Consider plugging in your device" -u critical -a "Shell"`)
    }

    onIsCriticalAndNotChargingChanged: {
        if (available && isCriticalAndNotCharging) Hyprland.dispatch(`exec notify-send "Critically low battery" "🙏 I beg for pleas charg\nAutomatic suspend triggers at ${ConfigOptions.battery.suspend}%" -u critical -a "Shell"`)
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    }
}
