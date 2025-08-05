<<<<<<< HEAD
import qs.modules.common
import qs.modules.common.widgets
import qs.services
=======
import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Item {
    id: root
<<<<<<< HEAD
    property bool alwaysShowAllResources: true
=======
    property bool borderless: ConfigOptions.bar.borderless
    property bool alwaysShowAllResources: false
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    implicitWidth: rowLayout.implicitWidth + rowLayout.anchors.leftMargin + rowLayout.anchors.rightMargin
    implicitHeight: 32

    RowLayout {
        id: rowLayout

        spacing: 0
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4

        Resource {
            iconName: "memory"
            percentage: ResourceUsage.memoryUsedPercentage
<<<<<<< HEAD
            tooltipText: `Memory usage: ${Math.round(ResourceUsage.memoryUsedPercentage * 100)}%`
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        }

        Resource {
            iconName: "swap_horiz"
            percentage: ResourceUsage.swapUsedPercentage
<<<<<<< HEAD
            tooltipText: `Swap usage: ${Math.round(ResourceUsage.swapUsedPercentage * 100)}%`
=======
            Layout.leftMargin: shown ? 4 : 0
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        }

        Resource {
            iconName: "settings_slow_motion"
            percentage: ResourceUsage.cpuUsage
            Layout.leftMargin: shown ? 4 : 0
<<<<<<< HEAD
            tooltipText: `CPU usage: ${Math.round(ResourceUsage.cpuUsage * 100)}%`
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        }

    }

}
