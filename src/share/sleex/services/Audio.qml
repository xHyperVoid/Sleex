import qs.modules.common
import QtQuick
import Quickshell
<<<<<<< Updated upstream
=======
import Quickshell.Hyprland
>>>>>>> Stashed changes
import Quickshell.Services.Pipewire
pragma Singleton
pragma ComponentBehavior: Bound

<<<<<<< Updated upstream
/**
 * A nice wrapper for default Pipewire audio sink and source.
 */
=======
>>>>>>> Stashed changes
Singleton {
    id: root

    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

<<<<<<< Updated upstream
    signal sinkProtectionTriggered(string reason);

    PwObjectTracker {
        objects: [sink, source]
    }

    Connections { // Protection against sudden volume changes
        target: sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0
        function onVolumeChanged() {
            if (!Config.options.audio.protection.enable) return;
=======
    property real volume: sink?.audio.volume ?? 0.0
    property bool muted: sink?.audio.muted ?? false

    Connections {
        target: Pipewire
        function onDefaultNodesChanged() {
            root.sink = Pipewire.defaultAudioSink
            root.source = Pipewire.defaultAudioSource
        }
    }

    Connections {
        target: sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0
        function onReadyChanged() {
            if (!sink.audio.ready) {
                lastReady = false;
                return;
            }
>>>>>>> Stashed changes
            if (!lastReady) {
                lastVolume = sink.audio.volume;
                lastReady = true;
                return;
            }
            const newVolume = sink.audio.volume;
<<<<<<< Updated upstream
            const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100; 
            const maxAllowed = Config.options.audio.protection.maxAllowed / 100;

            if (newVolume - lastVolume > maxAllowedIncrease) {
                sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered("Illegal increment");
            } else if (newVolume > maxAllowed) {
                sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered("Exceeded max allowed");
            }
            lastVolume = sink.audio.volume;
        }
        
    }

=======
            const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100;
            const maxAllowed = Config.options.audio.protection.maxAllowed / 100;

            if (newVolume - lastVolume > maxAllowedIncrease) {
                sink.audio.volume = lastVolume + maxAllowedIncrease;
            } else if (newVolume > maxAllowed) {
                sink.audio.volume = maxAllowed;
            }
            lastVolume = sink.audio.volume;
        }
    }

    // New function to play event sounds.
    function playSound(relativeSoundPath) {
        const fullPath = "/usr/share/sleex/" + relativeSoundPath;
        const command = `exec paplay ${fullPath}`;
        Hyprland.dispatch(command);
    }
>>>>>>> Stashed changes
}
