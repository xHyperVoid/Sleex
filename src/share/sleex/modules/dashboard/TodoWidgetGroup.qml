<<<<<<< HEAD
import qs.modules.common
import qs.modules.common.widgets
import qs.services
=======
import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import "./calendar"
import "./todo"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
<<<<<<< HEAD
    color: "transparent"
    clip: true
=======
    radius: Appearance.rounding.normal
    color: Appearance.colors.colLayer0
    clip: true
    implicitHeight: collapsed ? collapsedBottomWidgetGroupRow.implicitHeight : bottomWidgetGroupRow.implicitHeight
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

    
    TodoWidget {
        anchors.fill: parent
        anchors.margins: 5
    }
}