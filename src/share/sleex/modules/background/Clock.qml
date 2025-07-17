pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
import "root:/modules/common/functions/color_utils.js" as ColorUtils

Item {
    id: clockWidget

    required property real screenWidth
    required property real screenHeight
    required property real clockX
    required property real clockY
    required property bool fixedClockPosition
    required property color textColor
    required property int textHorizontalAlignment

    signal clockPositionChanged(real newX, real newY)
    signal fixedPositionToggled()

    visible: Config.options.background.enableClock ?? true

    property real startClockX: 0
    property real startClockY: 0

    anchors {
        left: parent.left
        top: parent.top
        leftMargin: fixedClockPosition ? clockX - implicitWidth / 2 : clockX - implicitWidth / 2
        topMargin: fixedClockPosition ? clockY - implicitHeight / 2 : clockY - implicitHeight / 2
    }

    implicitWidth: clockColumn.implicitWidth
    implicitHeight: clockColumn.implicitHeight

    DragHandler {
        enabled: !fixedClockPosition
        id: dragHandler
        cursorShape: active ? Qt.ClosedHandCursor : Qt.OpenHandCursor

        onActiveChanged: {
            if (active) {
                clockWidget.startClockX = clockWidget.clockX
                clockWidget.startClockY = clockWidget.clockY
            } else {
                Config.options.background.clockX = clockWidget.clockX
                Config.options.background.clockY = clockWidget.clockY
            }
        }

        onTranslationChanged: {
            let newX = clockWidget.startClockX + translation.x
            let newY = clockWidget.startClockY + translation.y
            let halfWidth = clockWidget.implicitWidth / 2
            let halfHeight = clockWidget.implicitHeight / 2

            newX = Math.max(halfWidth, Math.min(screenWidth - halfWidth, newX))
            newY = Math.max(halfHeight, Math.min(screenHeight - halfHeight, newY))

            clockPositionChanged(newX, newY)
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        propagateComposedEvents: true
        cursorShape: Qt.ArrowCursor

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                fixedPositionToggled()
            }
        }
    }

    ColumnLayout {
        id: clockColumn
        anchors.centerIn: parent
        spacing: -5

        Rectangle {
            visible: !fixedClockPosition
            anchors.fill: parent
            color: "transparent"
            border.color: "red"
            border.width: 3
            radius: Appearance.rounding.normal
            z: 100
        }

        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: textHorizontalAlignment
            font.pixelSize: 95
            font.family: Config.options.background.fontFamily ?? "Sans Serif"
            color: Config.options.background.textColor ?? textColor
            style: Text.Raised
            styleColor: Appearance.colors.colShadow
            text: DateTime.time
        }

        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: textHorizontalAlignment
            font.pixelSize: 25
            font.family: Config.options.background.fontFamily ?? "Sans Serif"
            color: Config.options.background.textColor ?? textColor
            style: Text.Raised
            styleColor: Appearance.colors.colShadow
            text: DateTime.date
        }
    }

    Connections {
        target: Config.options.background
        function onFontFamilyChanged() {
            clockWidget.forceLayout()
        }
    }
}
