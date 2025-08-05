<<<<<<< HEAD

import qs.modules.common
=======
import "root:/modules/common/"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
<<<<<<< HEAD

=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    property bool sidebarLeftOpen: false
    property bool dashboardOpen: false
    property bool overviewOpen: false
    property bool workspaceShowNumbers: false
    property bool superReleaseMightTrigger: true
<<<<<<< HEAD
    property bool wppselectorOpen: false
    property bool screenLocked: false

    property real screenZoom: 1
    onScreenZoomChanged: {
        Hyprland.dispatch(`exec hyprctl keyword cursor:zoom_factor ${root.screenZoom.toString()}`);
    }
    Behavior on screenZoom {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

    // When user is not reluctant while pressing super, they probably don't need to see workspace numbers
    onSuperReleaseMightTriggerChanged: { 
        workspaceShowNumbersTimer.stop()
    }

    Timer {
        id: workspaceShowNumbersTimer
<<<<<<< HEAD
        interval: Config.options.bar.workspaces.showNumberDelay
=======
        interval: ConfigOptions.bar.workspaces.showNumberDelay
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        // interval: 0
        repeat: false
        onTriggered: {
            workspaceShowNumbers = true
        }
    }

    GlobalShortcut {
        name: "workspaceNumber"
        description: qsTr("Hold to show workspace numbers, release to show icons")

        onPressed: {
            workspaceShowNumbersTimer.start()
        }
        onReleased: {
            workspaceShowNumbersTimer.stop()
            workspaceShowNumbers = false
        }
    }
<<<<<<< HEAD

    IpcHandler {
		target: "zoom"

		function zoomIn() {
            screenZoom = Math.min(screenZoom + 0.4, 3.0)
        }

        function zoomOut() {
            screenZoom = Math.max(screenZoom - 0.4, 1)
        } 
	}


    IpcHandler {
        target: "lock"

        function lock() {
            root.screenLocked = true;
        }
    }
    GlobalShortcut {
        name: "lockScreen"
        description: qsTr("Lock screen (obviously)")

        onPressed: {
            root.screenLocked = true;
        }
    }

=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
}