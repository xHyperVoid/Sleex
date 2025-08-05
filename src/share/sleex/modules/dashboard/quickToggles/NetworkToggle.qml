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
import "../"
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

QuickToggleButton {
    toggled: Network.networkName.length > 0 && Network.networkName != "lo"
    buttonIcon: Network.materialSymbol
    onClicked: {
        toggleNetwork.running = true
    }
    altAction: () => {
<<<<<<< HEAD
        Hyprland.dispatch(`exec ${Network.ethernet ? Config.options.apps.networkEthernet : Config.options.apps.network}`)
=======
        Hyprland.dispatch(`exec ${Network.ethernet ? ConfigOptions.apps.networkEthernet : ConfigOptions.apps.network}`)
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        Hyprland.dispatch("global quickshell:dashboardClose")
    }
    Process {
        id: toggleNetwork
        command: ["bash", "-c", "nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on"]
        onRunningChanged: {
            if(!running) {
                Network.update()
            }
        }
    }
    StyledToolTip {
        content: StringUtils.format(qsTr("{0} | Right-click to configure"), Network.networkName)
    }
}
