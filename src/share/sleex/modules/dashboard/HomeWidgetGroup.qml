import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
import "./notifications"
import "./calendar"
import "../mediaControls"
import Qt5Compat.GraphicalEffects
import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    color: Appearance.colors.colLayer0
    

    RowLayout {
        id: mainCols
        anchors.fill: parent
        spacing: 10
        
        ColumnLayout {
            id: firstCol
            spacing: 10

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.preferredHeight: 300

                Column {
                    anchors.centerIn: parent
                    spacing: 10
                
                    AnimatedImage {
                        id: userAvatar
                        width: 150
                        height: 150
                        source: Directories.home + "/.sleex/user/avatar.gif"
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectCrop
                    }

                    Text {
                        text: qsTr("Welcome, %1!").arg(SystemInfo.getUsername)
                        color: Appearance.colors.colOnLayer1
                        font.pixelSize: 30
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        text: qsTr("Today is a good day to have a good day!")
                        color: Appearance.colors.colOnLayer1
                        font.pixelSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        
        NotificationList {
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.margins: 15
        }
        
        ColumnLayout {
            id: thirdCol
            spacing: 10

            MediaControls {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
            }

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // CalendarWidget {
            //     Layout.fillWidth: true
            //     Layout.fillHeight: true
            // }
        }
    }

}