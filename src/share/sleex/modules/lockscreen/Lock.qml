import qs
import qs.modules.common
import qs.modules.common.functions
import qs.modules.lockscreen
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
	id: root
	// This stores all the information shared between the lock surfaces on each screen.
	// https://github.com/quickshell-mirror/quickshell-examples/tree/master/lockscreen
	LockContext {
		id: lockContext

		onUnlocked: {
			// Unlock the screen before exiting, or the compositor will display a
			// fallback lock you can't interact with.
			GlobalStates.screenLocked = false;

			// Refocus last focused window on unlock (hack)
			Quickshell.execDetached(["bash", "-c", `sleep 0.2; hyprctl --batch "dispatch togglespecialworkspace; dispatch togglespecialworkspace"`])
		}
	}

	WlSessionLock {
		id: lock
		locked: GlobalStates.screenLocked

		WlSessionLockSurface {
			color: "transparent"
			Loader {
                active: GlobalStates.screenLocked
                anchors.fill: parent
                opacity: active ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }

                sourceComponent: LockSurface {
                    context: lockContext
                }
            }
		}
	}

	// Blur layer hack
	Variants {
        model: Quickshell.screens

        LazyLoader {
			id: blurLayerLoader
			required property var modelData
			active: GlobalStates.screenLocked
			component: PanelWindow {
				screen: blurLayerLoader.modelData
				WlrLayershell.namespace: "quickshell:lockWindowPusher"
				color: "transparent"
				anchors {
					top: true
					left: true
					right: true
				}
				// implicitHeight: lockContext.currentText == "" ? 1 : screen.height
				implicitHeight: 1
			}
		}
	}

	IpcHandler {
        target: "lock"

        function activate(): void {
            GlobalStates.screenLocked = true;
        }
    }

	GlobalShortcut {
        name: "lock"
        description: "Locks the screen"

        onPressed: {
            GlobalStates.screenLocked = true;
        }
    }
}
