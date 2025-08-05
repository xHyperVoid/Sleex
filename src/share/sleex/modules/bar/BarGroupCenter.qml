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

Item {
    id: root
    property real padding: 5
<<<<<<< HEAD
    property real margin: 0
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    implicitHeight: 40
    implicitWidth: rowLayout.implicitWidth + padding * 2
    default property alias items: rowLayout.children

    Rectangle {
        id: background
<<<<<<< HEAD
        color: "transparent"
        anchors.fill: parent
        
        
        RowLayout {
            id: rowLayout
            spacing: 0
            
            anchors {
                verticalCenter: parent.verticalCenter
                leftMargin: root.margin
                rightMargin: root.margin
            }
            
        }

    }

=======
        anchors {
            fill: parent
        }
        color: ConfigOptions?.bar.borderless ? "transparent" : Appearance.colors.colLayer0
    }

    RowLayout {
        id: rowLayout
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: root.padding
            rightMargin: root.padding
        }
        spacing: 4

    }
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
}