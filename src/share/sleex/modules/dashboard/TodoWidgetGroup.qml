import qs.modules.common
import qs.modules.common.widgets
import qs.services
import "./calendar"
import "./todo"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    radius: Appearance.rounding.normal
    color: Appearance.colors.colLayer0
    clip: true

    
    TodoWidget {
        anchors.fill: parent
        anchors.margins: 5
    }
}