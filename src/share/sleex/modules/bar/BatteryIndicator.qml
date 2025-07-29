import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import Quickshell.Widgets

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    readonly property var chargeState: Battery.chargeState
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isPluggedIn: Battery.isPluggedIn
    readonly property real percentage: Battery.percentage
    readonly property string remainingTime: Battery.remainingTime
    readonly property string timeToEmpty: Battery.timeToEmpty
    readonly property bool isLow: percentage <= Config.options.battery.low / 100
    readonly property color batteryLowBackground: Appearance.m3colors.darkmode ? Appearance.m3colors.m3error : Appearance.m3colors.m3errorContainer
    readonly property color batteryLowOnBackground: Appearance.m3colors.darkmode ? Appearance.m3colors.m3errorContainer : Appearance.m3colors.m3error

    implicitWidth: 75
    implicitHeight: 23

    ClippingRectangle {
        id: background
        anchors.fill: parent
        radius: 100
        color: root.isLow ? "#350000" : Appearance.colors.colLayer2
        // border {
        //     width: 1
        //     color: root.isLow ? Appearance.m3colors.m3error : "#747474"
        // }
        RowLayout {
            id: textLayer
            anchors.centerIn: parent
            spacing: 4

            MaterialSymbol {
                text: "bolt"
                visible: root.isCharging
                font.pixelSize: 18
                color: root.isLow ? Appearance.m3colors.m3error : Appearance.colors.colOnLayer1
            }

            Text {
                id: batteryText
                text: `${Math.round(percentage * 100)}%`
                font.pixelSize: 13
                color: root.isLow ? Appearance.m3colors.m3error : Appearance.colors.colOnLayer1
                font {
                    bold: root.isLow
                }
            }
        }

        Rectangle {
            id: bar
            clip: true
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: root.width * Math.min(Math.max(parseFloat(percentage * 100), 0), 100) / 100
            color: root.isLow ? Appearance.m3colors.m3error : Appearance.colors.colOnLayer1

            Behavior on width {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            RowLayout {
                id: textLayer2
                x: (root.width - width) / 2
                y: (root.height - height) / 2
                spacing: 4

                MaterialSymbol {
                    text: "bolt"
                    visible: root.isCharging
                    font.pixelSize: 16
                    color: Appearance.colors.colLayer0
                }

                Text {
                    text: `${Math.round(percentage * 100)}%`
                    font.pixelSize: 13
                    color: Appearance.colors.colLayer0
                }
            }
        }
    }

    MouseArea {
        id: infoMouseArea
        anchors.fill: parent
        hoverEnabled: true
        StyledToolTip {
            content: root.isCharging ? `${root.percentage * 100}% charged, ${root.remainingTime} remaining` : `${root.percentage * 100}% remaining, ${root.timeToEmpty} to empty`
            extraVisibleCondition: infoMouseArea.containsMouse
        }
    }
        
}
