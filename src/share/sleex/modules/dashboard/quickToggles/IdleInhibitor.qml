<<<<<<< HEAD
import qs.modules.common
import qs.modules.common.widgets
=======
import "root:/modules/common"
import "root:/modules/common/widgets"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import "../"
import Quickshell.Io
import Quickshell
import Quickshell.Hyprland

QuickToggleButton {
    id: root
    toggled: false
    buttonIcon: "coffee"
    onClicked: {
        if (toggled) {
            root.toggled = false
<<<<<<< HEAD
            Hyprland.dispatch("exec pkill wayland-idle")
        } else {
            root.toggled = true
            Hyprland.dispatch('exec python /usr/share/sleex/scripts/wayland-idle-inhibitor.py')
=======
            Hyprland.dispatch("exec pkill wayland-idle") // pkill doesn't accept too long names
        } else {
            root.toggled = true
            Hyprland.dispatch('exec ${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/scripts/wayland-idle-inhibitor.py')
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        }
    }
    Process {
        id: fetchActiveState
        running: true
        command: ["bash", "-c", "pidof wayland-idle-inhibitor.py"]
        onExited: (exitCode, exitStatus) => {
            root.toggled = exitCode === 0
        }
    }
    StyledToolTip {
        content: qsTr("Keep system awake")
    }
}
