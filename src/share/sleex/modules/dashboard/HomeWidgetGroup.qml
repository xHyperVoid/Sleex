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
                
                    Rectangle {
                        id: userAvatar
                        width: 120
                        height: 120
                        radius: 99
                        anchors.horizontalCenter: parent.horizontalCenter

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: 150
                                height: 150
                                radius: 75
                            }
                        }

                        AnimatedImage {
                            id: userAvatarImage
                            anchors.fill: parent
                            source: `/var/lib/AccountsService/icons/${SystemInfo.username}`
                            fillMode: Image.PreserveAspectCrop
                            cache: false
                            antialiasing: true
                            sourceSize.width: 150
                            sourceSize.height: 150
                        }
                    }

                    Text {
                        text: qsTr("Welcome, %1!").arg(SystemInfo.username)
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
                Layout.preferredHeight: 150

                Column{
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: DateTime.time
                        color: Appearance.colors.colPrimary
                        font.pixelSize: 60
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: DateTime.longDateFormat
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
                
                Column{
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: Github.contribution_number || qsTr("Error")
                        color: Appearance.colors.colPrimary
                        font.pixelSize: 60
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "contributions this year"
                        color: Appearance.colors.colOnLayer1
                        font.pixelSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: `@${Github.author}`
                        color: Appearance.colors.colOnLayer1
                        font.pixelSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                
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

                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    
                    Text {
                        text: `${Weather.temperature}` || qsTr("Error")
                        font.bold: true
                        color: Appearance.colors.colPrimary
                        font.pixelSize: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        //text: Weather.condition
                        text: Weather.condition || qsTr("Loading...")
                        font.pixelSize: 30
                        color: Appearance.colors.colOnLayer1
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

            }

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.preferredHeight: 400

                CalendarWidget {}
            }

        }
    }

    Rectangle {
        color: Appearance.colors.colLayer1
        radius: Appearance.rounding.normal
        Layout.fillWidth: true
        Layout.preferredHeight: 150
    }

}