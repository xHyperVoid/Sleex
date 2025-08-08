import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import "../"
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

QuickToggleButton {
    
    toggled: Network.wifiEnabled
    buttonIcon: Network.wifiEnabled ? Network.getNetworkIcon(Network.active.strength ?? 0) : "wifi_off"
    onClicked: {
        Network.toggleWifi()
    }
    altAction: () => {
        Hyprland.dispatch(`exec ${Network.ethernet ? Config.options.apps.networkEthernet : Config.options.apps.network}`)
        Hyprland.dispatch("global quickshell:dashboardClose")
    }
    StyledToolTip {
        content: StringUtils.format(qsTr("{0} | Right-click to configure"), Network.active.ssid)
    }
}
