import qs.modules.common
import qs.modules.common.widgets
import qs.services
import "./volumeMixer"
import Qt5Compat.GraphicalEffects
import QtQuick
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
        
        Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Text {
                    anchors.centerIn: parent
                    text: "Quick settings: coming soon"
                    color: Appearance.colors.colOnLayer1
                    font.pixelSize: 30
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

        }
        
        ColumnLayout {
            id: secondCol
            spacing: 10

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    anchors.centerIn: parent
                    text: "BT settings: coming soon"
                    color: Appearance.colors.colOnLayer1
                    font.pixelSize: 30
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            VolumeMixer {
                Layout.fillWidth: true
                Layout.fillHeight: true
                anchors.margins: 15
            }
        }
        
        ColumnLayout {
            id: thirdCol
            spacing: 10

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    anchors.centerIn: parent
                    text: "WiFi settings: coming soon"
                    color: Appearance.colors.colOnLayer1
                    font.pixelSize: 30
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

}