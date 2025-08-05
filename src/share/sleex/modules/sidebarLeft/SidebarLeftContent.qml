import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    required property var scopeRoot
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: sidebarPadding
        
        spacing: sidebarPadding

        SwipeView { // Content pages
            id: swipeView
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            
            contentChildren: [
                aiChat.createObject()
            ]
        }

        Component {
            id: aiChat
            AiChat {}
        }        
    }
}