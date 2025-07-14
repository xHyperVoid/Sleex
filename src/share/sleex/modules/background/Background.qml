pragma ComponentBehavior: Bound

import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
import "root:/modules/common/functions/color_utils.js" as ColorUtils
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root
    readonly property bool fixedClockPosition: Config.options.background.fixedClockPosition
    readonly property real fixedClockX: Config.options.background.clockX
    readonly property real fixedClockY: Config.options.background.clockY

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bgRoot

            required property var modelData
            property string wallpaperPath: Config.options.background.wallpaperPath

            // Clock position (can be modified)
            property real clockX: Config.options.background.clockX !== 0 ? Config.options.background.clockX : modelData.width / 2
            property real clockY: Config.options.background.clockY !== 0 ? Config.options.background.clockY : modelData.height / 2

            property var textHorizontalAlignment: clockX < screen.width / 3 ? Text.AlignLeft :
                (clockX > screen.width * 2 / 3 ? Text.AlignRight : Text.AlignHCenter)

            // Colors
            property color dominantColor: Appearance.colors.colPrimary
            property bool dominantColorIsDark: dominantColor.hslLightness < 0.5
            property color colText: ColorUtils.colorWithLightness(Appearance.colors.colPrimary, (dominantColorIsDark ? 0.8 : 0.12))

            screen: modelData
            WlrLayershell.layer: WlrLayer.Bottom
            WlrLayershell.namespace: "quickshell:background"

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"

            AnimatedImage {
                z: 0
                anchors.fill: parent
                source: bgRoot.wallpaperPath
                fillMode: Image.PreserveAspectCrop
                sourceSize {
                    width: bgRoot.screen.width
                    height: bgRoot.screen.height
                }
            }

            Item {
                id: clock
                z: 1

                property real startClockX: 0
                property real startClockY: 0

                anchors {
                    left: parent.left
                    top: parent.top
                    leftMargin: root.fixedClockPosition
                        ? root.fixedClockX - implicitWidth / 2
                        : bgRoot.clockX - implicitWidth / 2

                    topMargin: root.fixedClockPosition
                        ? root.fixedClockY - implicitHeight / 2
                        : bgRoot.clockY - implicitHeight / 2
                }

                implicitWidth: clockColumn.implicitWidth
                implicitHeight: clockColumn.implicitHeight

                DragHandler {
                    enabled: !root.fixedClockPosition
                    id: dragHandler
                    cursorShape: active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                    
                    onActiveChanged: {
                        if (active) {
                            // Store starting position when drag begins
                            clock.startClockX = bgRoot.clockX
                            clock.startClockY = bgRoot.clockY
                        } else {
                            // Save position when drag ends
                            Config.options.background.clockX = bgRoot.clockX
                            Config.options.background.clockY = bgRoot.clockY
                        }
                    }
                    
                    onTranslationChanged: {
                        // Calculate new position with bounds checking
                        let newX = clock.startClockX + translation.x
                        let newY = clock.startClockY + translation.y
                        
                        // Constrain to screen bounds
                        let halfWidth = clock.implicitWidth / 2
                        let halfHeight = clock.implicitHeight / 2
                        
                        newX = Math.max(halfWidth, Math.min(bgRoot.screen.width - halfWidth, newX))
                        newY = Math.max(halfHeight, Math.min(bgRoot.screen.height - halfHeight, newY))
                        
                        bgRoot.clockX = newX
                        bgRoot.clockY = newY
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.RightButton) {
                            Config.options.background.fixedClockPosition = !root.fixedClockPosition
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
                        visible: root.fixedClockPosition == false
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "red"
                        border.width: 3
                        radius: Appearance.rounding.normal
                        z: 100
                    }

                    StyledText {
                        Layout.fillWidth: true
                        horizontalAlignment: bgRoot.textHorizontalAlignment
                        font.pixelSize: 95
                        color: bgRoot.colText
                        style: Text.Raised
                        styleColor: Appearance.colors.colShadow
                        text: DateTime.time
                    }
                    StyledText {
                        Layout.fillWidth: true
                        horizontalAlignment: bgRoot.textHorizontalAlignment
                        font.pixelSize: 25
                        color: bgRoot.colText
                        style: Text.Raised
                        styleColor: Appearance.colors.colShadow
                        text: DateTime.date
                    }
                }
            }
        }
    }
}