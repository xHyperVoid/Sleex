<<<<<<< HEAD
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland

=======
import "root:/modules/common"
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
pragma Singleton
pragma ComponentBehavior: Bound

/**
 * A nice wrapper for default Pipewire audio sink and source.
 */
Singleton {
    id: root

    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

    signal sinkProtectionTriggered(string reason);

    PwObjectTracker {
        objects: [sink, source]
    }

    Connections { // Protection against sudden volume changes
        target: sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0
        function onVolumeChanged() {
<<<<<<< HEAD
            if (!Config.options.audio.protection.enable) return;
=======
            if (!ConfigOptions.audio.protection.enable) return;
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            if (!lastReady) {
                lastVolume = sink.audio.volume;
                lastReady = true;
                return;
            }
            const newVolume = sink.audio.volume;
<<<<<<< HEAD
            const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100; 
            const maxAllowed = Config.options.audio.protection.maxAllowed / 100;
=======
            const maxAllowedIncrease = ConfigOptions.audio.protection.maxAllowedIncrease / 100; 
            const maxAllowed = ConfigOptions.audio.protection.maxAllowed / 100;
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

            if (newVolume - lastVolume > maxAllowedIncrease) {
                sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered("Illegal increment");
            } else if (newVolume > maxAllowed) {
                sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered("Exceeded max allowed");
            }
            lastVolume = sink.audio.volume;
        }
<<<<<<< HEAD
    }

    // Reverted to Hyprland.dispatch, which is the idiomatic method for this shell.
    function playSound(relativeSoundPath) {
        const fullPath = "/usr/share/sleex/" + relativeSoundPath;
        // Use the absolute path to paplay to be safe.
        const command = `exec /usr/bin/paplay ${fullPath}`;
        Hyprland.dispatch(command);
    }
=======
        
    }

>>>>>>> fa28d8f (Initial commit of the quickshell migration)
}
