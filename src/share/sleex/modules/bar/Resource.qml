import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
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

    RowLayout {
        spacing: 4
        id: resourceRowLayout
        x: shown ? 0 : -resourceRowLayout.width

        CircularProgress {
            enableAnimation: false
            Layout.alignment: Qt.AlignVCenter
            lineWidth: 2
            value: percentage
            size: 26
            secondaryColor: Appearance.colors.colSecondaryContainer
            primaryColor: percentage >= 0.9 ? root.warningColor : Appearance.m3colors.m3onSecondaryContainer

            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: iconName
                iconSize: Appearance.font.pixelSize.normal
                color: percentage >= 0.9 ? root.warningColor : Appearance.m3colors.m3onSecondaryContainer
            }

        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            color: percentage >= 0.9 ? root.warningColor : Appearance.m3colors.m3onSecondaryContainer
            text: `${Math.round(percentage * 100)}%`
        }

        Behavior on x {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }
    }

    MouseArea {
        id: infoMouseArea
        anchors.fill: parent
        hoverEnabled: true

        StyledToolTip {
            extraVisibleCondition: infoMouseArea.containsMouse
            content: tooltipText
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
            easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }
}