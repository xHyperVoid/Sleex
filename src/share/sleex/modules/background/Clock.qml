pragma ComponentBehavior: Bound

import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
import "root:/modules/common/functions/color_utils.js" as ColorUtils
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: clockWidget
    
    // Properties that need to be set from parent
    required property real screenWidth
    required property real screenHeight
    required property real clockX
    required property real clockY
    required property bool fixedClockPosition
    required property color textColor
    required property int textHorizontalAlignment
    
    // Signals to communicate with parent
    signal clockPositionChanged(real newX, real newY)
    signal fixedPositionToggled()
    
    visible: Config.options.background.enableClock ?? true
    
    property real startClockX: 0
    property real startClockY: 0
    
    anchors {
        left: parent.left
        top: parent.top
        leftMargin: fixedClockPosition
            ? clockX - implicitWidth / 2
            : clockX - implicitWidth / 2
        topMargin: fixedClockPosition
            ? clockY - implicitHeight / 2
            : clockY - implicitHeight / 2
    }
    
    implicitWidth: clockColumn.implicitWidth
    implicitHeight: clockColumn.implicitHeight
    
    DragHandler {
        enabled: !fixedClockPosition
        id: dragHandler
        cursorShape: active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
        
        onActiveChanged: {
            if (active) {
                // Store starting position when drag begins
                clockWidget.startClockX = clockWidget.clockX
                clockWidget.startClockY = clockWidget.clockY
            } else {
                // Save position when drag ends
                Config.options.background.clockX = clockWidget.clockX
                Config.options.background.clockY = clockWidget.clockY
            }
        }
        
        onTranslationChanged: {
            // Calculate new position with bounds checking
            let newX = clockWidget.startClockX + translation.x
            let newY = clockWidget.startClockY + translation.y
            
            // Constrain to screen bounds
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
        onClicked: {
            if (mouse.button === Qt.RightButton) {
                fixedPositionToggled()
            }
        }
        cursorShape: Qt.ArrowCursor
        // Prevent interfering with drag
        propagateComposedEvents: true
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
            color: textColor
            style: Text.Raised
            styleColor: Appearance.colors.colShadow
            text: DateTime.time
        }
        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: textHorizontalAlignment
            font.pixelSize: 25
            color: textColor
            style: Text.Raised
            styleColor: Appearance.colors.colShadow
            text: DateTime.date
        }
    }
}