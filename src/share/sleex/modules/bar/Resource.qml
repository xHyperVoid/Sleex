<<<<<<< HEAD
import qs.modules.common
import qs.modules.common.widgets
=======
import "root:/modules/common"
import "root:/modules/common/widgets"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
<<<<<<< HEAD
    id: root
    required property string iconName
    required property double percentage
    required property string tooltipText
    property bool shown: true

    clip: true
    visible: width > 0 && height > 0

    implicitWidth: resourceRowLayout.x < 0 ? 0 : childrenRect.width
    implicitHeight: childrenRect.height

    property string warningColor: "#feb36c"

=======
    required property string iconName
    required property double percentage
    property bool shown: true
    clip: true
    visible: width > 0 && height > 0
    implicitWidth: resourceRowLayout.x < 0 ? 0 : childrenRect.width
    implicitHeight: childrenRect.height

>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    RowLayout {
        spacing: 4
        id: resourceRowLayout
        x: shown ? 0 : -resourceRowLayout.width

        CircularProgress {
<<<<<<< HEAD
            enableAnimation: false
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            Layout.alignment: Qt.AlignVCenter
            lineWidth: 2
            value: percentage
            size: 26
            secondaryColor: Appearance.colors.colSecondaryContainer
<<<<<<< HEAD
            primaryColor: percentage >= 0.9 ? root.warningColor : Appearance.m3colors.m3onSecondaryContainer
=======
            primaryColor: Appearance.m3colors.m3onSecondaryContainer
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: iconName
                iconSize: Appearance.font.pixelSize.normal
<<<<<<< HEAD
                color: percentage >= 0.9 ? root.warningColor : Appearance.m3colors.m3onSecondaryContainer
            }
=======
                color: Appearance.m3colors.m3onSecondaryContainer
            }

>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
<<<<<<< HEAD
            color: percentage >= 0.9 ? root.warningColor : Appearance.m3colors.m3onSecondaryContainer
=======
            color: Appearance.colors.colOnLayer1
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            text: `${Math.round(percentage * 100)}%`
        }

        Behavior on x {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }
<<<<<<< HEAD
=======

>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
            easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }
<<<<<<< HEAD

    // Fix: Use explicit size instead of anchors.fill to break circular dependency
    MouseArea {
        id: infoMouseArea
        x: resourceRowLayout.x
        y: resourceRowLayout.y
        width: resourceRowLayout.width
        height: resourceRowLayout.height
        hoverEnabled: true

        StyledToolTip {
            extraVisibleCondition: infoMouseArea.containsMouse
            content: tooltipText
        }
    }
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
}